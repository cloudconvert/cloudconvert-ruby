describe CloudConvert::Entity, :unit do
  describe ".result" do
    it "should build an entity" do
      entity = CloudConvert::Entity.result(OpenStruct.new(data: { id: 123 }))
      expect(entity).to be_a CloudConvert::Entity
      expect(entity.id).to be 123
    end

    it "should build a collection of entities" do
      collection = CloudConvert::Entity.collection(OpenStruct.new(data: [{ id: 123 }, { id: 456 }]))
      expect(collection).to be_a CloudConvert::Collection
      expect(collection[0]).to be_a CloudConvert::Entity
      expect(collection[0].id).to be 123
      expect(collection[1]).to be_a CloudConvert::Entity
      expect(collection[1].id).to be 456
      expect(collection.count).to be 2
    end
  end
end
