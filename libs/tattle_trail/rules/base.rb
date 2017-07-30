
module TattleTrail
  module Rule

    class Base
      @log
      @rule_name
      @field_name

      def initialize(field_name)
        @log = Logger.new(STDOUT)
        @field_name = field_name
      end

      def converge(event)
      end
    end

  end
end
