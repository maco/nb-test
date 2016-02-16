# Installation
This service uses Ruby on Rails. First, install the [Ruby Version Manager (RVM)](https://rvm.io/rvm/install) using the method appropriate for your operating system.

Then, install a recent version of Ruby and set RVM to use it.

```
rvm install 2.3.0
rvm use 2.3.0
```
All remaining dependencies are listed in the Gemfile. To install them, run `bundle install`

# Initializating database
 Run `rake db:migrate` to set up the sqlite3 database

# Running the service
To start the Ruby server, run `rails server` from the top level of the code checkout

# Testing
To run the included unit tests, type `rake`

# Notes
If I had chosen to use PostgreSQL instead of SQLite, the [groupdate gem](https://github.com/ankane/groupdate) would have been available to me. However, on OS X with Postgres.app, running `bundle install` and expecting the `gem install pg` step to succeed on its own is foolhardy. That gem must be installed on its own with config flags specifying the location of the config directory, and the answer will vary depending on which version of PostgreSQL you have installed. Given this is only a demo, I chose to go the route that won't make installation unnecessarily tedious. Also, this means I had to do date grouping myself. For all I know, you would think groupdate was cheating.

I made the read operations able to handle having the "to" date occur after the "from" date, since I have had Google Analytics behave unexpectedly when I mis-click and set an invalid date range of this variety, and that is annoying. I think swapping those instead of erroring is like a tiny "do what I mean" module.

I have never tested JSON API output before. I think I need to go add some of those tests to Growstuff!
