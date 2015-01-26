---
layout: post
title: We're on to Seattle
category: stuff
---

Unfortunately the [Pats/Packers Super Bowl Prediction](http://dpmartin42.github.io/posts/brady-vs-rodgers/) I made in Week 13 came up just short. To get my mind off of the Patriots' football inflation tendencies and back on to the upcoming Super Bowl next week, I decided to update my previous football post where I looked at play-by-play data to visualize on-the-field pass distribution between the Pats and the Packers. I do the same here, but I also include rushing plays because the Seahawks are more of a run-heavy offense.

Starting with the aerial attack, I looked at where pass targets typically occurred on the field between Brady and Wilson. Brady has a strong preference for short throws to the left side of the field, which typically come in the form of an out route to Edelman, LaFell, or Vereen. Wilson, on the other hand, has a slight preference for the right side of the field. In total, the Pats obviously have a larger number of pass attempts this season.





![center](/figs/2015-01-25-on-to-Seattle/unnamed-chunk-3.png) 

Next, I examined how number of targets varied by both location and player (with at least 5 targets). Since only the description of each play was included in the data set, I used regular expressions to identify the targeted player. The first figure shows the data for New England. Again, we see a huge preference for short passes to the left by Brady. However, targets in this location seem to be fairly uniform across the most highly targeted players (Edelman, Gronk, Vereen, and LaFell). Gronk is favored up the middle, while Edelman is slightly favored to the right. 



![center](/figs/2015-01-25-on-to-Seattle/unnamed-chunk-5.png) 

Like Brady, Wilson also does not take many shots down the field, where he typically looks to Kearse down the right. While Baldwin receives the vast majority of the targets, the Seahawks have many others who are involved in the offense. For example, Lynch will be targeted on the left side of the field for short passes, while any one of four Seahawks (Kearse, Willson, Lynch, and Richardson; Harvin is no longer with the team) can be seen getting involved with short passes to the right. Like previously mentioned, Wilson favors short passes to the right side of the field.

![center](/figs/2015-01-25-on-to-Seattle/unnamed-chunk-6.png) 

I then took a look at both team's run offenses to finish up the post. I first plotted the number of rushes by the direction of the rush. The Patriots seem to start every week with a different running back. Ever since Ridley was lost for the season, the team has mainly been going with Blount as the power rusher and Vereen as the change-of-pace back, with a little bit of Gray sprinkled here and there. Either that, or they just ignore the run game all together. The Seahawks, on the other hand, favor the man known as "beast mode." The Seahawks also have quite a few QB scrambles, with almost 50 on the year (these are denoted by the tick mark without a label all the way to the right of the plot). Overall, both teams follow similar patterns in terms of location; the Seahawks just have a lot more rushes. Additionally, the Seahawks put a little less focus on running to the guards (who are probably just pulling to become an extra blocker on these plays). 



![center](/figs/2015-01-25-on-to-Seattle/unnamed-chunk-8.png) 



Finally, I faceted the plot above by player (minimum 10 touches). You can immediately identify the lack of a number one back for the Pats just by glancing at the number of touches given to each player. This is also a product of losing Ridley in the middle of the season, given the number of touches he had in the first few weeks. Blount has been picking up the slack, though, since he was also acquired right after Ridley got injured (and a week after Gray's monster performance versus the Colts in the regular season). As a fan, seeing Vereen get so many touches up the middle can be annoying, especially because he is a third down back. I know many other Pats fans have not been happy with the play calling this season with that respect. Hopefully this trend does not continue for the Super Bowl.

![center](/figs/2015-01-25-on-to-Seattle/unnamed-chunk-10.png) 

While the Pats had quite a few players contributing in the rushing game, it's not too hard to see what the Seahawks like to do. Lynch up the middle: all day, every day. This is the key to stopping the Seahawks offensive game plan. Notice, however, the number of designed runs and scrambles by Wilson as well. It will be tough to stop both Lynch and contain Wilson, and I expect the pass rush to suffer as a result. I expect the Pats defense will dare Wilson to throw, and rely on their upgraded secondary with Revis, Browner, McCourty, and Chung to win the game.

![center](/figs/2015-01-25-on-to-Seattle/unnamed-chunk-11.png) 

As always, the code and data can be found on [GitHub](https://github.com/dpmartin42/dpmartin42.github.io). GO PATS!
