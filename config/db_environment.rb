configure :development, :test do
  enable :logging
  ActiveRecord::Base.configurations = YAML.load_file('config/database.yml')
end

# for production connect to postgres
configure :production do
  enable :logging
  db = URI.parse(ENV['DATABASE_URL'] || 'postgres:///localhost/queenshop')
  ActiveRecord::Base.establish_connection(
    adapter: db.scheme == 'postgres' ? 'postgresql' : db.scheme,
    host: db.host,
    username: db.user,
    password: db.password,
    database: db.path[1..-1],
    encoding: 'utf8'
  )
end
