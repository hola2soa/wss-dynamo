#!/usr/bin/env ruby
require_relative 'spec_helper'
require 'json'

describe 'Getting the root of the service' do
  it 'Should return ok' do
    get '/'
    last_response.must_be :ok?
    last_response.body.must_match(/queenshop/i)
  end
end
=begin
describe 'Get item information' do
	PASSED_TESTS.each_pair do |test, params|
		it "must be identical to the file #{test}" do
			VCR.use_cassette("#{test}") do
				test_info = File.read("./spec/fixtures/#{test}")
				header = { 'CONTENT_TYPE' => 'application/json' }
    		body = params
				post '/happy/', body.to_json, header
					last_response.body.must_equal test_info
			end
		end
  end
end
=end
