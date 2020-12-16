describe CloudConvert::Collection, unit: true do
  let(:collection) do
    CloudConvert::Collection.new [import_task, export_task]
  end

  let(:import_task) do
    CloudConvert::Task.new(name: "import/url", status: :finished)
  end

  let(:export_task) do
    CloudConvert::Task.new(name: "export/url", status: :finished)
  end

  describe "#where" do
    it "should filter results" do
      expect(collection.where(name: "import/url").first).to be import_task
      expect(collection.where(name: "import/url").count).to be 1
      expect(collection.where(name: "export/url").first).to be export_task
      expect(collection.where(name: "export/url").count).to be 1
      expect(collection.where(name: "import/url", status: :finished).first).to be import_task
      expect(collection.where(name: "import/url", status: :finished).count).to be 1
      expect(collection.where(name: "export/url", status: :finished).first).to be export_task
      expect(collection.where(name: "export/url", status: :finished).count).to be 1
      expect(collection.where(name: "import/url", status: :waiting).first).to be nil
      expect(collection.where(name: "import/url", status: :waiting).count).to be 0
      expect(collection.where(name: "export/url", status: :waiting).first).to be nil
      expect(collection.where(name: "export/url", status: :waiting).count).to be 0
    end
  end
end
