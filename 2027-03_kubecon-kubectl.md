# kubectl like a pro

## bio

Nicholas Dille is a DevOps Engineer at Haufe Group in Freiburg, Germany, where he keeps the machinery running for development teams across the full DevOps lifecycle. Before that, he spent years as an IT architect in consulting designing and implementing large-scale infrastructure and end-user computing environments for enterprise clients. He has been obsessed with automation and containerization for over 20 years.
He teaches Kubernetes, observability, and GitLab through heise Academy, and is the creator of uniget (https://uniget.dev), an installer and updater for CLI tools from the container ecosystem and beyond. He has been a Docker Captain and a Microsoft MVP, speaks regularly at community events and conferences, and has been writing about things that interest him on his community blog since 2001.
When not staring at terminals, he plays trumpet and runs ideally not at the same time.

Nicholas Dille is a Senior DevOps Engineer at Haufe Group, Germany, with a background in IT architecture and enterprise consulting. Obsessed with automation and containerization for over 20 years, he teaches Kubernetes and DevOps topics through heise Academy, speaks regularly at community events and conferences, and is the creator of uniget, an installer and updater for CLI tools. When not staring at terminals, he plays trumpet and runs ideally not at the same time.

## abstract

You type kubectl more times a day than you drink coffee. You know your get, apply, and describe. But there's a whole layer of the tool you walk past every single day and it's been quietly solving problems you're still solving the hard way.
This session is a practical tour of kubectl features that most people either don't know exist or never got around to learning. We'll cover how to find the one resource you actually care about. How to watch things change without losing your mind or your terminal width. How to shape output so it feeds into pipelines without grep and awk abuse. How to diff, patch, and update without accidentally wrecking immutable fields.
Along the way we'll pick up kuberc for sane defaults, kubectl diff with your own diff tool, impersonation for safer access, the API proxy you probably didn't know was there, and a handful of plugins that feel like you should have installed them from day one.
No new tools to install. No frameworks to learn. Just kubectl, used properly.

## value

kubectl is the daily driver for anyone working with Kubernetes, yet most practitioners use only a fraction of what it offers. This talk gives attendees immediately actionable techniques that they can apply the next day. It also covers recent additions in Kubernetes 1.34 that are not yet widely known. Attendees leave with a better understanding of a tool they already use, reducing toil and avoiding common pitfalls.