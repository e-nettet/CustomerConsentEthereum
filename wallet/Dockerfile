FROM nginx:alpine

RUN apk update && \
  apk add ca-certificates wget && \
  update-ca-certificates && \
  wget https://github.com/e-nettet/CustomerConsentWallet/releases/download/v0.1-alpha/dist.zip && \
  unzip dist.zip && \
  mv dist/* /usr/share/nginx/html

EXPOSE 8080
