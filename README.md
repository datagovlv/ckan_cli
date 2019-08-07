# [CKAN CLI](https://github.com/datagovlv/ckan_cli)

[![Gem Version](https://badge.fury.io/rb/ckan_cli.svg)][gem]

[gem]: http://badge.fury.io/rb/ckan_cli

> CKAN on your command line. Use your terminal to validate and publish resources to CKAN. Works with CKAN API.

![Interface](https://github.com/datagovlv/ckan_cli/raw/master/assets/interface.png)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ckan_cli'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ckan_cli

## Usage

Run it:

```shell
$ ckancli
```

For instance, to publish to CKAN all CSV files in folder do

```shell
$ ckancli upload -d C:\my_csv_collection\ -c config.json -r resource.json
```

To see help do

```shell
$ ckancli help
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. 

To install this gem onto your local machine, run `bundle exec rake install`. 

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/datagovlv/ckan_cli. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the CKAN CLI project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/datagovlv/ckan_cli/blob/master/CODE_OF_CONDUCT.md).

## Copyright

Copyright (c) 2019 datagovlv. See [MIT License](LICENSE.txt) for further details.