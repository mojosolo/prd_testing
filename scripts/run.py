#!/usr/bin/env python
"""
Run script for PRD Generator.
This script provides a unified way to run the PRD Generator across platforms.
"""

import os
import sys
import argparse
import subprocess
import platform

def setup_virtual_env():
    """Set up a virtual environment if not already exists."""
    if platform.system() == "Windows":
        venv_path = "venv"
        python_executable = os.path.join(venv_path, "Scripts", "python")
        pip_executable = os.path.join(venv_path, "Scripts", "pip")
    else:
        venv_path = "venv"
        python_executable = os.path.join(venv_path, "bin", "python")
        pip_executable = os.path.join(venv_path, "bin", "pip")
    
    # Check if virtual environment exists
    if not os.path.exists(venv_path):
        print("Setting up virtual environment...")
        subprocess.run([sys.executable, "-m", "venv", venv_path], check=True)
    
    # Install dependencies
    print("Installing dependencies...")
    subprocess.run([pip_executable, "install", "-r", "requirements.txt"], check=True)
    
    return python_executable

def run_server(args):
    """Run the PRD Generator server."""
    python_executable = setup_virtual_env()
    
    # Run the server
    print("Starting PRD Generator server...")
    cmd = [python_executable, "prd_server.py"]
    
    # Run in background on Unix-like systems if requested
    if args.daemon and platform.system() != "Windows":
        cmd = ["nohup"] + cmd + ["&"]
        subprocess.Popen(" ".join(cmd), shell=True)
        print("Server started in background. Logs are in nohup.out")
    else:
        # Interactive mode
        subprocess.run(cmd)

def stop_server():
    """Stop the PRD Generator server (Unix-like systems only)."""
    if platform.system() == "Windows":
        print("Manual stop required on Windows. Press Ctrl+C in the server window.")
        return
    
    # Find and kill the process
    print("Stopping PRD Generator server...")
    subprocess.run(["pkill", "-f", "python prd_server.py"])
    print("Server stopped.")

def setup_environment():
    """Setup the environment with necessary files."""
    python_executable = setup_virtual_env()
    
    # Create .env file if it doesn't exist
    if not os.path.exists(".env"):
        print("Creating .env file...")
        with open(".env", "w") as f:
            f.write("OPENAI_API_KEY=your_openai_api_key\n")
            f.write("FIREFLIES_API_KEY=your_fireflies_api_key\n")
        print("Created .env file. Please edit it with your API keys.")
    
    # Create logs directory if it doesn't exist
    if not os.path.exists("logs"):
        os.makedirs("logs")

def main():
    """Main entry point."""
    parser = argparse.ArgumentParser(description="PRD Generator")
    subparsers = parser.add_subparsers(dest="command", help="Command to run")
    
    # Server command
    server_parser = subparsers.add_parser("server", help="Run the PRD Generator server")
    server_parser.add_argument("--daemon", "-d", action="store_true", help="Run in daemon mode (Unix-like systems only)")
    
    # Stop command
    stop_parser = subparsers.add_parser("stop", help="Stop the PRD Generator server")
    
    # Setup command
    setup_parser = subparsers.add_parser("setup", help="Setup the environment")
    
    args = parser.parse_args()
    
    if args.command == "server":
        run_server(args)
    elif args.command == "stop":
        stop_server()
    elif args.command == "setup":
        setup_environment()
    else:
        parser.print_help()

if __name__ == "__main__":
    main()