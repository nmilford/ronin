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
require 'ronin/run_list'
require 'ronin/util'
require 'ronin/git'
require 'ronin/log'
require 'fileutils'
require 'parallel'

module Ronin
  class ArtifactRunner
    def initialize
      @changes    = false
      @run_list   = Ronin::RunList.new
    end

    def download_and_report_changes
      @items = @run_list.items
      Parallel.each(@items, :in_threads => Ronin::Util.num_cores) do |item|
        @actual_branch = Ronin::Git.branch(item[:name])

        if File.exist?("#{Ronin::Config[:artifact_path]}/#{item[:name]}")
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
            FileUtils.rm_rf("#{Ronin::Config[:artifact_path]}/#{item[:name]}/")
            Ronin::Git.clone(item)
            @changes = true if Ronin::Config[:update_on_change]
          end
        else
          Ronin::Log.info("Module #{item[:name]} not cached, cloning branch #{item[:branch]} of #{item[:repo]} to #{Ronin::Config[:artifact_path]}.")
          Ronin::Git.clone(item)
          @changes = true if Ronin::Config[:update_on_change]
        end
      end
      @changes
    end

    def purge_unused
      @local_artifacts = Dir.entries(Ronin::Config[:artifact_path]).select { |dir| File.directory?("#{Ronin::Config[:artifact_path]}/#{dir}") and !(dir =='.' || dir == '..') }
      @artifacts = @run_list.artifacts

      @local_artifacts.each do |a|
        unless @artifacts.include?(a)
          Ronin::Log.info("No module named #{a} in run list, but it exists in #{Ronin::Config[:artifact_path]}. Purging it.")
          FileUtils.rm_rf("#{Ronin::Config[:artifact_path]}/#{a}/")
        end
      end
    end
  end
end
