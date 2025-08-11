FROM python:3.13.5-alpine
RUN apk add --no-cache git
WORKDIR /app
RUN git clone https://github.com/crytic/slither.git
RUN pip install ./slither
