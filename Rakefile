require "bundler/gem_tasks"

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)

namespace :spec do
  RSpec::Core::RakeTask.new(:integration) do |t|
    t.rspec_opts = "--tag integration"
  end

  RSpec::Core::RakeTask.new(:sandbox) do |t|
    ENV["VCR"] = "off"
  end

  RSpec::Core::RakeTask.new(:unit) do |t|
    t.rspec_opts = "--tag unit"
  end

  RSpec::Core::RakeTask.new(:vcr)
end

require "rubocop/rake_task"
RuboCop::RakeTask.new

task default: %i[spec rubocop]
