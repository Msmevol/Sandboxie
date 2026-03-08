"""
Run Xdefend deployment via scheduled task (no UAC prompt)
"""
import subprocess
import time

def main():
    print("=== Xdefend Deploy (via Task) ===\n")
    
    # Run the scheduled task
    print("Starting deployment task...")
    result = subprocess.run('schtasks /run /tn "XdefendDeploy"', 
                          shell=True, capture_output=True, text=True)
    
    if result.returncode != 0:
        print("[FAIL] Task not found. Run setup-task.bat first (as admin)")
        return 1
    
    print("[OK] Task started\n")
    
    # Wait for completion
    print("Waiting for deployment to complete...")
    time.sleep(3)
    
    for i in range(30):
        result = subprocess.run('schtasks /query /tn "XdefendDeploy" /fo list', 
                              shell=True, capture_output=True, text=True)
        
        if "Running" not in result.stdout:
            print("\n[OK] Deployment completed!")
            
            # Check service status
            result = subprocess.run('sc query SbieSvc', 
                                  shell=True, capture_output=True, text=True)
            if "RUNNING" in result.stdout:
                print("[OK] Service is running")
            else:
                print("[WARN] Service may not be running")
            
            return 0
        
        print(".", end="", flush=True)
        time.sleep(2)
    
    print("\n[WARN] Deployment timeout")
    return 1

if __name__ == "__main__":
    exit(main())
