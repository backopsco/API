# Scalus's API

HOST: http://organization_slug.scalus.com/api/

Scalus's API allows developers to create tasks within the scalus ecosystem.

# Oauth Overview

All developers need to register their application before getting started. A registered OAuth application is assigned a unique Client ID and Client Secret. The Client Secret should not be shared. You may create a personal access token for your own use or implement the web flow below to allow other users to authorize your application.

## Definitions


| Phrase | Definition | example  |
| --------- | -------- | :------- |
| **Resource Owner** | the user who wants to share a resource | john.smith@xyz.com |
| **Client** | the application that wants to leverage a resource hosted by scalus.com | your social network |
| **Authorization Server** | the entity that decides to grant access to the client | scalus.com's authorization server |
| **Resource Server** | the place where the third party resource is hosted | scalus.com's server where the task's & tasklists exist |


## Web Application Flow

A) Redirect users to request access to Scalus

     GET https://organization_slug.scalus.com/oauth/authorize

Parameters

| Name | Type | Description  |
| --------- | -------- | :------- |
| **client_id** | string | The client ID on http://organization_slug.scalus.com/settings |
| **redirect_uri** | string | The URL in your app where users will be sent after authorization.  |

B) Scalus redirects back to your site

If the user accepts your request, Scalus redirects back to your site with a temporary code in a `code` parameter.

Parameters

| Name | Type | Description  |
| --------- | -------- | :------- |
| **client_id** | string | The client ID on http://organization_slug.scalus.com/settings |
| **client_secret** | string | The client secret you received on http://organization_slug.scalus.com/settings |
| **code** | string | The code you received as a response to Step 1 |
| **redirect_uri** | string | The URL in your app where users will be sent after authorization.  |


Exchange this for an access token:

`
     POST https://organization_slug.scalus.com/oauth/token
     Authorization: Basic czZCaGRSa3F0MzpnWDFmQmF0M2JW
     Content-Type: application/x-www-form-urlencoded;charset=UTF-8
     grant_type=client_credentials
`

After that you'll have the access token in the response:

`
    token = JSON.parse(response)["access_token"]
`

C)  Use the access token to access the API

The access token allows you to make requests to the API on a behalf of a user.

`
    GET https://organization_slug.scalus.com/api/tasks?access_token=...
`


## Command line oAuth Flow

#### 1) Request access to Scalus with a username/password
`
     POST https://organization_slug.scalus.com/oauth/token
     Parameters: {"client_id"=>".....", "client_secret"=>".....", "grant_type"=>"password", "password"=>"userPassword123", "username"=>"your@email.com"}
`

Parameters

| Name | Type | Description  |
| --------- | -------- | :------- |
| **client_id** | string | The client ID on http://organization_slug.scalus.com/settings |
| **client_secret** | string | The client SECRET on http://organization_slug.scalus.com/settings |
| **grant_type** | string | Set to "password" |
| **username** | string | The User's username.  |
| **password** | string | The User's password.  |

#### 2) Scalus returns an OAuth2 access token back

Parameters

| Name | Type | Description  |
| --------- | -------- | :------- |
| **token_type** | string | 'bearer' |

## Testing with OAuth2 gem

```ruby
client = OAuth2::Client.new(client_id, client_secret, :site => 'https://organization_slug.scalus.com')
puts client.auth_code.authorize_url(:redirect_uri => redirect_uri)
# => http://organization_slug.scalus.com/oauth/authorize?response_type=code&client_id=...&redirect_uri=http%3A%2F%2Forganization_slug.scalus.com%3A9393%2Fcallback
```

> Authorize the client and request the first access token with:

```ruby
token = client.auth_code.get_token(code, :redirect_uri => redirect_uri)
# POST '/oauth/token' with grant_type set to authorization_code
# => #<OAuth2::AccessToken:0x007fbcd38415b0 ...>
```

> You can check the generated tokens with:

```ruby
token.token
# => 'c6212bdd8e4a2dd8218ac22d9cc703eac5ac5f439bafd31594d96ce5be6effa0'
token.refresh_token
# => '4ffee626f0058e1bc1f1a29a76dc4ac5978b27e674f58b7e58f4bd6872b0452b'
```

> When time passes and the access token expires, you can refresh the old token, so you can continue accessing the provider's API.

```ruby
token.expired?
# => true

new_token = token.refresh!
# POST '/oauth/token' with grant_type set to refresh_token
# => #<OAuth2::AccessToken:0x007fbcd1ae4850 ...>

new_token.token
# => '67aa16d8c0476d2fb478df2876f6d3d3b8eda0b5ff2020960a7d6ad781184258'

new_token.refresh_token
# => '3dde18e1532f1d6f256caa89c366cfed3cd5bce68066ac8f1dbb053dbf65b90f'

new_token.expires_at
# => 1446085207

```

