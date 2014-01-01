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
require 'net/https'
require 'net/http'
require 'socket'
require 'json'

module Ronin
  module Etcd

    @hostname = Socket.gethostname

    def get_key(type, key)
      # Will add error handling... one day.
      @path = "/v2/keys/ronin/#{type}/#{key}"
      @http = Net::HTTP.new(Ronin::Config[:etcd_host], Ronin::Config[:etcd_port])
      @http.read_timeout = Ronin::Config[:etcd_read_timeout]
      @http.open_timeout = Ronin::Config[:etcd_conn_timeout]

      if Ronin::Config[:etcd_use_ssl]
        @http.use_ssl = true
        unless Ronin::Config[:etcd_ssl_cert] = ''
          @http.verify_mode = OpenSSL::SSL::VERIFY_PEER
          store = OpenSSL::X509::Store.new
          store.add_cert(OpenSSL::X509::Certificate.new(File.read(Ronin::Config[:etcd_ssl_ca_cert])))
          @http.cert_store = store
          @http.key = OpenSSL::PKey::RSA.new(File.read(Ronin::Config[:etcd_ssl_cert]))
          @http.cert = OpenSSL::X509::Certificate.new(File.read(Ronin::Config[:etcd_ssl_key]))
        end
      else
        @http.use_ssl = false
      end

      @request = Net::HTTP::Get.new(@path)

      begin
        @result = @http.request(@request)
      rescue Exception => e
        abort("Connection refused by etcd host #{Ronin::Config[:etcd_host]}:#{Ronin::Config[:etcd_port]}, exiting...")
      end

      unless @result.kind_of?(Net::HTTPSuccess)
        if @result.code == 404
          Ronin::Log.info("Key http://#{Ronin::Config[:etcd_host]}:#{Ronin::Config[:etcd_port]}#{@path} not found, returning an empty set.")
          return "{}"
        else
          Ronin::Log.info("Got status #{@result.code} querying http://#{Ronin::Config[:etcd_host]}:#{Ronin::Config[:etcd_port]}#{@path}, returning an empty set.")
          return "{}"
        end
      end

      return JSON.parse(@result.body)['node']['value']
    end
    module_function :get_key

    def get_config
      @config = {}
      Ronin::Config[:etcd_keys].each do |key|
        key = @hostname if key == 'node'
        @payload = JSON.parse(Ronin::Etcd.get_key('config', key))
        @config = @config.merge(@payload)
      end
      return @config
    end
    module_function :get_config

    def get_run_list
      @run_list = []
      Ronin::Config[:etcd_keys].each do |key|
        key = @hostname if key == 'node'
        @payload = JSON.parse(Ronin::Etcd.get_key('run_list', key))['artifacts']
        @run_list += @payload unless @payload.nil?
      end
      return @run_list.uniq
    end
    module_function :get_run_list

  end
end