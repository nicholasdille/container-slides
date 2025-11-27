# IDE

You can follow this workshop in the IDE (Integrated Development Environment) of your choice but...

A web-based instance of Visual Studio Code has been provisioned for you to follow this workshop.

Why not the integrated web IDE, you ask? Because it does not support a terminal for security reasons.

## Task 1: Access your instance of Visual Studio Code

1. Go to `https://seatN.vscode.inmylab.de` where `N` is a number.
1. Login using your personal user `seatN` (where `N` is a number) and your password

The password is the same as your GitLab password.

??? info "Hint (Click if you are stuck)"
    Your username looks like `seatN` where `N` is a number.

    Your password is a long, random string which is displayed on the web pages access in the previous chapter.

## Task 2: Use git in Visual Studio Code

Familiarize yourself with Visual Studio Code and the git workflow:

1. Make a small change to `README.md`
1. Stage the change
1. Commit the change
1. Push the commit
1. Make sure the change is visible in GitLab

??? info "Hint (Click if you are stuck)"
    Check the official documentation of Visual Studio Code for help with the [git workflow](https://code.visualstudio.com/docs/sourcecontrol/overview).

??? info "Hint (Click if you are stuck)"
    Make sure you enter a commit message - either in the box above the commit button or in the input box after you clicked the commit button.

??? info "Hint (Click if you are stuck)"
    Go to GitLab (`https://gitlab.inmylab.de`) and go to your project called `demo`.

## Troubleshooting: Context menu not working correctly

When using Firefox, the context menu may not show up without issues. This can be fixed as [proposed on StackOverflow](https://stackoverflow.com/questions/79320517/why-does-right-click-in-a-code-server-instance-of-vs-code-open-paste-instead-o):

1. Go to `about:config`
1. Search for `dom.events.testing.asyncClipboard`
1. Set it to `true`
