FROM node:alpine

RUN \
  apk add --update git && \
  git clone --depth 1 https://github.com/cubedro/eth-net-intelligence-api && \
  cd eth-net-intelligence-api && \
  npm install && \
  npm install -g pm2 && \
  apk del git

COPY app.json /eth-net-intelligence-api/app.json

WORKDIR /eth-net-intelligence-api

CMD ["pm2-docker", "start", "app.json"]
