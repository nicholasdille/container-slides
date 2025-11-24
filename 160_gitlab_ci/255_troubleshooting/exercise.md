# Troubleshooting

!!! tip "Goal"
    Learn how to run a pipeline locally

## Preparation

Open a terminal and make sure the working directory is your repository.

## Task 1: Run a single job

Select a single job to run:

```shell
gcil
```

## Task 2: Run the whole pipeline

Run the whole pipeline:

```shell
gcil --pipeline
```

## Task 3: Explore pre-defined variables

Add a job to print all environment variables.

??? info "Hint (Click if you are stuck)"
    Use the following command to show all environment variables: `printenv | sort`

??? example "Solution (Click if you are stuck)"

    ```yaml
    #...
    new_job:
      stage: check
      script: |
        printenv | sort
    #...
    ```

## Task 4: Pass variables to the pipeline

Check the help how to pass a variable called `AUTHOR` with a value of your choice.

??? info "Hint (Click if you are stuck)"
    The parameter `-e` is used to pass variables to the pipeline.

??? example "Solution (Click if you are stuck)"

    ```shell
    gcil --pipeline --pipeline -e FOO=bar
    ```
