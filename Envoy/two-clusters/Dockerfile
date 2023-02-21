# syntax=docker/dockerfile:1
FROM python:3-slim-buster
WORKDIR /code
COPY requirements.txt requirements.txt
COPY app.py app.py
RUN apt-get update 
RUN apt-get install curl -y # install curl for debugging
RUN pip install --upgrade pip
RUN pip install -r requirements.txt
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_RUN_PORT=5000
EXPOSE 5000
CMD ["flask", "run"]
