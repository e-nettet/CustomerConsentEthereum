FROM node:latest

RUN \
  git clone https://github.com/cubedro/eth-netstats && \
  cd eth-netstats && \
  npm install && \
  npm install -g grunt-cli && \
  grunt

EXPOSE 3000

WORKDIR /eth-netstats

CMD ["npm", "start"]
