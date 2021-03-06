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
require 'mixlib/config'

module Ronin
  class Config
    extend Mixlib::Config

    config_file = '/etc/ronin/ronin.rb'

    if File.exist?(config_file)
      Ronin::Config.from_file(config_file)
    else
      puts "No configuration file at #{config_file}, using defaults."
    end

    config_strict_mode true
    default :config_from_etcd, false
    default :cache_etcd_data, true
    default :lock_file, '/var/tmp/ronin.lock'
    default :log_path, 'STDOUT'
    default :interpreter_log_path, '/var/log/ronin'
    default :log_level, :info
    default :update_on_change, true
    default :interpreter, 'chef'
    default :cache_path, '/var/lib/ronin/cache'
    default :artifact_path, '/var/lib/ronin/artifacts'
    default :run_list_type, 'yaml'
    default :run_list_file, '/etc/ronin/artifacts.yaml'
    default :etcd_host, '127.0.0.1'
    default :etcd_port, 4001
    default :etcd_conn_timeout, 5
    default :etcd_read_timeout, 5
    default :etcd_use_ssl, false
    default :etcd_ssl_ca_cert, ''
    default :etcd_ssl_cert, ''
    default :etcd_ssl_key, ''
    default :etcd_keys, ['common', 'node']

  end
end
