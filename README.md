# htimer
This is a little console program I wrote that simply loops counting down a list of timeframes (in seconds).

Aka `htimer 10 60` &#x2192; countdown 10 .. 0 (from 10 to 0) seconds, then countdown 60 .. 0 then 10 .. 0 again.

It accepts any number of timeframes as input.

`htimer 10 5 60 80` &#x2192; 10 .. 0 >> (then) 5 .. 0 >> 60 .. 0 >> 80 .. 0 and repeat (indefinetly).

It displays intermediate steps in a sane way. Aka &#x221e; .. 10 it prints the remaining time every *n* mod 10 = 0 step >> 5 .. 1 every second, 0 is not printed, instead it says "NEXT".
