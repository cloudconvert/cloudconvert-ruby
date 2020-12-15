describe CloudConvert do
  it "has api url" do
    expect(CloudConvert::API_URL).to be_a String
  end

  it "has sandbox url" do
    expect(CloudConvert::SANDBOX_URL).to be_a String
  end

  it "has user agent" do
    expect(CloudConvert::USER_AGENT).to be_a String
  end

  it "has version number" do
    expect(CloudConvert::VERSION).to be_a String
  end
end
