require 'spec_helper'

describe BuildPart do
  let(:queue) { :master }
  let(:build) {Build.build_sha!(:sha => "abcdef", :queue => queue) }
  let(:build_part) { BuildPart.create!(:build => build, :paths => ["a", "b"], :kind => "test") }

  describe "when created" do
    it "enqueues a build part job" do
      BuildPartJob.should_receive(:enqueue_on).with(queue, anything)
      build_part.should be_present
    end
    it "creates a runnable build part result" do
      build_part.build_part_results.should be_present
      build_part.build_part_results.first.state.should == :runnable
    end
  end
end