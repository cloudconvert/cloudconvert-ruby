describe CloudConvert::SignedUrl, :unit do
  payload = fixture("requests/webhook_job_finished_payload.json").read
  signature = "576b653f726c85265a389532988f483b5c7d7d5f40cede5f5ddf9c3f02934f35"
  invalid_signature = SecureRandom.alphanumeric(64)
  secret = "secret"

  describe ".sign" do
    it "should return a signed url" do

      job = {
        tasks: {
          "import-it": { operation: "import/url", filename: "test.file", url: "http://invalid.url" },
          "convert-it": { input: "import-it", operation: "convert", output_format: "pdf" },
        }
      }

      base = "https://s.cloudconvert.com/b3d85428-584e-4639-bc11-76b7dee9c109"
      signing_secret = "NT8dpJkttEyfSk3qlRgUJtvTkx64vhyX"
      cache_key = "mykey"

      url = CloudConvert::SignedUrl.sign(base, signing_secret, job, cache_key)

      print url

      expect(url).to start_with base
      expect(url).to include "?job="
      expect(url).to include "&cache_key=mykey"
      expect(url).to include "&s=3fb529168264bccea28ba9a1d02f2a4662d1917029829ee77e753a7748b98904"

    end

  end
end
