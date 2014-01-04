require 'spec_helper'
require 'ronin/etcd'

describe Ronin::Etcd do

  before do
    Ronin::Config[:etcd_host] = '127.0.0.1'
    Ronin::Config[:etcd_port] = 4422
  end

  it ".get_key" do
    Ronin::Etcd.get_key('config', 'common').should == "{\n  \"log_path\": \"common_config\"\n}"
  end

  it ".get_config" do
    Ronin::Etcd.get_config.should == { "log_path"=>"node_config" }
  end

  it ".get_run_list" do
    Ronin::Etcd.get_run_list.should == ["common_artifact", "node_artifact"]
  end

end
