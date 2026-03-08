"""
Xdefend Auto CI/CD - Complete automation without elevated access
"""
import subprocess
import time
import sys
from pathlib import Path

def run_cmd(cmd, cwd=None):
    """Run command and return output"""
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True, cwd=cwd)
    return result.returncode, result.stdout, result.stderr

def wait_for_build(timeout=300):
    """Wait for GitHub Actions build to complete"""
    print("Waiting for GitHub Actions build...")
    project_dir = Path("C:/project/Sandboxie")
    
    start_time = time.time()
    while time.time() - start_time < timeout:
        # Check if build artifacts exist
        build_dir = project_dir / "Sandboxie-Build-x64"
        if build_dir.exists():
            print(f"[OK] Build artifacts found")
            return True
        
        print(".", end="", flush=True)
        time.sleep(10)
    
    print("\n[FAIL] Build timeout")
    return False

def download_artifacts():
    """Download build artifacts using gh CLI"""
    print("\nDownloading build artifacts...")
    project_dir = "C:/project/Sandboxie"
    gh_exe = "C:/Program Files/GitHub CLI/gh.exe"
    
    # Clean old artifacts
    code, _, _ = run_cmd("Remove-Item -Recurse -Force Sandboxie-Build-x64, Xdefend-Installer -ErrorAction SilentlyContinue", cwd=project_dir)
    
    # Get latest run ID
    code, stdout, stderr = run_cmd(f'"{gh_exe}" run list --limit 1 --json databaseId --jq ".[0].databaseId"', cwd=project_dir)
    if code != 0:
        print(f"[FAIL] Failed to get run ID: {stderr}")
        return False
    
    run_id = stdout.strip()
    print(f"Latest run ID: {run_id}")
    
    # Download artifacts
    code, stdout, stderr = run_cmd(f'"{gh_exe}" run download {run_id}', cwd=project_dir)
    if code != 0:
        print(f"[FAIL] Download failed: {stderr}")
        return False
    
    print("[OK] Artifacts downloaded")
    return True

def deploy():
    """Deploy using scheduled task (no UAC)"""
    print("\nDeploying...")
    code, stdout, stderr = run_cmd("schtasks /run /tn XdefendDeploy")
    
    if code != 0:
        print(f"[FAIL] Deploy task failed: {stderr}")
        return False
    
    print("[OK] Deploy task started")
    
    # Wait for deployment to complete
    print("Waiting for deployment...")
    time.sleep(5)
    
    for i in range(30):
        code, stdout, _ = run_cmd('schtasks /query /tn "XdefendDeploy" /fo list')
        if "Running" not in stdout:
            print("\n[OK] Deployment completed")
            return True
        print(".", end="", flush=True)
        time.sleep(2)
    
    print("\n[WARN] Deployment timeout")
    return False

def verify():
    """Verify deployment"""
    print("\nVerifying deployment...")
    
    # Check service status
    code, stdout, _ = run_cmd("sc query SbieSvc")
    if "RUNNING" in stdout:
        print("[OK] SbieSvc is running")
    else:
        print("[FAIL] SbieSvc is not running")
        return False
    
    # Check latest backup
    code, stdout, _ = run_cmd("Get-ChildItem C:\\Xdefend-Backup -Directory | Sort-Object LastWriteTime -Descending | Select-Object -First 1 Name")
    if code == 0:
        backup_name = stdout.strip().split('\n')[-1].strip()
        print(f"[OK] Latest backup: {backup_name}")
    
    return True

def main():
    print("=== Xdefend Auto CI/CD ===\n")
    
    # Step 1: Wait for build (or download if ready)
    if not download_artifacts():
        print("\n[INFO] Artifacts not ready, waiting for build...")
        if not wait_for_build():
            return 1
        if not download_artifacts():
            return 1
    
    # Step 2: Deploy
    if not deploy():
        return 1
    
    # Step 3: Verify
    if not verify():
        return 1
    
    print("\n=== CI/CD Complete ===")
    return 0

if __name__ == "__main__":
    exit(main())
