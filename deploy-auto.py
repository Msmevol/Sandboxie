"""
Xdefend Deploy Tool - Run via Task Scheduler with admin rights
"""
import os
import sys
import subprocess
from pathlib import Path

def create_scheduled_task():
    """Create a scheduled task that runs with highest privileges"""
    script_path = Path(__file__).parent / "deploy.py"
    python_exe = sys.executable
    
    task_name = "XdefendDeploy"
    
    # Delete old task
    subprocess.run(f'schtasks /delete /tn "{task_name}" /f', shell=True, capture_output=True)
    
    # Create new task with highest privileges (use future time)
    from datetime import datetime, timedelta
    future_time = (datetime.now() + timedelta(minutes=1)).strftime("%H:%M")
    cmd = f'schtasks /create /tn "{task_name}" /tr "\"{python_exe}\" \"{script_path}\"" /sc once /st {future_time} /rl highest /f'
    
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    if result.returncode == 0:
        print(f"[OK] Task created: {task_name}")
        return task_name
    else:
        print(f"[FAIL] Task creation failed: {result.stderr}")
        return None

def run_scheduled_task(task_name):
    """Run the scheduled task immediately"""
    result = subprocess.run(f'schtasks /run /tn "{task_name}"', shell=True, capture_output=True, text=True)
    if result.returncode == 0:
        print(f"[OK] Task started")
        return True
    else:
        print(f"[FAIL] Task start failed: {result.stderr}")
        return False

def wait_for_task(task_name, timeout=60):
    """Wait for task to complete"""
    import time
    waited = 0
    while waited < timeout:
        result = subprocess.run(f'schtasks /query /tn "{task_name}" /fo list', 
                              shell=True, capture_output=True, text=True)
        if "Running" not in result.stdout:
            print(f"[OK] Task completed")
            return True
        time.sleep(2)
        waited += 2
        print(f"  Waiting... ({waited}/{timeout}s)")
    
    print(f"[FAIL] Task timeout")
    return False

def main():
    print("=== Xdefend Auto Deploy ===\n")
    
    # Create task
    task_name = create_scheduled_task()
    if not task_name:
        return 1
    
    # Run task
    if not run_scheduled_task(task_name):
        return 1
    
    # Wait for completion
    if not wait_for_task(task_name):
        return 1
    
    print("\n=== Deploy Complete ===")
    return 0

if __name__ == "__main__":
    exit(main())
