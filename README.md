# Sales Importer Exercise

This Rails application is an exercise showing how we might import and normalize 
tab-delimited Sales data into a relational database.


## Major Dependencies

- `Ruby 2.0.0p247` (May work on 1.9+, but not tested there)
- `Rails 4.0`
- `bundler`
- Redis (with resque)
- All other dependencies are gems that bundler should take care of.


## Installation Instructions

These instructions are writen for an audience of engineers familiar with ruby and rails.
They also only cover installing and running the app in a development environment.
Improving the documentation to cover production environments and an end-user audience
is a future task.

#### Download and install
Assuming you already have `git`, `ruby` and `bundler` on your system:

    # download the repository
    git clone https://github.com/exbinary/importer-exercise

    # run bundler to set up dependencies
    # if you use rvm gemsets, switch to a new gemset before running bundle
    cd importer-exercise && bundle install

#### Environment variables
There are a couple of environment variables that are not checked into the source-code
repository since they would compromise security. They can be set up locally by running:

    rake env:init

#### Database initialization

    rake db:migrate

The app is configured to create and use a locals `sqlite3` database.  This can be
configured in `config/database.yml` to use something else.  Note that you will also
need to add gem dependencies for the appropriate adapter in `Gemfile` and run 
`bundle install`, at a minimum, if you choose to change the db settings.
    
#### Redis and resque

This version of the app (the `asynch` branch) uses `resque` to offline the parsing
and loading of data.  This requires setting up `Redis` and running the `resque`
worker.

Install [Redis](http://redis.io) on the machine or use an online provider such as
[RedisToGo](http://redistogo.com/).

On Mac OS X, using brew:

    brew install redis

Set up launchd as instructed, or simply run it with

    redis-server /usr/local/etc/redis.conf

Once the redis server is ready, we have to start the `resque` workers

    # from the app root directory,
    rake resque:work QUEUE='*'

#### And we're off...!
That's it! Start the app (in development mode) with:

    rails server

    # or if you're working on a public network,
    # make sure you're not opening up your machine!
    rails s --bind 127.0.0.1

Browse to (http://localhost:3000) to check out the sample app.


## Running the test suite

After following the installation instructions:

    rake db:migrate RAILS_ENV=test
    rspec

The app also uses spork to speed up the testing cycle.
Either run spork in a separate process and then:

    rspec --drb

Or use `guard` (also included) to keep a running process that will load
spork, watch for changes to source files and re-run specs automatically:


## Task-list in order of priority

### Core requirements
- <del> create normalized models (Purchaser, Merchant, Item, Sale) </del>
- <del> create SalesImporter service </del>
    - <del> rudimentary synchronous import - won't scale </del>
    - <del> no error-handling </del>
- <del> put together site layout, minimal styling </del>
- <del> get upload working, connect to SalesImporter </del>
    - <del> create page to show completed imports </del>
    - <del> introduce Import model </del>
- <del> write up installation instructions (for engineers) </del>

### Extra features (i'll probably get to these)
- <del> add Devise </del>
- **background import**
    - <del> install paperclip </del>
    - <del> extract import into resque worker (asynch branch) </del>
    - store rows that fail import (validation/errors)
- run brakeman, other security, quality metrics
- style Devise views

### Bells and whistles (time permitting)
- **add OpenID**
- make summary page responsive, list completed imports
- **benchmark import, try bulk insert (raw sql)**
- create import detail page, link to purchases
- enhance documentation
    - add instructions for deploying to a production env.
    - add instructions for installing ruby
- add some serious styling
- benchmark upload, explore options
- deploy demo somewhere public

