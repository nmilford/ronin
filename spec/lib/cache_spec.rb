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
require 'ronin/cache'

describe Ronin::Cache do
  before do
    Ronin::Config[:cache_path] = '/var/tmp/ronin-rspec'
    Dir.mkdir(Ronin::Config[:cache_path]) if ! Dir.exists?(Ronin::Config[:cache_path])
    @config = { "log_path"=>"node_config" }
    @run_list = ["common_artifact", "node_artifact"]
  end

  it ".cache_config" do
    Ronin::Cache.cache_config(@config)
    File.exists?("#{Ronin::Config[:cache_path]}/config.json").should == true
  end

  it ".cache_run_list" do
    Ronin::Cache.cache_run_list(@run_list)
    File.exists?("#{Ronin::Config[:cache_path]}/run_list.json").should == true
  end


  context "with existing cache" do

    it ".load_cached_config" do
      Ronin::Cache.cache_config(@config)
      Ronin::Cache.load_cached_config.should == @config
    end

    it ".load_cached_run_list" do
      Ronin::Cache.cache_run_list(@run_list)
      Ronin::Cache.load_cached_run_list.should == @run_list
    end

  end

  context "without existing cache" do

    it ".load_cached_config" do
      begin
        Ronin::Cache.load_cached_config
      rescue SystemExit=>e
        expect(e.status).to eq(1)
      end
    end

    it ".load_cached_run_list" do
      begin
        Ronin::Cache.load_cached_run_list
      rescue SystemExit=>e
        expect(e.status).to eq(1)
      end
    end

  end

  after do
    FileUtils.rm_rf(Ronin::Config[:cache_path]) if Dir.exists?(Ronin::Config[:cache_path])
  end
end
