## Cloud Native Builds

### Where are we today?

Build instructions require tools

```bash
javac HelloWorld.java
jar cf HelloWorld.jar HelloWorld.jar
```

Builds are usually more complex

Tools are installed on build agents

Build agents become critical infrastructure components

Automated installation only addresses symptom

---

## Cloud Native Builds

### The future

```yaml
steps:

  - image: alpine/git
    commands:
      - git clone <somerepo>

  - image: openjdk:8-jdk
    commands:
      - javac HelloWorld.java
      - jar cf HelloWorld.jar HelloWorld.jar
```

- Pipeline as code
- Easier to track in `git`
- Easier to read than script

---

## Cloud Native Builds

### Existing solutions

- GitLab CI (docker executor)
- Drone CI
- Concourse CI
- Jenkins (Jenkinsfile DSL)

(List is not exhaustive)

---

## Cloud Native Builds

### Enter `insulatr`

- Independent of build server
- No server component
- Called as only step of automated build
- [https://github.com/nicholasdille/insulatr](https://github.com/nicholasdille/insulatr)

### Features

- Clone multiple repositories
- State passed between steps in Docker volume
- Start services running during the build
- Inject files before build
- Extract files after build

--

## Demo: Cloud Native Builds

[https://github.com/nicholasdille/insulatr](https://github.com/nicholasdille/insulatr)

Use `insulatr` >=1.0.1

Enable privileged service:

```bash
insulatr --file insulatr.yaml --allow-privileged
```
