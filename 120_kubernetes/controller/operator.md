## Controllers versus Operators

Operators are controllers on steroids

### Controllers

Manages state (often based on CRD)

Runs control loop to "make it so"

### Operators

Manages application lifecycle

Includes updates, configuration, backup, restore etc.

--

## Frameworks

[kubebuilder](https://book.kubebuilder.io/)

[Operator Framework](https://operatorframework.io/)

[metacontroller](https://metacontroller.github.io/metacontroller/intro.html)

For very simple projects: [shell-operator](https://github.com/flant/shell-operator)

[Kubernetes Universal Declarative Operator (KUDO)](https://kudo.dev/)
