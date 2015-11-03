# QueenShop Webservice [ ![Codeship Status for hola2soa/QueenShopWebApi](https://codeship.com/projects/7b7d0460-6030-0133-0431-46609ca5f084/status?branch=master)](https://codeship.com/projects/112052)

Take a look: <a href="https://hola2soa-api.herokuapp.com/" target="_blank">live site</a>

A simple version of web service that scrapes QueenShop data using the
[![Gem Version](https://badge.fury.io/rb/queenshop.svg)](https://badge.fury.io/rb/queenshop) gem

Handles:
- GET   /
  - returns OK status to indicate service is alive
- GET   api/v1/queenshop/<item>.json
  - returns JSON of items info: (full title and price)
- POST  /api/v1/queenshop/check
  - takes JSON: array of 'items', array of 'prices'
  - returns: array of items with corresponding array 
    of prices if they are found on the website