With this flow, you'll have access to scalus.com's API.

# Tasks

## Creating a Task

```shell
curl
-F task[title]="Thank you for looking at our API" \
-F task[description]="The best way to get work done and keep people in sync." \
-F task[requester_id]=1 \
-F task[assignee_id]=1 \
-F task[due_date]="10-25-2021" \
-F access_token="YOUR_ACCESS_TOKEN"
-X POST http://localhost:3000/api/tasks
```

```ruby
require 'rest-client'
require 'json'

client_id     = '4ea1b...'
client_secret = 'a2982...'

response = RestClient.post 'http://organization_slug.scalus.com/api/tasks', {
  access_token: 'YOUR_ACCESS_TOKEN',
  "task": {
    "title": "Thank you for looking at our API",
    "description": "The best way to get work done and keep people in sync.",
    "requester_id": 1,
    "assignee_id": 2,
    "due_date": "10-25-2021"
  }
}

```
> The above command returns JSON structured like this:

```json
{
  {"data"=>
    {"id"=>"19",
     "type"=>"tasks",
     "links"=>{"self"=>"http://hq.lvh.me:4000/api/external/tasks/19"},
     "attributes"=>
      {"title"=>"Thank you for looking at our API",
       "description"=>"The best way to get work done and keep people in sync.",
       "created_at"=>"2015-12-10T12:43:50-08:00",
       "updated_at"=>"2015-12-10T12:43:50-08:00",
       "due_date"=>"10-25-2021",
       "last_message"=>""},
     "relationships"=>
      {"assignee"=>
        {"links"=>
          {"self"=>
            "http://hq.lvh.me:4000/api/external/tasks/19/relationships/assignee",
           "related"=>"http://hq.lvh.me:4000/api/external/tasks/19/assignee"},
         "data"=>{"type"=>"users", "id"=>"1"}},
       "creator"=>
        {"links"=>
          {"self"=>
            "http://hq.lvh.me:4000/api/external/tasks/19/relationships/creator",
           "related"=>"http://hq.lvh.me:4000/api/external/tasks/19/creator"},
         "data"=>{"type"=>"users", "id"=>"2"}},
       "requester"=>
        {"links"=>
          {"self"=>
            "http://hq.lvh.me:4000/api/external/tasks/19/relationships/requester",
           "related"=>
            "http://hq.lvh.me:4000/api/external/tasks/19/requester"},
         "data"=>{"type"=>"users", "id"=>"2"}},
       "tasklist"=>
        {"links"=>
          {"self"=>
            "http://hq.lvh.me:4000/api/external/tasks/19/relationships/tasklist",
           "related"=>
            "http://hq.lvh.me:4000/api/external/tasks/19/tasklist"}},
       "team"=>
        {"links"=>
          {"self"=>
            "http://hq.lvh.me:4000/api/external/tasks/19/relationships/team",
           "related"=>"http://hq.lvh.me:4000/api/external/tasks/19/team"},
         "data"=>nil},
       "comments"=>
        {"links"=>
          {"self"=>
            "http://hq.lvh.me:4000/api/external/tasks/19/relationships/comments",
           "related"=>
            "http://hq.lvh.me:4000/api/external/tasks/19/comments"}}}},
   "included"=>
    [{"id"=>"1",
      "type"=>"users",
      "links"=>{"self"=>"http://hq.lvh.me:4000/api/external/users/1"},
      "attributes"=>
       {"first_name"=>"Mike",
        "last_name"=>"Tria",
        "email"=>"mike@scalus.com",
        "kind"=>"firm",
        "status"=>"active"}},
     {"id"=>"2",
      "type"=>"users",
      "links"=>{"self"=>"http://hq.lvh.me:4000/api/external/users/2"},
      "attributes"=>
       {"first_name"=>"Kristen Koh",
        "last_name"=>"Goldstein",
        "email"=>"kristen@scalus.com",
        "kind"=>"firm",
        "status"=>"active"}}]}
```

This endpoint creates a task.

### HTTP Request

`POST http://organization_slug.scalus.com/api/tasks`

### Query Parameters

Parameter | Required | Description
--------- | ------- | -----------
title | true | The title of the task
description | false | A short description of the task between 0 & 250 characters
requester_id | false | ID of the `User` that requested the task
assignee_id | false | ID of the `User` that is assigned the task
due_date | false | Date that the task is due

<aside class="notice">
You must replace <code>organization\_slug</code> with your personal slug. (your subdomain in scalus is your organization\_slug)
</aside>

## Get a Specific Task

```shell
curl
-F access_token="YOUR_ACCESS_TOKEN"
-X GET http://localhost:3000/api/tasks/19
```

```ruby
require 'rest-client'
require 'json'

client_id     = '4ea1b...'
client_secret = 'a2982...'

response = RestClient.post 'http://organization_slug.scalus.com/api/tasks/19', {
  access_token: 'YOUR_ACCESS_TOKEN'
}

```

