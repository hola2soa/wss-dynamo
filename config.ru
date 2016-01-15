#\ -s puma -E production
# ---- Load the API environment
require ::File.expand_path('../config/environments', __FILE__)


require 'rack/cors'
use Rack::Cors do
  allow do
    origins '*'
    resource '*', :methods => [:get, :post, :delete, :put, :patch, :options, :head], :headers => :any
  end
end

use Faye::RackAdapter, :mount => '/faye', :timeout => 25

# --------------------------------------------------------------
# Top-level routing
run SinatraApp
