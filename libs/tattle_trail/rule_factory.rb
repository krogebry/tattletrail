
module TattleTrail

  class RuleFactory < Base
    @rules
    @rule_name

    @t_level
    @match_type

    attr_accessor :rule_name, :t_level
    def initialize(rule_name)
      super()
      @rules = []
      @rule_name = rule_name

      @match_type = :match_all
      @threat_level = :low
    end

    def match_all
      @match_type = :match_all
    end

    def threat_level(level)
      @t_level = level
    end

    def converge(event)
      passing = 0

      @rules.each do |r|
        passing += (r.converge(event) ? 1 : 0)
      end

      #@log.debug('Converged %s: %i / %i' % [@rule_name, passing, @rules.size])

      if @match_type == :match_all
        return passing == @rules.size
      end

      return false
    end

    def opens_cidr(field_name, &block)
      rule = Rule::OpensCIDR.new(field_name)
      rule.instance_eval(&block)
      @rules.push(rule)
    end

    def match(field_name, &block)
      rule = Rule::Match.new(field_name)
      rule.instance_eval(&block)
      @rules.push(rule)
    end

    def performed(field_name, &block)
      rule = Rule::Performed.new(field_name)
      rule.instance_eval(&block)
      @rules.push(rule)
    end

  end
end
