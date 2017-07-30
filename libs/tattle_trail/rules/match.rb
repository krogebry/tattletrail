
module TattleTrail
  module Rule

    class Match < Base
      @regex

      def initialize(field_name)
        super(field_name)
        @log.debug('Creating match rule for %s' % field_name)
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

  end
end
