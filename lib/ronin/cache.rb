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
require 'ronin/log'
require 'json'

module Ronin
  module Cache

    def cache_config(config)
      Ronin::Log.info("Caching configuration items from etcd (#{Ronin::Config[:etcd_host]}:#{Ronin::Config[:etcd_port]}) to #{Ronin::Config[:cache_path]}/config.json.")

      File.open("#{Ronin::Config[:cache_path]}/config.json", "w") do |f|
        f.write(config.to_json)
      end
    end
    module_function :cache_config

    def load_cached_config
      if File.exist?("#{Ronin::Config[:cache_path]}/config.json")
        Ronin::Log.info("Loading cached configuration items from #{Ronin::Config[:cache_path]}/config.json.")
        @config = JSON.parse(IO.read("#{Ronin::Config[:cache_path]}/config.json"))
        return @config
      else
        abort("Connection refused by etcd host #{Ronin::Config[:etcd_host]}:#{Ronin::Config[:etcd_port]}, and no cached config found at (#{Ronin::Config[:cache_path]}/config.json)")
      end
    end
    module_function :load_cached_config

    def cache_run_list(run_list)
      Ronin::Log.info("Caching run_list from etcd (#{Ronin::Config[:etcd_host]}:#{Ronin::Config[:etcd_port]}) to #{Ronin::Config[:cache_path]}/run_list.json.")
      File.open("#{Ronin::Config[:cache_path]}/run_list.json", "w") do |f|
        f.write(run_list.to_json)
      end
    end
    module_function :cache_run_list

    def load_cached_run_list
      if File.exist?("#{Ronin::Config[:cache_path]}/run_list.json")
        Ronin::Log.info("Loading cached run list items from #{Ronin::Config[:cache_path]}/run_list.json.")
        @run_list = JSON.parse(IO.read("#{Ronin::Config[:cache_path]}/run_list.json"))
        return @run_list
      else
        abort("Connection refused by etcd host #{Ronin::Config[:etcd_host]}:#{Ronin::Config[:etcd_port]}, and no cached run list found at (#{Ronin::Config[:cache_path]}/run_list.json)")
      end
    end
    module_function :load_cached_run_list

  end
end
