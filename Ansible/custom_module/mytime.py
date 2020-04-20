#!/usr/bin/env python

from datetime import datetime
import json
import sys
import os

# tell ansibe we want input parameters in json format instead of key=value
"WANT_JSON"

# read input arguments
args_filename = sys.argv[1]
with open(args_filename) as json_file:
    args_data = json.load(json_file)
time_format = args_data.get('format')


# create response dict
if time_format is None:
    result = {
        "failed" : True,
        "why" : "No time format specified",
        "changed" : False
    }  
elif time_format == "long":
    result = {
        "failed" : False,
        "now" : datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "format" : time_format,
        "changed" : True
    }  
elif time_format == "short":
    result = {
        "failed" : False,
        "now" : datetime.now().strftime("%H:%M:%S"),
        "format" : time_format,
        "changed" : True
    }  
else:
    result = {
        "failed" : True,
        "why" : "Invalid format specified: " + time_format,
        "changed" : False
    } 

# return response
print(json.dumps(result))