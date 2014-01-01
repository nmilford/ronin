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

require File.dirname(__FILE__) + '/lib/ronin/version'
require File.dirname(__FILE__) + '/lib/ronin/util'

task :test do
  puts 'Tests'
end

namespace :build do
  task :gem do
    sh %{#{Ronin::Util.find_cmd("gem")} build ./ronin-wrapper.gemspec}
  end

  task :rpm do
    if Ronin::Util.find_cmd("rpmbuild") and Ronin::Util.find_cmd("rpmdev-setuptree")
      unless File.exist?("#{File.expand_path('~')}/rpmbuild")
        puts "Setting up RPM build tree at ~/rpmbuild."
        sh %{#{Ronin::Util.find_cmd("rpmdev-setuptree")}}
      end
      sh %{#{Ronin::Util.find_cmd("rpmbuild")} -bb ./packaging/rpm/ronin-wrapper.spec}
    else
      puts "You must have rpmdevtools installed to build an RPM package."
      exit 1
    end
  end

  task :deb do
    puts 'not implemented'
  end
end