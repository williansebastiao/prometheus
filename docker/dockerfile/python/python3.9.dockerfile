FROM python:3.9
WORKDIR /var/www/app
COPY ./requirements.txt /var/www/app/requirements.txt
RUN pip install uvicorn
RUN pip install --no-cache-dir --upgrade -r /var/www/app/requirements.txt
COPY ./app /var/www/app
CMD ["uvicorn", "main:app", "--reload", "--host", "0.0.0.0", "--port", "80"]