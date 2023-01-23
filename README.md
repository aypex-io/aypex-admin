[![CI](https://github.com/aypex-io/aypex-admin/actions/workflows/ci.yml/badge.svg)](https://github.com/aypex-io/aypex-admin/actions/workflows/ci.yml)
[![Standard RB](https://github.com/aypex-io/aypex-admin/actions/workflows/standardrb.yml/badge.svg)](https://github.com/aypex-io/aypex-admin/actions/workflows/standardrb.yml)
[![Standard JS](https://github.com/aypex-io/aypex-admin/actions/workflows/standardjs.yml/badge.svg)](https://github.com/aypex-io/aypex-admin/actions/workflows/standardjs.yml)
[![StyleLint](https://github.com/aypex-io/aypex-admin/actions/workflows/stylelint.yml/badge.svg)](https://github.com/aypex-io/aypex-admin/actions/workflows/stylelint.yml)

# Aypex::Admin

The default Admin UI for Aypex eCommerce Platform.


## Benefits

- Product Images can be tagged to their applicable option(s).
- New order process, more akin to building an invoice than attempting to replicate a shopping cart in an admin UI (WIP).
- Modern UI (WIP).
- Adaptive Light/Dark modes.


## Installation

Starting with a freshly generated Rails 7 app running Propshaft, add the following gems to your Gemfile:

```ruby
gem "aypex",             github: "aypex-io/aypex"
gem "aypex-api",         github: "aypex-io/aypex-api"
gem "aypex-admin",       github: "aypex-io/aypex_admin"
gem "aypex-auth_devise", github: "aypex-io/aypex-auth_devise"
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
yarn add @aypex/aypex-admin
```
And then create a new file in `app/javascript` called `aypex_admin.js` and then import `import "@matthewkennedy/aypex-admin"`.


## The Tech Stack

- All ES6 JavaScript.
- CSS and images all set for Rails Propshaft.
- Uses the Rails Hotwire ecosystem where possible.
- Bootstrap 5.3

### Run in Dev Mode

From the root of `aypex-admin` run:

```bash
yarn watch
```


### Running tests
```bash
cd aypex-admin
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
