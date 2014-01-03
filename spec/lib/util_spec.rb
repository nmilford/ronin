require 'spec_helper'
require 'ronin/util'

describe Ronin::Util do
  it ".find_cmd" do
    Ronin::Util.find_cmd('ruby').should == `which ruby`.chomp
  end

  it ".num_cores" do
    Ronin::Util.num_cores.should == `cat /proc/cpuinfo | grep processor | wc -l`.to_i
  end
end
