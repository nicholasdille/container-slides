FROM openjdk:8-jdk-slim as builder
COPY HelloWorld.java .
RUN javac HelloWorld.java

FROM openjdk:8-jre-slim
COPY --from=builder /HelloWorld.class .
CMD [ "java", "HelloWorld" ]
