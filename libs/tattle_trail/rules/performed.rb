
module TattleTrail
  module Rule

    class Performed < Base
      @by
      @via 

      def initialize(field_name)
        super(field_name)
        @log.debug('Starting reporter')
      end

      def by(key)
        @log.debug('Performed by: %s' % key)
        @by = key
      end

      def via(source=:console)
        @log.debug('Via: %s' % source)

        if source == :cloudformation
          @via = 'cloudformation.amazonaws.com'
        else
          @via = 'console.ec2.amazonaws.com'
        end
      end

      def converge(event)
        #@log.debug('%s == %s' % [event['userAgent'], @via])
        event['userAgent'] == @via 
      end
    end

  end
end
