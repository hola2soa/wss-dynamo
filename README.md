# QueenShop Webservice [ ![Codeship Status for hola2soa/wss-dynamo](https://codeship.com/projects/837f5960-8602-0133-6b2f-12253304c6fc/status?branch=master)](https://codeship.com/projects/122494)

Take a look: <a href="https://wss-dynamo.herokuapp.com/" target="_blank">live site</a>

Handles:
- GET   /
  - returns OK status to indicate service is alive
- GET   api/v1/queenshop/\<item\>.json
  - returns JSON of items info: (titles and prices)
- GET   api/v1/queenshop/query\<integer\>
  - returns JSON of items info: (id, items, prices, pages)
- POST  /api/v1/queenshop/query
  - takes JSON: array of 'items', array of 'prices'
  - returns: redirects (303) to GET /api/v1/queenshop/<some integer>
