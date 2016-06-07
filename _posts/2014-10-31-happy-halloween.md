---
layout: post
title: Happy Halloween!
category: stuff
---

[Christmas](http://simplystatistics.org/2012/12/24/make-a-christmas-tree-in-r-with-random-ornamentspresents/) gets all the love when creating holiday-themed plots in R. Halloween is great too, so here's a snippet of code for making a simple jack-o'-lantern in R.


{% highlight r %}
# Make the canvas
plot(1:10, 1:10, xlim = c(-5, 5), ylim = c(0, 10),
     type = "n", xlab = "", ylab = "", xaxt = "n", yaxt = "n")

# Make the pumpkin and the stem
rect(-0.5, 8, 0.5, 9, col = "darkgreen", border = "black", lwd = 3)
polygon(c(-2.5, -3, -3, -2.5, 2.5, 3, 3, 2.5),
        c(8, 5.67, 3.33, 1, 1, 3.3, 5.67, 8),
        col = "darkorange", border = "black", lwd = 3)

# Eyes and nose
polygon(c(-2, -1.5, -1), c(5.5, 6.5, 5.5), col = "black")
polygon(c(1, 1.5, 2), c(5.5, 6.5, 5.5), col = "black")
polygon(c(-0.5, 0, 0.5), c(4, 5, 4), col = "black")

# Mouth
polygon(c(-2, -1.5, 1.5,  2), c(3, 1.5, 1.5, 3), col = "black")

# top teeth
rect(-0.25, 2.5, 0.25, 3.1,
     col = "darkorange",
     border = "darkorange",
     lwd = 0)
rect(-1.5, 2.5, -1, 3.1,
     col = "darkorange",
     border = "darkorange",
     lwd = 0)
rect(1.5, 2.5, 1, 3.1,
     col = "darkorange",
     border = "darkorange",
     lwd = 0)

# bottom teeth
rect(0.3, 1.4, 0.9, 2,
     col = "darkorange",
     border = "darkorange",
     lwd = 0)
rect(-0.3, 1.4, -0.9, 2,
     col = "darkorange",
     border = "darkorange",
     lwd = 0)
{% endhighlight %}

![center](/figs/2014-10-31-happy-halloween/unnamed-chunk-1-1.png)

