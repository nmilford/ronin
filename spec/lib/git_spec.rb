require 'spec_helper'
require 'ronin/git'

describe Ronin::Git do

  before do
    Ronin::Config[:artifact_path] = '/var/tmp/ronin-rspec'

    Dir.mkdir(Ronin::Config[:artifact_path]) if ! Dir.exists?(Ronin::Config[:artifact_path])

    @item     = { :name=>"ntp", :repo=>"https://github.com/opscode-cookbooks/ntp", :branch=>"master" }
    @target   = "#{Ronin::Config[:artifact_path]}/#{@item[:name]}"
  end

  it ".clone" do
    Ronin::Git.clone(@item)
    Dir.exists?(@target).should == true
  end

  it ".branch" do
    Ronin::Git.clone(@item)
    Ronin::Git.branch(@item[:name]).should == 'master'
  end

  it ".pull_and_report_updated" do
    Ronin::Git.clone(@item)
    Ronin::Git.pull_and_report_updated(@item[:name]).should == false
  end

  after do
    FileUtils.rm_rf(Ronin::Config[:artifact_path]) if Dir.exists?(Ronin::Config[:artifact_path])
  end

end
