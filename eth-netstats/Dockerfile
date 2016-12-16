FROM node:alpine

RUN \
  apk add --update git && \
  git clone --depth 1 https://github.com/cubedro/eth-netstats && \
  cd eth-netstats && \
  npm install && \
  npm install -g grunt-cli && \
  grunt && \
  apk del git

EXPOSE 3000

WORKDIR /eth-netstats

CMD ["npm", "start"]
