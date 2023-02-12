FROM node:lts-alpine
RUN npm install -g solhint
COPY docker-entrypoint.sh /usr/local/bin
COPY .solhint.json /
ENTRYPOINT [ "docker-entrypoint.sh" ]
