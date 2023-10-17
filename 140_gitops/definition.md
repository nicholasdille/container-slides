## What is GitOps

Continuous Deployment for Cloud Native Applications

Developer centric experience when operating infrastructure

Version control as single source of truth

Declarative infrastructure as desired state

Automation is key

Invented by WeaveWorks in 2017

---

## GitOps != DevOps

### DevOps is cultural change

Shared responsibility

Tools can support but are not essential

### GitOps is a methodology

Technical implementation

---

## How to do GitOps?

Version control

Declarative infrastructure

Automation to *make it so*

Minimize glue code

You decide
- Repository layout (monorepo or multirepo)
- Development mode (trunk-based or gitflow)
- Stages (one or more)

---

## How to do GitOps?

When this becomes religion...

### Push deployment

All-knowing CI/CD pipeline

Extensive permissions required

WeaveWorks calls this *CIOps*

### Pull deployment

Preached by WeaveWorks

Smaller attack surface due to few permissions

---

## Don't be religious

### Doing CIOps is just fine

Select well-established CI/CD tool

Do pipeline-as-code

Do fully automated deployments

Redeploy regularly

### *Official GitOps* will be an evolutionary step
