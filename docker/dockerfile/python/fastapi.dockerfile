FROM python:3.9
COPY . /var/www/app
RUN pip install uvicorn
RUN pip install --no-cache-dir --upgrade -r /var/www/app/requirements.txt
WORKDIR /var/www/app
CMD ["uvicorn", "main:app", "--reload", "--host", "0.0.0.0", "--port", "80"]