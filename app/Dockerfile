FROM ghcr.io/cirruslabs/flutter:3.10.0 as build-env
RUN mkdir app
COPY . /app/
WORKDIR /app/
RUN flutter pub get
RUN flutter pub run build_runner build --delete-conflicting-outputs
RUN flutter build web
FROM nginx:1.21.1-alpine
COPY --from=build-env /app/build/web /usr/share/nginx/html