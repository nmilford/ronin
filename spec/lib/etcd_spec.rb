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
require 'ronin/etcd'
require 'ronin/cache'

describe Ronin::Etcd do

  context "etcd is up" do
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

  context "cache_etcd_data == false, etcd is down" do
    before do
      Ronin::Config[:etcd_host] = '127.0.0.1'
      Ronin::Config[:etcd_port] = 4001
      Ronin::Config[:cache_etcd_data] == false
    end

    it ".get_key" do
      begin
        Ronin::Etcd.get_key('config', 'common')
      rescue SystemExit=>e
        expect(e.status).to eq(1)
      end
    end

    it ".get_config" do
      begin
        Ronin::Etcd.get_config
      rescue SystemExit=>e
        expect(e.status).to eq(1)
      end
    end

    it ".get_run_list" do
      begin
        Ronin::Etcd.get_run_list
      rescue SystemExit=>e
        expect(e.status).to eq(1)
      end
    end
  end

  context "cache_etcd_data == true, etcd is down, nothing cached" do
    before do
      Ronin::Config[:etcd_host] = '127.0.0.1'
      Ronin::Config[:etcd_port] = 4001
    end

    it ".get_key" do
      begin
        Ronin::Etcd.get_key('config', 'common')
      rescue SystemExit=>e
        expect(e.status).to eq(1)
      end
    end

    it "..get_config" do
      begin
        Ronin::Etcd.get_config
      rescue SystemExit=>e
        expect(e.status).to eq(1)
      end
    end

    it ".get_run_list" do
      begin
        Ronin::Etcd.get_run_list
      rescue SystemExit=>e
        expect(e.status).to eq(1)
      end
    end
  end

  context "cache_etcd_data == true, etcd is down, data cached" do
    before do
      Ronin::Config[:etcd_host] = '127.0.0.1'
      Ronin::Config[:etcd_port] = 4001
      Ronin::Config[:cache_path] = '/var/tmp/ronin-rspec'
      Dir.mkdir(Ronin::Config[:cache_path]) if ! Dir.exists?(Ronin::Config[:cache_path])
      @config = { "log_path"=>"node_config" }
      @run_list = ["common_artifact", "node_artifact"]

      Ronin::Cache.cache_config(@config)
      Ronin::Cache.cache_run_list(@run_list)
    end

    it ".get_key (good value)" do
      Ronin::Etcd.get_key('config', 'common').should == :down
    end

    it ".get_config" do
      Ronin::Etcd.get_config.should == { "log_path"=>"node_config" }
    end

    it ".get_run_list" do
      Ronin::Etcd.get_run_list.should == ["common_artifact", "node_artifact"]
    end

    after do
      FileUtils.rm_rf(Ronin::Config[:cache_path]) if Dir.exists?(Ronin::Config[:cache_path])
    end
  end

  # TODO: test get_key for bad submitted values

end
