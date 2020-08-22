---
layout: post
title: "Notes on Contributing to Open Source Software on GitHub"
date: 2018-03-03T16:52:09-06:00
---

This is a note for myself on contributing to open source software on [GitHub](https://github.com/). Specifically on the the topic of making multiple pull requests from my own fork on a public repository. 

Dislaimer: Everything here is based on my own understanding from multiple sources ([stackoverflow](https://stackoverflow.com/questions/8450036/how-to-open-multiple-pull-requests-on-github), [bitbucket tutorial](https://www.atlassian.com/git/tutorials/comparing-workflows/feature-branch-workflow) and [hub](https://hub.github.com/)), it may not be the "right" way to do it.

<h1 id='overview'> Overview </h1>

![Figure 1]({{ site.baseurl }}/assets/article_images/git_feature_branch/git_faeture_branch.png)

I am using [pysam](https://github.com/pysam-developers/pysam) as an [example](#overview) to illustrate the use of [git feature branch workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/feature-branch-workflow) for creating multiple pull requests from a single fork/user. 

### 1. Always start with a fork ###

On GitHub, every public repository can be forked. Forking a repository means cloning the repository and creating a copy that resides on the user's own GitHub homepage. 

For this *pysam* example, forking *pysam* from ```pysam-developers/pysam``` is going to create a *pysam* repository on ```wckdouglas/pysam```.

### 2. Make a local copy ###

Cloning repositories from GitHub to a local destination should be familiar to most GitHub users. This can be done by ```git clone git@github.com:wckdouglas/pysam.git```.

### 3. Make a new branch for a new feature ###

It is [suggested](https://www.atlassian.com/git/tutorials/comparing-workflows/feature-branch-workflow) **master branch** should not be touched, every new feature should be added to it's own isolated branch. This practice ensures every pull request is only adding one feature or fixing one issue at a time, and is better for the maintainer to review/merge the pull requests. 

Suppose there are two new features (**new_feature_1** and **new_feature_2**) that I want to add, it will require make two new branches:

1. First feature branch
```
git branch new_feature_1
git checkout new_feature_1
```

2. Second feature branch
```
git branch new_feature_2
git checkout new_feature_2
```

Alternatively, it can be done in a single command:

```
git checkout -b new_feature_1  
git checkout -b new_feature_2
```

* ```checkout -b``` checks a branch out, or creates it if its not there 

### 4. Push branches to GitHub repository  ###

After making changes, branches can be push to GitHub repository by 

```
git push origin new_feature_1
```

If the branch is pushed to GitHub, then a pull request can be made by clicking ***New pull request*** (blue box) from the chosen fork (red box).

![Figure 2]({{ site.baseurl }}/assets/article_images/git_feature_branch/github_branch.png)

### 5. Workflow ###

So if I want to add two different features, the workflow will be:

```
git checkout -b new_feature_1
< ...make changes... >
git commit -am 'some message'
git push origin new_feature_1
```

Then, make a new branch from **master branch*, and do the same thing again:

```
git branch new_feature_2 master
git checkout new_feature_2
< ...make changes... >
git commit -am 'some message'
git push origin new_feature_2
```

# A rookie mistake #

Git is magical, and this is mostly the reason why we don't always do things right at the first time. As *pysam* is the first repository that I have made two pull requests before any of them was merged, I made a mistake where I fixed an [issue](https://github.com/pysam-developers/pysam/pull/621) on my **master branch** and made a pull request from my **master branch**. This was fine until I wanted to make a change to speed up a function in *pysam*, since any new commits and pushes on my **master branch** will automatically be added to the first pull requests that I made and will violate the rule: [one pull request should only fix one thing](https://medium.com/@fagnerbrack/one-pull-request-one-concern-e84a27dfe9f1). 

Long story short, I fixed this by checking out the last commit before I made any changes on **master branch**, then started a new branch (**speed_up_find_intron**) based on this commit, and finally made a second [pull request](https://github.com/pysam-developers/pysam/pull/635) with this branch (**speed_up_find_intron**). But my first pull is still made from my **master branch**... Anyway, I hope anyone who read this post will not make the same mistake that I did.


```
git checkout <last commit before I amde changes>  # revert to the initial state of the public repository 
git checkout -b speed_up_find_intron              # make a fresh branch that only add one feature
< ...make changes...>                               
git commit -am 'fixed a inefficient loop'
git push origin speed_up_find_intron              # push this new branch to my own github repository   
```


# Side notes #

* Some [oh-my-zsh themes](https://github.com/robbyrussell/oh-my-zsh/wiki/themes) show the name of the current Git Branch on the commandline prompt, this info can be very helpful if one is working on multiple branches. An example oh-my-zsh theme:

![](https://cloud.githubusercontent.com/assets/124808/21915191/89dffcac-d97b-11e6-8b46-ea5fbddde02a.png)


* [Sourcetree](https://www.sourcetreeapp.com/) can be very helpful on vizualizing branches as well (Given that one is not using a Linux machine.....):

![](https://atlassianblog.wpengine.com/wp-content/uploads/visualize-original-windows.jpg)


* [Visual Studio Code](https://code.visualstudio.com/docs/editor/versioncontrol) has integrated Git, and can show the Git branch of the currently-editing file (see bottom left corner):

![](https://code.visualstudio.com/assets/docs/extensionAPI/api-scm/main.png)