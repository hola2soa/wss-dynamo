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
    ted = User.new(name: 'Ted', email_address: 'ted@gmail.com')
    ted.stores << Store.new(name: 'queenshop').save
    ted.stores << Store.new(name: 'joyceshop').save
    ted.save
  end

  it 'should should login user' do
    header = { 'CONTENT_TYPE' => 'application/json' }
    body = { email_address: "ted@gmail.com" }

    post '/api/v1/auth', body.to_json, header
    last_response.must_be :ok?
  end

  it 'should create new user' do
    header = { 'CONTENT_TYPE' => 'application/json' }
    body = {
      email_address: "joe@gmail.com",
      name: "Joe",
      stores: ["queenshop"]
    }

    post '/api/v1/create_user', body.to_json, header
    last_response.must_be :ok?
  end

  it 'should return 404 for unknown items' do
    get "/api/v1?id=#{random_str(20)}"
    last_response.must_be :not_found?
  end

  it 'should get items from queenshop' do
    get '/api/v1?store=queenshop&category=tops'
    last_response.body.wont_be_empty
    last_response.must_be :ok?
  end

  it 'should scrape single page' do
    get '/api/v1/ssp?store=joyceshop&category=tops&page=2'
    last_response.body.wont_be_empty
    last_response.must_be :ok?
  end

  it 'should get items from queenshop' do
    get '/api/v1/random_items?random=2'
    JSON.parse(last_response.body).count.must_be :==, 2
    last_response.must_be :ok?
  end

=begin
  # how to check end point that requires authentication
  it 'should pin items for logged in user' do
    header = { 'CONTENT_TYPE' => 'application/json' }
    body = { item: { title: "some test item",
      price: 431,
      images: ["https://queenshop.com.tw/photo/01021996/01021996.jpg","https://queenshop.com.tw/photo/01021996/01021996-h.jpg"],
      link: "https://queenshop.com.tw/PDContent.asp?yano=01021996" }
    }
    post '/api/v1/pin_item', body.to_json, header
    # TODO: query database directly and see if the item was inserted

    last_response.must_be :ok?
  end

  it 'should get items from queenshop' do
    post '/api/v1/user_pinned_items'

    JSON.parse(last_response.body).count.must_be :==, 1
    last_response.must_be :ok?
  end
=end

  it 'should should logout user' do
    get '/api/v1/logout'
    last_response.must_be :ok?
  end

end
