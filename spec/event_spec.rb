describe CloudConvert::Event do
  job = { id: SecureRandom.uuid }

  describe "#==" do
    it "returns true when event name and job are the same" do
      event = CloudConvert::Event.new(event: "job.created", job: job)
      other = CloudConvert::Event.new(event: "job.created", job: job)
      expect(event == other).to be true
    end
    it "returns false when event names are different" do
      event = CloudConvert::Event.new(event: "job.created", job: job)
      other = CloudConvert::Event.new(event: "job.finished", job: job)
      expect(event == other).to be false
    end
    it "returns false when jobs are different" do
      event = CloudConvert::Event.new(event: "job.created", job: job)
      other = CloudConvert::Event.new(event: "job.created", job: { id: SecureRandom.uuid })
      expect(event == other).to be false
    end
    it "returns false when classes are different" do
      event = CloudConvert::Event.new(event: "job.created", job: job)
      other = CloudConvert::Task.new(event: "job.created", job: job)
      expect(event == other).to be false
    end
  end

  describe "#name" do
    it "returns value when event is set" do
      event = CloudConvert::Event.new(event: "job.failed")
      expect(event.name).to eq "job.failed"
    end
    it "returns nil when event is not set" do
      event = CloudConvert::Event.new()
      expect(event.name).to be_nil
    end
  end

  describe "#event" do
    it "returns value when event is set" do
      event = CloudConvert::Event.new(event: "job.failed")
      expect(event.event).to eq "job.failed"
    end
    it "returns nil when event is not set" do
      event = CloudConvert::Event.new()
      expect(event.event).to be_nil
    end
  end

  describe "#job" do
    it "returns value when job is set" do
      event = CloudConvert::Event.new(job: job)
      expect(event.job).to be_a CloudConvert::Job
      expect(event.job.id).to eq job[:id]
    end
    it "returns nil when job is not set" do
      event = CloudConvert::Event.new()
      expect(event.job).to be_nil
    end
  end
end
