
module TattleTrail
  module Rule

    class OpensCIDR < Base
      @cidr
      @ignored_ports

      def initialize(field_name)
        super(field_name)
        @log.debug('Creating match rule for %s' % field_name)
        @ignored_ports = []
      end

      def cidr(val)
        @cidr = val
      end

      def ignore_port(port)
        @ignored_ports.push(port)
      end

      def converge(event)
        return false if !event.has_key? 'requestParameters'
        return false if !event['requestParameters'].has_key? 'ipPermissions'

        ip_perms = event['requestParameters']['ipPermissions']['items']

        ip_perms.each do |perm|

          ip_perms.each do |ip|
            if ip['ipRanges'].has_key? 'items'
              if ip['ipRanges']['items'].select{|p| 
                p['cidrIp'] == @cidr && 
                !@ignored_ports.include?(p['toPort'])
              }.compact.size > 0
                return true
              end
            end
          end

        end

        return false
      end
    end

  end
end
