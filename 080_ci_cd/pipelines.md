## Pipelines

Build and release pipelines FTW

Images should be tested before publishing them

![Test is an important step in pipelines](media/Testing.svg) <!-- .element: style="background: none; box-shadow: none;" -->

Artifacts should be *copied* to production (no rebuild!)

---

## Dependencies

Deployment pipelines allow for dependencies between image builds

![Dependencies between image builds](media/Pipelines.svg) <!-- .element: style="background: none; box-shadow: none;" -->

Makes code reuse much easier
