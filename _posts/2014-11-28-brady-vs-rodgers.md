---
layout: post
title: Brady/Rodgers Showdown
---

With the way both teams are playing right now, this could be the first look at a possible Super Bowl matchup. As of the Friday before the game, various websites have the Packers as three-point favorites at home. In thinking about the outcome of the game, I realized I did not know the Packers' offense that well. Of course Rodgers has been playing great, but who does he favor as targets? What part of the field does he like to throw to? It seems like I always see a bomb or two to Jordy Nelson on SportsCenter. To get a better idea, I tried to find some data to get a better look at who Brady and Rodgers are targeting and where. Luckily, I was able to find a play-by-play data set from the beginning of 2014 season to the present, which is freely available from [NFLsavant.com](http://nflsavant.com/about.php). 

First, I decided to take a look at how pass targets are spread across the field between both the Green Bay and New England offense. See the figure below, and note that this includes all passing plays. As such, some attempts might be made by either Jimmy Garoppolo (New England's backup), or Matt Flynn (Green Bay's backup). Obviously more pass attempts are made closer to the line of scrimmage. Rodgers appears to slightly favor the right side of the field, while Brady seems to have substantial preference for short throws to the left side of the field. This is probably due to the high number of attempts to Edelman running either an out route on the left side of the field, or a crossing route from right to left.




    
![center](/figs/2014-11-28-brady-vs-rodgers/unnamed-chunk-3-1.png)

I then examined how the number of targets varied by location and player. This step required a little bit of work given that only a description of each play was included in the data set and not the actual targeted player. The regular expression I used was certainly not perfect due to some inconsistencies in these descriptions. However, it seemed to capture the majority of the information correctly. Again, this included pass attempts by the offense as a whole, not just with the starting QBs. The first figure shows the data for Green Bay. By far, Jordy Nelson is the favorite target, catching quite a few short passes on both the right and left side of the field. The vast majority of deep passes going to Nelson are on the left side of the field. Randall Cobb is also a popular target, though he tends to be targeted on short passes to the left side of the field.



![center](/figs/2014-11-28-brady-vs-rodgers/unnamed-chunk-5-1.png)

While the Packers' offense is dominated by Nelson and Cobb, the Patriots offense is much more evenly-distributed. In addition to Edelman and Lafell as popular WR options, Brady also looks to Gronkowski, the TE, and Vereen, the 3rd-down running back. Edelman is the overall favorite for short throws to the left and right side of the field, though not by much. Gronkowski is also a favorite target down the middle of the field, where he is looking to get open against zone defenses with a seam route.  

![center](/figs/2014-11-28-brady-vs-rodgers/unnamed-chunk-6-1.png)

This analysis is nowhere near exhaustive, but it gave me a better idea of what to expect for the game on Sunday. With the level of detail found in this play-by-play data set, I am hoping to do something a little more interesting for playoff teams at the end of the season. As always, the code and data can be found on [GitHub](https://github.com/dpmartin42/dpmartin42.github.io).
