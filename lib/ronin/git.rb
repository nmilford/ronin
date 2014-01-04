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
require "mixlib/shellout"
require 'ronin/config'
require 'ronin/util'

module Ronin
  module Git
    def branch(artifact)
      @cmd = Mixlib::ShellOut.new("#{Ronin::Util.find_cmd("git")} --git-dir=#{Ronin::Config[:artifact_path]}/#{artifact}/.git --work-tree=#{Ronin::Config[:artifact_path]}/#{artifact}/ branch")
      @cmd.run_command
      @branch = @cmd.stdout.chomp.split(' ')[1]
      @branch
    end
    module_function :branch

    def pull_and_report_updated(artifact)
      @cmd = Mixlib::ShellOut.new("#{Ronin::Util.find_cmd("git")} --git-dir=#{Ronin::Config[:artifact_path]}/#{artifact}/.git --work-tree=#{Ronin::Config[:artifact_path]}/#{artifact}/ pull")
      @cmd.run_command
      @updated = @cmd.stdout.include?("Updating")
      @updated ? true : false
    end
    module_function :pull_and_report_updated

    def clone(artifact_data)
      @cmd = Mixlib::ShellOut.new("#{Ronin::Util.find_cmd("git")}  clone #{artifact_data[:repo]} #{Ronin::Config[:artifact_path]}/#{artifact_data[:name]}/ -b #{artifact_data[:branch]}")
      @cmd.run_command
      @cmd.stdout
    end
    module_function :clone
  end
end
