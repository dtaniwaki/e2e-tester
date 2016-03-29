# e2e-tester

[![Dependency Status][deps-image]][deps-link]
[![Build Status][build-image]][build-link]
[![Coverage Status][cov-image]][cov-link]
[![Code Climate][gpa-image]][gpa-link]

End-to-end test across the browsers.

## Requirement

- [PhantomJS v2.x](http://phantomjs.org/)
- Redis >= v2.8
- MySQL >= v5.5

### Optional

- FireFox
- [Safari Selenium Driver](https://github.com/SeleniumHQ/selenium/wiki/SafariDriver)
- [Browserstack](https://www.browserstack.com)

## Run

```bash
bundle install
bundle exec puma -C config/puma.rb -d
bundle exec sidekiq -C config/sidekiq.yml -d
open http://localhost:3000/
```

## Test

```bash
bundle exec rspec
```

Run rubocop for the code regulation

```bash
bundle exec rubocop
bundle exec rubocop --auto-correct # To correct them automatically as much as possible
```

## Run in Docker

You can try the e2e tester without any settings with docker-compose.

```bash
docker-compose up
open http://$(docker-machine ip $machine):3000
```

If you have browserstack account, you can set them in `.docker_env` with the environment variables below.

```bash
BROWSERSTACK_USERNAME=foo
BROWSERSTACK_PASSWORD=bar
```

Then, run the rake task.

```bash
docker-compose run init bundle exec rake browser:update:browserstack
```

You need to set up Google Oauth2 settings in `.docker_env` to use the admin.

```bash
OMNIAUTH_GOOGLE_APP_ID=foo
OMNIAUTH_GOOGLE_APP_SECRET=bar
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

