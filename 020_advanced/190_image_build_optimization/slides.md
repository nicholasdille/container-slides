<!-- .slide: id="heredocs" class="center" style="text-align: center; vertical-align: middle" -->

## Image Build Optimization

---

## Goal to optimize a `Dockerfile`

<i class="fas fa-running fa-2x" style="width: 2em; text-align: center;"></i> Faster build

<i class="fas fa-compress-arrows-alt fa-2x" style="width: 2em; text-align: center;"></i> Smaller image

<i class="fas fa-shield-alt fa-2x" style="width: 2em; text-align: center;"></i> More secure contents

<i class="fas fa-dumbbell fa-2x" style="width: 2em; text-align: center;"></i> Easier to maintain

---

## Overview

<div class="layout-double">

Multi-stage build <i class="fas fa-running"></i> <i class="fas fa-compress-arrows-alt"></i>

FROM scratch <i class="fas fa-shield-alt"></i> <i class="fas fa-compress-arrows-alt"></i>

Order of commands <i class="fas fa-running"></i>

BuildKit RUN cache <i class="fas fa-compress-arrows-alt"></i>

Heredocs <i class="fas fa-dumbbell"></i>

USER <i class="fas fa-shield-alt"></i>

Parallel multi-stage build <i class="fas fa-running"></i>

Dependency update, e.g. RenovateBot <i class="fas fa-shield-alt"></i>

Patch/digest auto-merge <i class="fas fa-shield-alt"></i>

Automated build <i class="fas fa-shield-alt"></i> <i class="fas fa-running"></i>

Cache From <i class="fas fa-running"></i>

Testing <i class="fas fa-shield-alt"></i>

Scan <i class="fas fa-shield-alt"></i>

Scheduled rebuild <i class="fas fa-shield-alt"></i>

</div>

--

## More

BuildKit RUN mount <i class="fas fa-compress-arrows-alt"></i> <i class="fas fa-running"></i>

Base and derived images <i class="fas fa-running"></i> <i class="fas fa-dumbbell"></i>

LABEL <i class="fas fa-dumbbell"></i>

Job dependencies <i class="fas fa-running"></i>

CI caching <i class="fas fa-running"></i>

CI only certain file changes <i class="fas fa-running"></i>

Remote tagging <i class="fas fa-running"></i>

Readability beats size <i class="fas fa-dumbbell"></i>
