# Learnings

The main thing I wanted to learn was the elm/parser. 

The problems of Advent of Code always includes some input that you need to parse so I thought it would be ideal. 

Although I have learned a few things about the parser package so has the problem inputs been not ideal for the parser and more towards looping and if statements.

It is sometimes hard to understand how the parser chomp characters and how that interacts with backtracking,

## Parsing parenthesis

The problem of Day10 was to balance different types of parenthesis. It was quite easy to write a parser that converted them to symbols. To solve the problem, it was a matter of analysing the symbols.

However, that lends itself to backtracking so the parser might should be able to handle this straight of. So I tried to write a recursive parser, using the `lazy` function. That turned out to be hard as there is nothing between the parenthesis, which is not a typical use case for a parser.

I tried to say that a chunk is a start parenthesis, followed by zero or more chunks and an end parenthesis. But the problem is when the input is incorrect. I expected it to backtrack and handle an unexpected end parenthesis or end of input. But it seems that it does not. 

I tried the `backtrackable` function but could not make it happen.

Finally, I decided that a correct line well handled is good enough. When it fails, I analyze the failure.

## Parsing bingo boards

This was something that I found very hard. The boards were 5 rows of numbers, separated by an empty line. But since both the rows and the boards were separated by empty lines, the parser got lost.

I solved this by counting the number of rows and using the `loop` function. See Day4.

