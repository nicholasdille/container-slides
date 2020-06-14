FROM alpine AS build1
RUN touch /opt/binary1
RUN sleep 5

FROM alpine AS build2
RUN touch /opt/binary2
RUN sleep 5

FROM alpine
COPY --from=build1 /opt/binary1 /opt/
COPY --from=build2 /opt/binary2 /opt/
