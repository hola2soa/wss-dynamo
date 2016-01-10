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

describe 'Checking user auth, pinning and unpinning items' do
  before do
    UserRequest.delete_all
    User.delete_all
    Item.delete_all
    Store.delete_all
  end

  it 'should create new user' do
    header = { 'CONTENT_TYPE' => 'application/json' }
    body = {
      email_address: "ted@gmail.com",
      name: "Ted",
      stores: ["queenshop"]
    }

    post '/api/v1/create_user', body.to_json, header
    last_response.must_be :ok?
  end
=begin
  it 'should should login user' do
    header = { 'CONTENT_TYPE' => 'application/json' }
    body = { "email_address": "ted@gmail.com" }

    post '/api/v1/auth', body.to_json, header
    last_response.must_be :ok?
  end

  it 'should return 404 for unknown items' do
    get "/api/v1?id=#{random_str(20)}"
    last_response.must_be :not_found?
  end

  it 'should get items from queenshop' do
    post '/api/v1?store=queenshop&category=tops'
    last_response.body.must_be_instance_of Array
    last_response.must_be :ok?
  end

  it 'should should logout user' do
    get '/api/v1/logout'
    last_response.must_be :ok?
  end
=end
end
