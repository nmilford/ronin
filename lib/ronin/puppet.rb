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

module Ronin
  module Puppet

    @run_list = "#{Ronin::Config[:module_path]}/ronin.pp"
    @modules = Ronin::RunList.new.modules

    def create_run_list
      Ronin::Log.info("Building Puppet run list at #{@run_list}.")
      File.open(@run_list, "w") do |f|
        @modules.each do |mod|
          Ronin::Log.info("Adding module '#{mod}' to run list.")
          f.write "include #{mod}\n"
        end
      end
    end
    module_function :create_run_list

    def run
      self.create_run_list
      Ronin::Log.info("Running Puppet, logging puppet output to #{Ronin::Config[:log_path]}/ronin-puppet.log.")
      @cmd = Mixlib::ShellOut.new("puppet apply --verbose --ordering manifest --logdest #{Ronin::Config[:log_path]}/ronin-puppet.log --modulepath #{Ronin::Config[:module_path]} #{@run_list}")
      @cmd.run_command
      self.clean_up
    end
    module_function :run

    def clean_up
      Ronin::Log.info("Cleaning up Puppet run list at #{@run_list}.")
      File.delete(@run_list)
    end
    module_function :clean_up
  end
end