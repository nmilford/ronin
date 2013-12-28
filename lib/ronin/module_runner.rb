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
# limitations under the License.require 'ronin/run_list'
require 'ronin/config'
require 'ronin/git'
require 'ronin/log'
require 'fileutils'

module Ronin
  class ModuleRunner
    def initialize
      @changes    = false
      @run_list   = Ronin::RunList.new
    end

    def download_and_report_changes
      @run_list.items.each do |item|
         @actual_branch = Ronin::Git.branch(item[:name])

        if File.exist?("#{Ronin::Config[:module_path]}/#{item[:name]}")
          if item[:branch] != 'master'
            Ronin::Log.info("Module #{item[:name]} is being pulled from the #{item[:branch]} branch and not master.")
          end

          if @actual_branch == item[:branch]
            Ronin::Log.info("Module #{item[:name]} already cached, pulling updates to #{item[:branch]} from #{item[:repo]}.")
            @updated = Ronin::Git.pull_and_report_updated(item[:name])
            if @updated
              Ronin::Log.info("Module #{item[:name]} has updates.")
              @changes = true if Ronin::Config[:update_on_change]
            end
          else
            Ronin::Log.info("Module #{item[:name]} already cached, but is the wrong branch. Deleting cached copy of branch #{@actual_branch}")
            FileUtils.rm_rf("#{Ronin::Config[:module_path]}/#{item[:name]}/")
            Ronin::Git.clone(item[:repo], item[:branch])
            @changes = true if Ronin::Config[:update_on_change]
          end
        else
          Ronin::Log.info("Module #{item[:name]} not cached, cloning branch #{item[:branch]} of #{item[:repo]} to #{Ronin::Config[:module_path]}.")
          Ronin::Git.clone(item)
          @changes = true if Ronin::Config[:update_on_change]
        end
      end
      @changes
    end

    def purge_unused
      @local_modules = Dir.entries(Ronin::Config[:module_path]).select { |dir| File.directory?("#{Ronin::Config[:module_path]}/#{dir}") and !(dir =='.' || dir == '..') }
      @modules = @run_list.modules

      @local_modules.each do |mod|
        unless @modules.include?(mod)
          Ronin::Log.info("No module named #{mod} in run list, but it exists in #{Ronin::Config[:module_path]}. Purging it.")
          FileUtils.rm_rf("#{Ronin::Config[:module_path]}/#{mod}/")
        end
      end
    end
  end
end