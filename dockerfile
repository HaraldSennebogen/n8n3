FROM n8nio/n8n

USER root

RUN apt-get update && \
    apt-get install -y imagemagick && \
    apt-get clean

USER node
