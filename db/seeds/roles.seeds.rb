defaults = [
  {
    :slug => 'super',
    :name => 'Супер администратор'
  },
  {
    :slug => 'admin',
    :name => 'Администратор'
  },
  {
    :slug => 'user',
    :name => 'Пользователь'
  }
]

defaults.each do |role|
  Role.new(role).save rescue nil
end

p 'Roles was created'
