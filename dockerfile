FROM python:3.12-slim

WORKDIR /favorites_app

COPY . /favorites_app/

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 80

CMD ["python", "app.py"]