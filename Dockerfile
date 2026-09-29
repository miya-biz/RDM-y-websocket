FROM node:24-alpine

RUN apk update && apk upgrade && apk add --no-cache tini
RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app
WORKDIR /home/node/app
COPY package.json ./
USER node
RUN npm install
COPY --chown=node:node . .
USER root
RUN rm -rf /usr/local/lib/node_modules/npm /usr/local/bin/npm /usr/local/bin/npx
USER node
EXPOSE 1234
ENTRYPOINT [ "/sbin/tini", "--" ]
CMD [ "node", "./bin/server.cjs" ]
