FROM node:lts-alpine
RUN npm install -g solhint; solhint --init
COPY docker-entrypoint.sh /usr/local/bin
ENTRYPOINT [ "docker-entrypoint.sh" ]
