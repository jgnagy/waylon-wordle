# Waylon::Wordle

This is a Skill for the [Waylon Bot Framework](https://github.com/jgnagy/waylon) that simulates Waylon playing [Wordle](https://www.nytimes.com/games/wordle/index.html). It uses a fairly straightforward algorithm to find today's word and either reports its score or most likely spoils things by showing its attempt at a solution.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'waylon-wordle'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install waylon-wordle

Finally, require the newly installed code in your bot (usually in your `plugins.rb` file under the `# Skills` section):

```ruby
require "waylon/wordle"
```

## Usage

The following skills are available by either direct messaging your bot or by `@` mentioning them:

* `Wordle?`:
  * Description: Attempts to solve today's Wordle and reports a score
  * Parameters: None
  * Permissions: `*`
  * Alternatives:
    * Literally anything with `wordle` in it that ends with a `?`
* `Spoil Wordle for me`
  * Description: Lists the words Waylon used to attempt to solve today's Wordle
  * Parameters: None
* Permissions: `*`
* Alternatives:
  * Literally anything with `spoil wordle` in it

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jgnagy/waylon-wordle.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
