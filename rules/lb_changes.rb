
rule 'User changes load balancer listener' do
  match_all
  threat_level  :high
  match 'eventName' do
    equals 'ModifyListener'
  end
  performed 'by user' do
    by :user
    via :console
  end
end

rule 'User changes load balancer attributes' do
  match_all
  threat_level  :high

  match 'eventName' do
    equals 'ModifyLoadBalancerAttributes'
  end

  performed 'by user' do
    by :user
    via :console
  end
end


