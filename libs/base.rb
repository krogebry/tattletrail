
module TattleTrail

  class Base
    @log

    def initialize
      @log = Logger.new(STDOUT)
      @log.debug('Creating base')
    end

  end

end

