FROM node:19-alpine as build

WORKDIR /app

COPY package.json .
RUN npm install
COPY . .

RUN npm run build
###############################################
FROM nginx:1.23-alpine

COPY --from=build /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]