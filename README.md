cloudconvert-ruby
=================

> This is the official Ruby SDK for the [CloudConvert](https://cloudconvert.com/api/v2) API v2.

## Installation

Add this line to your application's Gemfile:

```rb
gem "cloudconvert"
```

And then execute:

```sh
bundle install
```

Or install it yourself as:

```sh
gem install cloudconvert
```

## Creating API Client

```rb
cloudconvert = CloudConvert::Client.new(api_key: "API_KEY", sandbox: false)
```

Or set the environment variable `CLOUDCONVERT_API_KEY` and use:

```rb
cloudconvert = CloudConvert::Client.new
```

## Creating Jobs

```rb
cloudconvert.jobs.create({
  tasks: [
    {
      name: "import-my-file",
      operation: "import/url",
      url: "https://my-url"
    },
    {
      name: "convert-my-file",
      operation: "convert",
      input: "import-my-file",
      output_format: "pdf",
      some_other_option: "value"
    },
    {
      name: "export-my-file",
      operation: "export/url",
      input: "convert-my-file"
    },
  ]
})
```

## Downloading Files

CloudConvert can generate public URLs for using `export/url` tasks.

You can use these URLs to download output files:

```rb
exported_url_task_id = "84e872fc-d823-4363-baab-eade2e05ee54"
task = cloudconvert.tasks.wait(exported_url_task_id) # Wait for job completion
file = task.result.files[0]
export = cloudconvert.download(filename: file.filename, url: file.url)
puts export
```

## Uploading Files

Uploads to CloudConvert are done via `import/upload` tasks (see the [docs](https://cloudconvert.com/api/v2/import#import-upload-tasks)):

```rb
job = cloudconvert.jobs.create({
    tasks: [
        {
            name: "upload-my-file",
            operation: "import/upload",
        }
    ]
})
```

After you've created a `import/upload` task, you can upload a file:

```rb
upload_task = job.tasks[0]

response = cloudconvert.tasks.upload("/path/to/sample.pdf", upload_task)

updated_task = cloudconvert.tasks.find(upload_task.id)
```

Alternatively, instead of a path, you can pass in an open `IO` object:

```rb
file = File.open("/path/to/sample.pdf")
response = cloudconvert.tasks.upload(file, upload_task)
```

If you need to manually specify a `mimetype` or `filename` use our file wrapper:

```rb
file = CloudConvert::File.new("/path/to/sample.pdf", "video/mp4", "sample.mp4")
response = cloudconvert.tasks.upload(file, upload_task)
```

## Webhooks

Webhooks can be created on the [CloudConvert Dashboard](https://cloudconvert.com/dashboard/api/v2/webhooks),
where you can also find the signing secret.

If you're using Rails, you'll want to configure a route to receive the CloudConvert webhook POST requests:

```rb
# config/routes.rb
resource :cloudconvert_webhooks, controller: :cloud_convert_webhooks, only: :create
```

Then create a new controller that uses our processor concern:

```rb
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

Alternatively, you can verify the payload yourself:

```rb
payload = request.body.read
signature = request.headers["CloudConvert-Signature"]
secret = "..." # You can find it in your webhook settings

if CloudConvert::Webhook::verify(payload, signature, secret)
  event = CloudConvert::Webhook::event(payload)
  event.name == "job.finished"
  puts event.job.id
  puts event.job.tasks.count
end
```

Or by passing in a request:

```rb
CloudConvert::Webhook::verify_request(request, secret)
```

The `verify` and `verify_request` methods return true/false, use `verify!` or `verify_request!` if you'd rather raise a `CloudConvert::Webhook::Error`.

You can read the [full list of events](https://cloudconvert.com/api/v2/webhooks) CloudConvert can notify you about in our documentation.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cloudconvert/cloudconvert-ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Resources

* [API v2 Documentation](https://cloudconvert.com/api/v2)
* [CloudConvert Blog](https://cloudconvert.com/blog)
