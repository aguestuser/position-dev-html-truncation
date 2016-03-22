# Problem Statement

(cf: <http://positiondev.com/exercises/truncation.html>, accessed 3.20.16)

## [](#html-truncation)HTML Truncation

### [](#problem-statement)Problem Statement

Your task is to shorten a piece of text so that it fits into a fixed amount of space (more precisely, a fixed number of characters - don’t worry about variable width of characters). But, you aren’t truncating plain text, you are truncating HTML, which means that tags shouldn’t count towards the total character count. If you shorten the text, you should end the text with “…”, but if you don’t have to shorten anything, you don’t need to add that.

#### [](#the-input)The input:

A string of HTML, which can contain `<span>`, `<strong>`, `<em>`, `<a>`, `<blink>`, `<abbr>` tags, and they can be nested within one another, but you can trust that the HTML is not malformed (so all tags that are opened are closed, and only the most recently unclosed open can be closed).

The desired length in characters as an integer. This is the maximum, but you should not truncate individual words.

#### [](#the-output)The output:

A string of well-formed HTML where the rendered characters are no more than the desired length, but any HTML tags that were wrapped around those characters still exist. Further, no words should be broken, and if you have to truncate, you should end the text with “…”.

#### [](#examples)Examples:

| Input HTML                    | Desired Length | Output HTML             |
| Hello there!                  | 7              | Hello…                  |
| <strong>Hello there!</strong> | 7              | <strong>Hello…</strong> |
| Hello <strong>there!</strong> | 7              | Hello…                  |

#### [](#your-solution)Your solution:

Please write the solution in a test driven manner in either Ruby or Haskell. You are welcome to use XML parsing libraries to help the task!
