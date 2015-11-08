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

describe 'Getting cadet information' do
  it 'should return their prices' do
    get '/api/v1/queenshop/10.json'
    last_response.must_be :ok?
  end

  it 'should return 404 for unknown items' do
    get "/api/v1/query/#{random_str(20)}.json"
    last_response.must_be :not_found?
  end
end

describe 'Checking items for prices' do
  it 'should find matching prices' do
    header = { 'CONTENT_TYPE' => 'application/json' }
    body = {
      items: ['blouse'],
      prices: ['390','490'],
      pages: '1..7'
    }

    # checking for redirect
    post '/api/v1/queenshop/query', body.to_json, header
    last_response.must_be :redirect?
    next_location = last_response.location
    next_location.must_match %r{api\/v1\/queenshop\/query\/\d+}

    # get request
    request_id = next_location.scan(%r{query\/(\d+)}).flatten[0].to_i
    stored_request = Request.find(request_id)
    JSON.parse(stored_request[:items]).must_equal body[:items]
    # JSON.parse(stored_request[:prices]).must_equal body[:prices]

    # verify redirect
    VCR.use_cassette('happy_request') do
      follow_redirect!
    end
    last_request.url.must_match %r{api\/v1\/queenshop\/query\/\d+}

    # check response from get
    JSON.parse(last_response.body).count.must_be :>, 0
  end
  it 'should return 404 for unknown items' do
    header = { 'CONTENT_TYPE' => 'application/json' }
    body = {
      items: [random_str(15), random_str(15)],
      prices: ['800']
    }

    post '/api/v1/queenshop/query', body.to_json, header
    last_response.must_be :redirect?

    # verify redirect
    VCR.use_cassette('sad_request') do
      follow_redirect!
    end
    last_response.must_be :not_found?
  end

  it 'should return 400 for bad JSON formatting' do
    header = { 'CONTENT_TYPE' => 'application/json' }
    body = random_str(50)

    post '/api/v1/queenshop/query', body, header
    last_response.must_be :bad_request?
  end
end
