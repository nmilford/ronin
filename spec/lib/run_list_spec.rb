#require 'spec_helper'
#require 'ronin/run_list'

#describe Ronin::RunList do
#  context "from file" do
#      let(:burger) { Burger.new(:ketchup => true) }
#      before  { burger.apply_ketchup }
#
#      it "sets the ketchup flag to true" do
#        burger.has_ketchup_on_it?.should be_true
#      end
#    end
#  before do
#    Ronin::Config[:etcd_host] = '127.0.0.1'
#    Ronin::Config[:etcd_port] = 4422
#  end

#  it ".find_cmd" do
#    Ronin::Util.find_cmd('ruby').should == `which ruby`.chomp
#  end
#end
