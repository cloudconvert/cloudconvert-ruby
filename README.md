cloudconvert-ruby
=================

> This is the official Ruby SDK for the [CloudConvert](https://cloudconvert.com/api/v2) _API v2_.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cloudconvert'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install cloudconvert

## Usage

TODO: Write usage instructions here

## Webhooks

Webhooks can be created on the [CloudConvert Dashboard](https://cloudconvert.com/dashboard/api/v2/webhooks), where you can also find the signing secret for verifying requests.

If you're using Rails, you'll want to configure a route to receive the CloudConvert webhook POST requests:

```ruby
# config/routes.rb
resource :cloudconvert_webhooks, controller: :cloud_convert_webhooks, only: :create
```

Then create a new controller:

```ruby
# app/controllers/cloudconvert_webhooks_controller.rb
class CloudConvertWebhooksController < ActionController::Base
  include CloudConvert::Webhook::Processor

  # Handle job.created event
  def job_created(event)
    # TODO: handle job.created webhook
  end

  # Handle job.finished event
  def job_finished(event)
    # TODO: handle job.finished webhook
  end

  # Handle job.failed event
  def job_failed(event)
    # TODO: handle job.failed webhook
  end

  private

  def webhook_secret(event)
    ENV['CLOUDCONVERT_WEBHOOK_SECRET']
  end
end
```

Add as many instance methods as events you want to handle in your controller.

A `job.created` event can be handled by `job_created(event)`, or a `job.finished` event can be handled by `job_finished(event)`, etc.

Alternatively, you can verify the payload yourself:

```ruby
payload = request.body
signature = request.headers["CloudConvert-Signature"]
secret = "..." # You can find it in your webhook settings

CloudConvert::Webhook::verify(payload, signature, secret) do |event|
  event.name == "job.finished"
  puts event.job.id
  puts event.job.tasks.count
end
```

Or by passing in a request:

```ruby
CloudConvert::Webhook::verify_request(request, secret) do |event|
  # ...
end
```

The verify methods will raise a `CloudConvert::Webhook::Error` if the `CloudConvert-Signature` header is invalid or missing.

You can read the [full list of events](https://cloudconvert.com/api/v2/webhooks) CloudConvert can notify you about.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/cloudconvert.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
