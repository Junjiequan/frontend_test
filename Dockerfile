FROM node:18.18.0-alpine AS builder

RUN apk add --update python3 make g++ && rm -rf /var/cache/apk/*

WORKDIR /frontend
COPY package*.json /frontend/
RUN npm ci
COPY . /frontend/
RUN npx ng build

FROM nginx:1.25-alpine
RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /frontend/dist/ /usr/share/nginx/html/
EXPOSE 80
