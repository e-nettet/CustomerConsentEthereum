FROM node:latest

RUN \
  git clone https://github.com/cubedro/eth-net-intelligence-api && \
  cd  eth-net-intelligence-api && \
  npm install && \
  npm install -g pm2

COPY app.json /eth-net-intelligence-api/app.json

WORKDIR /eth-net-intelligence-api

CMD ["pm2-docker", "start", "app.json"]
