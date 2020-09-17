FROM node:12.18-alpine As development
ARG APP_NAME
ENV APP_DIR=${APP_NAME}
ENV PATH node_modules/.bin:$PATH
WORKDIR /opt/${APP_DIR}
RUN apk -q --update --upgrade --no-cache add curl && curl -sfL https://install.goreleaser.com/github.com/tj/node-prune.sh | sh -s -- -b /usr/local/bin >/dev/null 2>&1
COPY package.json yarn.lock ./
RUN yarn --frozen-lockfile --ignore-optional --no-progress --silent --force
COPY . .
RUN yarn --frozen-lockfile --ignore-optional --no-progress --silent build

FROM node:12.18-alpine As production
ARG APP_NAME
ENV APP_DIR=${APP_NAME}
ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}
ENV APP_PORT='3000'
EXPOSE ${APP_PORT}
WORKDIR /opt/${APP_DIR}
ENV PATH node_modules/.bin:$PATH
COPY package.json yarn.lock ./
COPY --from=development /usr/local/bin/node-prune /usr/local/bin
COPY --from=development /opt/${APP_DIR}/dist ./dist
RUN yarn --production --frozen-lockfile --ignore-optional --no-progress --silent --force && yarn cache clean --no-progress --silent --force && /usr/local/bin/node-prune
CMD [ "yarn", "start:prod" ]