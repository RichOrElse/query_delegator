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

Query objects inherit from `QueryDelegator` class, they typically live under `app/queries` directory.
Naming convention suggests adding a `Query` suffix to query object class names.
Alternatively prefixing class names with words like `By` is shorter and reads more naturally.

```ruby
class ByEmail < QueryDelegator
  def call(email)
    at(email).first
  end

  def at(email)
    where(email: email.to_s.downcase)
  end

  def be(email)
    return all unless email.blank?

    at email
  end
end
```

Wrap scopes outside ActiveRecord models.

```ruby
@user = ByEmail.new(User).("john.doe@example.test")
@contacts = @user.contacts.then(&ByEmail).be(params[:email])
```

Wrap scopes inside ActiveRecord models.

```ruby
class User < ApplicationRecord
  has_many :contacts
  scope :by_email, ByEmail
end

class Contact < ApplicationRecord
  belong_to :user
  scope :by_email, ByEmail
end

@user = User.by_email.("john.doe@example.test")
@contacts = @user.contacts.by_email.be(params[:email])
```

### QueryDelegator::[]

Delegates Active Record scope to a query object method.
Intended for association and named scopes, it accepts a query object's method name and returns a `Proc`.

```ruby
class User < ApplicationRecord
  has_many :contacts, ByCreated[:recently]
  scope :since, ByCreated[:since]
end

class ByCreated < QueryDelegator
  def recently
    order(created_at: :desc)
  end

  def since(timestamp)
    where table[:created_at].gteq(timestamp)
  end
end

@users = User.since 1.year.ago
```

### QueryDelegator::Be

To add the helper method `be`, include this module in your query object class like so:

```ruby
class ByPublished < QueryDelegator
  include Be

  def be_draft
    on nil
  end

  def be_published
    where.not(published_on: nil)
  end

  def on(date)
    where(published_on: date)
  end
end
```

#### be

Given a name, method `be` invokes another method prefixed with `be_`, otherwise
returns `none` by default or
returns `all` given a blank name.

```ruby
@books = @author.books.then(&ByPublished)
@books.be(['draft'])  # returns books without publish date
@books.be(:published) # returns books with publish date
@books.be('unknown')  # returns none
@books.be(nil)        # returns all books
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/RichOrElse/query_delegator. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the QueryDelegator project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/RichOrElse/query_delegator/blob/master/CODE_OF_CONDUCT.md).
