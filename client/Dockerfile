# Stage 1 - build Vue.js application
FROM node:lts-alpine as build-deps
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . ./
RUN npm run build
