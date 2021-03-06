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
require 'ronin/config'
require 'mixlib/log'

module Ronin
  class Log
    extend Mixlib::Log

    self.level = Ronin::Config[:log_level]

    if Ronin::Config[:log_path] == 'STDOUT'
      init(STDOUT)
    else
      init("#{Ronin::Config[:log_path]}/ronin.log")
    end

  end
end
