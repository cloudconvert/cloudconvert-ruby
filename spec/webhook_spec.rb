describe CloudConvert::Webhook do
  subject do
    CloudConvert::Webhook
  end

  payload = fixture("requests/webhook_job_finished_payload.json").read
  signature = "576b653f726c85265a389532988f483b5c7d7d5f40cede5f5ddf9c3f02934f35"
  invalid_signature = SecureRandom.alphanumeric(64)
  secret = "secret"

  describe ".verify" do
    it "should return true when signature is valid" do
      expect(subject.verify(payload, signature, secret)).to be true
    end

    it "should raise error when signature is invalid" do
      expect { subject.verify(payload, invalid_signature, secret) }.to raise_error CloudConvert::Webhook::InvalidSignature
    end
  end

  describe ".verify_request" do
    it "should return true when signature is valid" do
      request = Rack::Request.new("rack.input" => payload, CloudConvert::SIGNATURE => signature)
      expect(subject.verify_request(request, secret)).to be true
    end

    it "should raise error when signature is invalid" do
      request = Rack::Request.new("rack.input" => payload, CloudConvert::SIGNATURE => invalid_signature)
      expect { subject.verify_request(request, secret) }.to raise_error CloudConvert::Webhook::InvalidSignature
    end

    it "should raise error when signature is missing" do
      request = Rack::Request.new('rack.input': payload)
      expect { subject.verify_request(request, secret) }.to raise_error CloudConvert::Webhook::MissingSignature
    end
  end

  describe ".valid?" do
    it "should return true when signature is valid" do
      expect(subject.valid?(payload, signature, secret)).to be true
    end

    it "should return false when signature is invalid" do
      expect(subject.valid?(payload, invalid_signature, secret)).to be false
    end
  end
end
