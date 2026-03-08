"""
Xdefend Deploy Wrapper - Uses PowerShell Start-Process with RunAs
"""
import subprocess
import sys
from pathlib import Path

def main():
    print("=== Xdefend Deploy Wrapper ===\n")
    
    script_path = Path(__file__).parent / "deploy.py"
    python_exe = sys.executable
    
    # Use PowerShell to elevate
    ps_cmd = f'Start-Process -FilePath "{python_exe}" -ArgumentList "{script_path}" -Verb RunAs -Wait'
    
    print(f"Launching elevated process...")
    print(f"Python: {python_exe}")
    print(f"Script: {script_path}\n")
    
    result = subprocess.run(
        ["powershell", "-Command", ps_cmd],
        capture_output=True,
        text=True
    )
    
    if result.returncode == 0:
        print("[OK] Deploy completed")
        return 0
    else:
        print(f"[FAIL] Deploy failed")
        if result.stderr:
            print(result.stderr)
        return 1

if __name__ == "__main__":
    exit(main())
