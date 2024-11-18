---
title: Ratpack - Simpler HTTP Services
date: 2014-08-20
---

After writing http services in spring-mvc and jax-rs a number of times, I'm of the opinion that the stacks are a bit too complicated. Its not that they don't work, or even that they are hard to understand. They just feel a bit heavyweight (and surprisingly awkward) for implementing restful services, which is what I seem to be writing for the backend these days. 

I understand why the java REST frameworks look the way they do: they were built on standards (the servlet api), and grew out of their respective historical uses, XML-based HTTP web services for jax-rs, and MVC web framework for spring-mvc. Recently, though, I stumbled onto [Ratpack](http://ratpack.io) which might be a nice alternative.

Ratpack is an asynchronous HTTP framework based on Netty that does not rely on the servlet api. A few years ago, that would have been a deal-breaker for me personally, but in the age of the embedded container, do we really need to care about container standards? 

I haven't dove too deeply into Ratpack yet, but its generic filter/handler model feels like what the servlet api should have been, and its support of groovy DSL for configuring the handler tree seems to be worth investigating further. 
