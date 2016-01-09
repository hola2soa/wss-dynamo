# ---- Load the API environment
require ::File.expand_path('../config/environments', __FILE__)


require 'rack/cors'
use Rack::Cors do
  allow do
    origins '*'
    resource '*',
    :methods => [:get, :post, :delete, :put, :patch, :options, :head],
    :headers => :any
  end
end

# --------------------------------------------------------------
# Top-level routing
run SinatraApp
