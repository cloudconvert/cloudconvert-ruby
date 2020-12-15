describe CloudConvert::Client do
  subject do
    CloudConvert::Client.new(api_key: "test key")
  end

  describe "#jobs" do
    it "returns jobs resource" do
      expect(subject.jobs).to be_a CloudConvert::Resources::Jobs
    end
  end

  describe "#tasks" do
    it "returns tasks resource" do
      expect(subject.tasks).to be_a CloudConvert::Resources::Tasks
    end
  end

  describe "#users" do
    it "returns users resource" do
      expect(subject.users).to be_a CloudConvert::Resources::Users
    end
  end
end
