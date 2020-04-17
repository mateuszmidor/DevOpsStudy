#!/usr/bin/env python

import datetime
import json

date = datetime.datetime.now()
result = {
    "time" : str(date),
    "failed" : False,
    "changed" : True
}

print(json.dumps(result))