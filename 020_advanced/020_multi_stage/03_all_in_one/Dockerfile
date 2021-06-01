FROM openjdk:8-jdk AS builder1
COPY HelloWorld.java .
RUN javac HelloWorld.java

FROM openjdk:8-jdk AS builder2
COPY HelloHeise.java .
RUN javac HelloHeise.java

FROM openjdk:8-jre
COPY --from=builder1 /HelloWorld.class .
COPY --from=builder2 /HelloHeise.class .
ENTRYPOINT [ "java" ]
CMD [ "HelloWorld" ]