describe CloudConvert::Resources::Tasks do
  before do
    @client = CloudConvert::Client.new(api_key: "test key")
  end

  describe "#all" do
    before do
      stub_get("/v2/tasks").to_return(body: fixture("responses/tasks.json"), headers: { content_type: "application/json" })
    end

    subject! do
      @client.tasks.all
    end

    it "requests the correct resource" do
      expect(a_get("/v2/tasks")).to have_been_made
    end

    it "returns extended information of a given task" do
      expect(subject[0]).to be_a CloudConvert::Task
      expect(subject[0].id).to eq "4c80f1ae-5b3a-43d5-bb58-1a5c4eb4e46b"
      expect(subject[0].status).to be :error
      expect(subject[0].code).to eq "INPUT_TASK_FAILED"
      expect(subject[0].message).to eq "Input task has failed"
      expect(subject[0].depends_on_tasks.count).to eq 0
      expect(subject[0].depends_on_tasks?).to be false
      expect(subject[0].created_at).to eq Time.parse("2019-05-30T10:53:01+00:00").utc
      expect(subject[0].created?).to be true
      expect(subject[0].started_at).to be_nil
      expect(subject[0].started?).to be false
      expect(subject[0].ended_at).to eq Time.parse("2019-05-30T10:53:23+00:00").utc
      expect(subject[0].ended?).to be true
      expect(subject[0].links).to eq OpenStruct.new(self: "https://api.cloudconvert.com/v2/tasks/4c80f1ae-5b3a-43d5-bb58-1a5c4eb4e46b")
    end

    it "returns links data" do
      expect(subject.links).to eq OpenStruct.new({
        first: "https://api.cloudconvert.com/v2/tasks?page=1",
        last: nil,
        prev: nil,
        next: nil,
      })
    end

    it "returns meta data" do
      expect(subject.meta).to eq OpenStruct.new({
        current_page: 1,
        from: 1,
        path: "https://api.cloudconvert.com/v2/tasks",
        per_page: 100,
        to: 1,
      })
    end
  end

  describe "#create" do
    context "import/url" do
      before do
        stub_post("/v2/import/url")
          .with(body: { name: "test", operation: "import/url", filename: "test.file", url: "http://invalid.url" })
          .to_return({
            status: 201,
            body: fixture("responses/task_created.json"),
            headers: { content_type: "application/json" },
          })
      end

      subject! do
        @client.tasks.create({ name: "test", operation: "import/url", filename: "test.file", url: "http://invalid.url" })
      end

      it "requests the correct resource" do
        expect(a_post("/v2/import/url")).to have_been_made
      end

      it "returns extended information of a given task" do
        expect(subject).to be_a CloudConvert::Task
        expect(subject.id).to eq "2f901289-c9fe-4c89-9c4b-98be526bdfbf"
        expect(subject.operation).to eq "import/url"
        expect(subject.status).to be :waiting
        expect(subject.code).to be_nil
        expect(subject.message).to be_nil
        expect(subject.percent).to be 100
        expect(subject.depends_on_tasks.count).to eq 0
        expect(subject.depends_on_tasks?).to be false
        expect(subject.payload).to eq OpenStruct.new({ name: "test", url: "http://invalid.url", filename: "test.file" })
        expect(subject.result).to be_nil
        expect(subject.created_at).to eq Time.parse("2019-05-31T23:52:39+00:00").utc
        expect(subject.created?).to be true
        expect(subject.started_at).to eq Time.parse("2019-05-31T23:52:39+00:00").utc
        expect(subject.started?).to be true
        expect(subject.ended_at).to eq Time.parse("2019-05-31T23:53:26+00:00").utc
        expect(subject.ended?).to be true
        expect(subject.links).to eq OpenStruct.new(self: "https://api.cloudconvert.com/v2/tasks/2f901289-c9fe-4c89-9c4b-98be526bdfbf")
      end
    end
  end

  describe "#cancel" do
    before do
      stub_post("/v2/tasks/4c80f1ae-5b3a-43d5-bb58-1a5c4eb4e46b/cancel").to_return({
        body: fixture("responses/task.json"),
        headers: { content_type: "application/json" },
      })
    end

    subject! do
      @client.tasks.cancel("4c80f1ae-5b3a-43d5-bb58-1a5c4eb4e46b")
    end

    it "requests the correct resource" do
      expect(a_post("/v2/tasks/4c80f1ae-5b3a-43d5-bb58-1a5c4eb4e46b/cancel")).to have_been_made
    end

    it "returns the task" do
      expect(subject).to be_a CloudConvert::Task
      expect(subject.id).to eq "4c80f1ae-5b3a-43d5-bb58-1a5c4eb4e46b"
    end
  end

  describe "#find" do
    before do
      stub_get("/v2/tasks/4c80f1ae-5b3a-43d5-bb58-1a5c4eb4e46b").to_return(body: fixture("responses/task.json"), headers: { content_type: "application/json" })
    end

    subject! do
      @client.tasks.find("4c80f1ae-5b3a-43d5-bb58-1a5c4eb4e46b")
    end

    it "requests the correct resource" do
      expect(a_get("/v2/tasks/4c80f1ae-5b3a-43d5-bb58-1a5c4eb4e46b")).to have_been_made
    end

    it "returns extended information of a given task" do
      expect(subject).to be_a CloudConvert::Task
      expect(subject.id).to eq "4c80f1ae-5b3a-43d5-bb58-1a5c4eb4e46b"
      expect(subject.status).to be :error
      expect(subject.code).to eq "INPUT_TASK_FAILED"
      expect(subject.message).to eq "Input task has failed"
      expect(subject.depends_on_tasks.count).to eq 1
      expect(subject.depends_on_tasks[0]).to be_a CloudConvert::Task
      expect(subject.depends_on_tasks[0].id).to eq "6df0920a-7042-4e87-be52-f38a0a29a67e"
      expect(subject.depends_on_tasks[0].status).to be :error
      expect(subject.depends_on_tasks?).to be true
      expect(subject.created_at).to eq Time.parse("2019-05-30T10:53:01+00:00").utc
      expect(subject.created?).to be true
      expect(subject.started_at).to be_nil
      expect(subject.started?).to be false
      expect(subject.ended_at).to eq Time.parse("2019-05-30T10:53:23+00:00").utc
      expect(subject.ended?).to be true
      expect(subject.links).to eq OpenStruct.new(self: "https://api.cloudconvert.com/v2/tasks/4c80f1ae-5b3a-43d5-bb58-1a5c4eb4e46b")
    end
  end

  describe "#delete" do
    before do
      stub_delete("/v2/tasks/4c80f1ae-5b3a-43d5-bb58-1a5c4eb4e46b").to_return({ status: 204 })
    end

    subject! do
      @client.tasks.delete("4c80f1ae-5b3a-43d5-bb58-1a5c4eb4e46b")
    end

    it "requests the correct resource" do
      expect(a_delete("/v2/tasks/4c80f1ae-5b3a-43d5-bb58-1a5c4eb4e46b")).to have_been_made
    end

    it "returns nil" do
      expect(subject).to be_nil
    end
  end

  describe "#retry" do
    before do
      stub_post("/v2/tasks/4c80f1ae-5b3a-43d5-bb58-1a5c4eb4e46b/retry").to_return({
        body: fixture("responses/task.json"),
        headers: { content_type: "application/json" },
      })
    end

    subject! do
      @client.tasks.retry("4c80f1ae-5b3a-43d5-bb58-1a5c4eb4e46b")
    end

    it "requests the correct resource" do
      expect(a_post("/v2/tasks/4c80f1ae-5b3a-43d5-bb58-1a5c4eb4e46b/retry")).to have_been_made
    end

    it "returns the new task" do
      expect(subject).to be_a CloudConvert::Task
    end
  end

  describe "#upload" do
    before do
      stub_post("/v2/import/upload").to_return({
        body: fixture("responses/upload_task_created.json"),
        headers: { content_type: "application/json" },
      })

      stub_post(form_url)
      # .with({
      #   # WebMock does not support matching body for multipart/form-data requests yet :(
      #   body: form_parameters.merge(file: Faraday::FilePart.new(file, content_type)),
      #   headers: { content_type: "multipart/form-data" },
      # })
    end

    let(:form_url) do
      "https://upload.sandbox.cloudconvert.com/storage.de1.cloud.ovh.net/v1/AUTH_b2cffe8f45324c2bba39e8db1aedb58f/cloudconvert-files-sandbox/8aefdb39-34c8-4c7a-9f2e-1751686d615e/?s=jNf7hn3zox1iZfZY6NirNA&e=1559588529"
    end

    let(:form_parameters) do
      {
        expires: 1559588529,
        max_file_count: 1,
        max_file_size: 10000000000,
        signature: "79fda6c5ffbfaa857ae9a1430641cc68c5a72297",
      }
    end

    let(:file) do
      StringIO.new("test file")
    end

    let(:content_type) do
      "text/plain"
    end

    let(:task) do
      @client.tasks.create(operation: "import/upload")
    end

    subject! do
      @client.tasks.upload(file, task)
    end

    it "requests the correct resource" do
      expect(a_post("/v2/import/upload")).to have_been_made
      expect(a_post(form_url)).to have_been_made
    end
  end

  describe "#wait" do
    before do
      stub_get("/v2/tasks/4c80f1ae-5b3a-43d5-bb58-1a5c4eb4e46b/wait").to_return({
        body: fixture("responses/task.json"),
        headers: { content_type: "application/json" },
      })
    end

    subject! do
      @client.tasks.wait("4c80f1ae-5b3a-43d5-bb58-1a5c4eb4e46b")
    end

    it "requests the correct resource" do
      expect(a_get("/v2/tasks/4c80f1ae-5b3a-43d5-bb58-1a5c4eb4e46b/wait")).to have_been_made
    end

    it "returns the task" do
      expect(subject).to be_a CloudConvert::Task
      expect(subject.id).to eq "4c80f1ae-5b3a-43d5-bb58-1a5c4eb4e46b"
    end
  end
end
