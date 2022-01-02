# Learnings from Advent of Code

The main thing I wanted to learn was the elm/parser. 

The problems of Advent of Code always includes some input that you need to parse, so I thought it would be ideal. 

Although I have learned a few things about the parser package so has the problem inputs been not ideal for the parser and more towards looping and if statements.

It has been hard to understand how the parser chomp characters and how that interacts with backtracking,

## Reflections on the format

It is really fun, despite me falling behind. It is Christmas and I have just finished day 14. The problems have really taken their place in my mind even when I haven't been working on them. Other hobby hacking had to stand back. 

With more than 40 years of experience, shouldn't it be super easy then? No, because this is not what it is like when working as a developer. True, there are problems where you need to find an algorithm that scales to the problem. But it is just a small part of your work.

The specifications of the problems are very precise and written by a person who understands coding. Most programmers work with vague descriptions that may contain details that simply aren't true. You really have to understand beyond what is given to you. Experience gives you the ability to ask the right questions.

The code only serves the purpose of solving the problem once, and then it is not used anymore. In a professional context, the code lives for years, undergoing changes. Therefore, the code must be written with readability in mind. Even if it is you that will read your code in the future, it will be hard if you are not paying attention to readability. 

Another aspect of maintainable code is types and tests. When you change code, you want to be feel certain that nothing breaks. Or worse, it seems to work, but does so in an unintended way. Tests specify the intended way and types limits the number of tests you have to write. If input are primitives like strings and integers, then the tests must verify that the implementation handles the large variation of the input. With types, the possible values of the input is limited and the tests can focus on the core logic.

When coding to solve these problems, tests do help, I use them extensively to break down the problem. But from what I gather, it is not used by others. Many solutions I see on internet are written with low readability and no tests. Primitives are used mainly, and it is fine, although I made a mistake with parameter order of two integers.

Size of code is of course a huge difference. A problem solution is a single page while systems that we work with have millions of lines. Adding a feature to a system often means reading hundreds or thousands line of code. So reading code is a great deal of what being a programmer ia about.

The problems are solved working alone, while professionally you typically work in close collaboration with other programmers. Even if you don't mob or pair program, you review each other's code. Team work requires social skills such as accepting that ones favourite way of doings things are not necessarily accepted. What you create is scrutinized by others, and you are supposed to do the same. You are also supposed to step out of you immediate comfort zone to tackle things you haven't worked on before. 

## Parsing parenthesis

The problem of Day10 was to balance different types of parenthesis. It was quite easy to write a parser that converted them to symbols. To solve the problem, it was a matter of analysing the symbols.

However, that lends itself to backtracking so the parser might should be able to handle this straight of. So I tried to write a recursive parser, using the `lazy` function. That turned out to be hard as there is nothing between the parenthesis, which is not a typical use case for a parser.

I tried to say that a chunk is a start parenthesis, followed by zero or more chunks and an end parenthesis. But the problem is when the input is incorrect. I expected it to backtrack and handle an unexpected end parenthesis or end of input. But it seems that it does not. 

I tried the `backtrackable` function but could not make it happen.

Finally, I decided that a correct line well handled is good enough. When it fails, I analyze the failure.

## Parsing bingo boards

This was something that I found very hard. The boards were 5 rows of numbers, separated by an empty line. But since both the rows and the boards were separated by empty lines, the parser got lost.

I solved this by counting the number of rows and using the `loop` function. See Day4.

## Performance

I never before worried about performance in my web apps since it has never been a problem. But with these problems
it becomes an issue. So a learning was that you can use Chrome dev tools and search the call tree for bottlenecks.
Too bad it is the compiled JavaScript you see and not the Elm code you wrote. Another thing is that when the execution 
time went up to 30 sek, the performance tool hanged.

### Things I changed

The first thing I noticed was that I kept a list of nodes and wanted to get the most promising node to try next. So I
sorted them a picked the first. But it took too long so I did what I really wanted and roamed the list for best using 
a foldl. That cut half of the time.

Another half was found when I studied the list filter function. The comparison seemed to take long despite it was only
a structure of two integers, row and column. Splitting them, cut half the time.

A change from list to array representation cut a few seconds as well. But not conclusive. Guess that a lot of time
is consumed in managing arrays or lists.

Found a small improvement when using a list for unvisited nodes but not `foldl` for searching for the lowest, instead just 
use a simple function that takes head and tail of a list.

Using a Set for maintaining the set of unvisited nodes, instead of Array or List, shaved of a few seconds.