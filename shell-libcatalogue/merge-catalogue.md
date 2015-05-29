---
layout: lesson
root: ../..
title: Merging Catalogue Data from Two Files 
---

## Opening
Now that we've learned about loops and opening files, we're going to combine the two to solve a new problem.

##Our new problem
We have two files with different information about books in the database. One file contains information about the number of circulations each item has had, and a second file contains bibliographic information, namely the title and author of each item. 

	The files look like this:

	File 1:

	Item ID,Title,Author
	312210121823,A Canticle for Leibowitz,Walter M. Miller
	312210121212,Catching Fire,Suzanne Collins
	312210123281,Foundation Trilogy,Isaac Asimov
	312210121314,The Moon is a Harsh Mistress,Robert A. Heinlein

	File 2:
	Item ID,Checkouts
	312210121212,5
	312210121823,4
	312210121314,2
	312210123281,1

You can download the sample files here:
File 1 - [title-auth.csv](files/title-auth.csv)
File 2 - [circ-id.csv](files/circ-id.csv)

###Why is this a problem?
By merging our two data sets, we will be able to see which of our titles has the highest circulation. While our sample data set is small and we can figure out the largest item by cross-referencing the two data files ourselves, this would not be possible with a data set containing thousands of titles from your library.

##How to merge our data
To solve our problem, we need to match each line in file 1 with the corresponding line in file 2. There is only one field that appears in both fields, Item ID, so we need to use this field to match lines between our files. We will do this by opening each file, looping through the contents, and printing out the lines that match each other.

###Building our program

#### 1. Opening the files
Our files ([title-auth.csv](files/title-auth.csv) and [circ-id.csv](files/circ-id.csv)) are stored in a file type called "comma separated values". As you can see above, commas separate each field on the lines of our document.

To begin working with our file, we must open it in our program. Whenever you open a file, you must also close it. It won't necessarily cause an error if you don't, but it is good practice to do so. We will open and close both files:

~~~ python
file1 = open('circ-id.csv')
file2 = open ('title-auth.csv')

file1.close()
file2.close()
~~~

Now, between opening and closing our files, we need to actually do something with them! We will start by reading file 1 line by line. We will do this by using a method built into python called readlines. We will store the output of this method in a new variable called file1_lines, and will print this variable to make sure we set the variable correctly.

~~~ python
file1 = open('circ-id.csv')
file2 = open ('title-auth.csv')

f1_lines = file1.readlines()
print f1_lines

file1.close()
file2.close()
~~~

When you run your program, you should get somethign like the following result:

~~~python
['Item ID,checkouts\n', '312210121212,5\n', '312210123281,1\n', '312210121314,2\n', '312210121823,4\n', '312210121284,7\n', '312210124153,18\n', '312210124159,3\n', '312210124812,4\n', '312210123691,9\n', '312210128794,7\n', '312210125321,14\n']
~~~

Now we have a big long string of text that is our variable f1_lines. This isn't yet ready to compare against our second file. So that we can compare the item ID fields to each other in the two files, we need to split up the Item ID and the checkout fields. To do so, we first need to read each line in our file with a loop, and then we need to split each line wherever there is a comma into a separate data field. This can be done using the split() method.

~~~python
file1 = open('circ-id.csv')
file2 = open ('title-auth.csv')

f1_lines = file1.readlines()
for line_f1 in f1_lines:
    field_f1 = line_f1.split(',')
    print field_f1        

file1.close()
file2.close()
~~~

On the sixth line above, we begin looping over our data stored in the variable f1_lines. Line 7 then splits each line it is fed wherever it encounters a comma. Each data element is now stored in an array. Your program output should look something like this:

~~~python
['Item ID', 'checkouts\n']
['312210121212', '5\n']
['312210123281', '1\n']
['312210121314', '2\n']
['312210121823', '4\n']
['312210121284', '7\n']
['312210124153', '18\n']
['312210124159', '3\n']
['312210124812', '4\n']
['312210123691', '9\n']
['312210128794', '7\n']
['312210125321', '14\n']
~~~

Now that we have our data from file 1 separated into discrete elements, we can now repeat the same thing for file 2:

~~~python
file1 = open('circ-id.csv')
file2 = open ('title-auth.csv')

f1_lines = file1.readlines()
f2_lines = file2.readlines()

for line_f1 in f1_lines:
    field_f1 = line_f1.split(',')
    print field_f1      

for line_f2 in f2_lines:
    field_f2 = line_f2.split(',')
    print field_f2     
	
file1.close()
file2.close()
~~~

Your output will look something like this now:

~~~python
['Item ID', 'checkouts\n']
['312210121212', '5\n']
['312210121823', '4\n']
...
['Item ID', 'Title', 'Author\n']
['312210121823', 'A Canticle for Leibowitz', 'Walter M. Miller\n']
['312210121212', 'Catching Fire', 'Suzanne Collins\n']
...
~~~

Now that both files are read and split into arrays, we can compare the two line by line. We need to compare every single line in file 2 to every line in file 1 to see if there is a match. Right now, our program is looking at every line in file 1, and then looking at every line in file two. However, what we want is that while our program is looking at the first line in file 1, it should then look at every single line in file 2 to see if they match.To do so, we need to nest the two loops we already have for our program. We are going to do this by inserting our second loop at the end of our first loop, increasing its indentation to bring it "inside" the first loop:

