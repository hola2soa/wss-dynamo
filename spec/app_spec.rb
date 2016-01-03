#!/usr/bin/env ruby
require_relative 'spec_helper'
require 'json'

describe 'Getting the root of the service' do
  it 'Should return ok' do
    get '/'
    last_response.must_be :ok?
    last_response.body.must_match(/hola/i)
  end
end

describe 'Getting price information' do
  it 'should return their prices' do
    get '/api/v1/queenshop/1'
    last_response.must_be :ok?
  end

  it 'should return 404 for unknown items' do
    get "/api/v1/item/#{random_str(20)}"
    last_response.must_be :not_found?
  end
end

describe 'Checking items for prices' do
  before do
    Item.delete_all
  end

  it 'should find matching prices' do
    header = { 'CONTENT_TYPE' => 'application/json' }
    body = {
      items: ['m'],
      prices: ['390','490'],
      pages: '1..7'
    }

    # checking for redirect
    post '/api/v1/queenshop/item', body.to_json, header

    last_response.must_be :redirect?
    next_location = last_response.location
    next_location.must_match /api\/v1\/queenshop\/item\/.+/

    # get request
    request_id = next_location.scan(/item\/(.+)/).flatten[0]
    stored_request = UserRequest.find(request_id)

    JSON.parse(stored_request[:items]).must_equal body[:items]

    # verify redirect
    VCR.use_cassette('happy_request') do
      follow_redirect!
    end
    last_request.url.must_match /api\/v1\/queenshop\/item\/.+/

    # check response from get
    last_response.must_be :ok?
  end

  it 'should return 400 for items in database but not in scraper' do
    header = { 'CONTENT_TYPE' => 'application/json' }
    body = {
      items: [random_str(15), random_str(15)],
      prices: ['800']
    }

    post '/api/v1/queenshop/item', body.to_json, header
    last_response.must_be :redirect?

    # verify redirect
    VCR.use_cassette('sad_request') do
      follow_redirect!
    end
    last_response.status.must_equal 400
  end

  it 'should return 400 for bad JSON formatting' do
    header = { 'CONTENT_TYPE' => 'application/json' }
    body = random_str(50)

    post '/api/v1/queenshop/item', body, header
    last_response.must_be :bad_request?
  end
end
