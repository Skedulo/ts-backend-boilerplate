FROM node:12.14.1-alpine as builder
WORKDIR /app

COPY package.json yarn.lock tsconfig.json tslint.json ./

RUN yarn run bootstrap

COPY ./src/ ./src

RUN yarn compile

FROM node:12.14.1-alpine

ENV NODE_ENV=production

EXPOSE 9009

WORKDIR /app

RUN adduser -u 1004 -D -h /ts-runner ts-runner

COPY package.json yarn.lock ./

RUN yarn install --production \
    && yarn cache clean

COPY --from=builder /app/dist /app/dist

USER 1004

CMD ["node", "/app/dist/index"]
