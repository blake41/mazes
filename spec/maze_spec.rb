require_relative '../maze.rb'
describe Queue do

  it "<<" do
    queue = Queue.new
    o = Object.new
    queue << o
    queue.first.should eq(o)
  end

end