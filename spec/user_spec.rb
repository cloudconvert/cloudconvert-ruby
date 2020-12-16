describe CloudConvert::User, unit: true do
  describe "#==" do
    it "returns true when objects IDs are the same" do
      user = CloudConvert::User.new(id: 1, username: "foo")
      other = CloudConvert::User.new(id: 1, username: "bar")
      expect(user == other).to be true
    end

    it "returns false when objects IDs are different" do
      user = CloudConvert::User.new(id: 1)
      other = CloudConvert::User.new(id: 2)
      expect(user == other).to be false
    end

    it "returns false when classes are different" do
      user = CloudConvert::User.new(id: 1)
      other = CloudConvert::Task.new(id: 1)
      expect(user == other).to be false
    end
  end

  describe "#username" do
    it "returns value when username is set" do
      user = CloudConvert::User.new(username: "steve")
      expect(user.username).to eq "steve"
    end

    it "returns nil when username is not set" do
      user = CloudConvert::User.new()
      expect(user.username).to be_nil
    end
  end

  describe "#email" do
    it "returns value when email is set" do
      user = CloudConvert::User.new(email: "steve@steve.ly")
      expect(user.email).to eq "steve@steve.ly"
    end

    it "returns nil when email is not set" do
      user = CloudConvert::User.new()
      expect(user.email).to be_nil
    end
  end

  describe "#credits" do
    it "returns value when credits is set" do
      user = CloudConvert::User.new(credits: 1000)
      expect(user.credits).to eq 1000
    end

    it "returns nil when credits is not set" do
      user = CloudConvert::User.new()
      expect(user.credits).to be_nil
    end
  end

  describe "#paying?" do
    it "returns true when paying is true" do
      user = CloudConvert::User.new(paying: true)
      expect(user.paying?).to be true
    end

    it "returns false when paying is false" do
      user = CloudConvert::User.new(paying: false)
      expect(user.paying?).to be false
    end

    it "returns false when paying is not set" do
      user = CloudConvert::User.new()
      expect(user.paying?).to be false
    end
  end

  describe "#links" do
    it "returns struct when links is set" do
      user = CloudConvert::User.new(links: { self: "https://api.cloudconvert.com/v2/users/1" })
      expect(user.links).to eq OpenStruct.new(self: "https://api.cloudconvert.com/v2/users/1")
    end

    it "returns nil when links is not set" do
      user = CloudConvert::User.new()
      expect(user.links).to be_nil
    end
  end

  describe "#created_at" do
    it "returns a Time when created_at is set" do
      user = CloudConvert::User.new(created_at: "Mon Jul 16 12:59:01 +0000 2020")
      expect(user.created_at).to be_a Time
      expect(user.created_at).to be_utc
    end

    it "returns nil when created_at is not set" do
      user = CloudConvert::User.new()
      expect(user.created_at).to be_nil
    end
  end

  describe "#created?" do
    it "returns true when created_at is set" do
      user = CloudConvert::User.new(created_at: "Mon Jul 16 12:59:01 +0000 2020")
      expect(user.created?).to be true
    end

    it "returns false when created_at is not set" do
      user = CloudConvert::User.new()
      expect(user.created?).to be false
    end
  end
end
