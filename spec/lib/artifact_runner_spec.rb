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
require 'ronin/artifact_runner'

describe Ronin::ArtifactRunner do
  before do
    Ronin::Config[:artifact_path] = '/var/tmp/ronin-rspec'
    Ronin::Config[:run_list_type] = 'yaml'
    Ronin::Config[:run_list_file] = "#{File.expand_path('.')}/conf/artifacts.yaml.sample"

    Dir.mkdir(Ronin::Config[:artifact_path]) if ! Dir.exists?(Ronin::Config[:artifact_path])

    @run_list = Ronin::RunList.new
    @targets  = []

    @run_list.artifacts.each { |a| @targets << "#{Ronin::Config[:artifact_path]}/#{a}" }

    @r = Ronin::ArtifactRunner.new
  end

  # TODO: Add contexts for conditional states

  it ".download_and_report_changes" do
    @r.download_and_report_changes.should == true
    @targets.each do |t|
      Dir.exists?(t).should == true
    end
  end

  it ".purge_unused" do
    @r.download_and_report_changes

    Dir.mkdir("#{Ronin::Config[:artifact_path]}/unused_module")

    @r.purge_unused

    Dir.exists?("#{Ronin::Config[:artifact_path]}/unused_module").should == false
  end

  after do
    FileUtils.rm_rf(Ronin::Config[:artifact_path]) if Dir.exists?(Ronin::Config[:artifact_path])
  end
end
