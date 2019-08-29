## Extracting a `Database` setup object

[Back to the Challenge Map](00_challenge_map.md#challenges)

We've built a Sinatra application that can read and write from and to a database. It's structured in an MVC style, and has test and development environments.

At the moment, our `Bookmark` class methods have two responsibilities:

- Connect to the correct database for the current environment, and
- Manipulate data in that database.

Each time we want to transact with the database from the `Bookmark` model, we create a new connection using `PG.connect`. Wouldn't it be great if this all happened once, when the app boots?

Even worse – at the moment, we have no way of telling whether we're connecting to the _right_ database other than checking the database once we're connected to it. We should write some tests to make sure we're connecting to the right database.

In this challenge, you will extract an object which is used to setup a connection to the database when the application starts, and refactor `Bookmark` to use it.

*Object Relational Mapping*

So far we've written all the code to interact with the database using the `psql` gem. As you've probably noticed, this can make the code difficult to read as SQL queries can be quite lengthy! It's become common to instead use an [Object Relational Mapping](https://en.wikipedia.org/wiki/Object-relational_mapping) tool to abstract the database interaction. An example of an ORM is [DataMapper](https://datamapper.org/).

In this stage you'll make a first step towards making your own ORM!

## Learning Objectives

* Separate application behaviour from database behaviour.
* Wrap an adapter object.

## To complete this challenge, you will need to

- [ ] Test-drive a new class, `DatabaseConnection`, with two methods:
  - [ ] `DatabaseConnection.setup` is a class method. It takes one parameter: a database name. It should set up a connection to that database, which is saved as a class instance variable in `DatabaseConnection`.
  - [ ] `DatabaseConnection.query` is a class method. It takes one parameter: an SQL query string. It should use the class instance variable from `setup` to execute that SQL query string on the correct database, via `pg`.
- [ ] Write a setup script that runs when the application boots, which calls `DatabaseConnection.setup` with the correct database for the environment.
- [ ] Replace calls to `PG.connect` and `connection.exec` in `Bookmark` with your new `DatabaseConnection` wrapper class.

## Resources

- [class instance variables1](http://thoughts.codegram.com/understanding-class-instance-variables-in-ruby/)
- [class instance variables2](http://maximomussini.com/posts/ruby-class-variables/)
- [variable scope](https://www.sitepoint.com/understanding-scope-in-ruby/)
- [What is an ORM?](https://stackoverflow.com/questions/1279613/what-is-an-orm-and-where-can-i-learn-more-about-it)


## [Walkthrough](walkthroughs/14.md)


![Tracking pixel](https://githubanalytics.herokuapp.com/course/bookmark_manager/14_extracting_a_database_setup_object.md)
