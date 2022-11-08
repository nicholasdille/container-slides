## Deploying a blog

![WordPress with MySQL](120_kubernetes/13_wordpress/example.drawio.svg) <!-- .element: style="float: right; width: 25%;" -->

All necessary tools have been introduced

Deployment of WordPress with MySQL

Including services for accessing frontend and backend

Secret for storing the database password

Data persistence on the host

### Disadvantage

<i class="fa fa-minus" style="width: 1em;"></i> WordPress cannot be scaled easily (consistency)

<i class="fa fa-minus" style="width: 1em;"></i> MySQL cannot be scaled easily (consistency)
