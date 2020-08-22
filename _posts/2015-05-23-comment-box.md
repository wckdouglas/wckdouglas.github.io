---
layout: post
comments: TRUE
title:  "Comment box in Jekyll blog"
date:   2015-05-23
categories: mediator feature
tags: featured
---

I have spent a few hours today to figure out a way to add comment boxes in each post today.

So I come up with **[Disqus](https://disqus.com)**.

---
### Step 1
![step1]({{ site.url }}/assets/article_images/staticCommentBox/step1.png)

1. Create a **Disqus** account.
2. On the top right corner, press the preference button
3. Press *Add Disqus To Site*.

---
### Step 2
![step2]({{ site.url }}/assets/article_images/staticCommentBox/step2.png)

1. Fill up this form with something.
2. Press *Finish registration*.

---
### Step 3
![step3]({{ site.url }}/assets/article_images/staticCommentBox/step3.png)

* Press *Universal Code*.

---
### Step 4
![step4]({{ site.url }}/assets/article_images/staticCommentBox/step4.png)

* Follow the instructions and add the code into whereever it suppose to be at.

<script src="https://gist.github.com/wckdouglas/b3b4aa8ad18b76d546df.js"></script>

1. I copied the code above into /_include/comments.html
2. and added the following line to /_layouts/post.html

<script src="https://gist.github.com/wckdouglas/b317ca1c0a7deb00bd53.js"></script>


Updated: I switched to [google+ comment box](http://steelx.github.io/best-internet-tips/2014/11/23/Add-google-plus-comments-box-to-jekyll-website.html) now.
