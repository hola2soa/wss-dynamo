# QueenShop Webservice

A simple version of web service that scrapes QueenShop data using the
[![Gem Version](https://badge.fury.io/rb/queenshop.svg)](https://badge.fury.io/rb/queenshop) gem

Handles:
- GET   /
  - returns OK status to indicate service is alive
- GET   /api/v1/qs/<item>
  - returns JSON of items info: (full title and price)
- POST  /api/v1/check
  - takes JSON: array of 'items', array of 'prices'
  - returns: array of items and their matching prices
