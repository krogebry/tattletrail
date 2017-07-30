
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
      #@log.debug('Converging on %s' % rule)
      @rules.each do |r|
        res = r.converge(event)
        #@log.debug('Res: %s' % res)
        if res
          @log.info('%s level %s' % [r.rule_name, r.t_level])
          pp event
        end
      end
    end

  end

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

    def match(field_name, &block)
      #@log.debug('Running match on %s' % field_name)
      rule = Rule::Match.new(field_name)
      rule.instance_eval(&block)
      @rules.push(rule)
    end

    def performed(field_name, &block)
      #@log.debug('Running perfom %s' % block)
      rule = Rule::Performed.new(field_name)
      rule.instance_eval(&block)
      @rules.push(rule)
    end

  end

  module Rule
    class Base
      @log
      @rule_name

      def initialize
        @log = Logger.new(STDOUT)
      end

      def converge(event)
      end
    end

    class Match < Base
      @regex
      @field_name

      def initialize(field_name)
        super()
        @log.debug('Creating match rule for %s' % field_name)
        @field_name = field_name
      end

      def starts_with(str)
        @regex = /^#{str}.*/
      end

      def equals(str)
        @regex = /^#{str}$/
      end

      def converge(event)
        @regex.match(event[@field_name])
      end
    end

    class Performed < Base
      @by
      @via 

      def initialize(field_name)
        super()
        @log.debug('Starting reporter')
      end

      def by(key)
        @log.debug('Performed by: %s' % key)
        @by = key
      end

      def via(source=:console)
        @log.debug('Via: %s' % source)
        @via = (source == :console ? 'console.ec2.amazonaws.com' : nil)
      end

      def converge(event)
        event['userAgent'] == @via 
      end
    end
  end

end
