import requests 
import os

def checkDigit(raw_png_bytes : bytes) -> str:
    """ result as JSON: { "value" : "?" } """

    # env variables set by kubernetes
    ip = os.getenv("CHECKER_SERVICE_SERVICE_HOST")
    port = os.getenv("CHECKER_SERVICE_SERVICE_PORT")
    API_ENDPOINT = f"http://{ip}:{port}/checkdigit"
    try:
        r = requests.post(url = API_ENDPOINT, data = raw_png_bytes)
        result_json = r.text 
        return result_json
    except requests.exceptions.ConnectionError as e:
        return '{ "value" : "checkdigit service not ready" }'
    except requests.exceptions.RequestException as e:
        return '{ "value" : "POST exception" }'