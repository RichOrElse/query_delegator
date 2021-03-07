# QueryDelegator

Write composable and table agnostic query objects for ActiveRecord scopes. Move query code from ActiveRecord models to query objects, because database query code do not belong in the model.

## Installation

QueryDelegator works with Rails 5.1.7 onwards. Add this line to your application's Gemfile:

```ruby
gem 'query_delegator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install query_delegator

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/RichOrElse/query_delegator. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the QueryDelegator project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/RichOrElse/query_delegator/blob/master/CODE_OF_CONDUCT.md).
