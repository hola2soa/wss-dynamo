# Skeleton file for true config_env.rb
# - put your keys/secrets in '...'

config_env do
  set 'AWS_ACCESS_KEY_ID', 'AKIAIPO4E2F5TZ7VKBTA'
  set 'AWS_SECRET_ACCESS_KEY', 'A3znHojQO0bIgwxma2oYvnYj04u4dlnAEJpleAyI'
end

config_env :production do
  # AWS Region: US East (N. Virginia)
  set 'AWS_REGION', 'us-east-1'

  # Memcachier region: US
#  set 'MEMCACHIER_SERVERS', ''
#  set 'MEMCACHIER_USERNAME', ''
#  set 'MEMCACHIER_PASSWORD', ''
end

config_env :development, :test do
  # AWS Region: EU Central (Frankfurt)
  set 'AWS_REGION', 'eu-central-1'

  # Memcachier region: EU
  set 'MEMCACHIER_SERVERS', 'mc4.dev.ec2.memcachier.com:11211'
  set 'MEMCACHIER_USERNAME', 'f13642'
  set 'MEMCACHIER_PASSWORD', '9690ca8f5c787dc5db23479004c8628e'
end
