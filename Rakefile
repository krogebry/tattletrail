require 'pp'
require 'json'
require 'time'
require 'logger'
require 'colorize'
require 'time_difference'

require 'aws-sdk'

require './libs/cache.rb'

require './libs/base.rb'
require './libs/report.rb'
require './libs/gather.rb'

require './libs/netdoc.rb'

## Network doctor
namespace :netdoc do
  desc 'Check VPC network'
  task :check_vpc, :vpc_name do |t,args|
    #pp args
    netdoc = NetworkDoctor.new(args[:vpc_name])
    report = netdoc.checkup
  end
end

namespace :tt do

  desc 'Gather data'
  task :gather do
    #g = TattleTrail::Gather.new()
    `aws cloudtrail lookup-events > /tmp/cloudtrail.json`
  end

  desc 'Create a report'
  task :report do
    rules = ""
    Dir.glob(File.join('rules/*.rb')).each do |filename|
      rules << File.read(filename)       
    end

    reporter = TattleTrail::Report.new()
    reporter.compile(rules)

    ct_data = JSON::parse(File.read('/tmp/cloudtrail.json'))
    ct_data['Events'].each do |ct_e|
      event = JSON::parse(ct_e['CloudTrailEvent'])
      reporter.converge(event)
    end
  end
end
