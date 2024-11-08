<!-- .slide: id="gitlab_pages" class="vertical-center" -->

<i class="fa-duotone fa-globe fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## GitLab Pages

---

## GitLab Pages

<i class="fa-duotone fa-globe fa-4x fa-duotone-colors" style="float: right;"></i>

Publish static websites [](https://docs.gitlab.com/ee/user/project/pages/)

Extensively customizable [](https://docs.gitlab.com/ee/administration/pages/index.html)

### How it works

Create a job called `pages`, ...

...to directory `public/` and...

...create an artifact

---

### Hands-On

1. Create a new top-level group with a new project
1. Create a file called `index.html`

    ```html
    <html><body>
    <h1>GitLab Pages</h1>Test
    </body></html>
    ```

1. Create a files called `.gitlab-ci.yml`

    ```yaml
    pages:
      script:
      - mkdir public
      - cp index.html public
      artifacts:
        paths:
        - public
    ```

1. Go to the pages configuration to view your page (Settings <i class="fa-regular fa-arrow-right"></i> Pages)
