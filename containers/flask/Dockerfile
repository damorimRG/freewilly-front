FROM python:3.7-slim
MAINTAINER Luis Melo "luis@lhsm.com.br"

COPY . /app
WORKDIR /app
RUN pip install -r requirements.txt
ENTRYPOINT ["python"]
CMD ["app.py"]