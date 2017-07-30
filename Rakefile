require 'pp'
require 'json'
require 'logger'

require './libs/base.rb'
require './libs/report.rb'
require './libs/gather.rb'

namespace :tt do

  desc 'Gather data'
  task :gather do
    g = TattleTrail::Gather.new()
  end

  desc 'Create a report'
  task :report do
    rules = File.read('./rules/base.rb')
    reporter = TattleTrail::Report.new()
    reporter.compile(rules)

    ct_data = JSON::parse(File.read('/tmp/cloudtrail.json'))
    ct_data['Events'].each do |ct_e|
      event = JSON::parse(ct_e['CloudTrailEvent'])
      reporter.converge(event)
    end
  end
end
