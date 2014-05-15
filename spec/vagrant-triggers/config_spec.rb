require "spec_helper"

describe VagrantPlugins::Triggers::Config do
  let(:config)  { described_class.new }
  let(:machine) { double("machine") }

  describe "defaults" do
    subject do
      config.tap do |o|
        o.finalize!
      end
    end

    its("triggers") { should eq [] }
  end

  describe "add triggers" do
    it "should add before triggers" do
      config.before(:up) { run "ls" }
      expect(config.triggers).to have(1).item
    end

    it "should add after triggers" do
      config.after(:up) { run "ls" }
      expect(config.triggers).to have(1).item
    end
  end

  describe "accept multiple entries" do
    it "should record multiple entries" do
      config.before(:up) { run "ls" }
      config.after(:up) { run "ls" }
      expect(config.triggers).to have(2).items
    end

    it "should record multiple entries if the action is an array" do
      config.before([:up, :halt]) { run "ls" }
      expect(config.triggers).to have(2).items
    end
  end

  describe "validation" do
    it "should validate" do
      config.finalize!
      expect(config.validate(machine)["triggers"]).to have(:no).items
    end

    it "shouldn't accept invalid methods" do
      config.foo "bar"
      expect(config.validate(machine)["triggers"]).to have(1).item
    end
  end
end
