describe CloudConvert::Job do
  id1, id2 = [SecureRandom.uuid, SecureRandom.uuid]
  url = "https://api.cloudconvert.com/v2/tasks/#{id1}"

  describe "#==" do
    it "returns true when objects IDs are the same" do
      job = CloudConvert::Job.new(id: id1, tasks: [{ operation: "convert" }])
      other = CloudConvert::Job.new(id: id1, tasks: [{ operation: "optimize" }])
      expect(job == other).to be true
    end

    it "returns false when objects IDs are different" do
      job = CloudConvert::Job.new(id: id1)
      other = CloudConvert::Job.new(id: id2)
      expect(job == other).to be false
    end

    it "returns false when classes are different" do
      job = CloudConvert::Job.new(id: id1)
      other = CloudConvert::Task.new(id: id1)
      expect(job == other).to be false
    end
  end

  describe "#tasks" do
    it "returns value when tasks is set" do
      job = CloudConvert::Job.new(tasks: [{ operation: "convert" }])
      expect(job.tasks.count).to eq 1
      expect(job.tasks.first).to be_a CloudConvert::Task
      expect(job.tasks.first.operation).to eq "convert"
    end

    it "returns [] when tasks is not set" do
      job = CloudConvert::Job.new()
      expect(job.tasks).to eq []
    end
  end

  describe "#status" do
    it "returns value when status is set" do
      job = CloudConvert::Job.new(status: "pending")
      expect(job.status).to be :pending
    end

    it "returns nil when status is not set" do
      job = CloudConvert::Job.new()
      expect(job.status).to be_nil
    end
  end

  describe "#tag" do
    it "returns value when tag is set" do
      job = CloudConvert::Job.new(tag: "a tag")
      expect(job.tag).to eq "a tag"
    end

    it "returns nil when tag is not set" do
      job = CloudConvert::Job.new()
      expect(job.tag).to be_nil
    end
  end

  describe "#links" do
    it "returns struct when links is set" do
      job = CloudConvert::Job.new(links: { self: url })
      expect(job.links).to eq OpenStruct.new(self: url)
    end

    it "returns nil when links is not set" do
      job = CloudConvert::Job.new()
      expect(job.links).to be_nil
    end
  end

  describe "#created_at" do
    it "returns a Time when created_at is set" do
      job = CloudConvert::Job.new(created_at: "Mon Jul 16 12:59:01 +0000 2020")
      expect(job.created_at).to be_a Time
      expect(job.created_at).to be_utc
    end

    it "returns nil when created_at is not set" do
      job = CloudConvert::Job.new()
      expect(job.created_at).to be_nil
    end
  end

  describe "#created?" do
    it "returns true when created_at is set" do
      job = CloudConvert::Job.new(created_at: "Mon Jul 16 12:59:01 +0000 2020")
      expect(job.created?).to be true
    end

    it "returns false when created_at is not set" do
      job = CloudConvert::Job.new()
      expect(job.created?).to be false
    end
  end

  describe "#started_at" do
    it "returns a Time when started_at is set" do
      job = CloudConvert::Job.new(started_at: "Mon Jul 16 12:59:01 +0000 2020")
      expect(job.started_at).to be_a Time
      expect(job.started_at).to be_utc
    end

    it "returns nil when started_at is not set" do
      job = CloudConvert::Job.new()
      expect(job.started_at).to be_nil
    end
  end

  describe "#started?" do
    it "returns true when started_at is set" do
      job = CloudConvert::Job.new(started_at: "Mon Jul 16 12:59:01 +0000 2020")
      expect(job.started?).to be true
    end

    it "returns false when started_at is not set" do
      job = CloudConvert::Job.new()
      expect(job.started?).to be false
    end
  end

  describe "#ended_at" do
    it "returns a Time when ended_at is set" do
      job = CloudConvert::Job.new(ended_at: "Mon Jul 16 12:59:01 +0000 2020")
      expect(job.ended_at).to be_a Time
      expect(job.ended_at).to be_utc
    end

    it "returns nil when ended_at is not set" do
      job = CloudConvert::Job.new()
      expect(job.ended_at).to be_nil
    end
  end

  describe "#ended?" do
    it "returns true when ended_at is set" do
      job = CloudConvert::Job.new(ended_at: "Mon Jul 16 12:59:01 +0000 2020")
      expect(job.ended?).to be true
    end

    it "returns false when ended_at is not set" do
      job = CloudConvert::Job.new()
      expect(job.ended?).to be false
    end
  end
end
