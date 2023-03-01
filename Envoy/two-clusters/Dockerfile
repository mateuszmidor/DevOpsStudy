# syntax=docker/dockerfile:1
FROM python:3-slim-buster

# prepare the system
RUN apt-get update 
RUN apt-get install curl -y # install curl for debugging

# configure non-root user
ARG USER=talker
RUN useradd --create-home ${USER} 
ENV PATH=/home/${USER}/.local/bin:$PATH
USER ${USER}

# configure the actual app
WORKDIR /code
COPY requirements.txt requirements.txt
COPY app.py app.py
RUN pip install --upgrade pip
RUN pip install -r requirements.txt
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_RUN_PORT=5000

# make the container run the app by default
EXPOSE 5000
ENTRYPOINT ["flask", "run"]
