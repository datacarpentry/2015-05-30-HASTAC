---
layout: lesson
root: ../..
title: Processing a Circulation Card in Python 
---

This example is based on an exercise created by [Jessica Hamrick](https://github.com/jhamrick/library-exercise)

## Opening

After learning the basics of repetitive actions (Loops) and conditional statements (IFs), we now have enough material
to use Python to solve a problem.

## Our problem

Let's say that we have an old circulation card for a book that we want to have
in electronic form (a computer file) to make it searchable to have an online
history of books.  For example, consider the following
[card](http://2.bp.blogspot.com/-6VxNTXpOnoc/URh4RVpm6wI/AAAAAAAAPEQ/c6mhrcTgEiw/s1600/duedate.jpg).

If we translate this card to a text file, either manually or using some kind
of optical character recognition (OCR), we would end up with something like
the
[following](./files/library-card.txt).
While now electronic, we have a program with inconsistent data.
We can have dates in the following three formats:

    Feb 16 53
    Jun 21 '54
    Sep 5 1961

As well, some librarians did not always use the next available space on the card, so some dates are out of order.

### Why is this a problem?

What are three questions we can ask about this circulation card?  I suggest the following:

- When was this copy in circulation?
- How long was this copy in circulation?
- What year was the most active for this book?
- Is a book about baseball more popular during baseball season?

To answer these questions we need to analyze the dates.  The point is that
a human could answer these questions in a few minutes looking at the card.
However, once programmed a computer can answer the question in within
thousandths of a second.  Considering we may have thousands of index cards,
programming will make answering the above questions possible whereas it would
unlikely be worth a librarians time.

Our goal is to turn raw data (the circulation card) into meaningful information (the answers to the questions above).

## Why fix the dates?

We need to have the dates in a consistent format in order to do math on them.
Let's look at our first question: *When was this book in circulation?*

Can we answer it?  The first checkout was Dec 17 '49, the last was June 28, 1962.  If we simply take the first and last date on the card, we are presuming the are in order.  What if the last few dates were out of order due to a lazy checkout person?

    Feb 3 1962
    Jun 28 1962
    Oct 3 1961

Then we would not have the correct starting and ending dates of circulation.  So we need to ensure the dates are
in order!  Could a person do this?  Yes, in a few minutes and they may make
a mistake.  But remember, a computer could do it in a few thousandths of
a second and is less likely to go crazy after the 1000 circulation card :)
Once we have the dates in order, we can answer our question accurately, which
is the whole point.

What about the second question:  *How long was this copy in circulation?*

If we have the dates in order, we still have a problem.  To find how many
years it was in circulation, we would subtract that the last date from the
first (1962 minus '49).  A human would know that this means our book was in
circulation for 13 years.  But computers have no intuition, they simple perform the
math they are programmed to.  So a computer program may be programmed naively to
perform the following subtraction

    1962 - 49

which would result in an inaccurate answer of **1913**.  Clearly a book would not survive for
19 centuries, but a computer would simply spit out the answer it's programmed
to calculate.  A computer does not have any intuition that '49 means 1949, so
it must be programmed to handle such a date.  These are the kind of bugs that
make software frustrating to use.

To get the correct total, 13, we need to have both dates in 4-digit format.  So we need to fix the dates.

Our point here is simply to express why thinking about data is a necessary programming skill.  There is an axiom in computer science "Garbage In, Garbage Out".  The principle behind it is that we must have good data in order to leverage
a computer's ability to process thousands of circulation card files and give us meaningful statistics and information.

Next, we'll learn how to apply what we've learned to convert the dates into a consistent format.

## How to Fix the Dates

Recalling that our problem is that we have three different formats of date
that make calculations incompatible.

    Feb 16 53
    Jun 21 '54
    Sep 5 1961

We'll walkthrough how to fix each of the first two so that they are all of the
format of the third, **Sep 5 1961**.  Specifically, we want "MMM DD YYYY"
where each month is the standard three character month, followed by a space,
a two digit day, followed by another space, then a 4-digit year.



### Building our program

#### 1. Reading a file

Our circulation card is stored in a plain-text file named [library-card.txt](./files/library-card.txt).  Our goal is
to change the contents of this file, but to keep its name the same.  In order to do this, we need to know how to read
and write files in Python.

To access a file in any way, either reading from it or writing to it, we must first open the file.  And when we are done
reading or writing a file, we must close it.  Therefore, most file access will be surrounded by **open()** and **close()**
commands as follows:

~~~ python
f = open('library-card.txt')
...read file data and do something with it...
f.close()
~~~

For example, the following program will print out all the lines of a file with a line number prepended to each line:

~~~ python
file_handle = open('provinces.txt')
all_lines = file_handle.readlines()
line_number = 0
for line in all_lines:
    print str(line_number) + ": ",
    print line 
    line_number = line_number + 1
file_handle.close()
~~~

By reading all the lines of the file using readlines (line 2) and then looping over them, we print the lines individually
and can modify each line as we want.  With each line we do the following inside the loop
    1. we print the line number
    2. we print line itself
    3. we increment the line number for use on the next line

Please take a second to understand what each line is doing above.

If provinces.txt contained

    Alberta
    British Columbia
    Manitoba
    Ontario
    New Brunswick

The output would be

    0: Alberta
    1: British Columbia
    2: Manitoba
    3: Ontario
    4: New Brunswick

##### Back to our circulation card:

Let's write the code to read the card file named **library_card.txt** into our program.
(I suggest giving the students a few minutes to try this.)


~~~ python
fh = open('library-card.txt')
all_lines = fh.readlines()
fh.close()
~~~

The above will read in all the contents of circulation card.  Even if it
contain one million lines, it would read them all in.

What do we want to do with them?  Recall our goal is simply to *clean* the
data.  So, we want to access only the lines that have checkout dates on them.
The first three lines contain other information, so we only want the other lines.

The readlines method, when called on the file handle (fh), returns all the
lines of the file in a large list.  We know how to loop over all the lines, we
would do this as follows:

~~~ python
fh = open('library_card.txt')
all_lines = fh.readlines()
fh.close() #once we've read the data, close the file
for line in all_lines:
    print line
~~~

But, how do we skip the first three lines?  That's easy.  We can use **list slicing**, we can give two
indices - where to start and where to stop to index into the list.  So the following code will give us 
just the lines we want.

~~~ python
fh = open('library-card.txt')
all_lines = fh.readlines()
fh.close() #once we've read the data, close the file
due_dates = all_lines[3:len(all_lines)]
for date in due_dates
    print date
~~~

On the 3rd line above, we create a new list named due_dates by indexing the list variable all_lines to start at line 3 and go until the end, the length of the list len(all_lines).  After executing this line, due_dates will contain only the lines that have the due dates, not the book title, author, etc.

You should see output like the following:

    Dec 17 '49
    
    Sep 4 50
    
    Feb 28 51
    
    Jun 18 51
    
    Aug 18 51
    
    Oct 5 51
    

The above looks unusual because there are extra spaces in between each line.  The reason for this is there is a "newline" character at the end of each line in the file and Python adds a "newline" character to each line that is printed with "print".  We can get rid of the former by using the strip() method for a string.

Add date = date.strip() before the print statement to get rid of the extra space.

We are ready to process our dates.

#### 2. Splitting the data

Each line of our due_dates contains a due date that is in one of three formats:

    Feb 16 53
    Jun 21 '54
    Sep 5 1961

The months and days are accurate, so we only need to modify the year.  How can
we access it?  The first task is to split the data into the separate fields
- month, day, year.

Take a minute and modify your program to only output the year from each line.

~~~ python
fh = open('library-card.txt')
all_lines = fh.readlines()
fh.close() #once we've read the data, close the file
due_dates = all_lines[3:len(all_lines)]
for date in due_dates
    field = date.split(' ') # we want to divide the data on whitespace into M-D-Y
    print field[2]
~~~

Now, you should see output like the following:

    '49
    50
    51
    53
    '53
    '53
    '53
    '53
    '54
    1958
    1960
    1960
    1960
    62
    1960

I have reduced the number of entries for brevity, but you can clearly see the
three different kinds of dates.  Our goal is to convert them all into 4-digit
years.

#### 3.  Detecting 2-digit years

So in our program so far, the string referred to by **field[2]** is the year.

##### Two-digit years without an apostrophe

The simplest cases are years that have a two-digit year without an apostrophe
in front, such as **50**.  

First, we must detect that we have a two-digit-non-apostrophe year?  So what identifies
two-digit years like **50** versus the other year formats like **'49** and **1963**?

Their lengths?  Two-digit years without an apostrophe have a length of
2 (there are two characters, the 5 and the 0 in the case of 50)
where two-digit years *with an apostrophe* have a length of 3 characters (the
', the 4 and the 9).  So if we detect that field[2] has a length of 2 then we will know
we have a two-digit year.

We can detect the length of a string using the *len()* function.

~~~ python
if len(field[2]) == 2:
~~~

So, how do we change **50** into **1950** in Python?

Remember that we are dealing with strings, not integers, so we *concatenate*
a **"19"** on the front.

~~~ python
field[2] = "19" + field[2]
~~~

So, we need to add the following code to modify two-digit-no-apostrophe years to 4-digit years:

~~~ python
if len(field[2]) == 2:
    field[2] = "19" + field[2]
~~~

See if you can add this code in the correct location?  Our output should change to:

    '49
    1950
    1951
    1951
    1951
    1951
    1952
    1952
    1952
    1953
    '53
    '53
    '53
    '53

Ta da!  Our two-digit dates have been converted to 4-digit dates.

##### Two digit dates with an apostrophe

The second case we need to fix is very similar to the first.  We need to detect years that contain an apostrophe.
The simplest way is to again check the length.  Years with apostrophes will
have a length of 3.  So we can use a similar if statement like

~~~ python
if len(field[2]) == 3:
~~~

will detect them.  But how do we fix it?  We cannot simply concatenate like we did before as that would result
in '49 turning into **19'49** which is not what we want?  How do we get just
the last two characters, the 2 year digits we want.

Similar to skipping the first three lines of the file, we can *slice* the part of the string we want.  We don't
want the first character which has the index???? Zero, that's right!  So we'll start at index one.  The following
(slightly complicated) bit of Python will get just the year dates

~~~ python
field[2][1:len(field[2])]
~~~

Sometimes using an extra variable makes the code a bit more readable:

~~~ python
yr_apostrophe = field[2]
field[2] = "19" + yr_apostrophe[1:len(field[2])]
~~~

In fact, we can drop the **len(field[2])** and get cleaner code

~~~ python
yr_apostrophe = field[2]
field[2] = "19" + yr_apostrophe[1:]
~~~

Now combine this statement with the if statement to detect a year length of
3 to correctly modify two digit years with apostrophes into 4-digit years.

    1949
    1950
    1951
    1951
    1951
    1951
    ...
    <snip>
    ...
    1961
    1961
    1962
    1962

Congrats, we have successfully modified our data.  Our list "due_dates" now contains all the due dates with the proper years.  So let's print out all the complete dates.  The rest of the dates are contained in field[0] (the month) and field[1], the day, so add them to the print statement.  Your output should now look like the following:

    Dec 17 1949
    Sep 4 1950
    Feb 28 1951
    Jun 18 1951
    Aug 18 1951
    Oct 5 1951
    Feb 26 1952

#### Saving our "corrected" circulation card

The last part of this lesson to is to write our new "corrected" circulation card data to file
that.  First, we'll briefly cover writing to files in Python

##### Writing to a file

Just a we can read from a file, Python naturally supports writing to files too.  The following simple snippet will
create a file named 'my_words.txt' and write four lines to it.

~~~ python
file_handle = open('my_words.txt', 'w')
for word in ['the', 'quick', 'brown', 'fox']
    file_handle.write(word + '\n')
file_handle.close()
~~~

After running this code, the contents of my_words.txt would be

    the
    quick
    brown
    fox

If my_words.txt already existed, regardless of it's length or contents, it would be overwritten with the four lines above.

It is important to close all files (reading or writing) when you are done with them or unexpected things can happen.

If we want to modify a file, that is, make a change to it, the process can seem complicated.  We will first open it, read the contents into our program and then close the file.  Then we will open it again (this time using the 'w' parameter) and overwrite it.  Even if we want to change a single line, in Python, we will overwrite the whole file completely.  This might sound inefficient, akin to rewriting a whole document by hand, but given computers are so fast at writing files, it's the easiest way to do it.

~~~ python
fh = open('library-card.txt', 'r')
...read in the data...
fh.close()
...modify the data...
fh = open('library-card.txt', 'w')
...write the modified data to the file...
fh.close()
~~~

**Caution:** In Python, when a file is opened with 'w' as the second
parameter, the contents of the file are deleted, even if nothing is written to
the file.  It is important to understand what you are doing when writing to
files.  I suggest using test files before running your program on any important
data that would be difficult to replace.

##### Back to our circulation card

We have a few additions to our code from above to overwrite the library-card.txt file with the new
data.  If you don't want to overwrite the data (or are nervous, name the file something different like
library-card-fixed.txt).

We need to do four things to write the file
  1. Open the file with write permissions
  2. Rewrite the first three lines of the original file (author info, etc.)
  3. Write the fixed due dates that we have created
  4. Close the file

The comments in the complete solution below have the corresponding numbers.

~~~ python
fh = open('library-card.txt')
all_lines = fh.readlines()
fh.close() # close the file when we're done with it

due_dates = all_lines[3:len(all_lines)]

# 1. open the file to write to it
# this deletes the contents (don't worry we'll replace them)
fh = open('library-card.txt','w') # you could name the output file something else

# 2. print out first 3 lines - author info, title, etc.
for i in range(3):
    fh.write(all_lines[i])

for line in due_dates:
    line = line.strip('\n')
    field = line.split(' ')
    
    if len(field[2]) == 2:
        field[2] = "19" + field[2]

    if len(field[2]) == 3:
        field[2] = "19" + field[2][1:]

    # 3. write each new "clean" line to the file
    fh.write(field[0] + " " + field[1] + " " + field[2] +"\n")
# 4. always close files when done
fh.close() 
~~~

### Summary

We have now completed our task.  We have properly cleaned the circulation card
and replaced the variable year formats in the file with consistent 4-digit years.

Things we have learned or re-inforced in this lesson:

  1.  Working with files
  2.  Detecting different conditions (2-digit with or without apostrophe)
  3.  Working with *columnar* data
  4.  Writing files

While this example may seem simple or not a real world situation, the concepts
here, in particular working with files that contain columns of information, translate to almost
any data format that can be represented in plain-text files.  Recall that a spreadsheet
is just columns of data organized in lines.

### Need a bigger challenge?

You may treat the follow on as "take home" assignments to add a level of challenge, or if you find the above example
too simple then try your hand at these.  An instructor may give these to
advanced students to occupy them while giving the lesson above.

  1.  Allow the file name to be given from the command-line
      
    % python circulation-fix.py library-card.txt

  2.  Try with an even less consistent input file [library-card-hard.txt](./files/library-card-hard.txt).
