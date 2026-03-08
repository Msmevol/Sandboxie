import os
import shutil
import subprocess
import time
from datetime import datetime
from pathlib import Path

def run_command(cmd):
    """执行命令并返回结果"""
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    return result.returncode, result.stdout, result.stderr

def main():
    print("=== Xdefend 部署脚本 ===\n")
    
    # 配置
    build_path = Path(r"C:\project\Sandboxie\Sandboxie-Build-x64")
    install_path = Path(r"C:\Program Files\Xdefend")
    backup_base = Path(r"C:\Xdefend-Backup")
    
    # 步骤 1: 停止服务
    print("[1/6] 停止服务...")
    code, out, err = run_command("sc stop SbieSvc")
    if code != 0 and "1062" not in err:  # 1062 = 服务未启动
        print(f"警告: {err}")
    time.sleep(2)
    
    # 步骤 2: 备份
    print("[2/6] 备份旧文件...")
    timestamp = datetime.now().strftime("%Y%m%d-%H%M%S")
    backup_dir = backup_base / timestamp
    backup_dir.mkdir(parents=True, exist_ok=True)
    
    try:
        shutil.copytree(install_path, backup_dir, dirs_exist_ok=True)
        print(f"    备份到: {backup_dir}")
    except Exception as e:
        print(f"备份失败: {e}")
        return 1
    
    # 步骤 3: 复制 x64 文件（排除 .sys）
    print("[3/6] 复制 x64 文件...")
    x64_path = build_path / "x64"
    copied = 0
    
    for file in x64_path.iterdir():
        if file.is_file() and file.suffix.lower() != ".sys":
            try:
                shutil.copy2(file, install_path / file.name)
                print(f"    复制: {file.name}")
                copied += 1
            except Exception as e:
                print(f"    失败: {file.name} - {e}")
    
    print(f"    共复制 {copied} 个文件")
    
    # 步骤 4: 复制 x86 文件
    print("[4/6] 复制 x86 文件...")
    x86_path = build_path / "x86"
    x86_install = install_path / "32"
    
    if x86_install.exists():
        files_to_copy = [
            ("SbieDll.dll", x86_install / "SbieDll.dll"),
            ("SbieSvc.exe", x86_install / "SbieSvc.exe")
        ]
        
        for src_name, dst_path in files_to_copy:
            src_file = x86_path / src_name
            if src_file.exists():
                try:
                    shutil.copy2(src_file, dst_path)
                    print(f"    复制: {src_name}")
                except Exception as e:
                    print(f"    失败: {src_name} - {e}")
    
    # 步骤 5: 启动服务
    print("[5/6] 启动服务...")
    code, out, err = run_command("sc start SbieSvc")
    if code != 0:
        print(f"警告: {err}")
    time.sleep(2)
    
    # 步骤 6: 验证
    print("[6/6] 验证服务状态...")
    code, out, err = run_command("sc query SbieSvc")
    if "RUNNING" in out:
        print("[OK] SbieSvc running")
    else:
        print("[FAIL] SbieSvc not running")
        print(out)
    
    code, out, err = run_command("sc query SbieDrv")
    if "RUNNING" in out:
        print("[OK] SbieDrv running")
    else:
        print("[FAIL] SbieDrv not running")
        print(out)
    
    print("\n=== 部署完成 ===")
    print(f"备份位置: {backup_dir}")
    return 0

if __name__ == "__main__":
    try:
        exit(main())
    except Exception as e:
        print(f"\n错误: {e}")
        import traceback
        traceback.print_exc()
        exit(1)