> The above command returns JSON structured like this:

```json
{"data"=>
  {"id"=>"19",
   "type"=>"tasks",
   "links"=>{"self"=>"http://hq.lvh.me:4000/api/external/tasks/19"},
   "attributes"=>
    {"title"=>"Thank you for looking at our API",
     "description"=>"The best way to get work done and keep people in sync.",
     "created_at"=>"2015-12-10T12:43:50-08:00",
     "updated_at"=>"2015-12-10T12:43:50-08:00",
     "due_date"=>"10-25-2021",
     "last_message"=>""},
   "relationships"=>
    {"assignee"=>
      {"links"=>
        {"self"=>
          "http://hq.lvh.me:4000/api/external/tasks/19/relationships/assignee",
         "related"=>"http://hq.lvh.me:4000/api/external/tasks/19/assignee"},
       "data"=>{"type"=>"users", "id"=>"1"}},
     "creator"=>
      {"links"=>
        {"self"=>
          "http://hq.lvh.me:4000/api/external/tasks/19/relationships/creator",
         "related"=>"http://hq.lvh.me:4000/api/external/tasks/19/creator"},
       "data"=>{"type"=>"users", "id"=>"2"}},
     "requester"=>
      {"links"=>
        {"self"=>
          "http://hq.lvh.me:4000/api/external/tasks/19/relationships/requester",
         "related"=>
          "http://hq.lvh.me:4000/api/external/tasks/19/requester"},
       "data"=>{"type"=>"users", "id"=>"2"}},
     "tasklist"=>
      {"links"=>
        {"self"=>
          "http://hq.lvh.me:4000/api/external/tasks/19/relationships/tasklist",
         "related"=>
          "http://hq.lvh.me:4000/api/external/tasks/19/tasklist"}},
     "team"=>
      {"links"=>
        {"self"=>
          "http://hq.lvh.me:4000/api/external/tasks/19/relationships/team",
         "related"=>"http://hq.lvh.me:4000/api/external/tasks/19/team"},
       "data"=>nil},
     "comments"=>
      {"links"=>
        {"self"=>
          "http://hq.lvh.me:4000/api/external/tasks/19/relationships/comments",
         "related"=>
          "http://hq.lvh.me:4000/api/external/tasks/19/comments"}}}},
 "included"=>
  [{"id"=>"1",
    "type"=>"users",
    "links"=>{"self"=>"http://hq.lvh.me:4000/api/external/users/1"},
    "attributes"=>
     {"first_name"=>"Mike",
      "last_name"=>"Tria",
      "email"=>"mike@scalus.com",
      "kind"=>"firm",
      "status"=>"active"}},
   {"id"=>"2",
    "type"=>"users",
    "links"=>{"self"=>"http://hq.lvh.me:4000/api/external/users/2"},
    "attributes"=>
     {"first_name"=>"Kristen Koh",
      "last_name"=>"Goldstein",
      "email"=>"kristen@scalus.com",
      "kind"=>"firm",
      "status"=>"active"}}]}
```

This endpoint retreives a specific task if the user is authorized.

<aside class="warning">If you request a task that is not in your organization or the logged in user does not have permissions to see the task, the response will return 422 Unprocessable Entity.</aside>

### HTTP Request

`GET http://organization_slug.scalus.com/api/tasks/<ID>`

### URL Parameters

Parameter | Description
--------- | -----------
ID | The ID of the task to retrieve


# Users

## Get a Specific User

```shell
curl
-F access_token="YOUR_ACCESS_TOKEN"
-X GET http://localhost:3000/api/users/32
```

```ruby
require 'rest-client'
require 'json'

client_id     = '4ea1b...'
client_secret = 'a2982...'

response = RestClient.get 'http://organization_slug.scalus.com/api/users/32', {
  access_token: 'YOUR_ACCESS_TOKEN'
}

```

> The above command returns JSON structured like this:

```json
{"data"=>
  {"id"=>"32",
   "type"=>"users",
   "links"=>{"self"=>"http://hq.lvh.me:4000/api/external/users/32"},
   "attributes"=>
    {"first_name"=>"John",
     "last_name"=>"Goldstein",
     "email"=>"john.gold@scalus.com",
     "kind"=>"firm",
     "status"=>"active"}}}
```

Parameter | Description
--------- | -----------
first_name | First Name of the user
last_name | Last Name of the user
email | email of the user also used for logging in
status | status of the user, Can be active or inactive
organization_id | ID of the user’s organization
team | Team the user in associated to
kind | kind of user, Can be "Team" or "Organization"
send_task_notifications | Set to true if the user receives emails when events occur around tasks
has_daily_digest | Set to true if the user receives a daily email digest
created_at | time user was created in their organization’s time zone

