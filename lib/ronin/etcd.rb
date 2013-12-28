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
require 'net/https'
require 'net/http'
require 'socket'
require 'json'

module Ronin
  module Etcd
    def get_run_list
      # Will add error handling... one day.
      @hostname = Socket.gethostname
      @path = "/v2/keys/ronin/run_lists/#{hostname}"
      @http = Net::HTTP.new(Ronin::Config['etcd_host'], Ronin::Config['etcd_port'])
      @http.use_ssl = false
      @request = Net::HTTP::Get.new(@path)
      @result = http.request(@req)
      @raw = JSON.parse(result.body)['node']['value']
      return JSON.parse(@raw)['run_list']
    end
    module_function :get_run_list
  end
end




