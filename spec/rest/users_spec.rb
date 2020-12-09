require "spec_helper"

describe CloudConvert::REST::Users do
  before do
    @client = CloudConvert::Client.new(api_key: "test key")
  end

  describe "#user" do
    before do
      stub_get("/users/me").to_return(body: fixture("responses/user.json"), headers: { content_type: "application/json" })
    end

    subject! do
      @client.user
    end

    it "requests the correct resource" do
      expect(a_get("/users/me")).to have_been_made
    end

    it "returns extended information of a given user" do
      expect(subject).to be_a CloudConvert::User
      expect(subject.id).to be 1
      expect(subject.username).to eq "Username"
      expect(subject.email).to eq "me@example.com"
      expect(subject.credits).to be 4434
      expect(subject.created_at).to eq Time.parse("2018-12-01T22:26:29+00:00").utc
      expect(subject.created?).to be true
      expect(subject.links).to eq OpenStruct.new(self: "https://api.cloudconvert.com/v2/users/1")
    end
  end
end
