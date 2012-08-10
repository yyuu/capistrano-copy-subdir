# capistrano-copy-subdir

a capistrano strategy to deploy subdir with copy strategy.

## Installation

Add this line to your application's Gemfile:

    gem 'capistrano-copy-subdir'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano-copy-subdir

## Usage

Write following snipet in your `config/deploy.rb`.

    set(:deploy_via, :copy_subdir)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Author

- YAMASHITA Yuu (https://github.com/yyuu)
- Geisha Tokyo Entertainment Inc. (http://www.geishatokyo.com/)

## License

MIT
