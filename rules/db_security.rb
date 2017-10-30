
rule 'User changes DB subnet group' do
  match_all
  threat_level  :high

  match 'eventName' do
    equals 'ModifyDBSubnetGroup'
  end

  performed 'by user' do
    by :user
    via :console
  end
end

