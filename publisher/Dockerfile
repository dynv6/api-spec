FROM node:12-alpine

WORKDIR /app

COPY package.json yarn.lock /app/
RUN yarn install

CMD ["npx", "redoc-cli", "bundle", "-o", "/local/docs/index.html", "/local/api/openapi.yml"]
