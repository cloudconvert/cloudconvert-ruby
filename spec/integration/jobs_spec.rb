require "integration_helper"

describe CloudConvert::Resources::Jobs, :integration do
  let(:cloudconvert) do
    CloudConvert::Client.new({
      api_key: CLOUDCONVERT_API_KEY,
      sandbox: true,
    })
  end

  it "performs upload and download of file" do
    @job = cloudconvert.jobs.create({
      tag: "integration-test-upload-download",
      tasks: [
        {
          name: "import-it",
          operation: "import/upload"
        },
        {
          name: "export-it",
          input: "import-it",
          operation: "export/url"
        }
      ]
    })

    import_task = @job.tasks.where(name: "import-it").first
    export_task = @job.tasks.where(name: "export-it").first

    # fetch the finished task
    import_task = cloudconvert.tasks.find(import_task.id)

    # do upload
    cloudconvert.tasks.upload(File.expand_path("files/input.pdf", __dir__), import_task)

    # fetch the finished export task
    export_task = cloudconvert.tasks.wait(export_task.id)

    # get exported url
    url = export_task.result.files.first.url
    expect(export_task.result.files.first.filename).to eq "input.pdf"

    # now download the exported file
    expect(cloudconvert.download(url)).to be_a Tempfile
  end

  after do
    cloudconvert.jobs.delete(@job.id)
  end
end
