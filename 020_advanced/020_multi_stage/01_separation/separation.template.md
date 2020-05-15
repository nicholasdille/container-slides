## Multi Stage Builds - Separation

Separate build and runtime environments

| Build environment | Runtime environment |
|-------------------|---------------------|
| Compilers (e.g. `javac`) | Runtime (e.g. `java`) |
| Build dependencies | Execution dependencies |
| Build tools (e.g. `make`) | - |
| Large image | Smaller attack surface |

This also works in the legacy builder

--

## Demo: Multi Stage Builds - Separation

<!-- include: separation-0.command -->

<!-- include: separation-1.command -->
