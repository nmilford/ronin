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
require 'yaml'

module Ronin
  class RunList
    include Enumerable

    def initialize
      @run_list = {}
      if Ronin::Config['run_list_type'] = :yaml
         @modules_raw = YAML.load_file(Ronin::Config['run_list_file'])['modules']
      end

      @modules_raw.each do |m|
        if m.include?(";")
          @repo   = m.split(";")[0].sub(/(\/)+$/,'')
          @branch = m.split(";")[1]
        else
          @repo   = m
          @branch = 'master'
        end

        @name = @repo.split("/").last

        @run_list[@name] = { :name => @name, :repo => @repo, :branch => @branch }
      end

      @run_list
    end

    def modules
      @mods = []
      @run_list.each { |k,v| @mods << k }
      @mods
    end

    def items
      @items = []
      @run_list.each { |k,v| @items << { :name => v[:name], :repo => v[:repo], :branch => v[:branch] } }
      @items
    end

  end
end