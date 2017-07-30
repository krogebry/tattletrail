
rule "Delete commands from the UI" do
  match_all
  threat_level  :high

  match 'eventName' do
    starts_with 'Delete'
  end

  performed 'by user' do
    by :user
    via :console
  end
end

rule 'User creates a new key pair' do
  match_all
  threat_level  :high

  match 'eventName' do
    equals 'CreateKeyPair'
  end

  performed 'by user' do
    by :user
    via :console
  end
end
