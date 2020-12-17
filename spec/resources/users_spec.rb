describe CloudConvert::Resources::Users, :unit do
  let(:cloudconvert) do
    CloudConvert::Client.new(api_key: "test key")
  end

  describe "#me" do
    before do
      stub_get("/v2/users/me").to_return(body: fixture("responses/user.json"), headers: { content_type: "application/json" })
    end

    let!(:user) do
      cloudconvert.users.me
    end

    it "requests the correct resource" do
      expect(a_get("/v2/users/me")).to have_been_made
    end

    it "returns extended information of the user" do
      expect(user).to be_a CloudConvert::User
      expect(user.id).to be 1
      expect(user.username).to eq "Username"
      expect(user.email).to eq "me@example.com"
      expect(user.credits).to be 4434
      expect(user.created_at).to eq Time.parse("2018-12-01T22:26:29+00:00").utc
      expect(user.created?).to be true
      expect(user.links).to eq OpenStruct.new(self: "https://api.cloudconvert.com/v2/users/1")
    end
  end
end
