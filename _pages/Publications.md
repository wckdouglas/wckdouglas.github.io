---
layout: page
category : pages
title: PUBLICATIONS
permalink: /publications/
---
<script type='text/javascript' src='https://d1bxh8uas1mnw7.cloudfront.net/assets/embed.js'></script>


<ul class="pub-list">
{% assign year = "0000" %}
{% for pub in site.data.publications %}
    {% if year != pub.year %}
      {% assign year = pub.year %}
      <h1 class="pub-year">{{ year | capitalize }} </h1>
    {% endif %}
    
    <li> {{ pub.author }} ({{ pub.year }}). <a href="{{ pub.link }}">{{ pub.title }}.</a> <i>{{ pub.ref }}.</i>

    <!-- Volumn and issue  -->
    {% if pub.vol %}
        {{ pub.vol }}
    {% endif %} 

    <!-- DOI/almetric -->
    {% if pub.doi %}
        <div style="display: inline; white-space: nowrap" data-badge-popover="right" data-badge-type="4" data-doi="{{pub.doi}}" data-hide-no-mentions="true" class="altmetric-embed">
        </div>
    {% endif %}
    
    <!-- GITHUB script  -->
    {% if pub.scripts %}
        <a style="display:inline" href="{{ pub.scripts }}"><img style="display:inline" src="{{ site.baseurl }}/assets/icons/github.png" alt="" width="20" height="20">
        </a>
    {% endif %} 
    
    <!-- SRA project  -->
    {% if pub.sra %}
        <a style="display:inline" href="{{ pub.sra }}"><img style="display:inline" src="{{ site.baseurl }}/assets/icons/flatiron_cloud-computing.png" alt="" width="20" height="20">
        </a>
    {% endif %}
    </li>
    <br>

{% endfor %}