require "integration_helper"

describe CloudConvert::Resources::Tasks, integration: true do
  let(:cloudconvert) do
    CloudConvert::Client.new({
      api_key: CLOUDCONVERT_API_KEY,
      sandbox: true,
    })
  end

  it "performs import/upload task" do
    # create task
    @task = cloudconvert.tasks.create({
      operation: "import/upload",
    })

    # upload file
    cloudconvert.tasks.upload(File.expand_path("files/input.pdf", __dir__), @task)

    # wait for the task
    @task = cloudconvert.tasks.wait(@task.id)

    # check updates
    expect(@task.status).to be :finished
    expect(@task.result.files.first.filename).to eq "input.pdf"
  end

  it "performs import/url task" do
    # create task
    @task = cloudconvert.tasks.create({
      operation: "import/url",
      url: "https://github.com/cloudconvert/cloudconvert-php/raw/master/tests/Integration/files/input.pdf",
    })

    # wait for the task
    @task = cloudconvert.tasks.wait(@task.id)

    # check updates
    expect(@task.status).to be :finished
    expect(@task.result.files.first.filename).to eq "input.pdf"
  end

  after do
    cloudconvert.tasks.delete(@task.id)
  end
end
