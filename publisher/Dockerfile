FROM node:12-alpine

WORKDIR /app

COPY package.json yarn.lock /app/
RUN yarn install

COPY dynv6.svg publish.js /app/

CMD ["node", "publish.js"]
