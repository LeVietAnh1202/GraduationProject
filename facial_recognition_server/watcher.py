import os
import sys
import time
import subprocess
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

class MyHandler(FileSystemEventHandler):
    def __init__(self, command):
        self.command = command
        self.process = None

    def on_any_event(self, event):
        if event.is_directory:
            return None
        elif event.event_type == 'modified':
            if self.process:
                self.process.terminate()
            print(f"File {event.src_path} changed, restarting process...")
            self.process = subprocess.Popen(self.command, shell=True)

if __name__ == "__main__":
    path = "."
    command = "python main.py"
    event_handler = MyHandler(command)
    observer = Observer()
    observer.schedule(event_handler, path, recursive=True)
    observer.start()
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
    observer.join()
