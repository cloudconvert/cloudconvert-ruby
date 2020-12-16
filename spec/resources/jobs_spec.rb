describe CloudConvert::Resources::Jobs do
  let(:cloudconvert) do
    CloudConvert::Client.new(api_key: "test key")
  end

  describe "#all" do
    before do
      stub_get("/v2/jobs").to_return(body: fixture("responses/jobs.json"), headers: { content_type: "application/json" })
    end

    let!(:jobs) do
      cloudconvert.jobs.all
    end

    it "requests the correct resource" do
      expect(a_get("/v2/jobs")).to have_been_made
    end

    it "returns extended information of a given job" do
      expect(jobs.first).to be_a CloudConvert::Job
      expect(jobs.first.id).to eq "bd7d06b4-60fb-472b-b3a3-9034b273df07"
      expect(jobs.first.status).to be :waiting
      expect(jobs.first.created_at).to eq Time.parse("2019-05-13T19:52:21+00:00").utc
      expect(jobs.first.created?).to be true
      expect(jobs.first.started_at).to be_nil
      expect(jobs.first.started?).to be false
      expect(jobs.first.ended_at).to be_nil
      expect(jobs.first.ended?).to be false
      expect(jobs.first.links).to eq OpenStruct.new(self: "https://api.cloudconvert.com/v2/jobs/bd7d06b4-60fb-472b-b3a3-9034b273df07")
    end

    it "returns links data" do
      expect(jobs.links).to eq OpenStruct.new({
        first: "https://api.cloudconvert.com/v2/jobs?page=1",
        last: nil,
        prev: nil,
        next: nil,
      })
    end

    it "returns meta data" do
      expect(jobs.meta).to eq OpenStruct.new({
        current_page: 1,
        from: 1,
        path: "https://api.cloudconvert.com/v2/jobs",
        per_page: 100,
        to: 1,
      })
    end
  end

  describe "#create" do
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

    let!(:job) do
      cloudconvert.jobs.create({
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
      expect(job).to be_a CloudConvert::Job
      expect(job.id).to eq "c677ccf7-8876-4f48-bb96-0ab8e0d88cd7"
      expect(job.tasks.first).to be_a CloudConvert::Task
      expect(job.tasks.first.id).to eq "22b3d686-126b-4fe2-8238-a9781cd023d9"
      expect(job.tasks.first.operation).to eq "import/url"
      expect(job.tasks.first.status).to be :waiting
      expect(job.tasks.first.code).to be_nil
      expect(job.tasks.first.message).to be_nil
      expect(job.tasks.first.percent).to be 100
      expect(job.tasks.first.depends_on_tasks.count).to eq 0
      expect(job.tasks.first.depends_on_tasks?).to be false
      expect(job.tasks.first.payload).to eq OpenStruct.new({ operation: "import/url", url: "http://invalid.url", filename: "test.file" })
      expect(job.tasks.first.result).to be_nil
      expect(job.tasks.first.created_at).to eq Time.parse("2019-06-01T00:35:33+00:00").utc
      expect(job.tasks.first.created?).to be true
      expect(job.tasks.first.started_at).to eq Time.parse("2019-06-01T00:35:33+00:00").utc
      expect(job.tasks.first.started?).to be true
      expect(job.tasks.first.ended_at).to be_nil
      expect(job.tasks.first.ended?).to be false
      expect(job.tasks.first.links).to eq OpenStruct.new(self: "https://api.cloudconvert.com/v2/tasks/22b3d686-126b-4fe2-8238-a9781cd023d9")
      expect(job.links).to eq OpenStruct.new(self: "https://api.cloudconvert.com/v2/jobs/c677ccf7-8876-4f48-bb96-0ab8e0d88cd7")
    end
  end

  describe "#delete" do
    before do
      stub_delete("/v2/jobs/cd82535b-0614-4b23-bbba-b24ab0e892f7").to_return({ status: 204 })
    end

    let!(:job) do
      cloudconvert.jobs.delete("cd82535b-0614-4b23-bbba-b24ab0e892f7")
    end

    it "requests the correct resource" do
      expect(a_delete("/v2/jobs/cd82535b-0614-4b23-bbba-b24ab0e892f7")).to have_been_made
    end

    it "returns nil" do
      expect(job).to be_nil
    end
  end

  describe "#find" do
    before do
      stub_get("/v2/jobs/cd82535b-0614-4b23-bbba-b24ab0e892f7").to_return(body: fixture("responses/job.json"), headers: { content_type: "application/json" })
    end

    let!(:job) do
      cloudconvert.jobs.find("cd82535b-0614-4b23-bbba-b24ab0e892f7")
    end

    it "requests the correct resource" do
      expect(a_get("/v2/jobs/cd82535b-0614-4b23-bbba-b24ab0e892f7")).to have_been_made
    end

    it "returns extended information of a given job" do
      expect(job).to be_a CloudConvert::Job
      expect(job.id).to eq "cd82535b-0614-4b23-bbba-b24ab0e892f7"
      expect(job.status).to be :error
      expect(job.tag).to eq "test-1234"
      expect(job.tasks.count).to eq 3
      expect(job.tasks.first).to be_a CloudConvert::Task
      expect(job.tasks.first.id).to eq "4c80f1ae-5b3a-43d5-bb58-1a5c4eb4e46b"
      expect(job.tasks.first.name).to eq "export-1"
      expect(job.tasks.first.code).to eq "INPUT_TASK_FAILED"
      expect(job.tasks.first.status).to be :error
      expect(job.tasks[1]).to be_a CloudConvert::Task
      expect(job.tasks[1].id).to eq "6df0920a-7042-4e87-be52-f38a0a29a67e"
      expect(job.tasks[1].name).to eq "task-1"
      expect(job.tasks[1].code).to eq "INPUT_TASK_FAILED"
      expect(job.tasks[1].status).to be :error
      expect(job.tasks[2]).to be_a CloudConvert::Task
      expect(job.tasks[2].id).to eq "22be63c2-0e3f-4909-9c2a-2261dc540aba"
      expect(job.tasks[2].name).to eq "import-1"
      expect(job.tasks[2].code).to eq "SANDBOX_FILE_NOT_ALLOWED"
      expect(job.tasks[2].status).to be :error
      expect(job.tasks?).to be true
      expect(job.created_at).to eq Time.parse("2019-05-30T10:53:01+00:00").utc
      expect(job.created?).to be true
      expect(job.started_at).to eq Time.parse("2019-05-30T10:53:05+00:00").utc
      expect(job.started?).to be true
      expect(job.ended_at).to eq Time.parse("2019-05-30T10:53:23+00:00").utc
      expect(job.ended?).to be true
      expect(job.links).to eq OpenStruct.new(self: "https://api.cloudconvert.com/v2/jobs/cd82535b-0614-4b23-bbba-b24ab0e892f7")
    end
  end

  describe "#wait" do
    before do
      stub_get("/v2/jobs/cd82535b-0614-4b23-bbba-b24ab0e892f7/wait").to_return({
        body: fixture("responses/job.json"),
        headers: { content_type: "application/json" },
      })
    end

    let!(:job) do
      cloudconvert.jobs.wait("cd82535b-0614-4b23-bbba-b24ab0e892f7")
    end

    it "requests the correct resource" do
      expect(a_get("/v2/jobs/cd82535b-0614-4b23-bbba-b24ab0e892f7/wait")).to have_been_made
    end

    it "returns the job" do
      expect(job).to be_a CloudConvert::Job
      expect(job.id).to eq "cd82535b-0614-4b23-bbba-b24ab0e892f7"
    end
  end
end
