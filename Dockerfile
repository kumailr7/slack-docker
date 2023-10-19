FROM node:bookworm-slim
WORKDIR /app
COPY ./package.json ./package.json
COPY ./public ./public
COPY ./src ./src
RUN yarn install
EXPOSE 3000

CMD ["yarn","start"]
