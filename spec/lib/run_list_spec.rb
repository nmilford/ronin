# Author:: Nathan Milford (<nathan@milford.io>)
# Copyright:: Copyright (c) 2013 Nathan Milford
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
require 'spec_helper'
require 'ronin/run_list'

describe Ronin::RunList do
  context "from file" do
    before do
      Ronin::Config[:run_list_type] = 'yaml'
      Ronin::Config[:run_list_file] = "#{File.expand_path('.')}/conf/artifacts.yaml.sample"
      @run_list = Ronin::RunList.new
    end

    it ".artifacts" do
      @run_list.artifacts.should == ["puppetlabs-ntp", "puppetlabs-git"]
    end

    it ".items" do
      @run_list.items.should == [{ :name=>"puppetlabs-ntp", :repo=>"https://github.com/puppetlabs/puppetlabs-ntp", :branch=>"master" }, { :name=>"puppetlabs-git", :repo=>"https://github.com/puppetlabs/puppetlabs-git", :branch=>"master" }]
    end
  end

  context "from etcd" do
    before do
      Ronin::Config[:run_list_type] = 'etcd'
      Ronin::Config[:etcd_host] = '127.0.0.1'
      Ronin::Config[:etcd_port] = 4422
      @run_list = Ronin::RunList.new
    end

    it ".artifacts" do
      @run_list.artifacts.should == ["common_artifact", "node_artifact"]
    end

    it ".items" do
      @run_list.items.should == [{ :name=>"common_artifact", :repo=>"common_artifact", :branch=>"master" }, { :name=>"node_artifact", :repo=>"node_artifact", :branch=>"master" }]
    end
  end
end
