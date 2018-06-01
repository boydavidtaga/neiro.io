---
layout: post
title: Protocols in Elixir
crosspost_to_medium: true
tags: [programming, elixir, code, protocols, polymorphism]
---

The Elixir programming language has many features by itself. Some of them, like
pattern-matching, are pretty widely-used and common, but some of them are not.
In this article we will learn about Elixir Protocols - one of the most powerful
yet underrated - in my opinion - mechanism.

## What Are Protocols

If you have experience in object-oriented programming languages, I'm pretty sure that you are familiar
with the polymorphism concept.

Basically it allows you to apply the same functions
on different types or entities. Imagine if we have `size` function that should return
size or length of any entity that comes in as the first argument:

```elixir
size([]) # 0
size(nil) # 0
size(0..2) # 3
size(:foo) # 3
size("foo") # 3
size({:foo, "bar"}) # 2
size(%{foo: "bar"}) # 1 - has 1 key
size(%MyStruct{foo: "bar"}) # 1 - has 1 key
```

We can achive this in Elixir by using *Protocols* for polymorphism. It acts like
a contact - you need to implement a *protocol* for each data type that you need to
support.

If you are already know something about Elixir, I bet you already faced protocols.
If you was using `Enum.count/1`, `to_string/1`, `inspect/1` then you really was using
the protocols - `Enumerable`, `String.Chars`, `Inspect` accordingly.

Let's try to convert *tuple* into string:

```elixir
to_string {}
#
** (Protocol.UndefinedError) protocol String.Chars not implemented for {}
(elixir) lib/string/chars.ex:3: String.Chars.impl_for!/1
(elixir) lib/string/chars.ex:22: String.Chars.to_string/1
```

As you can see, `Chars` protocol is not supported by the *tuple*. You need to
learn how to write your custom protocols in order to extend existing
functionality.

## Defining a Protocol

So let's start with the most simplest example. Let's try to define a *Size* protocol:

```elixir
defprotocol Size do
  def size(), do:
end
```

## Implementation of Protocol

## Fallback
# any

## Conclusion

Happy hacking!
