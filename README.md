# QueenShop Webservice [ ![Codeship Status for hola2soa/wss-dynamo](https://codeship.com/projects/837f5960-8602-0133-6b2f-12253304c6fc/status?branch=master)](https://codeship.com/projects/122494)

Take a look: <a href="https://wss-dynamo.herokuapp.com/" target="_blank">live site</a>

Handles:
- GET   /
  - returns OK status to indicate service is alive
- GET   /api/v1?uri
  - uri can have
    - variable name: store
      - description: the store to scrape
      - valid values: queenshop, joyceshop or stylemooncat
    - variable name: category
      - description: a specific category to scrape
      - valid values: tops, latest, pants, accessories, popular, search
    - variable name: keyword
      - description: any words to filter the results
      - valid values: any string that can be sent over GET
    - variable name: price
      - description: the price range to filter the results by
      - valid values: two comma separated integers eg. 100,300
    - variable name: page_limit
      - description: the number of pages to scrape starting from one
      - valid values: positive integer

  - result: an array of hashes each containing the following keys
    - key: title
      - description: the title/name of the item
      - type: string
    - key: price
      - description: price of item
      - type: Numeric (float/signed integer)
    - key: images
      - description: list of images where the items can be seen
      - type: array of strings
    - key: link
      - description: the base url to item
      - type: string

- POST   /api/v1/create_user
  - parameters
    - name: name
      - description: name of user to create
      - type: string
    - name: email_address
      - description: email address of user to create
      - type: valid email

  - return
    - error
      - status 400 if user exists
      - status 400 if invalid input
      - status 400 user already exists
      - { success: false, message: 'failed to create user' }
    - status 200 on success
      - JSON { success: true, data: user, message: 'user created successfully' }

- POST /api/v1/add_user_stores
  - description: assign stores to user
  - note: user must be logged in
  - parameters
    - name: stores
      - description: array of valid stores queenshop, joyceshop and stylemooncat
      - type: array of string

  - return
    - status 200 on success
    - status 400 on input error
    - status 500 on server error

- POST /api/v1/remove_user_stores
  - description: remove stores from user
  - note: user must be logged in
  - parameters
    - name: stores
      - description: array of valid stores queenshop, joyceshop and stylemooncat
      - type: array of string

  - return
    - status 200 on success
    - status 400 on input error
    - status 500 on server error

- POST /api/v1/pin_item
  - description: assign item to user
  - note: user must be logged in
  - parameters
    - name: item
      - description: the item to be assigned to the user
      - type: hash
      - the item type contains the following keys
        - key: title
          - description: the title/name of the item
          - type: string
        - key: price
          - description: price of item
          - type: Numeric (float/signed integer)
        - key: images
          - description: list of images where the items can be seen
          - type: array of strings
        - key: link
          - description: the base url to item
          - type: string

  - return
    - status 200 on success
    - status 400 on input error
    - status 500 on server error

- POST /api/v1/unpin_item
  - description: remove item from user
  - note: user must be logged in
  - parameters
    - same as pin_item

  - return
    - same as pin_item

- POST /api/v1/auth
  - parameters
    - name: email_address
    - type: string valid email

- GET /api/v1/logout
  - URI none

- POST    /api/v1/get_items
  - description: save user request to database
  - note: user must be logged in to fetch record
  - parameters
    - name: keywords
      - description: keywords to filter by
      - type: a string splitting items by new lines "\n"
        - or array of arrays of strings
    - name: prices
      - description: prices to filter by
      - type: string containing paired comma separated integers each pair separated by \n
        - or array of arrays of integers
    - name: categories
      - description: limit scraping to categories :default search
      - type: string separated by new line \n
        - or array of valid categories: tops, pants, latest, popular, search, accessories

  - return
    - status 303 redirect to api/vi?id=new_id_of_item
    - status 400 on input error

- DELETE  /api/v1
  - description: delete the item matching the id
  - parameters
    - name: id
      - description: id of a record in the database
      - type: string

  - return
    - status 200 on success
    - status 404 on item id not found
    - status 400 on other error
