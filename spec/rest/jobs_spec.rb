require "spec_helper"

describe CloudConvert::REST::Jobs do
  before do
    @client = CloudConvert::Client.new(api_key: "test key")
  end

  describe "#job" do
    before do
      stub_get("/v2/jobs/cd82535b-0614-4b23-bbba-b24ab0e892f7").to_return(body: fixture("responses/job.json"), headers: { content_type: "application/json" })
    end

    subject! do
      @client.job("cd82535b-0614-4b23-bbba-b24ab0e892f7")
    end

    it "requests the correct resource" do
      expect(a_get("/v2/jobs/cd82535b-0614-4b23-bbba-b24ab0e892f7")).to have_been_made
    end

    it "returns extended information of a given job" do
      expect(subject).to be_a CloudConvert::Job
      expect(subject.id).to eq "cd82535b-0614-4b23-bbba-b24ab0e892f7"
      expect(subject.status).to be :error
      expect(subject.tag).to eq "test-1234"
      expect(subject.tasks.count).to eq 3
      expect(subject.tasks[0]).to be_a CloudConvert::Task
      expect(subject.tasks[0].id).to eq "4c80f1ae-5b3a-43d5-bb58-1a5c4eb4e46b"
      expect(subject.tasks[0].name).to eq "export-1"
      expect(subject.tasks[0].code).to eq "INPUT_TASK_FAILED"
      expect(subject.tasks[0].status).to be :error
      expect(subject.tasks[1]).to be_a CloudConvert::Task
      expect(subject.tasks[1].id).to eq "6df0920a-7042-4e87-be52-f38a0a29a67e"
      expect(subject.tasks[1].name).to eq "task-1"
      expect(subject.tasks[1].code).to eq "INPUT_TASK_FAILED"
      expect(subject.tasks[1].status).to be :error
      expect(subject.tasks[2]).to be_a CloudConvert::Task
      expect(subject.tasks[2].id).to eq "22be63c2-0e3f-4909-9c2a-2261dc540aba"
      expect(subject.tasks[2].name).to eq "import-1"
      expect(subject.tasks[2].code).to eq "SANDBOX_FILE_NOT_ALLOWED"
      expect(subject.tasks[2].status).to be :error
      expect(subject.tasks?).to be true
      expect(subject.created_at).to eq Time.parse("2019-05-30T10:53:01+00:00").utc
      expect(subject.created?).to be true
      expect(subject.started_at).to eq Time.parse("2019-05-30T10:53:05+00:00").utc
      expect(subject.started?).to be true
      expect(subject.ended_at).to eq Time.parse("2019-05-30T10:53:23+00:00").utc
      expect(subject.ended?).to be true
      expect(subject.links).to eq OpenStruct.new(self: "https://api.cloudconvert.com/v2/jobs/cd82535b-0614-4b23-bbba-b24ab0e892f7")
    end
  end

  describe "#jobs" do
    before do
      stub_get("/v2/jobs").to_return(body: fixture("responses/jobs.json"), headers: { content_type: "application/json" })
    end

    subject! do
      @client.jobs
    end

    it "requests the correct resource" do
      expect(a_get("/v2/jobs")).to have_been_made
    end

    it "returns extended information of a given job" do
      expect(subject[0]).to be_a CloudConvert::Job
      expect(subject[0].id).to eq "bd7d06b4-60fb-472b-b3a3-9034b273df07"
      expect(subject[0].status).to be :waiting
      expect(subject[0].created_at).to eq Time.parse("2019-05-13T19:52:21+00:00").utc
      expect(subject[0].created?).to be true
      expect(subject[0].started_at).to be_nil
      expect(subject[0].started?).to be false
      expect(subject[0].ended_at).to be_nil
      expect(subject[0].ended?).to be false
      expect(subject[0].links).to eq OpenStruct.new(self: "https://api.cloudconvert.com/v2/jobs/bd7d06b4-60fb-472b-b3a3-9034b273df07")
    end

    it "returns links data" do
      expect(subject.links).to eq OpenStruct.new({
        first: "https://api.cloudconvert.com/v2/jobs?page=1",
        last: nil,
        prev: nil,
        next: nil,
      })
    end

    it "returns meta data" do
      expect(subject.meta).to eq OpenStruct.new({
        current_page: 1,
        from: 1,
        path: "https://api.cloudconvert.com/v2/jobs",
        per_page: 100,
        to: 1,
      })
    end
  end

  describe "#create_job" do
    before do
      stub_post("/v2/jobs")
        .with({
          body: {
            tasks: {
              "import-it": { operation: "import/url", filename: "test.file", url: "http://invalid.url" },
              "convert-it": { operation: "convert", output_format: "pdf" },
            }
          }
        })
        .to_return({
          status: 201,
          body: fixture("responses/job_created.json"),
          headers: { content_type: "application/json" },
        })
    end

    subject! do
      @client.create_job({
        tasks: [
          { name: "import-it", operation: "import/url", filename: "test.file", url: "http://invalid.url" },
          { name: "convert-it", operation: "convert", output_format: "pdf" },
        ]
      })
    end

    it "requests the correct resource" do
      expect(a_post("/v2/jobs")).to have_been_made
    end

    it "returns extended information of a given job" do
      expect(subject).to be_a CloudConvert::Job
      expect(subject.id).to eq "c677ccf7-8876-4f48-bb96-0ab8e0d88cd7"
      expect(subject.tasks[0]).to be_a CloudConvert::Task
      expect(subject.tasks[0].id).to eq "22b3d686-126b-4fe2-8238-a9781cd023d9"
      expect(subject.tasks[0].operation).to eq "import/url"
      expect(subject.tasks[0].status).to be :waiting
      expect(subject.tasks[0].code).to be_nil
      expect(subject.tasks[0].message).to be_nil
      expect(subject.tasks[0].percent).to be 100
      expect(subject.tasks[0].depends_on_tasks.count).to eq 0
      expect(subject.tasks[0].depends_on_tasks?).to be false
      expect(subject.tasks[0].payload).to eq OpenStruct.new({ operation: "import/url", url: "http://invalid.url", filename: "test.file" })
      expect(subject.tasks[0].result).to be_nil
      expect(subject.tasks[0].created_at).to eq Time.parse("2019-06-01T00:35:33+00:00").utc
      expect(subject.tasks[0].created?).to be true
      expect(subject.tasks[0].started_at).to eq Time.parse("2019-06-01T00:35:33+00:00").utc
      expect(subject.tasks[0].started?).to be true
      expect(subject.tasks[0].ended_at).to be_nil
      expect(subject.tasks[0].ended?).to be false
      expect(subject.tasks[0].links).to eq OpenStruct.new(self: "https://api.cloudconvert.com/v2/tasks/22b3d686-126b-4fe2-8238-a9781cd023d9")
      expect(subject.links).to eq OpenStruct.new(self: "https://api.cloudconvert.com/v2/jobs/c677ccf7-8876-4f48-bb96-0ab8e0d88cd7")
    end
  end

  describe "#delete_job" do
    before do
      stub_delete("/v2/jobs/cd82535b-0614-4b23-bbba-b24ab0e892f7").to_return({ status: 204 })
    end

    subject! do
      @client.delete_job("cd82535b-0614-4b23-bbba-b24ab0e892f7")
    end

    it "requests the correct resource" do
      expect(a_delete("/v2/jobs/cd82535b-0614-4b23-bbba-b24ab0e892f7")).to have_been_made
    end

    it "returns nil" do
      expect(subject).to be_nil
    end
  end

  describe "#wait_for_job" do
    before do
      stub_get("/v2/jobs/cd82535b-0614-4b23-bbba-b24ab0e892f7/wait").to_return({
        body: fixture("responses/job.json"),
        headers: { content_type: "application/json" },
      })
    end

    subject! do
      @client.wait_for_job("cd82535b-0614-4b23-bbba-b24ab0e892f7")
    end

    it "requests the correct resource" do
      expect(a_get("/v2/jobs/cd82535b-0614-4b23-bbba-b24ab0e892f7/wait")).to have_been_made
    end

    it "returns the job" do
      expect(subject).to be_a CloudConvert::Job
      expect(subject.id).to eq "cd82535b-0614-4b23-bbba-b24ab0e892f7"
    end
  end
end
