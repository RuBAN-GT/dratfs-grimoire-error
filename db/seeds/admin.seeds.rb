after :roles do
  defaults = [
    {
      :uid => '12488384',
      :membership_id => '4611686018455641628',
      :membership_type => '2',
      :display_name => 'RuBAN-GT',
      :roles => [Role.find_by_slug('super')]
    },
    {
      :uid => '6208552',
      :membership_id => '4611686018433052893',
      :membership_type => '2',
      :display_name => 'olifirka',
      :roles => [Role.find_by_slug('super')]
    }
  ]

  defaults.each do |user|
    next unless User.find_by_uid(user[:uid]).nil?

    u = User.new(user)

    u.save!
  end

  p 'Admin was created'
end
