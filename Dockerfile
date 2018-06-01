ARG IMAGE=node:10-alpine

FROM $IMAGE as client-server
RUN yarn global add serve

FROM $IMAGE as client-built
COPY . .
RUN yarn
RUN yarn run build

FROM client-server as client
COPY --from=client-built build build

FROM client-server as client-with-test
COPY --from=client build build
COPY ./__tests__ ./__tests__

# Expose entrypoint and CMD configed to allow as gitlab runner service
EXPOSE 5000
ENTRYPOINT ["serve"]
CMD ["-s", "build"]

# docker build --target client -t ncrmro/auto-selenium-cra . && docker push ncrmro/auto-selenium-cra