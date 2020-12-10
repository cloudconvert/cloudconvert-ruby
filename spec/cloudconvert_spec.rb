RSpec.describe CloudConvert do
  it "has api url" do
    expect(CloudConvert::API_URL).not_to be_nil
  end

  it "has sandbox url" do
    expect(CloudConvert::SANDBOX_URL).not_to be_nil
  end

  it "has version number" do
    expect(CloudConvert::VERSION).not_to be_nil
  end
end
