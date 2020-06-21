FROM python:2.7-alpine

RUN mkdir /code
WORKDIR /code
COPY requirements.txt /code/

RUN \
    apk update && \
    apk add --virtual build-deps gcc python-dev musl-dev && \
    apk add libmemcached-dev zlib-dev postgresql-dev build-base postgresql-dev libffi-dev && \
    apk add --no-cache --virtual .build-deps gcc musl-dev postgresql-dev && \
    python -m pip install -r requirements.txt --no-cache-dir && \
    apk --purge del .build-deps
COPY . /code/

RUN make install \
    && make build \
    && make load_data

CMD [ "make", "serve"]
