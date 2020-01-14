FROM alpine as build1
RUN touch /opt/binary1
RUN sleep 10

FROM alpine as build2
RUN touch /opt/binary2
RUN sleep 10

FROM alpine
COPY --from=build1 /opt/binary1 /opt/
COPY --from=build2 /opt/binary2 /opt/
