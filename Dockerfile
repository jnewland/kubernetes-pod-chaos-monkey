FROM debian:jessie

ADD \
  https://storage.googleapis.com/kubernetes-release/release/v1.3.2/bin/linux/amd64/kubectl \
  /usr/local/bin/kubectl
RUN chmod 755 /usr/local/bin/kubectl

WORKDIR /usr/src/app
COPY chaos.sh ./
CMD ["bash", "/usr/src/app/chaos.sh"]
