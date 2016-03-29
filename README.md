# e2e-tester

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
bundle exec puma -C config/puma.rb
bundle exec sidekiq -C config/sidekiq.yml.sample
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

