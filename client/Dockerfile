# Stage 1 - build Vue.js application
FROM node:lts-alpine as build-deps
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . ./
RUN npm run build

# Stage 2 - the production environment with Nginx
FROM nginx:alpine
COPY nginx.conf /etc/nginx/nginx.conf
COPY api.conf /etc/nginx/conf.d/default.conf
COPY --from=build-deps /usr/src/app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
