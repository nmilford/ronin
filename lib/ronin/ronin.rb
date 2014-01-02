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
require 'ronin/artifact_runner'
require 'ronin/run_list'
require 'ronin/config'
require 'ronin/puppet'
require 'ronin/chef'
require 'ronin/util'
require 'ronin/log'

module Ronin
  def run

    if Ronin::Config[:config_from_etcd] == true
      Ronin::Log.info("Pulling configuration items from etcd (#{Ronin::Config[:etcd_host]}:#{Ronin::Config[:etcd_port]}).")

      Ronin::Etcd.get_config.each do |k, v|
        Ronin::Log.info("Setting #{k} to #{v}.")

        if v.start_with?(':')
          v = v[1..-1].to_sym
        end

        Ronin::Config["#{k}"] = v
      end
    end

    Ronin::Log.level = Ronin::Config[:log_level]

    if Ronin::Util.find_cmd("git").nil?
      abort("You need to have git installed to perform this command.")
    else
      $GIT_BIN = Ronin::Util.find_cmd("git")
    end

    if Ronin::Util.find_cmd("puppet").nil? and Ronin::Config[:interpreter] == 'puppet'
      abort("You need to have Puppet installed to perform this command with Puppet set as the interpreter.")
    else
      $PUPPET_BIN = Ronin::Util.find_cmd("puppet")
    end

    if Ronin::Util.find_cmd("chef-solo").nil? and Ronin::Config[:interpreter] == 'chef'
      abort("You need to have Chef-Solo installed to perform this command with Chef set as the interpreter.")
    else
      $CHEFSOLO_BIN = Ronin::Util.find_cmd("chef-solo")
    end

    unless File.exists?(Ronin::Config[:lock_file])
      Ronin::Log.info("Dropping lock file. (#{Ronin::Config[:lock_file]})")
      File.new(Ronin::Config[:lock_file], "w")

      r = Ronin::ArtifactRunner.new
      changes = r.download_and_report_changes
      r.purge_unused

      if changes
        if Ronin::Config[:interpreter] == 'puppet'
          runner = Ronin::Puppet.new
          runner.run
        elsif Ronin::Config[:interpreter] == 'chef'
          runner = Ronin::Chef.new
          runner.run
        end
      else
        Ronin::Log.info("No changes detected, not running interpretor.")
      end
      Ronin::Log.info("Deleting lock file and exiting. (#{Ronin::Config[:lock_file]})")
      File.delete(Ronin::Config[:lock_file])
    else
      abort("Lock file (#{Ronin::Config[:lock_file]}) exists! Check to see if this Ronin is already running. Exiting.")
    end
  end
  module_function :run
end
