describe CloudConvert::Webhook do
  payload = fixture("requests/webhook_job_finished_payload.json").read
  signature = "576b653f726c85265a389532988f483b5c7d7d5f40cede5f5ddf9c3f02934f35"
  invalid_signature = SecureRandom.alphanumeric(64)
  secret = "secret"

  describe ".verify" do
    it "should return true when signature is valid" do
      expect(CloudConvert::Webhook.verify(payload, signature, secret)).to be true
    end

    it "should return false when signature is invalid" do
      expect(CloudConvert::Webhook.verify(payload, invalid_signature, secret)).to be false
    end
  end

  describe ".verify!" do
    it "should return true when signature is valid" do
      expect(CloudConvert::Webhook.verify!(payload, signature, secret)).to be true
    end

    it "should raise error when signature is invalid" do
      expect { CloudConvert::Webhook.verify!(payload, invalid_signature, secret) }.to raise_error CloudConvert::Webhook::InvalidSignature
    end
  end

  describe ".verify_request" do
    it "should return true when signature is valid" do
      request = Rack::Request.new("rack.input" => StringIO.new(payload), "HTTP_CLOUDCONVERT_SIGNATURE" => signature)
      expect(CloudConvert::Webhook.verify_request(request, secret)).to be true
    end

    it "should return false when signature is invalid" do
      request = Rack::Request.new("rack.input" => StringIO.new(payload), "HTTP_CLOUDCONVERT_SIGNATURE" => invalid_signature)
      expect(CloudConvert::Webhook.verify_request(request, secret)).to be false
    end

    it "should return false when signature is invalid" do
      request = Rack::Request.new("rack.input" => StringIO.new(payload))
      expect(CloudConvert::Webhook.verify_request(request, secret)).to be false
    end
  end

  describe ".verify_request!" do
    it "should return true when signature is valid" do
      request = Rack::Request.new("rack.input" => StringIO.new(payload), "HTTP_CLOUDCONVERT_SIGNATURE" => signature)
      expect(CloudConvert::Webhook.verify_request!(request, secret)).to be true
    end

    it "should raise error when signature is invalid" do
      request = Rack::Request.new("rack.input" => StringIO.new(payload), "HTTP_CLOUDCONVERT_SIGNATURE" => invalid_signature)
      expect { CloudConvert::Webhook.verify_request!(request, secret) }.to raise_error CloudConvert::Webhook::InvalidSignature
    end

    it "should raise error when signature is missing" do
      request = Rack::Request.new("rack.input" => StringIO.new(payload))
      expect { CloudConvert::Webhook.verify_request!(request, secret) }.to raise_error CloudConvert::Webhook::MissingSignature
    end
  end
end
