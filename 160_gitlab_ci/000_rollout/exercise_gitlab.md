# GitLab

This workshop is performed on a shared GitLab instance. You have been assigned a user and password for this instance in an email.

## Task 1: Retrieve your credentials digitally

You have received your credentials in an email but the password is not fun to type in. Let's retrieve it digitally:

1. Go to [https://code.inmylab.de](https://code.inmylab.de)
1. Select your username from the list
1. Login using your personal user `seatN` (where `N` is a number) and your code (looks like this `ABCDEF`)
1. The web page displays your credentials

Keep the page open to refer to your credentials anytime throughout the workshop.

## Task 2: Login to GitLab

Go to [https://gitlab.inmylab.de](https://gitlab.inmylab.de) and login with your credentials.

??? info "Hint (Click if you are stuck)"
    Your username looks like `seatN` where `N` is a number.

    Your password is a long, random string which is displayed on the web pages access in the previous task.

??? example "Solution (Click if you are stuck)"
    `.gitlab-ci.yml`:

    ```yaml linenums="1"
    build:
      script:
      - apk update
      - apk add go
      - go build -o hello .
      - ./hello
    ```
    
    If you want to jump to the solution, execute the following command:

    ```bash
    git checkout origin/160_gitlab_ci/010_jobs_and_stages/build -- '*'
    ```

## Task 3: Access the demo project

A personal project has been provisioned for you to follow this workshop. It is called `demo`. Let's find it!

??? info "Hint (Click if you are stuck)"
    Personal projects are access by clicking on your avatar in the top left corner.

??? example "Solution (Click if you are stuck)"
    The deep link is https://gitlab.inmylab.de/seatN/demo where `N` is a number.
