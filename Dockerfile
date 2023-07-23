FROM node:18.16.0-slim AS build-stage
ENV NODE_ENV production
WORKDIR /usr/src/app

COPY --chown=node:node tsconfig.json ./
COPY --chown=node:node .env* ./

COPY package.json ./
COPY package-lock.json ./

RUN npm i

COPY --chown=node:node index.ts ./

RUN npx tsc

FROM node:18.16.0-slim
ENV NODE_ENV production
WORKDIR /usr/src/app

COPY --chown=node:node --from=build-stage /usr/src/app/node_modules /usr/src/app/node_modules

COPY --chown=node:node --from=build-stage /usr/src/app/build /usr/src/app/build

USER node
CMD ["node", "build/index.js"]