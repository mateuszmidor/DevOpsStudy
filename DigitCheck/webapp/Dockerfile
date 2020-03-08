FROM python:3.7-slim
RUN pip install --user --upgrade pip
RUN pip install --user requests
WORKDIR /usr/src/webapp
COPY . .
EXPOSE 80
CMD ["python", "main.py", "80"]