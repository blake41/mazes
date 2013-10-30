require_relative '../maze.rb'

RSpec.configure do |config|
  config.mock_framework = :mocha
end

describe MyQueue do

  it "<<" do
    queue = MyQueue.new
    o = Object.new
    queue << o
    queue.first.should eq(o)
  end

  it "shift" do
    queue = MyQueue.new
    o = Object.new
    queue << o
    queue.shift.should eq(o)
    queue.first.should be_nil
  end

  context "empty queue" do
    it "empty?" do
      queue = MyQueue.new
      queue.empty?.should be_true
    end

    it "present?" do
      queue = MyQueue.new
      queue.present?.should be_false
    end
  end

  context "full queue" do
    it "empty?" do
      queue = MyQueue.new
      o = Object.new
      queue << o
      queue.empty?.should be_false
    end

    it "present?" do
      queue = MyQueue.new
      o = Object.new
      queue << o
      queue.present?.should be_true
    end
  end
  
  it "print" do
    queue = MyQueue.new
    sqr = mock('object')
    sqr.stubs(:x => 0, :y => 0)
    sqr2 = mock('object')
    sqr2.stubs(:x => 1, :y => 1)
    queue << sqr << sqr2
    Kernel.expects(:puts).with("(0,0), (1,1)")
    queue.print
  end

end