---
layout: lesson
root: ../..
title: Working with Report Data (Excel or Director's Station)
---

## Opening

Librarians often find themselves working with speadsheets, in particular,
Excel files.  Excel is the most popular spreadsheet software.  Spreadsheets
are designed to store and analyze tabular or categorized data.  Librarians
also use a tool called Director's Station that allows creation of 
reports of library data.

While these two tools can be useful, there are some limitations

- They often require repetative tasks to be performed in creation of reports
- They cost money to purchase licenses
- A librarian may need to learn two sets of skills - one for Excel, one
 for Director's station - to perform very similar tasks

By coupling learning how to program in a general-purpose language like Python 
with an understanding of how data is stored, a librarian can learn to automate
tasks to save time and to overcome new obstacles they
discover in either Excel, Director's Station or any other software tool.

The rest of this chapter will explore how to use Python to manipulate
library-related data.  We acknowledge that not all librarians use the same
tools, but we have designed this lessons to be as general as possible.

## A simple example

Consider a the following data as an example of a spreadsheet that a librarian
may find themself working with.

![]({{page.root}}/lessons/swc-librarians/images/excel.png)

Eventually, we will get to the point where can know how many holds 
there are on Ender's Game.

Here is the data of the above spreadsheet exported as [CSV file](../../data/librarians/simple.csv).

    List Titles with Holds,,,,,,,,
    Holds,Title,Author,Hold Created Date,Hold Placed Lib,Item Library,Pickup Library,Item Type,Availability
    1,RED 2,Malkovich, John,2014-05-14 0:00,EPLWMC,EPLLHL,EPLRIV,DVD7,Not Available
    1,ENDER'S GAME,Card, Orson Scott,2014-05-12 0:00,EPLWMC,EPLLHL,EPLWMC,BOOK,Available
    1,GRAMMY NOMINEES N2012,,2014-05-14 0:00,EPLWMC,EPLMNA,EPLWMC,CD,Not Available
    1,GRAMMY NOMINEES N2011,,2014-05-14 0:00,EPLWMC,EPLLON,EPLWMC,CD,Not Available
    1,GRAMMY NOMINEES N2014,,2014-05-14 0:00,EPLWMC,EPLMNA,EPLWMC,CD,Not Available
    1,GRAMMY NOMINEES N2007,,2014-05-14 0:00,EPLWMC,EPLLON,EPLWMC,CD,Not Available
    1,THE STORY OF ASTRONOMY,Aughton, Peter,2014-05-14 0:00,EPLWMC,EPLMNA,EPLWMC,BOOK,Not Available
    1,GRAMMY NOMINEES N2009,,2014-05-14 0:00,EPLWMC,EPLCPL,EPLWMC,CD,Not Available
    1,ENDER'S GAME,Hood, Gavin,2014-05-13 0:00,EPLWMC,EPLZORDER,EPLWMC,JDVD7,Not Available
    1,RAYGUN COWBOYS,Raygun Cowboys,2014-05-14 0:00,EPLWMC,EPLCSD,EPLWMC,CD,Not Available
    1,GRAMMY NOMINEES N2010,,2014-05-14 0:00,EPLWMC,EPLLON,EPLWMC,CD,Not Available
    1,ALLOSAURUS A WALKING WITH,Branagh, Kenneth,2014-05-13 0:00,EPLWMC,EPLLHL,EPLWMC,DVD7,Not Available
    1,AMAZING MAGIC TRICKS BEGINNER LEVEL,Barnhart, Norm,2014-05-13 0:00,EPLWMC,EPLABB,EPLWMC,JBOOK,Not Available
    1,BLUESAMERICANA,Mo, Keb,2014-05-13 0:00,EPLWMC,EPLZORDER,EPLWMC,CD,Not Available
    1,BRAVE,Chapman, Brenda,2014-05-13 0:00,EPLWMC,EPLWOO,EPLJPL,JDVD7,Not Available
    1,BREAKAWAY,Hirsch, Jeff,2014-05-13 0:00,EPLWMC,EPLSTR,EPLSTR,JCD,Available
    1,CLASSIC CANADIAN ROCK,,2014-05-13 0:00,EPLWMC,EPLMLW,EPLWMC,CD,Not Available
    1,CRASH MY PARTY,Bryan, Luke,2014-05-13 0:00,EPLWMC,EPLLHL,EPLMLW,CD,Not Available
    1,CREATIVE SEED BEAD CONNECT, JUMP RINGS, AND C,Meister, Teresa,2014-05-13 0:00,EPLWMC,EPLMNA,EPLWMC,BOOK,Intransit
    1,DANCE PARTY 2013 [14 ESSENTIAL HITS,Cash, Cory,2014-05-13 0:00,EPLWMC,EPLLON,EPLWMC,CD,Not Available
    1,ENDER'S GAME,Card, Orson Scott,2014-05-07 0:00,EPLWMC,EPLWMC,EPLWMC,BOOK,Available
    1,DIGGING CANADIAN HISTORY,Grambo, Rebecca,2014-05-13 0:00,EPLWMC,EPLMLW,EPLWMC,JBOOK,Not Available

### Our problem

As part of an annual report, we want to know what our items with the most holds are.
We could compare number of holds to, say, the number of copies of each popular item.

Looking at the above, the most popular item is *Ender's Game* by Orson Scott
Card?  We can figure this out by counting.  But, the actual file containing these hold records has
over 35000 hold records.  Clearly we can't count that many and so need to automate.

For this problem we're going to use BASH shell programming to answer it, not Python.  So we have to
figure out the important information is?  It's obviously the title of the item which is the second column.
Each line only represents 1 hold, so the **1** in the first column doesn't actually tell us anything.  So what
we need to know is how many lines have the same item in the second column, the title.

#### Display the file

Let's start simply by printing out the whole file (it's only 22 lines).  **cat** is the program to do this.  Simply run

     % cat simple.csv

and you'll get all the text of the file

#### The Ugly Header

The first two lines of the file are not meaningful in terms of actual holds, they're just headers from the spreadsheet.

    List Titles with Holds,,,,,,,,
    Holds,Title,Author,Hold Created Date,Hold Placed Lib,Item Library,Pickup Library,Item Type,Availability 

There's a program called **tail** that prints out the last part of
a file.  We want *almost* all of the file, but we want to skip the first two
lines.  This is super easy to do with **tail**.  The parameter **-n +3** tells
tail to start from the 3rd line.  So

    % tail -n +3 simple.csv

will give us

    1,RED 2,Malkovich, John,2014-05-14 0:00,EPLWMC,EPLLHL,EPLRIV,DVD7,Not Available
    1,ENDER'S GAME,Card, Orson Scott,2014-05-12 0:00,EPLWMC,EPLLHL,EPLWMC,BOOK,Available
    1,GRAMMY NOMINEES N2012,,2014-05-14 0:00,EPLWMC,EPLMNA,EPLWMC,CD,Not Available
    1,GRAMMY NOMINEES N2011,,2014-05-14 0:00,EPLWMC,EPLLON,EPLWMC,CD,Not Available
    1,GRAMMY NOMINEES N2014,,2014-05-14 0:00,EPLWMC,EPLMNA,EPLWMC,CD,Not Available
    1,GRAMMY NOMINEES N2007,,2014-05-14 0:00,EPLWMC,EPLLON,EPLWMC,CD,Not Available
    1,THE STORY OF ASTRONOMY,Aughton, Peter,2014-05-14 0:00,EPLWMC,EPLMNA,EPLWMC,BOOK,Not Available
    1,GRAMMY NOMINEES N2009,,2014-05-14 0:00,EPLWMC,EPLCPL,EPLWMC,CD,Not Available
    2,ENDER'S GAME,Hood, Gavin,2014-05-13 0:00,EPLWMC,EPLZORDER,EPLWMC,JDVD7,Not Available
    1,RAYGUN COWBOYS,Raygun Cowboys,2014-05-14 0:00,EPLWMC,EPLCSD,EPLWMC,CD,Not Available
    1,GRAMMY NOMINEES N2010,,2014-05-14 0:00,EPLWMC,EPLLON,EPLWMC,CD,Not Available
    1,ALLOSAURUS A WALKING WITH,Branagh, Kenneth,2014-05-13 0:00,EPLWMC,EPLLHL,EPLWMC,DVD7,Not Available
    1,AMAZING MAGIC TRICKS BEGINNER LEVEL,Barnhart, Norm,2014-05-13 0:00,EPLWMC,EPLABB,EPLWMC,JBOOK,Not Available
    1,BLUESAMERICANA,Mo, Keb,2014-05-13 0:00,EPLWMC,EPLZORDER,EPLWMC,CD,Not Available
    1,BRAVE,Chapman, Brenda,2014-05-13 0:00,EPLWMC,EPLWOO,EPLJPL,JDVD7,Not Available
    1,BREAKAWAY,Hirsch, Jeff,2014-05-13 0:00,EPLWMC,EPLSTR,EPLSTR,JCD,Available
    1,CLASSIC CANADIAN ROCK,,2014-05-13 0:00,EPLWMC,EPLMLW,EPLWMC,CD,Not Available
    1,CRASH MY PARTY,Bryan, Luke,2014-05-13 0:00,EPLWMC,EPLLHL,EPLMLW,CD,Not Available
    1,CREATIVE SEED BEAD CONNECT, JUMP RINGS, AND C,Meister, Teresa,2014-05-13 0:00,EPLWMC,EPLMNA,EPLWMC,BOOK,Intransit
    1,DANCE PARTY 2013 [14 ESSENTIAL HITS,Cash, Cory,2014-05-13 0:00,EPLWMC,EPLLON,EPLWMC,CD,Not Available
    1,ENDER'S GAME,Card, Orson Scott,2014-05-07 0:00,EPLWMC,EPLWMC,EPLWMC,BOOK,Available
    1,DIGGING CANADIAN HISTORY,Grambo, Rebecca,2014-05-13 0:00,EPLWMC,EPLMLW,EPLWMC,JBOOK,Not Available

Play around with **tail** and see what it does.  In fact, I encourage your to play around with all
the shell programs in this lesson as we come across them.

#### Filtering the important information

Now we have just the meaningful lines, but not every piece of data is necessary to solve our problem for what
is the most popular hold item.
Needing only the second column, we turn to the **cut** program to extract only that column.  **cut** is made to work
with columnar data.  It works like this

    cut -d , -f 2

the **-d** parameter gives the *delimiter* (the character that separates
columns).  Since this is a CSV file (Comma Separate Values) the delimite is a comma.  The **-f** parameter tells **cut** which columns to print.  We can print as many as we want.  For example, if we want the 2nd, 5th and 9th columns, we could give the parameter **-f 2,5,9** which would print

    ,,
    Title,Hold Placed Lib,Availability
    RED 2,2014-05-14 0:00,DVD7
    ENDER'S GAME,2014-05-12 0:00,BOOK
    GRAMMY NOMINEES N2012,EPLWMC,Not Available
    GRAMMY NOMINEES N2011,EPLWMC,Not Available
    GRAMMY NOMINEES N2014,EPLWMC,Not Available
    GRAMMY NOMINEES N2007,EPLWMC,Not Available
    THE STORY OF ASTRONOMY,2014-05-14 0:00,BOOK
    GRAMMY NOMINEES N2009,EPLWMC,Not Available
    ENDER'S GAME,2014-05-13 0:00,JDVD7
    RAYGUN COWBOYS,EPLWMC,Not Available
    GRAMMY NOMINEES N2010,EPLWMC,Not Available
    ALLOSAURUS A WALKING WITH,2014-05-13 0:00,DVD7
    AMAZING MAGIC TRICKS BEGINNER LEVEL,2014-05-13 0:00,JBOOK
    BLUESAMERICANA,2014-05-13 0:00,CD
    BRAVE,2014-05-13 0:00,JDVD7
    BREAKAWAY,2014-05-13 0:00,JCD
    CLASSIC CANADIAN ROCK,EPLWMC,Not Available
    CRASH MY PARTY,2014-05-13 0:00,CD
    CREATIVE SEED BEAD CONNECT,Meister,EPLMNA
    DANCE PARTY 2013 [14 ESSENTIAL HITS,2014-05-13 0:00,CD
    ENDER'S GAME,2014-05-07 0:00,BOOK
    DIGGING CANADIAN HISTORY,2014-05-13 0:00,JBOOK

But, we only want the second column so we run

    % cut -d , -f 2

BUT, the data we REALLY want to use is the *output* of the **tail** program
above, not the original file (it has the ugly header)?  How can we get our
**tail** program to send it's output to our **cut** program.  We do, by using
the **pipe**.  A pipe character **|** is located above the return key, usually
the same key as backslash(\), so you'll likely have to press the shift key to 
access it.

To combine our programs in the way we want we type the following

    tail -n +3 simple.csv | cut -d , -f 2

Looks powerful, doesn't it?  This give us the following output
    
    RED 2
    ENDER'S GAME
    GRAMMY NOMINEES N2012
    GRAMMY NOMINEES N2011
    GRAMMY NOMINEES N2014
    GRAMMY NOMINEES N2007
    THE STORY OF ASTRONOMY
    GRAMMY NOMINEES N2009
    ENDER'S GAME
    RAYGUN COWBOYS
    GRAMMY NOMINEES N2010
    ALLOSAURUS A WALKING WITH
    AMAZING MAGIC TRICKS BEGINNER LEVEL
    BLUESAMERICANA
    BRAVE
    BREAKAWAY
    CLASSIC CANADIAN ROCK
    CRASH MY PARTY
    CREATIVE SEED BEAD CONNECT
    DANCE PARTY 2013 [14 ESSENTIAL HITS
    ENDER'S GAME
    DIGGING CANADIAN HISTORY

This is the data we really care about, but how can we calculate the number of
times each item appears?  The first step is getting all the lines with the
same titles together.  How do we do that?  We sort them!

#### Combining data

Yes, there's a program called **sort** which sorts line alphabetically/lexicographically.
Once again, we'll connect our output from cut to sort with a pipe


    tail -n +3 simple.csv | cut -d , -f 2 | sort

No parameters are needed for sort.  Now we get,
    
    ALLOSAURUS A WALKING WITH
    AMAZING MAGIC TRICKS BEGINNER LEVEL
    BLUESAMERICANA
    BRAVE
    BREAKAWAY
    CLASSIC CANADIAN ROCK
    CRASH MY PARTY
    CREATIVE SEED BEAD CONNECT
    DANCE PARTY 2013 [14 ESSENTIAL HITS
    DIGGING CANADIAN HISTORY
    ENDER'S GAME
    ENDER'S GAME
    ENDER'S GAME
    GRAMMY NOMINEES N2007
    GRAMMY NOMINEES N2009
    GRAMMY NOMINEES N2010
    GRAMMY NOMINEES N2011
    GRAMMY NOMINEES N2012
    GRAMMY NOMINEES N2014
    RAYGUN COWBOYS
    RED 2
    THE STORY OF ASTRONOMY

So, it would certainly be easier to manually count now as the same title
appears on consecutive lines, but remember, we have 35000 hold records, so
let's keep automating.

How can we get the three lines of "ENDER'S GAME" to be counted together?
Well, there's a program to do that too!  It's called **uniq** and it combines
identical consecutive lines into one line.  We can even get it to give a count
by passing the parameter **-c**.

    tail -n +3 simple.csv | cut -d , -f 2 | sort | uniq -c

    1 ALLOSAURUS A WALKING WITH
    1 AMAZING MAGIC TRICKS BEGINNER LEVEL
    1 BLUESAMERICANA
    1 BRAVE
    1 BREAKAWAY
    1 CLASSIC CANADIAN ROCK
    1 CRASH MY PARTY
    1 CREATIVE SEED BEAD CONNECT
    1 DANCE PARTY 2013 [14 ESSENTIAL HITS
    1 DIGGING CANADIAN HISTORY
    3 ENDER'S GAME
    1 GRAMMY NOMINEES N2007
    1 GRAMMY NOMINEES N2009
    1 GRAMMY NOMINEES N2010
    1 GRAMMY NOMINEES N2011
    1 GRAMMY NOMINEES N2012
    1 GRAMMY NOMINEES N2014
    1 RAYGUN COWBOYS
    1 RED 2
    1 THE STORY OF ASTRONOMY

Notice "ENDER'S GAME" has a count of 3 and all others have a count of 1 (the others only appear once).  We'll we have
the counts of each hold title now.  But, how do we find the maximum value?  Well, we can sort them based on the count and the highest count will be at the top.  So we'll use our **sort** program again.  This time we pass the **-n** parameter to tell sort to sort based on the first value *numerically*, not *lexicographically*.  We also give the **-r** parameter to get descending order (the 'r' means reverse) rather than ascending and our final output is.

    tail -n +3 22-holds.csv | cut -d , -f 2 | sort | uniq -c | sort -n -r

And we get

    3 ENDER'S GAME
    1 THE STORY OF ASTRONOMY
    1 RED 2
    1 RAYGUN COWBOYS
    1 GRAMMY NOMINEES N2014
    1 GRAMMY NOMINEES N2012
    1 GRAMMY NOMINEES N2011
    1 GRAMMY NOMINEES N2010
    1 GRAMMY NOMINEES N2009
    1 GRAMMY NOMINEES N2007
    1 DIGGING CANADIAN HISTORY
    1 DANCE PARTY 2013 [14 ESSENTIAL HITS
    1 CREATIVE SEED BEAD CONNECT
    1 CRASH MY PARTY
    1 CLASSIC CANADIAN ROCK
    1 BREAKAWAY
    1 BRAVE
    1 BLUESAMERICANA
    1 AMAZING MAGIC TRICKS BEGINNER LEVEL
    1 ALLOSAURUS A WALKING WITH

## Summary

We have successfully determined the most popular hold for this file, ENDER'S
GAME, and in doing so achieved the following:

 - Running shell programs (tail, cut, sort, uniq)
 - Extracting select data from CSV files using cut
 - Combining multiple programs with pipes

For reference, if we run this program on the actual hold data (35000+ records)
it runs in less than 5 seconds, and the output is:

    333
    282 FROZEN
    184 THE BOOK THIEF
    153 GRAVITY
    151 THE WOLF OF WALL STREET
    137 12 YEARS A SLAVE
    127 AMERICAN HUSTLE
    119 THE HUNGER GAMES PCATCHING FIRE
    114 DALLAS BUYERS CLUB
    109 CAPTAIN PHILLIPS

The most popular hold is...Frozen (not suprising in 2014) with 282 holds.  But what is the
333?  Recall we are sorting the 2nd
column (title) for the holds.  The 333 means that 333 hold records had the
title blank (blanks are considered the same and so **uniq** groups them
together).  In short, we are using real data and a real librarian would look
into how the title field is being left blank.

### Need a bigger challenge?

You may treat the follow on as "take home" assignments to add a level of challenge, or if you find the above example
too simple then try your hand at these.  An instructor may give these to
advanced students to occupy them while giving the lesson above.

  1.  How do we find the most common hold at the EPLWNC branch?
 
  2.  Create a shell script that can run these bash commands on any file
 
      % ./most_common_hold.sh simple.csv
