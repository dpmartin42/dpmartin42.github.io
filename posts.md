---
layout: page
title: Posts
---

<ul class="listing">

{% for post in site.posts %}
  {% assign currentdate = post.date | date: "%Y" %}
  {% if currentdate != date %}
    {% unless forloop.first %}</ul>{% endunless %}
    {% unless post.draft %}
    <h1 id="y{{post.date | date: "%Y"}}">{{ currentdate }}</h1>
    <ul>
    {% assign date = currentdate %}
    {% endunless %}
  {% endif %}
    {% unless post.draft %}
    <li><span>{{ post.date | date: "%B %e, %Y" }}</span> | <a href="{{ post.url }}">{{ post.title }}</a></li>
    {% endunless %}
  {% if forloop.last %}</ul>{% endif %}
{% endfor %}
    
</ul>