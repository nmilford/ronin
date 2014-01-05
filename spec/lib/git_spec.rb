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
require 'ronin/git'

describe Ronin::Git do

  before do
    Ronin::Config[:artifact_path] = '/var/tmp/ronin-rspec'

    Dir.mkdir(Ronin::Config[:artifact_path]) if ! Dir.exists?(Ronin::Config[:artifact_path])

    @item     = { :name=>"ntp", :repo=>"https://github.com/opscode-cookbooks/ntp", :branch=>"master" }
    @target   = "#{Ronin::Config[:artifact_path]}/#{@item[:name]}"
  end

  it ".clone" do
    Ronin::Git.clone(@item)
    Dir.exists?(@target).should == true
  end

  it ".branch" do
    Ronin::Git.clone(@item)
    Ronin::Git.branch(@item[:name]).should == 'master'
  end

  it ".pull_and_report_updated" do
    Ronin::Git.clone(@item)
    Ronin::Git.pull_and_report_updated(@item[:name]).should == false
  end

  after do
    FileUtils.rm_rf(Ronin::Config[:artifact_path]) if Dir.exists?(Ronin::Config[:artifact_path])
  end

end
