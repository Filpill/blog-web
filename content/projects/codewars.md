---
title: "Codewars - Solving Coding Problems"
date: 2022-06-24
draft: true

cover:
  image: img/codewars/codewars-logo.png
  alt: codewars logo

tags: [python,sql,programming,coding,data-structures,algorithms]
categories: [programming]

---
## Codewars Badge

<div id="header" align="left">
  <img src="https://www.codewars.com/users/Filpill/badges/large" width="350"/>
</div>

Predominantly solving Python and SQL problems

## Codewars profile:
[Filpill - Codewars Profile](https://www.codewars.com/users/Filpill/)


## What is Codewars?
A website that provides challenges for you to solve in a variety of programming languages. The higher the rank of the problem, the harder it is to solve.

## Rank System
Ranks are used to indicate the proficiency of users and the difficulty of Kata. There are two classes of ranks, Kyu and Dan, which are divided in 8 levels each. By increasing order of proficiency/difficulty:


![Rank System](/img/codewars/rank-system.png)

## Motivation

Recently I was feeling inspired to try and improve my existing programming skills. I am specifically focusing on improving my fundamental knoweldge of Python.

The majority of my learning process so far has been based on my independant project based learning. However, I do feel that some of my programming methodology is not utlising best practice. My programs can have a tendancy to be long-winded or have extremely confusing flow of logic. I do feel like I can benefit from writing simpler and more consice programs.

I think its useful to solve some coding problems which drive you to implement solutions using data structures and algorithms you do not typically encounter on a daily basis.

I'm slowly realising the benefit of nested data structures which is something that I would've avoided in the past. For example I would not typically use a structure like a list of tuples. However, in some cases its much easier to generate a solution when you are nesting the data as opposed to a ustilising completely flat data structures (depending on the question of course).

Additionally, the practice helps me learn the standard Python libraries to a much deeper level. In the long run, I think it will be more useful to lean on the standard library as opposed to importing modules for a one-off use-case.

This will also be a gateway to learning more programming languages in the future.

## Example of Kata Solutions

For reference, I will show an example problem I solved previously:

### Kata name: Strings Mix   ![4ky logo](/img/codewars/4kyu.png)

DESCRIPTION:
Given two strings s1 and s2, we want to visualize how different the two strings are. We will only take into account the lowercase letters (a to z). First let us count the frequency of each lowercase letters in s1 and s2.

s1 = "A aaaa bb c"

s2 = "& aaa bbb c d"

s1 has 4 'a', 2 'b', 1 'c'

s2 has 3 'a', 3 'b', 1 'c', 1 'd'

So the maximum for 'a' in s1 and s2 is 4 from s1; the maximum for 'b' is 3 from s2. In the following we will not consider letters when the maximum of their occurrences is less than or equal to 1.

We can resume the differences between s1 and s2 in the following string: "1:aaaa/2:bbb" where 1 in 1:aaaa stands for string s1 and aaaa because the maximum for a is 4. In the same manner 2:bbb stands for string s2 and bbb because the maximum for b is 3.

The task is to produce a string in which each lowercase letters of s1 or s2 appears as many times as its maximum if this maximum is strictly greater than 1; these letters will be prefixed by the number of the string where they appear with their maximum value and :. If the maximum is in s1 as well as in s2 the prefix is =:.

In the result, substrings (a substring is for example 2:nnnnn or 1:hhh; it contains the prefix) will be in decreasing order of their length and when they have the same length sorted in ascending lexicographic order (letters and digits - more precisely sorted by codepoint); the different groups will be separated by '/'.

```[python]
#Count chars and return list of tuples
def count_char(string_list):
    #Pulling only lower case letters from strings
    string1 = string_list[0][1]
    string2 = string_list[1][1]
    s1_chars = ''.join(char for char in list(set(string1)) if char.isalnum() and char.islower())
    s2_chars = ''.join(char for char in list(set(string2)) if char.isalnum() and char.islower())
    chars = s1_chars + s2_chars
    chars = list(set(chars))
    char_count_list = []
    #Counting characters in each string
    for char in chars:
        count1 = string1.count(char)
        count2 = string2.count(char)
        if count1 > 1 or count2 > 1:char_count_list.append((char,count1,count2))
    return char_count_list

#Take list of tuples and return list of string repeated by occurrence
def char_iter(tuple_consol):
    chars=f''
    chars_form_list = []
    for tuple in tuple_consol:
        chars = f'{tuple[2]}:'
        for i in range(tuple[1]): chars = f'{chars}{tuple[0]}'
        chars_form_list.append(chars)
        chars=f''
    return chars_form_list

def ascii_concat(chars_form_list):
    ascii_list = []
    for item in chars_form_list:
        asc_val = '' #reset concat
        for char in item:
            ascii = str(ord(char))
            if len(ascii) == 2: ascii = '0' + ascii
            asc_val = asc_val + ascii
        ascii_list.append(int(asc_val))
    return ascii_list

def mix(s1, s2):
    #List of string, labeled with 1 and 2
    string_list = [(1,s1),(2,s2)]

    #Counting ordered characters through function for each string and return list of tuples
    char_count_list = count_char(string_list)
    #Consolidate list by finding max count in respective string
    tuple_consol = []
    for tuple in char_count_list:
        char_count1 = tuple[1]
        char_count2 = tuple[2]
        if char_count1 > char_count2: tuple_consol.append((tuple[0],char_count1,'1'))
        elif char_count1 < char_count2: tuple_consol.append((tuple[0],char_count2,'2'))
        elif char_count1 == char_count2: tuple_consol.append((tuple[0],char_count1,'='))

    #Returing formatted list of string iterated by char count and sorting by length
    chars_form_list = char_iter(tuple_consol)
    #Concat up all the ascii's in the respective strings
    ascii_list = ascii_concat(chars_form_list)
    #Combine the lists together into list of tuples and sort by ascii value
    ascii_tuples = []
    for i in range(len(ascii_list)): ascii_tuples.append((chars_form_list[i],ascii_list[i]))
    ascii_tuples = sorted(ascii_tuples,key=lambda i:i[1],reverse=True)

    #Need to create a list of lists.
    #Each sublist will contain strings of the same length.
    sub_slices = []
    prev_idx = 0
    for i in range(len(ascii_tuples)-1):
        tuple1 = ascii_tuples[i][0]
        tuple2 = ascii_tuples[i+1][0]
        if len(tuple1) != len(tuple2):
            sub_slices.append(ascii_tuples[prev_idx:i+1])
            prev_idx = i+1
        elif len(tuple1) == len(tuple2) and i == (len(ascii_tuples)-2):
            sub_slices.append(ascii_tuples[prev_idx:i+2])

    #Sorting each sublist into lexigraphical order (low to high) and append to result
    result = ''
    for sublist in sub_slices:
        sublist = sorted(sublist,key=lambda i:i[1])
        for tuple in sublist:
            string = tuple[0]
            result = result + string + '/'
    result = result[:-1] #tidy up trailing string

    return result
```
