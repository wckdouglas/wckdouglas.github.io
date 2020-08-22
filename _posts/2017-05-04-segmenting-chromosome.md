---
layout: post
title: "Segmenting Chromosome"
category: post
date: 2017-05-04
comments: true
---

When computing statistics on each base across a chromosome, it is often not feasible to put the whole chromosome into memory.

Here is a python generator function to create segments on a chromosome and iterate through them.


```python
def make_regions(chromosome_length, how_many_bases_to_look_at):
    start = 0
    end = start + how_many_bases_to_look_at
    while end < chromosome_length:
        yield (start, end)
        start = end
        end = end + how_man_bases_to_look_at
    yield (start, chromosome_length)
```
