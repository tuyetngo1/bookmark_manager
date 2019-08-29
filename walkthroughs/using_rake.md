# Walkthrough – Using Rake

[Back to Challenge](../11_using_rake.md)

Rake is a Ruby task runner. It allows us to do this sort of thing from the command line:

```
$> rake setup_test_database
```

And a Ruby script (possibly many Ruby scripts!) will run.

In this walkthrough, we will:

- Set up Rake, a Ruby task runner.
- Move our test database setup script to Rake.
- Replace the call to our test database script with a call to the Rake task.
- Create a Rake task to set up the development and test databases.

> If you prefer to work from a git diff, there is one [here](https://github.com/sjmog/bookmark_manager/commit/a115785c9dcc63584b1766e0e168a26d61b15750).

## Setting up Rake

Rake is available as a gem. To install it:

- Install the `rake` gem to the project.
- Add a `Rakefile`, where Rake tasks are defined in Ruby.

First, we add it to the Gemfile:

```ruby
# in Gemfile

source "https://rubygems.org"
gem 'sinatra'
gem 'rspec'
gem 'capybara'
gem 'pg'
gem 'rake'
```

And `bundle install`.

Secondly, we add a `Rakefile`, which is where we will write our tasks:

```ruby
# in Rakefile

task :say_hello do
  p "Hello World!"
end
```

We can run the Rake task in the following way:

```
$> rake say_hello
```

## Moving the test database setup script to Rake

Here's the script we use to setup our test database:

```ruby
# in spec/test_database_setup.rb

require 'pg'

p "Cleaning database..."

connection = PG.connect(dbname: 'bookmark_manager_test')

# Clear the database
connection.exec("TRUNCATE links;")
```

We can move it to a Rake task by moving the whole script to our Rakefile:

```ruby
# in Rakefile

require 'pg'

task :test_database_setup do
  p "Cleaning database..."

  connection = PG.connect(dbname: 'bookmark_manager_test')

  # Clear the database
  connection.exec("TRUNCATE links;")
end
```

Now, whenever we run `rake test_database_setup`, our database will be cleaned.

## Replacing the call to our script with a call to a Rake task

We can call Rake tasks from the command line. We can also call Rake tasks from within a Ruby program. This is a three-stage process:

- Require Rake into the program.
- Ask Rake to load the Rakefile.
- **Invoke** the Rake task.

In `spec_helper.rb`, let's replace the `require_relative` statement which loads our `spec/test_database_setup.rb` script with these two actions:

```ruby
# in spec/spec_helper.rb

ENV['ENVIRONMENT'] = 'test'

# Require Rake
require 'rake'

# Load the Rakefile
Rake.application.load_rakefile

# Then, in the RSpec config...
RSpec.configure do |config|
  config.before(:each) do
    Rake::Task['test_database_setup'].execute
  end
end

### rest of the spec_helper.rb file ###
```

When we run `rspec`, our Rake task is automatically invoked before each test. We can now delete the `spec/test_database_setup.rb` script!

## Create a Rake task to setup the test and development databases

We can use `pg` and Rake to set up the test and development databases. Let's create a task for it:

```ruby
# in Rakefile

task :setup do
  p "Creating databases..."

  connection = PG.connect
  connection.exec("CREATE DATABASE bookmark_manager;")
  connection.exec("CREATE DATABASE bookmark_manager_test;")

  connection = PG.connect(dbname: 'bookmark_manager')
  connection.exec("CREATE TABLE links(id SERIAL PRIMARY KEY, url VARCHAR(60));")

  connection = PG.connect(dbname: 'bookmark_manager_test')
  connection.exec("CREATE TABLE links(id SERIAL PRIMARY KEY, url VARCHAR(60));")
end
```

When we run this Rake task on a machine without `bookmark_manager` or `bookmark_manager_test` databases, it will create them for us.

> If we run this script on a machine that already has one of these databases, it fails. Can you adjust the script to handle the case of one or both databases already existing?

We can refactor the script a little, too:

```ruby
# in Rakefile

task :setup do
  p "Creating databases..."

  ['bookmark_manager', 'bookmark_manager_test'].each do |database|
    connection = PG.connect
    connection.exec("CREATE DATABASE #{ database };")
    connection = PG.connect(dbname: database)
    connection.exec("CREATE TABLE links(id SERIAL PRIMARY KEY, url VARCHAR(60));")
  end
end
```

We can now add a line to the README guiding new developers to set up their databases using Rake.


![Tracking pixel](https://githubanalytics.herokuapp.com/course/bookmark_manager/walkthroughs/using_rake.md)
