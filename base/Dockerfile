FROM alpine:latest

RUN \
  apk add --update git go make gcc musl-dev && \
  git clone --depth 1 --branch release/1.5 https://github.com/ethereum/go-ethereum && \
  (cd go-ethereum && make geth) && \
  (cd go-ethereum && build/env.sh go run build/ci.go install ./cmd/bootnode) && \
  cp go-ethereum/build/bin/geth /usr/bin/geth && \
  cp go-ethereum/build/bin/bootnode /usr/bin/bootnode && \
  apk del git go make gcc musl-dev && \
  rm -rf /go-ethereum && rm -rf /var/cache/apk/*

ENTRYPOINT ["/usr/bin/geth"]
