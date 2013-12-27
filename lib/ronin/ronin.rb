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
require 'ronin/module_runner'
require 'ronin/run_list'
require 'ronin/config'

module Ronin
  def run

    raise 'Must run as root' unless Process.uid == 0

    Ronin::Log.level = Ronin::Config[:log_level]

    @r = Ronin::ModuleRunner.new
    @changes = @r.download_and_report_changes
    @r.purge_unused

    if @changes
      if Ronin::Config[:interpreter] = :puppet
        Ronin::Puppet.run
      elsif Ronin::Config[:interpreter] = :chef
        Ronin::Chef.run
      end
    end
  end
  module_function :run
end
