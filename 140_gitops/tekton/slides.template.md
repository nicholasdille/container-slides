## tekton

Pipelines executed natively inside Kubernetes

Pipelines are expressed as YAML documents

Example `Task`:

```yaml
apiVersion: tekton.dev/v1beta1
kind: Task
metadata:
    name: echo-hello-world
spec:
    steps:
    - name: echo
    image: ubuntu
    command:
    - echo
    args:
    - "Hello World"
```

--

## tekton

Example `TaskRun`:

```yaml
apiVersion: tekton.dev/v1beta1
kind: TaskRun
metadata:
    name: echo-hello-world-task-run
spec:
    taskRef:
    name: echo-hello-world
```

--

## Demo: TaskRun

<!-- include: taskrun-0.command -->

<!-- include: taskrun-1.command -->

<!-- include: taskrun-2.command -->

--

## Demo: PipelineRun

<!-- include: pipelinerun-0.command -->

<!-- include: pipelinerun-1.command -->

<!-- include: pipelinerun-2.command -->
