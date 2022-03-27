describe CloudConvert::Webhook::Processor, :unit do
  class ControllerWithoutSecret
    attr_reader :request, :result

    def self.before_action(*args); end
    def self.skip_before_action(*args); end

    include CloudConvert::Webhook::Processor

    def initialize(request)
      @request = request
    end

    private

    def head(status)
      status
    end

    def name
      self.class.name
    end
  end

  class ControllerWithoutMethod < ControllerWithoutSecret
    private

    def webhook_secret(event)
      "secret"
    end
  end

  class Controller < ControllerWithoutSecret
    def job_finished(event)
      @result = event.job
    end

    private

    def webhook_secret(event)
      "secret"
    end
  end

  let(:controller) { Controller.new(request) }

  let(:payload) { fixture("requests/webhook_job_finished_payload.json").read }

  let(:request) do
    Rack::Request.new({
      "rack.input" => StringIO.new(payload),
      "HTTP_CLOUDCONVERT_SIGNATURE" => signature,
    })
  end

  let(:signature) { "576b653f726c85265a389532988f483b5c7d7d5f40cede5f5ddf9c3f02934f35" }

  describe "#create" do
    context "when signature is valid" do
      it "calls the #job_finished method in controller" do
        expect(controller).to(receive(:job_finished)).and_call_original
        expect(controller.send(:authenticate_cloudconvert_request!)).to be nil
        expect(controller.create).to be :ok
        expect(controller.result).to be_a CloudConvert::Job
        expect(controller.result.id).to eq "c677ccf7-8876-4f48-bb96-0ab8e0d88cd7"
        expect(controller.result.status).to eq :finished
      end
    end

    context "when signature is invalid" do
      let(:signature) { SecureRandom.alphanumeric(64) }

      it "responds with a bad request" do
        expect(controller).not_to receive(:job_finished)
        expect(controller.send(:authenticate_cloudconvert_request!)).to be :bad_request
      end
    end

    context "event method is not implemented" do
      let(:controller) { ControllerWithoutMethod.new(request) }

      it "raises an error" do
        expect { controller.create }.to raise_error(NoMethodError)
      end
    end

    context "when #webhook_secret is not defined" do
      let(:controller) { ControllerWithoutSecret.new(request) }

      it "raises an error" do
        expect { controller.send(:authenticate_cloudconvert_request!) }.to raise_error CloudConvert::Webhook::Processor::UnspecifiedSecret
      end
    end
  end
end
