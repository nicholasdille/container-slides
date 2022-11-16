## Goal to optimize a container image

<i class="fa fa-running fa-2x" style="width: 2em; text-align: center;"></i> Faster build

<i class="fa fa-compress-arrows-alt fa-2x" style="width: 2em; text-align: center;"></i> Smaller image

<i class="fa fa-shield-alt fa-2x" style="width: 2em; text-align: center;"></i> More secure contents

<i class="fa fa-dumbbell fa-2x" style="width: 2em; text-align: center;"></i> Easier to maintain

---

## Container image building

How do you build your container image?

### In the beginning, there was Docker

But more great tools exist...

- Buildah
- BuildKit
- Kaniko

### Focus on Docker/BuildKit

Strong focus on Developer Experience (DX)

Many innnovations in the last few years

---

## Overview

<div class="layout-double">

Multi-stage build <i class="fa fa-running"></i> <i class="fa fa-compress-arrows-alt"></i>

FROM scratch <i class="fa fa-shield-alt"></i> <i class="fa fa-compress-arrows-alt"></i>

Order of commands <i class="fa fa-running"></i>

BuildKit RUN cache <i class="fa fa-compress-arrows-alt"></i>

Heredocs <i class="fa fa-dumbbell"></i>

USER <i class="fa fa-shield-alt"></i>

Parallel multi-stage build <i class="fa fa-running"></i>

Dependency update, e.g. RenovateBot <i class="fa fa-shield-alt"></i>

Patch/digest auto-merge <i class="fa fa-shield-alt"></i>

Automated build <i class="fa fa-shield-alt"></i> <i class="fa fa-running"></i>

Cache From <i class="fa fa-running"></i>

Testing <i class="fa fa-shield-alt"></i>

Scan <i class="fa fa-shield-alt"></i>

Scheduled rebuild <i class="fa fa-shield-alt"></i>

</div>

--

## More

BuildKit RUN mount <i class="fa fa-compress-arrows-alt"></i> <i class="fa fa-running"></i>

Base and derived images <i class="fa fa-running"></i> <i class="fa fa-dumbbell"></i>

LABEL <i class="fa fa-dumbbell"></i>

Job dependencies <i class="fa fa-running"></i>

CI caching <i class="fa fa-running"></i>

CI only certain file changes <i class="fa fa-running"></i>

Remote tagging <i class="fa fa-running"></i>

Readability beats size <i class="fa fa-dumbbell"></i>
