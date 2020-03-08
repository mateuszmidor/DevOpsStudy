FROM python:3.7-slim
RUN pip install --user --upgrade pip
RUN pip install --user Pillow
WORKDIR /usr/src/pngconverter
COPY . .
EXPOSE 81
CMD ["python", "main.py", "81"]