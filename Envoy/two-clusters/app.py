from flask import Flask
import time
import threading
import os
import random
import requests
import socket
import sys


def main():
    talkers = os.getenv("TALKERS")
    if talkers is None:
        print("Env variable TALKERS not set. No one to talk to It should be comma-separated list of hosts.")
        return
    talker_list = talkers.split(",")

    while True:
        time.sleep(random.randint(1, 5))
        talker = random.choice(talker_list)
        r = requests.get(url=talker, params={})
        print(r.text, flush=True)


app = Flask(__name__)
threading.Thread(target=main).start()


@app.route("/")
def hello_world():
    return f"Hello from {socket.gethostname()}"
