from flask import Flask
import time
import threading
import os
import random
import requests
import socket
from http import HTTPStatus

# --- configuration ---
MAX_RESPONSE_PAYLOAD_BYTES = int(os.getenv("MAX_RESPONSE_PAYLOAD_BYTES", "0"))
MIN_INJECTED_RESPONSE_LATENCY_MS = int(os.getenv("MIN_RESPONSE_LATENCY_MS", "500"))
MAX_INJECTED_RESPONSE_LATENCY_MS = int(os.getenv("MAX_RESPONSE_LATENCY_MS", "1000"))
STATUS_200_WEIGHT = int(os.getenv("STATUS_200_WEIGHT", "90"))
STATUS_300_WEIGHT = int(os.getenv("STATUS_300_WEIGHT", "4"))
STATUS_400_WEIGHT = int(os.getenv("STATUS_400_WEIGHT", "3"))
STATUS_500_WEIGHT = int(os.getenv("STATUS_500_WEIGHT", "3"))
HTTP_RESPONSES_TO_SELECT_FROM = (
    [HTTPStatus.OK] * STATUS_200_WEIGHT
    + [HTTPStatus.MULTIPLE_CHOICES] * STATUS_300_WEIGHT
    + [HTTPStatus.BAD_REQUEST] * STATUS_400_WEIGHT
    + [HTTPStatus.INTERNAL_SERVER_ERROR] * STATUS_500_WEIGHT
)
SEPARATOR = "\n"


# --- behavior ---
def start_talking():
    talkers = os.getenv("TALKERS")
    if talkers is None:
        print("Env variable TALKERS not set. No one to talk to. It should be a comma-separated list of hosts.")
        return

    talker_list = talkers.split(",")

    while True:
        time.sleep(1)  # be polite; don't talk too fast
        talker = random.choice(talker_list)
        response = requests.get(url=talker, params={}).text

        msg_payload = response.split(SEPARATOR)
        msg = msg_payload[0]
        payload = msg_payload[1] if len(msg_payload) == 2 else ""
        output = f"{msg} [payload: {len(payload)} bytes]"
        print(output, flush=True)


app = Flask(__name__)
threading.Thread(target=start_talking).start()


@app.route("/")
def handle_index():
    random_http_status = random.choice(HTTP_RESPONSES_TO_SELECT_FROM)
    random_latency_sec = random.randint(MIN_INJECTED_RESPONSE_LATENCY_MS, MAX_INJECTED_RESPONSE_LATENCY_MS) / 1000.0
    random_response_payload = "X" * random.randint(0, MAX_RESPONSE_PAYLOAD_BYTES)

    time.sleep(random_latency_sec)

    if random_http_status == HTTPStatus.OK:
        msg_payload = f"Hello from {socket.gethostname()}" + SEPARATOR + random_response_payload
        return msg_payload, HTTPStatus.OK
    else:
        return random_http_status.phrase, random_http_status.value
