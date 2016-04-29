# e2e-tester

[![Dependency Status][deps-image]][deps-link]
[![Build Status][build-image]][build-link]
[![Coverage Status][cov-image]][cov-link]
[![Code Climate][gpa-image]][gpa-link]
[![Gratipay][gratipay-image]][gratipay-link]

End-to-end test across the browsers.

Here's [the working example](http://e2e-tester.dtaniwaki.com/).

## Requirement

- [NodeJS](https://nodejs.org/en/) >= v5.0
- [PhantomJS](http://phantomjs.org/) >= v2.1
- [Mogrify](http://www.imagemagick.org/script/mogrify.php) >= v6.9
- [Redis](http://redis.io/) >= v2.8
- [MySQL](https://www.mysql.com/) >= v5.5

### Optional

- [FireFox](https://www.mozilla.org/)
- [Safari Selenium Driver](https://github.com/SeleniumHQ/selenium/wiki/SafariDriver)
- [Browserstack](https://www.browserstack.com)

## Usage

```bash
bundle install
bundle exec puma -C config/puma.rb -d
bundle exec sidekiq -C config/sidekiq.yml -d
open http://localhost:3000/
```

The followings are optional, but make you happier with this application.

### Browserstack

You can use the browsers of [Browserstack](https://www.browserstack.com/) through WebDriver.

As environment variables,

```bash
BROWSERSTACK_USERNAME=foo
BROWSERSTACK_PASSWORD=bar
```

Or in `config/settings.local.yml`,

```
browserstack:
  username: foo
  password: bar
```

Then, run the rake task to update the browsers.

```bash
bundle exec rake browser:update:browserstack
```

### ActiveAdmin

To use [ActiveAdmin](https://github.com/activeadmin/activeadmin) for this application, you need to set up Google Oauth2 settings.

As environment variables,

```bash
OMNIAUTH_GOOGLE_APP_ID=foo
OMNIAUTH_GOOGLE_APP_SECRET=bar
```

Or in `config/settings.local.yml`,

```
omniauth:
  google:
    app_id: foo
    app_secret: bar
```

Then, open the admin console in your browser.

```bash
open http://localhost:3000/admin/
```

## Run in Docker

You can try the e2e tester without any settings with docker-compose.

```bash
cp .docker_env.sample .docker_env
docker-compose up
open http://$(docker-machine ip $machine):3000
```

You can use `.docker_env` to set environment variables which you don't want to expose.

## Test

To run `rspec`, `rubocop` and `brakeman` in order,

```bash
bundle exec rake
```

### rspec

```bash
bundle exec rspec
open coverage/index.html # The test coverage will be collected automatically.
```

### rubocop

Run rubocop for the code regulation

```bash
bundle exec rubocop -D
bundle exec rubocop -D --auto-correct # To correct them automatically as much as possible
```

### brakeman

Run brakeman for static vulnerability scan.

```bash
bundle exec brakeman
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new [Pull Request](../../pull/new/master)

## Copyright

Copyright (c) 2014 Daisuke Taniwaki. See [LICENSE](LICENSE) for details.


[build-image]: https://secure.travis-ci.org/dtaniwaki/e2e-tester.png
[build-link]:  http://travis-ci.org/dtaniwaki/e2e-tester
[deps-image]:  https://gemnasium.com/dtaniwaki/e2e-tester.svg
[deps-link]:   https://gemnasium.com/dtaniwaki/e2e-tester
[cov-image]:   https://coveralls.io/repos/dtaniwaki/e2e-tester/badge.png
[cov-link]:    https://coveralls.io/r/dtaniwaki/e2e-tester
[gpa-image]:   https://codeclimate.com/github/dtaniwaki/e2e-tester.png
[gpa-link]:    https://codeclimate.com/github/dtaniwaki/e2e-tester
[gratipay-image]: https://img.shields.io/badge/support%20via-gratipay-green.svg
[gratipay-link]: https://gratipay.com/~dtaniwaki/

