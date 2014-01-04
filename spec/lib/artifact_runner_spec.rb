require 'spec_helper'
require 'ronin/artifact_runner'

describe Ronin::ArtifactRunner do
  before do
    Ronin::Config[:log_path]      = '/var/tmp/ronin-rspec'
    Ronin::Config[:artifact_path] = '/var/tmp/ronin-rspec'
    Ronin::Config[:run_list_type] = 'yaml'
    Ronin::Config[:run_list_file] = "#{File.expand_path('.')}/conf/artifacts.yaml.sample"

    Dir.mkdir(Ronin::Config[:artifact_path]) if ! Dir.exists?(Ronin::Config[:artifact_path])

    @run_list = Ronin::RunList.new
    @targets  = []

    @run_list.artifacts.each { |a| @targets << "#{Ronin::Config[:artifact_path]}/#{a}" }

    @r = Ronin::ArtifactRunner.new
  end

  # TODO: Add contexts for conditional states

  it ".download_and_report_changes" do
    @r.download_and_report_changes.should == true
    @targets.each do |t|
      Dir.exists?(t).should == true
    end
  end

  it ".purge_unused" do
    @r.download_and_report_changes

    Dir.mkdir("#{Ronin::Config[:artifact_path]}/unused_module")

    @r.purge_unused

    Dir.exists?("#{Ronin::Config[:artifact_path]}/unused_module").should == false
  end

  after do
    FileUtils.rm_rf(Ronin::Config[:artifact_path]) if Dir.exists?(Ronin::Config[:artifact_path])
  end
end
