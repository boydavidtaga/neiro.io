---
layout: post
title: Query Object in Ruby on Rails
tags: [programming, ruby, rails, oop, query, db]
---

![](https://cdn-images-1.medium.com/max/1600/1*-oIlwIWlt0BDN4b5a9rRCQ.png)

Database queries are common when you develop web applications. *Ruby on Rails*
 and its *ActiveRecord* liberates you from writing tons of boilerplate SQL code and results in creation of elegant, eloquent queries in plain Ruby.

But plenty of immense possibilities that Ruby and ActiveRecord provide,
unfortunately, remain unused. I bet that often you see a lot of enormous scopes
in Ruby on Rails models, endless chains of queries in controllers and even bulky
chunks of raw SQL.

<span class="figcaption_hack">Bad cases of using ActiveRecord queries</span>

These poor practices may create obstacles and become a reason of developer’s
headaches in the real-world web applications.

### Typical DB queries application problems:

* Big pieces of queries code in controllers/models/services mess up your code
* It is hard to understand complex database requests
* Inserts of raw SQL are non-consistent and often mix with ActiveRecord queries
* Testing one separate query in isolation is very problematic
* It is difficult to compose, extend or inherit queries
* Often Single Responsibility Principle gets violated

### Solution:

These problems can be solved by using *Query Object* pattern — a common
technique that isolates your complex queries.

*Query Object* in ideal case is a separate class that contains one specific
query that implements just one business logic rule.

### Implementation:

For most of the cases *Query Object* is PORO that accepts relation in
constructor and defines queries named like an *ActiveRecord* common methods:

<span class="figcaption_hack">Query Object implementation and usage in controller</span>

#### HEREDOC syntax for raw SQL:

For the cases where you desperately need to use raw SQL code try to isolate it
using Ruby’s *HEREDOC syntax:*

<span class="figcaption_hack">HEREDOC syntax example for raw SQL inserts</span>

#### Extending scope:

If your scope relates to existing *QueryObject*, you can easily extend its
relation instead of cluttering up your models.
[ActiveRecord::QueryMethods.extending](http://apidock.com/rails/ActiveRecord/QueryMethods/extending)
method will help you:

<span class="figcaption_hack">Extending scope for Query Objects relations</span>

### Composing Query Objects:

*Query Objects* should be devised to support composition with other *Query
Objects* and other ActiveRecord relations. In the example below two composed
Query Objects represent one SQL query:

<span class="figcaption_hack">Composing two Query Objects</span>

### Inheritance of Query Objects:

If you have similar queries you may want them to be inherited to reduce
repetition and follow DRY principle:

<span class="figcaption_hack">Inheritance of Query Objects</span>

### Testing Query Objects:

Query Objects should be designed to be pleasant for testing. In most cases you
just need to test core methods defined in query for their results:

<span class="figcaption_hack">Testing Query Objects</span>

### Summary:

#### Good Query Object:

* Follows *Single Responsibility Principle*
* Can be easily tested in isolation
* Can be combined/extended with another Query Object
* Can be effortlessly reused in any other parts of an application
* Returns *ActiveRecord::Relation*, not *Array*
* Represents only database query, not business logic or action
* Methods of Query Object are named like *ActiveRecord* methods (*all, last,
count, etc*)

#### Use Query Objects when:

* You need to reuse one query in multiple places of application
* You need to extend, compose or inherit queries and their relations
* You need to write a lot of raw SQL, but don’t want to mess up your code
* Your query is too complex / vast for just one method or scope
* Your query causes *feature envy*

#### Don’t use Query Objects when:

* Your query is simple enough for just one method or scope
* You don’t need to extend, compose or inherit your query
* Your query is unique and you don’t want to make it reusable


I hope this article will help you to build awesome queries in your applications.
Good luck and happy coding!
