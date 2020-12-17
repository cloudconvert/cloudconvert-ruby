require "integration_helper"

describe CloudConvert::Resources::Users, :integration, :vcr do
  let(:cloudconvert) do
    CloudConvert::Client.new({
      api_key: CLOUDCONVERT_API_KEY,
      sandbox: true,
    })
  end

  let(:user) do
    cloudconvert.users.me
  end

  it "performs user query" do
    expect(user).to be_a CloudConvert::User
  end
end
