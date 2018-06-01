ARG IMAGE=node:10-alpine

FROM $IMAGE as client-server
RUN yarn global add serve

FROM $IMAGE as client-built
COPY . .
RUN yarn
RUN yarn run build

FROM client-server as client
COPY --from=client-built build build

# Expose entrypoint and CMD configed to allow as gitlab runner service
EXPOSE 5000
ENTRYPOINT ["serve"]
CMD ["-s", "build"]

# docker build -t ncrmro/auto-selenium-cra . && docker push ncrmro/auto-selenium-cra