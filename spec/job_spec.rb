require "spec_helper"

describe CloudConvert::Job do
  id1 = SecureRandom.uuid, id2 = SecureRandom.uuid
  url = "https://api.cloudconvert.com/v2/tasks/#{id1}"

  describe "#==" do
    it "returns true when objects IDs are the same" do
      user = CloudConvert::Job.new(id: id1, tasks: [{ operation: "convert" }])
      other = CloudConvert::Job.new(id: id1, tasks: [{ operation: "optimize" }])
      expect(user == other).to be true
    end
    it "returns false when objects IDs are different" do
      user = CloudConvert::Job.new(id: id1)
      other = CloudConvert::Job.new(id: id2)
      expect(user == other).to be false
    end
    it "returns false when classes are different" do
      user = CloudConvert::Job.new(id: id1)
      other = CloudConvert::Task.new(id: id1)
      expect(user == other).to be false
    end
  end

  describe "#tasks" do
    it "returns value when tasks is set" do
      user = CloudConvert::Job.new(tasks: [{ operation: "convert" }])
      expect(user.tasks).to eq [{ operation: "convert" }]
    end
    it "returns nil when tasks is not set" do
      user = CloudConvert::Job.new()
      expect(user.tasks).to be_nil
    end
  end

  describe "#status" do
    it "returns value when status is set" do
      user = CloudConvert::Job.new(status: "pending")
      expect(user.status).to be :pending
    end
    it "returns nil when status is not set" do
      user = CloudConvert::Job.new()
      expect(user.status).to be_nil
    end
  end

  describe "#tag" do
    it "returns value when tag is set" do
      user = CloudConvert::Job.new(tag: "a tag")
      expect(user.tag).to eq "a tag"
    end
    it "returns nil when tag is not set" do
      user = CloudConvert::Job.new()
      expect(user.tag).to be_nil
    end
  end

  describe "#links" do
    it "returns struct when links is set" do
      user = CloudConvert::Job.new(links: { self: url })
      expect(user.links).to eq OpenStruct.new(self: url)
    end
    it "returns nil when links is not set" do
      user = CloudConvert::Job.new()
      expect(user.links).to be_nil
    end
  end

  describe "#created_at" do
    it "returns a Time when created_at is set" do
      user = CloudConvert::Job.new(created_at: "Mon Jul 16 12:59:01 +0000 2020")
      expect(user.created_at).to be_a Time
      expect(user.created_at).to be_utc
    end
    it "returns nil when created_at is not set" do
      user = CloudConvert::Job.new()
      expect(user.created_at).to be_nil
    end
  end

  describe "#created?" do
    it "returns true when created_at is set" do
      user = CloudConvert::Job.new(created_at: "Mon Jul 16 12:59:01 +0000 2020")
      expect(user.created?).to be true
    end
    it "returns false when created_at is not set" do
      user = CloudConvert::Job.new()
      expect(user.created?).to be false
    end
  end

  describe "#started_at" do
    it "returns a Time when started_at is set" do
      user = CloudConvert::Job.new(started_at: "Mon Jul 16 12:59:01 +0000 2020")
      expect(user.started_at).to be_a Time
      expect(user.started_at).to be_utc
    end
    it "returns nil when started_at is not set" do
      user = CloudConvert::Job.new()
      expect(user.started_at).to be_nil
    end
  end

  describe "#started?" do
    it "returns true when started_at is set" do
      user = CloudConvert::Job.new(started_at: "Mon Jul 16 12:59:01 +0000 2020")
      expect(user.started?).to be true
    end
    it "returns false when started_at is not set" do
      user = CloudConvert::Job.new()
      expect(user.started?).to be false
    end
  end

  describe "#ended_at" do
    it "returns a Time when ended_at is set" do
      user = CloudConvert::Job.new(ended_at: "Mon Jul 16 12:59:01 +0000 2020")
      expect(user.ended_at).to be_a Time
      expect(user.ended_at).to be_utc
    end
    it "returns nil when ended_at is not set" do
      user = CloudConvert::Job.new()
      expect(user.ended_at).to be_nil
    end
  end

  describe "#ended?" do
    it "returns true when ended_at is set" do
      user = CloudConvert::Job.new(ended_at: "Mon Jul 16 12:59:01 +0000 2020")
      expect(user.ended?).to be true
    end
    it "returns false when ended_at is not set" do
      user = CloudConvert::Job.new()
      expect(user.ended?).to be false
    end
  end
end
