FROM openjdk:8-jdk as builder
COPY HelloWorld.java .
RUN javac HelloWorld.java

FROM openjdk:11-jre
COPY --from=builder /HelloWorld.class .
CMD [ "java", "HelloWorld" ]
