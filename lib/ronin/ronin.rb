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
$LOAD_PATH << "."
require 'ronin/artifact_runner'
require 'ronin/run_list'
require 'ronin/config'
require 'ronin/util'

module Ronin
  def run

    Ronin::Log.level = Ronin::Config[:log_level]

    if Ronin::Util.find_cmd("git").nil?
      puts 'You need to have git installed to perform this command.'
      exit 1
    else
      $GIT_BIN = Ronin::Util.find_cmd("git")
    end

    if Ronin::Util.find_cmd("puppet").nil? and Ronin::Config[:interpreter] == :puppet
      puts 'You need to have Puppet installed to perform this command with Puppet set as the interpreter.'
      exit 1
    else
       $PUPPET_BIN = Ronin::Util.find_cmd("puppet")
    end

    if Ronin::Util.find_cmd("chef-solo").nil? and Ronin::Config[:interpreter] == :puppet
      puts 'You need to have Chef-Solo installed to perform this command with Chef set as the interpreter.'
      exit 1
    else
       $CHEFSOLO_BIN = Ronin::Util.find_cmd("puppet")
    end

    @r = Ronin::ArtifactRunner.new
    @changes = @r.download_and_report_changes
    @r.purge_unused

    if @changes
      if Ronin::Config[:interpreter] == :puppet
        Ronin::Puppet.run
      elsif Ronin::Config[:interpreter] == :chef
        Ronin::Chef.run
      end
    end
  end
  module_function :run
end
