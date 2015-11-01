#!/usr/bin/env ruby
require_relative 'spec_helper'
require 'json'

describe 'Getting the root of the service' do
  it 'Should return ok' do
    get '/api/v1/'
    last_response.must_be :ok?
    last_response.body.must_match(/queenshop/i)
  end
end
