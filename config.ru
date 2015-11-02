#!/usr/bin/env ruby

# ---- Load the API environment
require ::File.expand_path('../config/environment', __FILE__)

# --------------------------------------------------------------
# Top-level routing
run QueenShopApi::SinatraApp
# map('/api/v1/') { run QueenShopApi::SinatraApp }
