# Sales Importer Exercise

This Rails application is an exercise showing how we might import and normalize 
tab-delimited Sales data into a relational database.

# Gameplan: tasks in priority order

### Core requirements
- create normalized models (Purchaser, Merchant, Item, Sale)
- create SalesImporter service
    - rudimentary synchronous import - won't scale
    - no error-handling
- put together site layout, minimal styling
- get upload working, connect to SalesImporter
    - create summary page (total gross revenue)
    - introduce Import model?
- write up installation instructions

### Extra features (i'll probably get to these)
- add Devise
- **background import**
    - extract import into resque worker
    - create page to show completed imports
    - store rows that fail import (validation/errors)
- style Devise views

### Bells and whistles (time permitting)
- **add OpenID**
- make summary page responsive, list completed imports
- **benchmark import, try bulk insert (raw sql)**
- create import detail page, link to purchases
- add some serious styling
- benchmark upload, explore options
- deploy demo somewhere public


# todo: document the following:

* Ruby version
  - 2.0.0
  - 1.9.3?

* System dependencies

* Configuration
  - .env

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

