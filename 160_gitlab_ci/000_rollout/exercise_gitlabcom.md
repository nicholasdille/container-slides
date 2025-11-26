# Alternative: gitlab.com

You can follow this workshop in gitlab.com.

## Task 1: Create a project

Create a new project to work through the exercises of this workshop. This can even be a personal project.

## Task 2: Clone the project

Clone this project locally:

```bash
git clone https://gitlab.com/USER/PROJECT
```

## Task 3: Add remote for exercises

Add a git remote to obtain the example application and jump to solutions if required:

```bash
git remote add upstream https://github.com/nicholasdille/container-slides
```

## Notes

Whenever the slides or the exercises reference the demo environment, you need to change this to point to your project:

- `gitlab.inmylab.de` --> `gitlab.com`
- `seatN/demo` --> `USER/PROJECT`
- `seatN` --> `USER`

## Issues

A few exercises will not work as expected because of differences between the demo environment and `gitlab.com`.

1. The first three exercises ([Jobs and stages](/hands-on/2025-11-27/010_jobs_and_stages/exercise/), [Variables](/hands-on/2025-11-27/020_variables/exercise/), [Scriptblocks](/hands-on/2025-11-27/030_script_blocks/exercise/)) will not run without a fix because the default runner on `gitlab.com` does not use `alpine`. You need to add the following lines at the top of you `.gitlab-ci.yml`:

    ```yaml
    default:
      image: alpine
    ```

1. In the exercise for [environments](/hands-on/2025-11-27/100_environments/exercise/), the job `deploy` will fail because it attempts to deploy to a WebDAV server which is specific to the demo environment. This also affects the following two exercises ([Triggers](/hands-on/2025-11-27/110_triggers/exercise/), [Templates](/hands-on/2025-11-27/120_templates/exercise/)). Due to the changes introduced in the exercise about [rules](/hands-on/2025-11-27/130_rules/exercise/), the error disappears.
