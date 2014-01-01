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
require 'ronin/etcd'
require 'yaml'

module Ronin
  class RunList
    include Enumerable

    def initialize
      @run_list = {}

      if Ronin::Config[:run_list_type] == 'etcd'
        @artifacts_raw = Ronin::Etcd.get_run_list
      else
        @artifacts_raw = YAML.load_file(Ronin::Config['run_list_file'])['artifacts']
      end

      unless @artifacts_raw.nil?
        @artifacts_raw.each do |a|
          if a.include?(";")
            @repo   = a.split(";")[0].sub(/(\/)+$/, '')
            @branch = a.split(";")[1]
          else
            @repo   = a
            @branch = 'master'
          end

          @name = @repo.split("/").last

          @run_list[@name] = { :name => @name, :repo => @repo, :branch => @branch }
        end
      end

      @run_list
    end

    def artifacts
      @arts = []
      @run_list.each { |k, v| @arts << k }
      @arts
    end

    def items
      @items = []
      @run_list.each do |k, v|
        @items << { :name => v[:name], :repo => v[:repo], :branch => v[:branch] }
      end
      @items
    end

  end
end