~~~python
file1 = open('circ-id.csv')
file2 = open ('title-auth.csv')

f1_lines = file1.readlines()
f2_lines = file2.readlines()

for line_f1 in f1_lines:
    field_f1 = line_f1.split(',')
    print field_f1      
    for line_f2 in f2_lines:
        field_f2 = line_f2.split(',')
        print field_f2     

file1.close()
file2.close()
~~~

We now have a loop inside of another loop. Our program looks at the first line of file 1 and prints it, and then looks at every line of file 2 and prints it, and then move on the the second line of file 1 and repeats. We don't really want to be printing each line however. We want to compare elements of each line to see if they match. We will do so by comparing the first data element (the Item ID column) of each line from both files using the == operator. Then, we will use an if statement to print "yes" whenever the two fields match. Since the item ID column is the first data element in both documents, it can be referenced as field_f1[0] for file 1 and field_f2[0] for file 2.

~~~python
file1 = open('circ-id.csv')
file2 = open ('title-auth.csv')

f1_lines = file1.readlines()
f2_lines = file2.readlines()

for line_f1 in f1_lines:
    field_f1 = line_f1.split(',')   
    for line_f2 in f2_lines:
        field_f2 = line_f2.split(',')
        if field_f1[0] == field_f2[0]:
            print "yes"


file1.close()
file2.close()
~~~

On line 11 above, we are telling our program that if the data element in the variable field_f1[0] (i.e. the first piece of data in the array of the field line from file 1) matches the variable field_f2[0] (i.e. the first piece of data in the array of the field line from file 2), then print out the word "yes".

Instead of printing "yes", we want to print out the merged contenst of the lines that match. We want to see the title and author and the number of checkouts. The title is stored in the second data element (n=1) of each line in file 2, which is represented as field_f2[1]. Since the author is stored in the second data element of each line from file 2, it can be referenced as field_f2[2]. The number of checkouts is the second data element in file 1, so it is referenced as field_f1[1]. So, we just need to print out each of these values out now:

~~~python
file1 = open('circ-id.csv')
file2 = open ('title-auth.csv')

f1_lines = file1.readlines()
f2_lines = file2.readlines()

for line_f1 in f1_lines:
    field_f1 = line_f1.split(',')   
    for line_f2 in f2_lines:
        field_f2 = line_f2.split(',')
        if field_f1[0] == field_f2[0]:
            print field_f2[1], field_f2[2], field_f1[1]
            

file1.close()
file2.close()
~~~

When you run your program, you will notice that the checkouts are printing on a separate line from the author and the title:

~~~python
Title Author
checkouts

Catching Fire Suzanne Collins
5

A Canticle for Leibowitz Walter M. Miller
4
~~~

This is because in our original file 2, the author field is at the end of the line. This is because of the .csv format. There is a new line character at the end of the author field, so the checkout information is being printed on a new line. We can remove this using a method called rstrip(). This removes all white space characters from the right of a string. We want to apply this to our author field, which is field_f2[2]:

~~~python
file1 = open('circ-id.csv')
file2 = open ('title-auth.csv')

f1_lines = file1.readlines()
f2_lines = file2.readlines()

for line_f1 in f1_lines:
    field_f1 = line_f1.split(',')   
    for line_f2 in f2_lines:
        field_f2 = line_f2.split(',')
        if field_f1[0] == field_f2[0]:
            print field_f2[1], field_f2[2].rstrip(), field_f1[1]
            

file1.close()
file2.close()
~~~

We also have an extra line after each of our printed lines. This is because the checkout data element also has a new line character. Try removing this character now, too, so that extra line does not appear in your output.

~~~python
file1 = open('circ-id.csv')
file2 = open ('title-auth.csv')

f1_lines = file1.readlines()
f2_lines = file2.readlines()

for line_f1 in f1_lines:
    field_f1 = line_f1.split(',')   
    for line_f2 in f2_lines:
        field_f2 = line_f2.split(',')
        if field_f1[0] == field_f2[0]:
            print field_f2[1], field_f2[2].rstrip(), field_f1[1].rstrip()
            

file1.close()
file2.close()
~~~

Your output should now look something like this:

~~~
Title Author checkouts
Catching Fire Suzanne Collins 5
A Canticle for Leibowitz Walter M. Miller 4
The Moon is a Harsh Mistress Robert A. Heinlein 2
...
~~~

### Summary

This lesson comes from actual requests library techs have shared with us.

In this lesson, we have learned:

  1.  Working with multiple data sources
  2.  Nested looping

### Need a bigger challenge?

  Ideas for "take home" work or for more advanced students.

  1.  Use a Python dictionary to eliminate the need for the inner for loop in the solution above.
  2.  Imagine we have multiple files containing circulation counts (maybe from
  different branches).  Combine the counts from separate files into a single count above 
  3.  Allow the files to be passed on the command-line where the first file is the title/author index and
      any subsequent files are circulation count files.

     % python merge_cat.py title-auth.csv circ-id-1.csv [circ-id-2.csv ...]
