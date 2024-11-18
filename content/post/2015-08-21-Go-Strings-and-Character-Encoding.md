---
title: Go, Strings, and Character Encoding 
date: 2015-08-21
---

I recently had a conversation with a friend about how
[UTF-8](https://en.wikipedia.org/wiki/UTF-8) and character encoding 
works in general, centered around why strings seem weird in
[Go](https://golang.org) if you're used to how they're handled 
in other languages. 

The way that Go handles strings is pretty cool: a string *is* slice of bytes.
Period. End of story.

It also just so happens that a Go program is defined as a sequence of UTF-8
characters (that's all that is supported), so unless you
insert raw bytes into them using escapes, a string literal is *always* UTF-8
in Go. 

So what's so makes Go's handling of strings so different from other languages?
It's due to strings being byte slices and Go string literals being UTF-8. 
The following Go snippet from [the go blog](https://blog.golang.org/strings) illustrates 
how to iterate over the characters in a string:

```go
const nihongo = "日本語"
for i, w := 0, 0; i < len(nihongo); i += w {
    runeValue, width := utf8.DecodeRuneInString(nihongo[i:])
    fmt.Printf("%#U starts at byte position %d\n", runeValue, i)
    w = width
}
```

First, notice how the example uses Japanese characters. The reason isn't obvious if you don't
already understand how UTF-8 encoding works. The gist is this: UTF-8 is a 
[variable width encoding](https://en.wikipedia.org/wiki/Variable-width_encoding). 

Variable width encodings represent characters using byte sequences of different lengths.
The example uses characters that are known to be represented by more than one byte in UTF-8 
to prove that the code correctly iterates over characters, not bytes. 

So how does that code work? Why is it so complicated to iterate over a string in Go?

The answer is: 

* We have a sequence of bytes representing characters
* A character can be any number of bytes long

This means that we can't know how many bytes each character has without interpreting them in order.
Not having a consistent byte width for a character means we can't index into the data and pull out
a character (like `nihongo[1]`).  _We have to interpret the bytes in order to know where the character boundaries are._

And that is exactly what the code does. It iterates over the string, printing each character and its
byte position. However, notice that it doesn't increment the loop iterator, instead it add the width of the
last character. The width is determined by the `utf8.DecodeRunInString` function which returns both the 
'rune' (a.k.a. unicode code-point) and the number of bytes used to represent it. 

