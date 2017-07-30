
rule 'User opens TCP to world' do
  match_all
  threat_level  :high

  match 'eventName' do
    equals 'AuthorizeSecurityGroupIngress'
  end

  performed 'by user' do
    by :user
    via :console
  end

  opens_cidr 'world' do
    cidr '0.0.0.0/0'
  end
end



rule 'Cloudformation script opens TCP to world' do
  match_all
  threat_level  :medium

  match 'eventName' do
    equals 'AuthorizeSecurityGroupIngress'
  end

  performed 'by user' do
    by :user
    via :cloudformation
  end

  opens_cidr 'world' do
    cidr '0.0.0.0/0'
    ignore_port 80
    ignore_port 443
  end
end

