[![CI](https://github.com/MatthewKennedy/aypex_admin/actions/workflows/ci.yml/badge.svg)](https://github.com/MatthewKennedy/aypex_admin/actions/workflows/ci.yml)
[![Standard RB](https://github.com/MatthewKennedy/aypex_admin/actions/workflows/standardrb.yml/badge.svg)](https://github.com/MatthewKennedy/aypex_admin/actions/workflows/standardrb.yml)
[![Standard JS](https://github.com/MatthewKennedy/aypex_admin/actions/workflows/standardjs.yml/badge.svg)](https://github.com/MatthewKennedy/aypex_admin/actions/workflows/standardjs.yml)
[![StyleLint](https://github.com/MatthewKennedy/aypex_admin/actions/workflows/stylelint.yml/badge.svg)](https://github.com/MatthewKennedy/aypex_admin/actions/workflows/stylelint.yml)

# Aypex Admin

A fresh take on an Admin UI for Aypex, this is currently intended to be highly experimental and should not be used for production.


Aypex Admin is free of legacy dependencies and constraints, the goal is to speed up development and find new intuitive ways of using Aypex Admin while
completely modernizing the tech stack for the developers happiness.


## Benefits

- Product Images can be tagged to their applicable option(s).
- New order process, more akin to building an invoice than attempting to replicate a shopping cart in an admin UI (WIP).
- Modern UI (WIP).
- Adaptive Light/Dark modes.


## Installation

Starting with a freshly generated Rails 7 app running Propshaft, add the following gems to your Gemfile:

```ruby
# USE THESE FOR NOW...
gem 'aypex',             github: 'MatthewKennedy/aypex',             branch: 'custom/aypex_admin'
gem 'aypex_admin',       github: 'MatthewKennedy/aypex_admin',       branch: 'main'
gem 'aypex_auth_devise', github: 'MatthewKennedy/aypex_auth_devise', branch: 'custom/aypex_admin'
```

From the command line run the following commands:

Install Aypex
```bash
bin/rails g aypex:install --user_class=Aypex::User
```

Install Aypex Auth Devise
```bash
bin/rails g aypex:auth:install
```

### Import Javascript from NPM - (OPTIONAL)

If you are using NPM to manage your javascript and want to import the javascript via node_modules run:
```bash
yarn add @matthewkennedy/aypex-admin
```
And then create a new file in `app/javascript` called `aypex_admin.js` and then import `import '@matthewkennedy/aypex-admin'`.


## The Tech Stack

- All ES6 Vanilla JavaScript.
- CSS and images all set for Rails Propshaft.
- Uses the Rails Hotwire ecosystem where possible.
- Bootstrap 5.

### Run in Dev Mode

From the root of `aypex_admin` run:

```bash
yarn watch
```


### Running tests
```bash
cd aypex_admin
bundle update
yarn build
bundle exec rake test_app
bundle exec rspec
```

Single test file:

```bash
bundle exec rspec spec/features/admin/users_spec.rb
```

[ChromeDriver](https://chromedriver.chromium.org/) is required for feature tests. On MacOS you can install it by running:

```bash
brew install chromedriver
```
