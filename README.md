# PardotWrapper Gem

## Description

`PardotWrapper` is a Ruby gem designed to simplify interactions with the Pardot API version 5. This gem provides a straightforward and efficient way to integrate Pardot's functionalities into Ruby applications, offering basic functionalities such as listing custom fields, viewing account information, creating prospects, and managing list memberships.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pardot_wrapper'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install pardot_wrapper
```

## Usage

To start using PardotWrapper, configure the client with your OAuth credentials:

```ruby
client = PardotWrapper.new(access_token, refresh_token, client_id, client_secret, pardot_business_unit_id, :production)
```

## Available Methods

- List Custom Fields
```ruby
client.list_custom_fields

```

- View Account information
```ruby
client.get_account

```

- Create Prospect
```ruby
client.create_prospect(email, additional_params)

```

- Create List Membership
```ruby
client.create_list_membership(email, additional_params)

```

## Handling Expired Tokens
PardotWrapper handles the renewal of the access token automatically using the provided refresh_token.


## Configuration

For setting up the gem in a Rails environment, you might consider placing the initialization inside an initializer, such as config/initializers/pardot_wrapper.rb.

## Tests

The gem includes a suite of unit tests using RSpec. To run the tests, execute:

```bash
bundle exec rspec
```

## Contributions

Contributions to PardotWrapper are welcome! To contribute:

1. Fork the project.
2. Create a feature branch (git checkout -b my-new-feature).
3. Commit your changes (git commit -am 'Add some feature').
4. Push to the branch (git push origin my-new-feature).
5. Create a new Pull Request.

## License
This gem is available under the MIT License. See the LICENSE file for more details.
