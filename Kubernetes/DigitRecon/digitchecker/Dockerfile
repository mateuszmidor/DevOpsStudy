FROM python:3.7-slim
RUN pip install --user --upgrade pip
RUN pip install --user tensorflow 
RUN pip install --user matplotlib
RUN pip install --user requests
WORKDIR /usr/src/digitrecon
COPY . .
EXPOSE 80
CMD ["python", "main.py", "80"]