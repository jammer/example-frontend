FROM node:14-alpine as build
WORKDIR /usr/src/app
COPY . .
RUN npm install && \
    npm run build 
FROM node:14-alpine
WORKDIR /usr/src/app
COPY --from=build /usr/src/app/build ./build
RUN npm install --cache /cache -g serve && \
    rm -fr /cache && \
    echo 'user:x:1001:1001:Linux User,,,:/home/user:/sbin/nologin' >> /etc/passwd && \
    echo 'user:x:1001:user' >> /etc/group
USER user
CMD ["serve","-s","-l","5000","build"]
EXPOSE 5000
