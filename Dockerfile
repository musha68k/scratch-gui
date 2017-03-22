FROM node:alpine

ADD . /src

WORKDIR /src

RUN npm install

EXPOSE 8601

ENTRYPOINT npm start
