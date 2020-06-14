## Run demos for existing talk 1/

Commands are included in slides for reference

Demos can be executed just like in a talk

Prerequisites: Execute in clean VM with Docker

1. Run `demo_prepare.sh` to install required tools

    ```plaintext
    bash demo_prepare.sh talk.html
    ```

1. Run `demo_run.sh` to execute demos

    ```plaintext
    bash demo_run.sh talk.html
    ```

--

## Run demos for existing talk 2/2

Every demo is executed in a dedicated sub shell

1. Run `demos` for a list of demos

1. Use `demo` to execute a demo:

    ```plaintext
    demo <name>
    ```

Contained commands are executes in-order

Input (key press) is required to execute command as well as confirm output

First failed command interrupts demo

Leave sub shell to complete demo (e.g. `CTRL-D`)

After the demos, cleanup:

```plaintext
bash demo_cleanup.sh talk.html
```
