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
require 'ronin/run_list'
require 'ronin/config'
require 'ronin/log'
require 'json'

module Ronin
  class Chef

    def initialize
      @run_list  = "#{Ronin::Config[:artifact_path]}/ronin.json"
      @solo_conf = "#{Ronin::Config[:artifact_path]}/ronin-chef-solo.rb"
      @recipes   = Ronin::RunList.new.artifacts
    end

    def create_run_list
      Ronin::Log.info("Building Chef run list at #{@run_list}.")
      @rl = []
      @rl_obj = {}
      @recipes.each do |r|
        @rl << "recipe[#{r}]"
        Ronin::Log.info("Adding recipe '#{r}' to run list.")
      end

      @rl_obj['run_list'] = @rl

      File.open(@run_list, "w") do |f|
        f.write(@rl_obj.to_json)
      end
    end

    def run
      self.create_run_list
      self.create_solo_conf
      Ronin::Log.info("Running Chef, logging to #{Ronin::Config[:log_path]}/ronin-chef.log.")
      @cmd = Mixlib::ShellOut.new("#{Ronin::Util.find_cmd("chef-solo")}  --logfile #{Ronin::Config[:log_path]}/ronin-chef.log --config #{@solo_conf} --json-attributes #{@run_list}")
      @cmd.run_command
      self.clean_up
    end

    def create_solo_conf
      @solo_config = "file_cache_path '/var/tmp/ronin/chef-solo'\ncookbook_path '#{Ronin::Config[:artifact_path]}'\n"

      File.open(@solo_conf, "w") do |f|
        f.write(@solo_config)
      end
    end

    def clean_up
      Ronin::Log.info("Cleaning up Chef run list at #{@run_list}.")
      File.delete(@run_list)

      Ronin::Log.info("Cleaning up Chef-Solo config at #{@solo_conf}.")
      File.delete(@solo_conf)
    end

  end
end
