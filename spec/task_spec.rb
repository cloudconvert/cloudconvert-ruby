require "spec_helper"

describe CloudConvert::Task do
  id1 = SecureRandom.uuid, id2 = SecureRandom.uuid
  url = "https://api.cloudconvert.com/v2/tasks/#{id1}"

  describe "#==" do
    it "returns true when objects IDs are the same" do
      task = CloudConvert::Task.new(id: id1, operation: "convert")
      other = CloudConvert::Task.new(id: id1, operation: "optimize")
      expect(task == other).to be true
    end
    it "returns false when objects IDs are different" do
      task = CloudConvert::Task.new(id: id1)
      other = CloudConvert::Task.new(id: id2)
      expect(task == other).to be false
    end
    it "returns false when classes are different" do
      task = CloudConvert::Task.new(id: id1)
      other = CloudConvert::Job.new(id: id1)
      expect(task == other).to be false
    end
  end

  describe "#operation" do
    it "returns value when operation is set" do
      task = CloudConvert::Task.new(operation: "convert")
      expect(task.operation).to eq "convert"
    end
    it "returns nil when operation is not set" do
      task = CloudConvert::Task.new()
      expect(task.operation).to be_nil
    end
  end

  describe "#status" do
    it "returns value when status is set" do
      task = CloudConvert::Task.new(status: "pending")
      expect(task.status).to be :pending
    end
    it "returns nil when status is not set" do
      task = CloudConvert::Task.new()
      expect(task.status).to be_nil
    end
  end

  describe "#links" do
    it "returns struct when links is set" do
      task = CloudConvert::Task.new(links: { self: url })
      expect(task.links).to eq OpenStruct.new(self: url)
    end
    it "returns nil when links is not set" do
      task = CloudConvert::Task.new()
      expect(task.links).to be_nil
    end
  end

  describe "#created_at" do
    it "returns a Time when created_at is set" do
      task = CloudConvert::Task.new(created_at: "Mon Jul 16 12:59:01 +0000 2020")
      expect(task.created_at).to be_a Time
      expect(task.created_at).to be_utc
    end
    it "returns nil when created_at is not set" do
      task = CloudConvert::Task.new()
      expect(task.created_at).to be_nil
    end
  end

  describe "#created?" do
    it "returns true when created_at is set" do
      task = CloudConvert::Task.new(created_at: "Mon Jul 16 12:59:01 +0000 2020")
      expect(task.created?).to be true
    end
    it "returns false when created_at is not set" do
      task = CloudConvert::Task.new()
      expect(task.created?).to be false
    end
  end

  describe "#started_at" do
    it "returns a Time when started_at is set" do
      task = CloudConvert::Task.new(started_at: "Mon Jul 16 12:59:01 +0000 2020")
      expect(task.started_at).to be_a Time
      expect(task.started_at).to be_utc
    end
    it "returns nil when started_at is not set" do
      task = CloudConvert::Task.new()
      expect(task.started_at).to be_nil
    end
  end

  describe "#started?" do
    it "returns true when started_at is set" do
      task = CloudConvert::Task.new(started_at: "Mon Jul 16 12:59:01 +0000 2020")
      expect(task.started?).to be true
    end
    it "returns false when started_at is not set" do
      task = CloudConvert::Task.new()
      expect(task.started?).to be false
    end
  end

  describe "#ended_at" do
    it "returns a Time when ended_at is set" do
      task = CloudConvert::Task.new(ended_at: "Mon Jul 16 12:59:01 +0000 2020")
      expect(task.ended_at).to be_a Time
      expect(task.ended_at).to be_utc
    end
    it "returns nil when ended_at is not set" do
      task = CloudConvert::Task.new()
      expect(task.ended_at).to be_nil
    end
  end

  describe "#ended?" do
    it "returns true when ended_at is set" do
      task = CloudConvert::Task.new(ended_at: "Mon Jul 16 12:59:01 +0000 2020")
      expect(task.ended?).to be true
    end
    it "returns false when ended_at is not set" do
      task = CloudConvert::Task.new()
      expect(task.ended?).to be false
    end
  end
end
