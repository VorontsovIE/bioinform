# Bioinform
Bioinform is a bunch of classes extracted from daily bioinformatics work. This classes is an attempt to encapsulate loading(parsing) logic for positional matrices in different formats and common transformations. It also includes several core classes extensions which are particularly useful on Enumerables

Bioinform is in its development phase. API is changing very quickly. Each version is tested and consistent but no one guarantees that code worked in your version will work in future versions. However last version of bioinform is always consistent with latest version of macroape, and cli-tools that're built on top of libraries changes their interface not so often, so you can use them thinking about library as about black-box that makes able to do some useful things

## Installation

Add this line to your application's Gemfile:

    gem 'bioinform'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bioinform

## Usage

Usage is under construction. I don't recommend to use this gem for a while: syntax is on the way to change to more simple and concise. But stay tuned

### Command-line applications
  * pcm2pwm
  * split_motifs
  * merge_into_collection

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
