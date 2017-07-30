require './libs/tattle_trail/rule_factory.rb'
require './libs/tattle_trail/rules/base.rb'
require './libs/tattle_trail/rules/match.rb'
require './libs/tattle_trail/rules/opens_cidr.rb'
require './libs/tattle_trail/rules/performed.rb'

module TattleTrail
  class Report < Base
    @rules

    attr_accessor :log
    def initialize
      super()
      @rules = []
      @log.debug('Starting reporter')
    end

    def compile(rules)
      self.instance_eval(rules)
    end

    def rule(rule_name, &block)
      @log.debug('Creating rule: %s' % rule_name)
      rule = RuleFactory.new(rule_name)
      rule.instance_eval(&block)
      @rules.push(rule)
    end

    def converge(event)
      @rules.each do |r|
        res = r.converge(event)

        if res
          if r.t_level == :high
            color = :red
          elsif r.t_level == :medium
            color = :yellow
          else
            color = :green
          end

          @log.info('%s'.colorize(color) % [r.rule_name])
          #pp event

          username = self.get_username(event)
          ts = self.get_ts(event)

          #time_delta = Time.new.to_f - ts.to_f
          #time_diff = TimeDifference.between(ts, Time.now.utc)
          #pp time_diff.in_each_component
          #pp Time.new.utc

          @log.info("%s\t%s" % [username, ts])
        end
      end
    end

    def get_ts(event)
      Time.parse(event['eventTime'])
    end

    def get_username(event)
      event['userIdentity']['userName']
    end

  end
end
