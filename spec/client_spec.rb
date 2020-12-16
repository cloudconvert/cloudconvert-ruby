describe CloudConvert::Client do
  API_KEY_ATTR = "api key from attrs"
  API_KEY_ENV = "api key from env"

  subject do
    CloudConvert::Client.new(api_key: API_KEY_ATTR)
  end

  describe ".new" do
    it "reads the api key out of attrs" do
      expect(subject.api_key).to eq API_KEY_ATTR
    end

    it "reads the api key out of the env variable" do
      with_env CLOUDCONVERT_API_KEY: API_KEY_ENV do
        expect(CloudConvert::Client.new.api_key).to eq API_KEY_ENV
      end
    end

    it "prefers the api key out of attrs" do
      with_env CLOUDCONVERT_API_KEY: API_KEY_ENV do
        expect(subject.api_key).to eq API_KEY_ATTR
      end
    end

    it "raises an error when no api key is supplied" do
      expect { CloudConvert::Client.new }.to raise_error(Schemacop::Exceptions::ValidationError)
    end

    it "reads the sandbox bool out of attrs" do
      expect(CloudConvert::Client.new(api_key: API_KEY_ATTR, sandbox: true).sandbox).to be true
    end

    it "reads the sandbox bool out of the env variable" do
      with_env CLOUDCONVERT_SANDBOX: "true" do
        expect(subject.sandbox).to eq true
      end

      with_env CLOUDCONVERT_SANDBOX: "TRUE" do
        expect(subject.sandbox).to eq true
      end
    end

    it "prefers the sandbox bool out of attrs" do
      with_env CLOUDCONVERT_SANDBOX: "false" do
        expect(CloudConvert::Client.new(api_key: API_KEY_ATTR, sandbox: true).sandbox).to be true
      end

      with_env CLOUDCONVERT_SANDBOX: "FALSE" do
        expect(CloudConvert::Client.new(api_key: API_KEY_ATTR, sandbox: true).sandbox).to be true
      end
    end

    it "defaults to false when no sandbox bool is supplied" do
      expect(subject.sandbox).to be false
    end
  end

  describe "#download" do
    it "downloads the file and returns a tempfile" do
      stub_request(:get, "https://storage.cloudconvert.com/file.mp4").to_return(body: "video content")
      expect(subject.download("https://storage.cloudconvert.com/file.mp4")).to be_a Tempfile
    end
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
