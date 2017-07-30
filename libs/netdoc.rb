
class NetworkDoctor
  @log
  @vpc_name
  @ec2_client
  @aws_region

  @vpc_id

  @main_route

  def initialize(vpc_name)
    @log = Logger.new(STDOUT)
    @log.debug('Creating NetworkDoctor for %s' % vpc_name)

    @cache = DevOps::Cache.new

    creds = Aws::SharedCredentials.new()
    @aws_region = ENV['AWS_DEFAULT_REGION']
    @ec2_client = Aws::EC2::Client.new(region: @aws_region, credentials: creds)

    @vpc_name = vpc_name
  end

  def checkup
    self.check_vpc
    self.check_subnets
  end

  def get_vpc_by_tag(tag_name, tag_value)
    cache_key = format('vpc_%s_%s_%s', @aws_region, tag_name, tag_value)
    vpcs = @cache.cached_json( cache_key ) do
      filters = [{
        name: format('tag:%s', tag_name),
        values: [tag_value]
      }]
      @ec2_client.describe_vpcs( filters: filters).data.to_h.to_json
    end
    vpcs['vpcs'].first
  end

  def check_vpc
    @log.debug('Checking vpc: %s' % @vpc_name)
    vpc = get_vpc_by_tag('Name', @vpc_name)
    #pp vpc
    @vpc_id = vpc['vpc_id']
  end

  def check_subnets
    @log.debug('Checking subnets')
    subnets = get_subnets_by_vpc_id(@vpc_id)    
  end

  def get_subnets_by_vpc_id(vpc_id)
    cache_key = format('vpc_subnets_%s', vpc_id)
    subnets = @cache.cached_json( cache_key ) do
      filters = [{
        name: 'vpc-id',
        values: [vpc_id]
      }]
      @ec2_client.describe_subnets( filters: filters).data.to_h.to_json
    end

    @main_route = get_main_route_table(vpc_id)

    subnets['subnets'].each do |subnet|
      #route = self.get_subnet_route(subnet['subnet_id'])
      #if route == false
        ## Assume main rt
      #else
        ## Evaluate route
      #end

      if subnet_is_routable?(subnet['subnet_id'])
        @log.info('Subnet is routable'.colorize(:green))
      else
        @log.info('Subnet is not routable'.colorize(:red))
      end
    end
  end

  def subnet_is_routable?(subnet_id)
      route = self.get_subnet_route(subnet_id)
      if route == false
        route = @main_route
      end

      ## Check for default route on this route.
      route['routes'].select{|r| r['destination_cidr_block'] == '0.0.0.0/0'}.compact.size > 0
  end

  def get_main_route_table(vpc_id)
    cache_key = format('vpc_main_route_%s', vpc_id)
    routes = @cache.cached_json( cache_key ) do
      filters = [{
        name: 'association.main',
        values: ['true']
      }]
      @ec2_client.describe_route_tables( filters: filters).data.to_h.to_json
    end
    #pp routes
    #exit
    return routes['route_tables'].first
  end

  def get_subnet_route(subnet_id)
    # association.subnet-id
    cache_key = format('vpc_subnet_route_%s', subnet_id)
    routes = @cache.cached_json( cache_key ) do
      filters = [{
        name: 'association.subnet-id',
        values: [subnet_id]
      }]
      @ec2_client.describe_route_tables( filters: filters).data.to_h.to_json
    end
    #pp routes
    if routes['route_tables'].size == 0
      return false
    end

    return route['route_tables'].first
  end

end

