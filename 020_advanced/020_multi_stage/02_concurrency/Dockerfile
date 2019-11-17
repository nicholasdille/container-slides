FROM alpine as build1
RUN mkdir /opt/tool1 \
 && touch /opt/tool1/binary1
RUN sleep 10

FROM alpine as build2
RUN mkdir /opt/tool2 \
 && touch /opt/tool2/binary2
RUN sleep 10

FROM alpine
COPY --from=build1 /opt/tool1 /opt/tool1
COPY --from=build2 /opt/tool2 /opt/tool2
