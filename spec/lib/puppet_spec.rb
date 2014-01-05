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
require 'ronin/puppet'

describe Ronin::Puppet do

  before do
    Ronin::Config[:artifact_path] = '/var/tmp/ronin-rspec'
    Ronin::Config[:run_list_type] = 'yaml'
    Ronin::Config[:run_list_file] = "#{File.expand_path('.')}/conf/artifacts.yaml.sample"

    Dir.mkdir(Ronin::Config[:artifact_path]) if ! Dir.exists?(Ronin::Config[:artifact_path])

    @run_list = "#{Ronin::Config[:artifact_path]}/ronin.pp"
    @p = Ronin::Puppet.new
  end

  it ".create_run_list" do
    @p.create_run_list.should == ["puppetlabs-ntp", "puppetlabs-git"]
    File.read(@run_list).should match "include puppetlabs-ntp\ninclude puppetlabs-git\n"
  end

  it ".clean_up" do
    @p.create_run_list
    @p.clean_up
    File.exist?(@run_list).should == false
  end

  #it ".run" do
  #end

  after do
    FileUtils.rm_rf(Ronin::Config[:artifact_path]) if Dir.exists?(Ronin::Config[:artifact_path])
  end

end
