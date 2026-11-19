# GitLab

This workshop is performed on a dedicated instance. It consists of an instance of Visual Studio Code for the web as well as a Kubernetes cluster.

You have been assigned a hostname and password for this instance, e.g.

```plaintext
seatN.inmylab.de;P4s5w0rd
```

This exercise will help you familiarize with the workshop environment.

You will not require the coding and version control features of Visual Studio Code for this workshop. It is meant as an interface for viewing workshop material and interacting with the Kubernetes cluster.

## Task 1: Access your instance of Visual Studio Code

1. Go to `https://seatN.inmylab.de` where `N` is a number.
1. Login using your password

Configure Visual Studio Code to your liking.

## Task 2: Access your Kubernetes cluster

The Kubernetes cluster is only accessible from within Visual Studio Code. The `kubeconfig` as been provisioned automatically.

1. Open a terminal
1. Examine the cluster:

    ```bash
    kubectl cluster-info
    kubectl get nodes
    kubectl get pods -A
    ```

## Task 3: Open a terminal

There are two options to open a terminal in Visual Studio Code:

Option 1: Open the terminal from the Visual Studio Code interface by navigating to `Terminal` -> `New Terminal`.

Option 2: Open the command palette by pressing `Ctrl+Shift+P` and search for `Terminal: Create New Terminal in the Editor Area`

The advantage of option 2 is that it opens the terminal directly in the editor area, making it easier to work with multiple terminals and keep them organized within the Visual Studio Code interface.

## Heads-up

You will be working with copy and paste a lot. Note that your browser will probably show a pop-up asking you to allow interaction with the clipboard.
