#require 'spec_helper'
#require 'ronin/run_list'

#describe Ronin::RunList do

#  before do
#    Ronin::Config[:etcd_host] = '127.0.0.1'
#    Ronin::Config[:etcd_port] = 4422
#  end

#  it ".find_cmd" do
#    Ronin::Util.find_cmd('ruby').should == `which ruby`.chomp
#  end
#end
