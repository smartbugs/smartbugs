FROM node:lts-alpine
RUN npm install -g solhint@5.1.0
COPY docker-entrypoint.sh /usr/local/bin
COPY .solhint.json /
ENTRYPOINT [ "docker-entrypoint.sh" ]
