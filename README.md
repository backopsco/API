# Scalus's API

HOST: http://organization_slug.scalus.com/api/

Scalus's API allows developers to create tasks within the scalus ecosystem.


## Help Page

[GET][http://organization_slug.scalus.com/api/help]

+ Response 200 (application/json)

        [
            {
                "Welcome": "Thank you for looking at our API",
                "Documentation": "https://app.apiary.io/scalus/",
                "Contact": "We have a Slack channel setup at http://scalus.slack.com",
                "endpoints": [
                    {
                        "type": "Task",
                        "url": "http://organization_slug.scalus.com/api/tasks"
                    }, {
                        "type": "User",
                        "url": "http://organization_slug.scalus.com/api/users"
                    }
                ]
            }
        ]


## Oauth Overview

All developers need to register their application before getting started. A registered OAuth application is assigned a unique Client ID and Client Secret. The Client Secret should not be shared. You may create a personal access token for your own use or implement the web flow below to allow other users to authorize your application.

### Definitions


| Phrase | Definition | example  |
| --------- | -------- | :------- |
| **Resource Owner** | the user who wants to share a resource | john.smith@xyz.com |
| **Client** | the application that wants to leverage a resource hosted by scalus.com | your social network |
| **Authorization Server** | the entity that decides to grant access to the client | scalus.com's authorization server |
| **Resource Server** | the place where the third party resource is hosted | scalus.com's server where the task's & tasklists exist |


## Web Application Flow

#### 1) Redirect users to request access to Scalus

     GET https://organization_slug.scalus.com/oauth/authorize

Parameters

| Name | Type | Description  |
| --------- | -------- | :------- |
| **client_id** | string | The client ID on http://organization_slug.scalus.com/settings |
| **redirect_uri** | string | The URL in your app where users will be sent after authorization.  |

#### 2) Scalus redirects back to your site

If the user accepts your request, Scalus redirects back to your site with a temporary code in a `code` parameter.

Parameters

| Name | Type | Description  |
| --------- | -------- | :------- |
| **client_id** | string | The client ID on http://organization_slug.scalus.com/settings |
| **client_secret** | string | The client secret you received on http://organization_slug.scalus.com/settings |
| **code** | string | The code you received as a response to Step 1 |
| **redirect_uri** | string | The URL in your app where users will be sent after authorization.  |


Exchange this for an access token:

     POST https://organization_slug.scalus.com/oauth/token
     Authorization: Basic czZCaGRSa3F0MzpnWDFmQmF0M2JW
     Content-Type: application/x-www-form-urlencoded;charset=UTF-8
     grant_type=client_credentials

After that you'll have the access token in the response:

    token = JSON.parse(response)["access_token"]

#### 3)  Use the access token to access the API

The access token allows you to make requests to the API on a behalf of a user.

    GET https://organization_slug.scalus.com/api/tasks?access_token=...


https://github.com/doorkeeper-gem/doorkeeper/wiki/Enable-Refresh-Token-Credentials


* GET       /oauth/authorize/:code
* GET       /oauth/authorize
* POST      /oauth/authorize
* DELETE    /oauth/authorize
* POST      /oauth/token
* POST      /oauth/revoke
* resources /oauth/applications
* GET       /oauth/authorized_applications
* DELETE    /oauth/authorized_applications/:id
* GET       /oauth/token/info

## Testing with OAuth2 gem

```ruby
client = OAuth2::Client.new(client_id, client_secret, :site => 'https://organization_slug.scalus.com')
puts client.auth_code.authorize_url(:redirect_uri => redirect_uri)
# => http://organization_slug.scalus.com/oauth/authorize?response_type=code&client_id=...&redirect_uri=http%3A%2F%2Forganization_slug.scalus.com%3A9393%2Fcallback
```

Authorize the client and request the first access token with:

```ruby
token = client.auth_code.get_token(code, :redirect_uri => redirect_uri)
# POST '/oauth/token' with grant_type set to authorization_code
# => #<OAuth2::AccessToken:0x007fbcd38415b0 ...>
```

You can check the generated tokens with:

```ruby
token.token
# => 'c6212bdd8e4a2dd8218ac22d9cc703eac5ac5f439bafd31594d96ce5be6effa0'
token.refresh_token
# => '4ffee626f0058e1bc1f1a29a76dc4ac5978b27e674f58b7e58f4bd6872b0452b'
```

When time passes and the access token expires, you can refresh the old token, so you can continue accessing the provider's API.

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

## Creating a Task

[POST][http://organization_slug.scalus.com/api/tasks]

```
Request (application/json)

        "task": {
                "title": "Thank you for looking at our API",
                "description": "The best way to get work done and keep people in sync.",
                "requester_id": 1,
                "assignee_id": 1,
                "due_date": "10-25-2021",
        }

```

Response 200 (application/json)

```
{
  "data": {
    "type": "tasks",
    "id": "19",
    "attributes": {
      "title": "Thank you for looking at our API",
      "description": "The best way to get work done and keep people in sync.",
      "requester_id": 1,
      "assignee_id": 1,
      "created_by": 2,
      "due_date": "10-25-2021",
      "status": "not_started",
      "active_messages_count": 0,
      "source": "api",
      "created_at": "2015-09-19 20:59:55",
      "closed_at": nil
    },
    "links": {
      "self": "http://example.com/api/tasks/19"
    },
    "relationships": {
      "messages": {
        "links": {
          "self": "http://organization_slug.scalus.com/api/tasks/19/messages"
        },
        "data": [
          { "type": "messages", "id": "5" },
          { "type": "messages", "id": "12" }
        ]
      },
      "labels": {
        "links": {
          "self": "http://organization_slug.scalus.com/api/tasks/19/labels"
        },
        "data": [
          { "type": "labels", "id": "5" }
        ]
      }
    }
  },
  "included": [{
    "type": "labels",
    "id": "5",
    "attributes": {
      "name": "Milestone 1"
    },
    "links": {
      "self": "http://example.com/api/labels/5"
    }
  }]
}
```
