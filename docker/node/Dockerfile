FROM node:8-alpine

# UID/GID handling
ARG USER_UID=1000
ARG USER_GID=1000

RUN apk update && apk add --no-cache \
    shadow \
    bash \
    git \
    python \
    make \
    g++

# Add node user with correct UID/GID
RUN groupmod -g $USER_GID node && \
    usermod -u $USER_UID -g node node

WORKDIR /srv/app

USER node

CMD ["yarn", "watch"]
