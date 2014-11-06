---
layout: post
title: The Wizarding Network of Harry Potter
category: stuff
---

I spent part of my summer as an intern at the [Center for Open Science](http://centerforopenscience.org/). I wanted to become more familiar with JavaScript (I never used it before the internship), so I carved out my own project to create a better network visualization of users on the [Open Science Framework](https://osf.io/). This way, researchers could see who is working with whom, and on what projects. 

While that code is still being integrated into the CoS infrastructure, I wanted to write a post applying/extending my code to other datasets. After some thought, I figured creating a network of Harry Potter character connections would be pretty neat. While I found <a href="https://github.com/efekarakus/potter-network/tree/master/data" target="_blank">this</a>, unfortunately I was looking for a dataset that contained more than 65 characters. Looks like a job for web scraping!

First, I scraped a list of 178 characters taken from <a href="http://en.wikipedia.org/wiki/List_of_Harry_Potter_characters" target="_blank">wikipedia</a>. These characters also have their own pages on a <a href="http://harrypotter.wikia.com/wiki/Main_Page" target="_blank">Harry Potter wiki site</a>, and the majority of these names were identical to what needed to be added to the URL to access the page. A quick code check revealed only a few mistakes to be corrected, but luckily not much manual labor was required in this step.

Next, I made the assumption that on a given character's page, any name that was hyperlinked in the main text share some "logical connection" relevant in the Harry Potter universe. Of course, this assumption may not be completely tenable, but the results this came up with seemed reasonable. Thus, each character page was scraped for an image to use on a custom slider I created, as well as a list of connections to the other characters on my list.

And that was it! All data scraping and cleaning took place in R, with the network layout being calculated using <a href="http://igraph.org/r/" target="_blank">igraph</a>. The actual network was visualized using the <a href="http://sigmajs.org/" target="_blank">sigma.js</a> JavaScript library, while the navigation tools and custom slider was created in plain ol' HTML/JavaScript.

Both Hadley Wickham's new R web scraping tool <a href="https://github.com/hadley/rvest" target="_blank">rvest</a> and the awesome <a href="http://selectorgadget.com/" target="_blank">SelectorGadget</a> actually made this web scraping task much easier than I thought it would be. Note that rvest is not yet available on CRAN, but you can get the development version off his GitHub using devtools. One of my next posts will outline how to use rvest in more detail.

Check out the finished product on my <a href="https://dpmartin42.github.io/visualizations.html" target="_blank">data visualization page</a>, and check out my <a href="https://github.com/dpmartin42/Networks" target="_blank">GitHub</a> if you want to see the web scraping or JavaScript code. I also included two more networks with simple datasets in case anyone is interested in messing around with <a href="http://sigmajs.org/" target="_blank">sigma.js</a>.


