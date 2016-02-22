# Scalus's API

HOST: https://api.scalus.com/api/external/

Scalus's API allows developers to create tasks within the scalus ecosystem.


```
###################################################################
#  A Topic is a superclass that all Communications inherit from
#
#  A Communication Channel will accept a number of organizations_topics it wants communications for.
#    eg.  A mobile Device will by default want to hear all communications.
#         If the device adds a filter (NotificationFilter) they will not accept communications for
#         That type of message.
#
#  --------------                                --------------                ------------------
#  |  Org       |                                |Organizations|              |     Topic      |
#  |            |-------------------------------<| Topic      |>--------------|                |
#  |            |                                |            |               | medium         |
#  |            |                                |            |               | message_type   |
#  |            |                                |            |               | type           |
#  |            |                                |            |               | name           |
#  |            |                                |            |               | description    |
#  --------------                                --------------                ------------------
#        |                                             |
#        |                                             |
#       / \                                           / \
#  --------------        ------------------        ------------------
#  |  User      |        | Communication  |        |  Notification  |
#  |            |-------<| Channel        |-------<|  Filters       |
#  |            |        |                |        |                |
#  |            |        | type           |        |                |
#  |            |        | name           |        |                |
#  |            |        | meta           |        |                |
#  |            |        | options        |        |                |
#  |            |        | -------------  |        |                |
#  |            |        | medium (email) |        |                |
#  --------------        ------------------        ------------------
#
###################################################################
```

```
###################################################################
#
#  --------------         --------------                ------------------
#  |  Org       |         | Tasklist   |               |     Topic      |
#  |            |         |            |>--------------|                |
#  |            |         | title      |               | medium         |
#  |            |         |            |               | message_type   |
#  |            |         |            |               | type           |
#  |            |    /---<|            |               | name           |
#  |            |   /     |            |               | description    |
#  --------------  /      --------------                ------------------
#        |        /             |                  ------------------------
#        |       /              |                  |   Team               |
#        |      /               |                  |sorta like a client   |
#       / \    /               / \                 |or company that can't |
#  --------------        ------------------        |see your work but you |
#  |  User      |        | Task           |>-------|interact with them    |
#  |            |-------<|                |        ------------------------
#  |            |        |                |        |  Activity      |
#  |            |        | title          |-------<|  Items         |
#  |            |        | status         |        |                |
#  |            |        | due_date       |        |                |
#  |            |        |                |        ------------------
#  |            |        |                |        ------------------
#  |            |        |                |-------<|   Labels       |
#  --------------        ------------------        |                |
#                                 |                |                |
#                                / \               ------------------
#                        ------------------
#                        |   Messages     |
#                        |                |
#                        |                |
#                        ------------------
###################################################################
```

## Overview

- All requests must set the accept header to include the 'Content-Type' headers to "application/vnd.api+json" 
- The version of the API must be set in the Accept headers (currently version=1 is the only option). 
- Endpoints generally follow the jsonapi specifications.  http://jsonapi.org
- If an endpoint has a relationship that you would like to be side-loaded you can use "include=relationship" in the query params for the GET request.  EX. `GET /api/external/tasks/1?include=messages`

Look at our glossary:
http://help.scalus.com/support/solutions/articles/5000541650-glossary

# Activity Items

Activity Items the user is involved with.

paginated with the offset not the page number


Parameter | Description
--------- | -----------
event_type | brief word that describes what triggered the change
event_source | where the event was triggered (api, auto, email, webform) 
from | original value
to | new value
secondary_attribute | ...
target_title | this is the source's title if the source that changed has a title 
attribute_name | attribute that changed
read | indicates if the notification has been read or not.  Please POST <a href="#posttactitityitem">read = true</a> if a user reads the activity item.
metadata | a hash of more data

| related models |
| --------- |
| user |
| activity_item |


<h2 id="getactitityitems"><span class='green-btn'>GET</span> Activity Items</h2>

`GET https://api.scalus.com/api/external/activity_items`

```ruby
require 'rest-client'
require 'json'

client_id     = '4ea1b...'
client_secret = 'a2982...'

response = RestClient.get 'https://api.scalus.com/api/external/activity_items', {
  access_token: 'YOUR_ACCESS_TOKEN'
}

```

> The above command returns JSON structured like this:

```
{"data"=>
  [{"id"=>"9",
    "type"=>"activity_items",
    "links"=>{"self"=>"https://api.scalus.com/api/external/v1/activity_items/9"},
    "attributes"=>
     {"event_type"=>"task_created",
      "event_source"=>"webform",
      "from"=>nil,
      "to"=>nil,
      "created_at"=>"2016-01-19T17:08:20-08:00",
      "secondary_attribute"=>nil,
      "target_title"=>nil,
      "attribute_name"=>nil,
      "read"=>true,
      "resource_url"=>"http://firm-1.lvh.me:3000/api/external/tasks/3"},
    "relationships"=>
     {"activity_itemable"=>
       {"links"=>
         {"self"=>
           "https://api.scalus.com/api/external/v1/activity_items/9/relationships/activity_itemable",
          "related"=>
           "https://api.scalus.com/api/external/v1/activity_items/9/activity_itemable"}}}},
   {"id"=>"7",
    "type"=>"activity_items",
    "links"=>{"self"=>"https://api.scalus.com/api/external/v1/activity_items/7"},
    "attributes"=>
     {"event_type"=>"task_created",
      "event_source"=>"webform",
      "from"=>nil,
      "to"=>nil,
      "created_at"=>"2016-01-19T17:08:20-08:00",
      "secondary_attribute"=>nil,
      "target_title"=>nil,
      "attribute_name"=>nil},
    "relationships"=>
     {"activity_itemable"=>
       {"links"=>
         {"self"=>
           "https://api.scalus.com/api/external/v1/activity_items/7/relationships/activity_itemable",
          "related"=>
           "https://api.scalus.com/api/external/v1/activity_items/7/activity_itemable"}}}}],
 "links"=>
  {"first"=>
    "https://api.scalus.com/api/external/v1/activity_items?page%5Blimit%5D=20&page%5Boffset%5D=0",
   "last"=>
    "https://api.scalus.com/api/external/v1/activity_items?page%5Blimit%5D=20&page%5Boffset%5D=0"}}
```


<h2 id="getactitityitem"><span class='green-btn'>GET</span>  Activity Item</h2>

`GET https://api.scalus.com/api/external/activity_items/:id`

```ruby
require 'rest-client'
require 'json'

client_id     = '4ea1b...'
client_secret = 'a2982...'

response = RestClient.get 'https://api.scalus.com/api/external/activity_items/4', {
  access_token: 'YOUR_ACCESS_TOKEN'
}

```

> The above command returns JSON structured like this:

```
{"data"=>
  {"id"=>"4",
   "type"=>"activity_items",
   "links"=>{"self"=>"https://api.scalus.com/api/external/v1/activity_items/4"},
   "attributes"=>
    {"event_type"=>"task_created",
     "event_source"=>"webform",
     "from"=>nil,
     "to"=>nil,
     "created_at"=>"2016-01-19T17:13:45-08:00",
     "secondary_attribute"=>nil,
     "target_title"=>nil,
     "attribute_name"=>nil,
     "read"=>false,
     "resource_url"=>"http://firm-1.lvh.me:3000/api/external/tasks/3"},
   "relationships"=>
    {"activity_itemable"=>
      {"links"=>
        {"self"=>
          "https://api.scalus.com/api/external/v1/activity_items/4/relationships/activity_itemable",
         "related"=>
          "https://api.scalus.com/api/external/v1/activity_items/4/activity_itemable"}}}}}
```



<h2 id="posttactitityitem"><span class='blue-btn'>PUT</span>  Activity Item</h2>

Use only to change the "read" status.

`PUT https://api.scalus.com/api/external/activity_items/:id`

```ruby
require 'rest-client'
require 'json'

client_id     = '4ea1b...'
client_secret = 'a2982...'

response = RestClient.put 'https://api.scalus.com/api/external/activity_items/4', {
  access_token: 'YOUR_ACCESS_TOKEN',
  data: {
    type: 'activity_items',
    attributes: {
      read:         'true'
    }
  }
}

```

> The above command returns JSON structured like this:

```
{"data"=>
  {"id"=>"4",
   "type"=>"activity_items",
   "links"=>{"self"=>"https://api.scalus.com/api/external/v1/activity_items/4"},
   "attributes"=>
    {"event_type"=>"task_created",
     "event_source"=>"webform",
     "from"=>nil,
     "to"=>nil,
     "created_at"=>"2016-01-19T17:13:45-08:00",
     "secondary_attribute"=>nil,
     "target_title"=>nil,
     "attribute_name"=>nil,
     "read"=>true,
     "resource_url"=>"http://firm-1.lvh.me:3000/api/external/tasks/3"},
   "relationships"=>
    {"activity_itemable"=>
      {"links"=>
        {"self"=>
          "https://api.scalus.com/api/external/v1/activity_items/4/relationships/activity_itemable",
         "related"=>
          "https://api.scalus.com/api/external/v1/activity_items/4/activity_itemable"}}}}}
```



# Communication Channels

A communication Channel represents any form of communication that Scalus can contact a user.  Ex. Email Channel, Mobile Channel, Slack Channel.

Parameter | Description | Examples
--------- | ----------- | -----------
name | The name the user has given to their contact info | "Primary Email" <br /> "My Primary Phone"
identifier | The value of the channels contact info | john.doe@my_email.com <br /> 315-555-1234
identifier_name | name of what the identifier represents | "email" <br /> "number"

| Types of Channels |
| --------- |
| email_channels |
| mobile_channels |

<h2 id="getchannels"><span class='green-btn'>GET</span> Communication Channels</h2>

`GET https://api.scalus.com/api/external/communication_channels`

Returns all the Communication Channels related to the currently logged in user.

```shell
curl
-F access_token="YOUR_ACCESS_TOKEN"
-X GET https://api.scalus.com/api/external/communication_channels
-H "Accept: application/vnd.api+json; version=1"
-H "Content-Type: application/vnd.api+json"
```

```ruby
require 'rest-client'
require 'json'

client_id     = '4ea1b...'
client_secret = 'a2982...'

response = RestClient.get 'https://api.scalus.com/api/external/communication_channels', {
  access_token: 'YOUR_ACCESS_TOKEN'
}

```

> The above command returns JSON structured like this:


```json

{"data"=>
  [{"id"=>"7",
    "type"=>"email_channels",
    "links"=>{"self"=>"https://api.scalus.com/api/external/v1/email_channels/7"},
    "attributes"=>
     {"name"=>"my best contact",
      "identifier"=>"test@email.co",
      "identifier_name"=>"email"}},
   {"id"=>"9",
    "type"=>"email_channels",
    "links"=>{"self"=>"https://api.scalus.com/api/external/v1/email_channels/9"},
    "attributes"=>
     {"name"=>"My email",
      "identifier"=>"test@email2.co",
      "identifier_name"=>"email"}}],
 "links"=>
  {"first"=>
    "https://api.scalus.com/api/external/v1/communication_channels?page%5Bnumber%5D=1&page%5Bsize%5D=20",
   "last"=>
    "https://api.scalus.com/api/external/v1/communication_channels?page%5Bnumber%5D=1&page%5Bsize%5D=20"}}

```


<h2 id="getchannel"><span class='green-btn'>GET</span> Communication Channel</h2>

`GET https://api.scalus.com/api/external/communication_channels/:id`

Returns a specific Communication Channel related to the currently logged in user.

```shell
curl
-F access_token="YOUR_ACCESS_TOKEN"
-X GET https://api.scalus.com/api/external/communication_channels/4
-H "Accept: application/vnd.api+json; version=1"
-H "Content-Type: application/vnd.api+json"
```

```ruby
require 'rest-client'
require 'json'

client_id     = '4ea1b...'
client_secret = 'a2982...'

response = RestClient.get 'https://api.scalus.com/api/external/communication_channels/4', {
  access_token: 'YOUR_ACCESS_TOKEN'
}

```

> The above command returns JSON structured like this:

```json

{"data"=>
  {"id"=>"4",
   "type"=>"email_channels",
   "links"=>{"self"=>"https://api.scalus.com/api/external/v1/email_channels/4"},
   "attributes"=>
    {"name"=>"My business Email",
     "identifier"=>"test@email.co",
     "identifier_name"=>"email"
    }
  }
}
```


<h2 id="postemailchannel"><span class='blue-btn'>POST</span> Email Channel</h2>

`POST https://api.scalus.com/api/email_channels`

Creates a Email Channel related to the currently logged in user.

```shell
curl
-F access_token="YOUR_ACCESS_TOKEN"
-X POST https://api.scalus.com/api/external/email_channels
-H "Accept: application/vnd.api+json; version=1"
-H "Content-Type: application/vnd.api+json"
```

```ruby
require 'rest-client'
require 'json'

client_id     = '4ea1b...'
client_secret = 'a2982...'

response = RestClient.get 'https://api.scalus.com/api/external/email_channels/4', {
  access_token: 'YOUR_ACCESS_TOKEN'
  "data"=>
    { id: 4,
      type: 'email_channels',
     "attributes"=>
      {
			 "name"=>"My personal email",
       "email"=>"fred@test.com"
      }
    }
 
}

```

> The above command returns JSON structured like this:

```json

{"data"=>
  {"id"=>"4",
   "type"=>"email_channels",
   "links"=>{"self"=>"https://api.scalus.com/api/external/v1/email_channels/4"},
   "attributes"=>
    {"name"=>"My personal email",
     "identifier"=>"fred@test.com",
     "identifier_name"=>"number"
    }
  }
}
```



<h2 id="postmobilechannel"><span class='blue-btn'>POST</span> Mobile Channel</h2>

`POST https://api.scalus.com/api/mobile_channels`

Creates a Mobile Channel related to the currently logged in user.

```shell
curl
-F access_token="YOUR_ACCESS_TOKEN"
-X POST https://api.scalus.com/api/external/mobile_channels
-H "Accept: application/vnd.api+json; version=1"
-H "Content-Type: application/vnd.api+json"
```

```ruby
require 'rest-client'
require 'json'

client_id     = '4ea1b...'
client_secret = 'a2982...'

response = RestClient.get 'https://api.scalus.com/api/external/mobile_channels/4', {
  access_token: 'YOUR_ACCESS_TOKEN'
  "data"=>
    { id: 4,
      type: 'mobile_channels',
     "attributes"=>
      {"name"=>"My cell Phone",
       "number"=>"315-555-1234"
      }
    }
 
}

```

> The above command returns JSON structured like this:

```json

{"data"=>
  {"id"=>"4",
   "type"=>"mobile_channels",
   "links"=>{"self"=>"https://api.scalus.com/api/external/v1/mobile_channels/4"},
   "attributes"=>
    {"name"=>"My cell Phone",
     "identifier"=>"315-555-1234",
     "identifier_name"=>"number"
    }
  }
}
```


<h2 id="deletechannel"><span class='red-btn'>DELETE</span> Communication Channel Deactivation</h2>

`DELETE https://api.scalus.com/api/external/communication_channel_activations/:id`

Inactivates a specific Communication Channel related to the currently logged in user.  After you inactivate a channel it will no longer receive notifications.


```ruby
require 'rest-client'
require 'json'

client_id     = '4ea1b...'
client_secret = 'a2982...'

response = RestClient.get 'https://api.scalus.com/api/external/communication_channel_activations/8', {
  access_token: 'YOUR_ACCESS_TOKEN'
}

```

> The above command returns JSON structured like this:

```json

{"data"=>
  {"id"=>"8",
   "type"=>"email_channels",
   "links"=>{"self"=>"/api/external/v1/email_channels/8"},
   "attributes"=>
    {"name"=>"My Personal email",
     "identifier"=>"test@email.co",
     "identifier_name"=>"email",
     "active"=>false
    }
  }
}
```


<h2 id="activatechannel"><span class='red-btn'>POST</span> Communication Channel Activation</h2>

`POST https://api.scalus.com/api/external/communication_channel_activations/:id`

Activates a specific Communication Channel related to the currently logged in user.  After you inactivate a channel it will no longer receive notifications.


```ruby
require 'rest-client'
require 'json'

client_id     = '4ea1b...'
client_secret = 'a2982...'

response = RestClient.get 'https://api.scalus.com/api/external/communication_channel_activations/8', {
  access_token: 'YOUR_ACCESS_TOKEN'
}

```

> The above command returns JSON structured like this:

```json

{"data"=>
  {"id"=>"8",
   "type"=>"email_channels",
   "links"=>{"self"=>"/api/external/v1/email_channels/8"},
   "attributes"=>
    {"name"=>"My Personal email",
     "identifier"=>"test@email.co",
     "identifier_name"=>"email",
     "active"=>true
    }
  }
}
```
# File Uploads

File uploads happen in a two set process.  The first step a file is uploaded and a token is returned as a responce.  Using the token\_id returned in the responce.  The file can then be attached to a <a href="#messages">message</a>.

You can attach files of the following format to a task: PDF, JPG, PNG, .xls, .xlsx, .doc, .docx, and .txt


<h2 id="postfile"><span class='blue-btn'>POST</span> File Upload</h2>

`POST https://api.scalus.com/api/external/file_uploads`


```ruby
require 'rest-client'
require 'json'

client_id     = '4ea1b...'
client_secret = 'a2982...'

response = RestClient.post 'https://api.scalus.com/api/external/file_uploads', {
  access_token: 'YOUR_ACCESS_TOKEN',
  content_type: 'image/jpeg'
  file_upload:  { doc: File.new("/path/to/test.jpg", 'rb') }
}

```

> The above command returns JSON structured like this:

```json
{"data"=>
  {"id"=>"4",
   "type"=>"file_attachments",
   "links"=>{"self"=>"/api/external/v1/file_attachments/4"},
   "attributes"=>
    {"doc_content_type"=>"image/jpg",
     "doc_file_name"=>"test.jpg",
     "token_id"=>
      "SGlCMkx6b2FDMHVnMEdJaXhCVUxnb3dHMzZHdTVZdXNITUtUL0hZOXVLcz0tLWJER25MM1pPMWJZWlNVUDlpa2RwM3c9PQ==--4cd8b53da6b12a7b5ec5e6afa83af33d2f84f34e",
     "display_file_size"=>"1.75 KB",
     "doc_url"=>
      "https://s3.amazonaws.com/backops-dev/docs/4/test.jpg?1452287068"
    }
  }
}
```

> now to attach the file to a comment do the following

```ruby
require 'rest-client'
require 'json'

client_id     = '4ea1b...'
client_secret = 'a2982...'

response = RestClient.post 'https://api.scalus.com/api/external/messages', {
  access_token: 'YOUR_ACCESS_TOKEN',
  data: {
    type: 'messages',
    attributes: {
      body:         'Sample Comment from Attributes',
      internal:     'false',
      file_tokens:  ['SGlCMkx6b2FDMHVnMEdJaXhCVUxnb3dHMzZHdTVZdXNITUtUL0hZOXVLcz0tLWJER25MM1pPMWJZWlNVUDlpa2RwM3c9PQ==--4cd8b53da6b12a7b5ec5e6afa83af33d2f84f34e'],
      external_emails: ['john.james@yaho.comm', 'john.james2@yaho.cmm']
    }
  }
}

```

# Labels

A tag to group similar tasks or tasklists together to allow for easier searching in the future.

Parameter | Description
--------- | -----------
name | The name the label

<h2 id="getlabels"><span class='green-btn'>GET</span> Labels</h2>

`GET https://api.scalus.com/api/external/labels`

Returns all the Labels related to the firm of the logged in user.

```shell
curl
-F access_token="YOUR_ACCESS_TOKEN"
-X GET https://api.scalus.com/api/external/labels
-H "Accept: application/vnd.api+json; version=1"
-H "Content-Type: application/vnd.api+json"
```

```ruby
require 'rest-client'
require 'json'

client_id     = '4ea1b...'
client_secret = 'a2982...'

response = RestClient.get 'https://api.scalus.com/api/external/labels', {
  access_token: 'YOUR_ACCESS_TOKEN'
}

```

> The above command returns JSON structured like this:

```json
{"data"=>
  [{"id"=>"13",
    "type"=>"labels",
    "links"=>{"self"=>"http://firm-9.scalus.com/api/external/v1/labels/13"},
    "attributes"=>{"name"=>"one", "status"=>"active"}},
   {"id"=>"14",
    "type"=>"labels",
    "links"=>{"self"=>"http://firm-9.scalus.com/api/external/v1/labels/14"},
    "attributes"=>{"name"=>"two", "status"=>"active"}}],
 "links"=>
  {"first"=>
    "http://firm-9.scalus.com/api/external/v1/labels?page%5Bnumber%5D=1&page%5Bsize%5D=20",
   "last"=>
    "http://firm-9.scalus.com/api/external/v1/labels?page%5Bnumber%5D=1&page%5Bsize%5D=20"
  }
}
```

<h2 id="getlabel"><span class='green-btn'>GET</span> Label</h2>

`GET https://api.scalus.com/api/external/labels/:id`

Returns a specific label related to the firm of the logged in user.

```shell
curl
-F access_token="YOUR_ACCESS_TOKEN"
-X GET https://api.scalus.com/api/external/labels/4
-H "Accept: application/vnd.api+json; version=1"
-H "Content-Type: application/vnd.api+json"
```

```ruby
require 'rest-client'
require 'json'

client_id     = '4ea1b...'
client_secret = 'a2982...'

response = RestClient.get 'https://api.scalus.com/api/external/labels/4', {
  access_token: 'YOUR_ACCESS_TOKEN'
}

```

> The above command returns JSON structured like this:

```json

{"data"=>
  {"id"=>"4",
   "type"=>"labels",
   "links"=>{"self"=>"http://firm-3.scalus.com/api/external/v1/labels/4"},
   "attributes"=>{"name"=>"Urgent", "status"=>"active"}
  }
}
```

<h2 id="postlabel"><span class='blue-btn'>POST</span> Label</h2>

`POST https://api.scalus.com/api/labels`


```shell
curl
-F access_token="YOUR_ACCESS_TOKEN"
-X POST https://api.scalus.com/api/external/labels
-H "Accept: application/vnd.api+json; version=1"
-H "Content-Type: application/vnd.api+json"
```

```ruby
require 'rest-client'
require 'json'

client_id     = '4ea1b...'
client_secret = 'a2982...'

response = RestClient.post 'https://api.scalus.com/api/external/labels', {
  access_token: 'YOUR_ACCESS_TOKEN',
  data: {
    type: 'labels',
    attributes: {
      name: 'Low Priority'
    }
  }
}

```

> The above command returns JSON structured like this:

```json

{"data"=>
  {"id"=>"4",
   "type"=>"labels",
   "links"=>{"self"=>"http://firm-3.scalus.com/api/external/v1/labels/4"},
   "attributes"=>{"name"=>"Low Priority", "status"=>"active"}
  }
}
```


<h2 id="putlabel"><span class='blue-btn'>PUT</span> Label</h2>

`PUT https://api.scalus.com/api/labels/:id`


```shell
curl
-F access_token="YOUR_ACCESS_TOKEN"
-X PUT https://api.scalus.com/api/external/labels/4
-H "Accept: application/vnd.api+json; version=1"
-H "Content-Type: application/vnd.api+json"
```

```ruby
require 'rest-client'
require 'json'

client_id     = '4ea1b...'
client_secret = 'a2982...'

response = RestClient.put 'https://api.scalus.com/api/external/labels/4', {
  access_token: 'YOUR_ACCESS_TOKEN',
  data: {
    type: 'labels',
    attributes: {
      name: 'Zero Priority'
    }
  }
}

```

> The above command returns JSON structured like this:

```json

{"data"=>
  {"id"=>"4",
   "type"=>"labels",
   "links"=>{"self"=>"http://firm-3.scalus.com/api/external/v1/labels/4"},
   "attributes"=>{"name"=>"Zero Priority", "status"=>"active"}
  }
}
```

<h2 id="deletelabel"><span class='red-btn'>DELETE</span> Label</h2>

`DELETE https://api.scalus.com/api/external/labels/:id`


```ruby
require 'rest-client'
require 'json'

client_id     = '4ea1b...'
client_secret = 'a2982...'

response = RestClient.delete 'https://api.scalus.com/api/external/labels/4', {
  access_token: 'YOUR_ACCESS_TOKEN',
}

```

> The above command returns JSON structured like this:

```
{"data"=>
  {"id"=>"4",
   "type"=>"labels",
   "links"=>{"self"=>"/api/external/v1/labels/4"},
   "attributes"=>{"name"=>"one", "status"=>"deleted"}}}
```

# Messages

Messages are appended to a task so users can communicate with each other.


Parameter | Description
--------- | -----------
body | text of the comment to display
body\_markup | simple HTML markup of the comment to display
internal | Boolean set to true if the message is only for messages that can only be seen by those within your organization 
created\_at | timestamp when the message was created


| related models |
| --------- |
| creator (user) |
| task |

## Internal Messages

Internal messages on tasks can only be seen by those within your organization. They can not be seen by external team members or Third Party Email team members.


`GET https://api.scalus.com/api/external/messages?filter[internal]=true`

## External Messages

Messages marked as external (and highlighted green) are the only messaged that can be seen by External Team Members and Third Party Email team members

<h2 id="getmessages"><span class='green-btn'>GET</span> Messages</h2>

`GET https://api.scalus.com/api/external/messages?filter[internal]=false`

Returns all the Messages related to the task 

```shell
curl
-F access_token="YOUR_ACCESS_TOKEN"
-F task_id=12
-X GET https://api.scalus.com/api/external/messages
-H "Accept: application/vnd.api+json; version=1"
-H "Content-Type: application/vnd.api+json"
```

```ruby
require 'rest-client'
require 'json'

client_id     = '4ea1b...'
client_secret = 'a2982...'

response = RestClient.get 'https://api.scalus.com/api/external/messages/?task_id=12', {
  access_token: 'YOUR_ACCESS_TOKEN', 
  filter: { internal: 'false'}
}

```

> The above command returns JSON structured like this:


```json
{"data"=>
  [{"id"=>"3",
    "type"=>"messages",
    "links"=>{"self"=>"https://api.scalus.com/api/external/v1/messages/3"},
    "attributes"=>
     {"body"=>"Yabba Dabba Do",
      "body_markup"=>"<p>Yabba Dabba Do</p>",
      "internal"=>false,
      "created_at"=>"2016-01-07T14:16:25-08:00"},
    "relationships"=>
     {"creator"=>
       {"links"=>
         {"self"=>
           "https://api.scalus.com/api/external/v1/messages/3/relationships/creator",
          "related"=>"https://api.scalus.com/api/external/v1/messages/3/creator"}},
      "task"=>
       {"links"=>
         {"self"=>
           "https://api.scalus.com/api/external/v1/messages/3/relationships/task",
          "related"=>"https://api.scalus.com/api/external/v1/messages/3/task"}}}},
   {"id"=>"2",
    "type"=>"messages",
    "links"=>{"self"=>"https://api.scalus.com/api/external/v1/messages/2"},
    "attributes"=>
     {"body"=>"Is That you Fred?",
      "body_markup"=>"<p>Is That you Fred?</p>",
      "internal"=>false,
      "created_at"=>"2016-01-07T14:16:25-08:00"},
    "relationships"=>
     {"creator"=>
       {"links"=>
         {"self"=>
           "https://api.scalus.com/api/external/v1/messages/2/relationships/creator",
          "related"=>"https://api.scalus.com/api/external/v1/messages/2/creator"}},
      "task"=>
       {"links"=>
         {"self"=>
           "https://api.scalus.com/api/external/v1/messages/2/relationships/task",
          "related"=>"https://api.scalus.com/api/external/v1/messages/2/task"}}}}],
 "links"=>
  {"first"=>
    "https://api.scalus.com/api/external/v1/messages?page%5Bnumber%5D=1&page%5Bsize%5D=20",
   "last"=>
    "https://api.scalus.com/api/external/v1/messages?page%5Bnumber%5D=1&page%5Bsize%5D=20"
  }
}
```

<h2 id="getmessage"><span class='green-btn'>GET</span> Message</h2>

`GET https://api.scalus.com/api/external/messages/:id`

```shell
curl
-F access_token="YOUR_ACCESS_TOKEN"
-F task_id=12
-X GET https://api.scalus.com/api/external/messages/32
-H "Accept: application/vnd.api+json; version=1"
-H "Content-Type: application/vnd.api+json"
```

```ruby
require 'rest-client'
require 'json'

client_id     = '4ea1b...'
client_secret = 'a2982...'

response = RestClient.get 'https://api.scalus.com/api/external/messages/32/?task_id=12', {
  access_token: 'YOUR_ACCESS_TOKEN'
}

```

> The above command returns JSON structured like this:

```json
{"data"=>
  {"id"=>"32",
   "type"=>"messages",
   "links"=>{"self"=>"https://api.scalus.com/api/external/v1/messages/32"},
   "attributes"=>
    {"body"=>"Is That you Fred?",
     "body_markup"=>"<p>Is That you Fred?</p>",
     "internal"=>false,
     "created_at"=>"2016-01-07T14:27:54-08:00"},
   "relationships"=>
    {"creator"=>
      {"links"=>
        {"self"=>
          "https://api.scalus.com/api/external/v1/messages/32/relationships/creator",
         "related"=>"https://api.scalus.com/api/external/v1/messages/32/creator"}},
     "task"=>
      {"links"=>
        {"self"=>
          "https://api.scalus.com/api/external/v1/messages/32/relationships/task",
         "related"=>"https://api.scalus.com/api/external/v1/messages/32/task"
        }
      }
    }
  }
}
```

<h2 id="postmessages"><span class='blue-btn'>POST</span> Message</h2>

`POST https://api.scalus.com/api/external/messages/:id`

NOTE: If you need to attach a file, first you need to create a token_id as shown in <a href="#postfile">file uploads</a>

```ruby
require 'rest-client'
require 'json'

client_id     = '4ea1b...'
client_secret = 'a2982...'

response = RestClient.post 'https://api.scalus.com/api/external/messages', {
  access_token: 'YOUR_ACCESS_TOKEN',
  data: {
    type: 'messages',
    attributes: {
      body:         'Sample Comment from Attributes',
      internal:     'false',
      file_tokens:  ['SGlCMkx6b2FDMHVnMEdJaXhCVUxnb3dHMzZHdTVZdXNITUtUL0hZOXVLcz0tLWJER25MM1pPMWJZWlNVUDlpa2RwM3c9PQ==--4cd8b53da6b12a7b5ec5e6afa83af33d2f84f34e'],
      external_emails: ['john.james@yaho.comm', 'john.james2@yaho.cmm']
    }
  }
}

```


> The above command returns JSON structured like this:

```json
{"data"=>
  {"id"=>"32",
   "type"=>"messages",
   "links"=>{"self"=>"https://api.scalus.com/api/external/v1/messages/32"},
   "attributes"=>
    {"body"=>"Is That you Fred?",
     "body_markup"=>"<p>Is That you Fred?</p>",
     "internal"=>false,
     "created_at"=>"2016-01-07T14:27:54-08:00"},
   "relationships"=>
    {"creator"=>
      {"links"=>
        {"self"=>
          "https://api.scalus.com/api/external/v1/messages/32/relationships/creator",
         "related"=>"https://api.scalus.com/api/external/v1/messages/32/creator"}},
     "task"=>
      {"links"=>
        {"self"=>
          "https://api.scalus.com/api/external/v1/messages/32/relationships/task",
         "related"=>"https://api.scalus.com/api/external/v1/messages/32/task"
        }
      }
    }
  }
}
```


# Notification Filters


Parameter | Description
--------- | -----------
name | Name of the topic to be filtered
message\_type | type of message being sent (Ex. message_added) 
medium |  The communication medium (Ex. email or mobile) 
topic\_id | UID of the topic being filtered

| related models |
| --------- |
| organizations_topic |
| communication_channel |


<h2 id="getfilters"><span class='green-btn'>GET</span> Notification Filters</h2>

`GET https://api.scalus.com/api/external/notification_filters`

Returns all the Notification Filters related to the logged in user.

```shell
curl
-F access_token="YOUR_ACCESS_TOKEN"
-X GET https://api.scalus.com/api/external/notification_filters
-H "Accept: application/vnd.api+json; version=1"
-H "Content-Type: application/vnd.api+json"
```

```ruby
require 'rest-client'
require 'json'

client_id     = '4ea1b...'
client_secret = 'a2982...'

response = RestClient.get 'https://api.scalus.com/api/external/notification_filters', {
  access_token: 'YOUR_ACCESS_TOKEN'
}

```

> The above command returns JSON structured like this:

```json
{"data"=>
  [{"id"=>"1",
    "type"=>"notification_filters",
    "links"=>
     {"self"=>"https://api.scalus.com/api/external/v1/notification_filters/1"},
    "attributes"=>
     {"topic_id"=>1,
      "medium"=>"email",
      "message_type"=>"message_added",
      "name"=>"Message Added"},
    "relationships"=>
     {"organizations_topic"=>
       {"links"=>
         {"self"=>
           "https://api.scalus.com/api/external/v1/notification_filters/1/relationships/organizations_topic",
          "related"=>
           "https://api.scalus.com/api/external/v1/notification_filters/1/organizations_topic"}},
      "communication_channel"=>
       {"links"=>
         {"self"=>
           "https://api.scalus.com/api/external/v1/notification_filters/1/relationships/communication_channel",
          "related"=>
           "https://api.scalus.com/api/external/v1/notification_filters/1/communication_channel"}}}},
   {"id"=>"2",
    "type"=>"notification_filters",
    "links"=>
     {"self"=>"https://api.scalus.com/api/external/v1/notification_filters/2"},
    "attributes"=>
     {"topic_id"=>10,
      "medium"=>"mobile",
      "message_type"=>"task_ready",
      "name"=>"Task Ready"},
    "relationships"=>
     {"organizations_topic"=>
       {"links"=>
         {"self"=>
           "https://api.scalus.com/api/external/v1/notification_filters/2/relationships/organizations_topic",
          "related"=>
           "https://api.scalus.com/api/external/v1/notification_filters/2/organizations_topic"}},
      "communication_channel"=>
       {"links"=>
         {"self"=>
           "https://api.scalus.com/api/external/v1/notification_filters/2/relationships/communication_channel",
          "related"=>
           "https://api.scalus.com/api/external/v1/notification_filters/2/communication_channel"}}}}],
 "links"=>
  {"first"=>
    "https://api.scalus.com/api/external/v1/notification_filters?page%5Bnumber%5D=1&page%5Bsize%5D=20",
   "last"=>
    "https://api.scalus.com/api/external/v1/notification_filters?page%5Bnumber%5D=1&page%5Bsize%5D=20"
  }
}
```

<h2 id="postfilter"><span class='blue-btn'>POST</span> Notification Filter</h2>

`POST https://api.scalus.com/api/external/notification_filters`


```ruby
require 'rest-client'
require 'json'

client_id     = '4ea1b...'
client_secret = 'a2982...'

response = RestClient.post 'https://api.scalus.com/api/external/notification_filters', {
  access_token: 'YOUR_ACCESS_TOKEN',
   topic_id: 10, 
   communication_channel_id: 2
}

```


<h2 id="deletefilter"><span class='red-btn'>DELETE</span> Notification Filter</h2>

`DELETE https://api.scalus.com/api/notification_filters/:id`

# Organization's Topics

Organization's Topics are representations of the types of communications that can possibly be sent to users.

- Ex1.  Scalus can send an email when a message is added to a topic.
- Ex2.  Scalus can notify a mobile device when a message is added to a topic.

Parameter | Description
--------- | -----------
name | Name of the topic to be filtered
message\_type | type of message being sent (Ex. message_added) 
medium |  The communication medium (Ex. email or mobile) 
description | description of the topic
topic\_id | UID of the topic being filtered


<h2 id="getorgtopics"><span class='green-btn'>GET</span> Organization's Topics</h2>

`GET https://api.scalus.com/api/external/organizations_topics`

Returns all the Organization's Topics related to the firm of the logged in user.

```shell
curl
-F access_token="YOUR_ACCESS_TOKEN"
-X GET https://api.scalus.com/api/external/organizations_topics
-H "Accept: application/vnd.api+json; version=1"
-H "Content-Type: application/vnd.api+json"
```

```ruby
require 'rest-client'
require 'json'

client_id     = '4ea1b...'
client_secret = 'a2982...'

response = RestClient.get 'https://api.scalus.com/api/external/organizations_topics', {
  access_token: 'YOUR_ACCESS_TOKEN'
}

```

> The above command returns JSON structured like this:

```json
{"data"=>
  [{"id"=>"4",
    "type"=>"organizations_topics",
    "links"=>
     {"self"=>"https://api.scalus.com/api/external/v1/organizations_topics/4"},
    "attributes"=>
     {"name"=>"Message Added",
      "medium"=>"email",
      "message_type"=>"message_added",
      "description"=>
       "Send notification to email when a message is added to a task that I follow.",
      "topic_id"=>1}},
   {"id"=>"8",
    "type"=>"organizations_topics",
    "links"=>
     {"self"=>"https://api.scalus.com/api/external/v1/organizations_topics/8"},
    "attributes"=>
     {"name"=>"Task Ready",
      "medium"=>"mobile",
      "message_type"=>"task_ready",
      "description"=>
       "Send notification to device when a task made ready to work on and is assigned to me",
      "topic_id"=>10}}],
 "links"=>
  {"first"=>
    "https://api.scalus.com/api/external/v1/organizations_topics?page%5Bnumber%5D=1&page%5Bsize%5D=20",
   "last"=>
    "https://api.scalus.com/api/external/v1/organizations_topics?page%5Bnumber%5D=1&page%5Bsize%5D=20"
  }
}
```


<h2 id="getorgtopic"><span class='green-btn'>GET</span> Organization's Topic</h2>

`GET https://api.scalus.com/api/external/organizations_topics/:id`

Returns a specific Organization's Topic related to the firm of the logged in user.

```shell
curl
-F access_token="YOUR_ACCESS_TOKEN"
-X GET https://api.scalus.com/api/external/organizations_topics/4
-H "Accept: application/vnd.api+json; version=1"
-H "Content-Type: application/vnd.api+json"
```

```ruby
require 'rest-client'
require 'json'

client_id     = '4ea1b...'
client_secret = 'a2982...'

response = RestClient.get 'https://api.scalus.com/api/external/organizations_topics/4', {
  access_token: 'YOUR_ACCESS_TOKEN'
}

```

> The above command returns JSON structured like this:

```json
{"data"=>
  {"id"=>"4",
   "type"=>"organizations_topics",
   "links"=>
    {"self"=>"https://api.scalus.com/api/external/v1/organizations_topics/4"},
   "attributes"=>
    {"name"=>"Message Added",
     "medium"=>"email",
     "message_type"=>"message_added",
     "description"=>
      "Send notification to email when a message is added to a task that I follow.",
     "topic_id"=>1
    }
  }
}
```

# Tasks

A task is the basic unit in the Scalus workflow. It serves both as a reminder of work that your workers need to complete, as well as a collector for all activity and communication about completing the task.

### Query Parameters

Parameter | Required | Description
--------- | ------- | -----------
title | true | The title of the task
requester_id | false | ID of the `User` that requested the task
assignee_id | false | ID of the `User` that is assigned the task
due_date | false | Date that the task is due
team_id | false | The ID of the team associated to the task
status  | true | The status of the task (not_started, in_progress, resolved)
created_at | --- | created at
updated_at | --- | updated at

<aside class="notice">
You must replace <code>organization\_slug</code> with your personal slug. (your subdomain in scalus is your organization\_slug)
</aside>

Additional Attributes  | Description
--------- | -----------
last_message | text that represents the last message added to the task (this allows you to not sideload all messages on a task)
tasklist | This tasklist associated to the task (this can be nil) A tasklist groups many tasks for organizing into a group.  Think of it like a "project" that holds many tasks.
team | A team is very much like a client.
followers | The users that are "following" a task. These users will generally be notified about information about a task if specific activity_items happen
labels | It is what it sounds like
activity_items | Events that can happen within a task.  EX. "add a message to a task", "change status (to complete)", "Change the title", "add a label", "set due date", "remove yourself as a follower"
messages | Think of this as a comment on a task.  We call this "a message" rather than "a comment"


### URL Parameters

Parameter | Description
--------- | -----------
ID | The ID of the task to retrieve


<h2 id="gettasks"><span class='green-btn'>GET</span> Tasks</h2>

`GET https://api.scalus.com/api/external/tasks`

Sideload the tasklist & assignee

`GET https://api.scalus.com/api/external/tasks?include=tasklist,assignee`

Filter by team_id

`GET https://api.scalus.com/api/external/tasks?team_id=12`

Filter by assignee_id

`GET https://api.scalus.com/api/external/tasks?assignee_id=USER_ID`

Filter by requester_id

`GET https://api.scalus.com/api/external/tasks?requester_id=USER_ID`

Filter by tasklist_template_id

`GET https://api.scalus.com/api/external/tasks?tasklist_template_id=TASKLIST_TEMPLATE_ID`

Filter by tasklist_id

`GET https://api.scalus.com/api/external/tasks?tasklist_id=TASKLIST_ID`

Filter by follower_ids

`GET https://api.scalus.com/api/external/tasks?follower_ids=["USER1_ID","USER2_ID"]`

Filter by due_date

`GET https://api.scalus.com/api/external/tasks?due_date=DUE_DATE`

Filter by project_due_date

`GET https://api.scalus.com/api/external/tasks?project_due_date=PROJECT_DUE_DATE`

Filter by launched_at

`GET https://api.scalus.com/api/external/tasks?launched_at=LAUNCHED_AT`

Filter by resolved_at

`GET https://api.scalus.com/api/external/tasks?resolved_at=RESOLVED_AT`

Filter due before 

`GET https://api.scalus.com/api/external/tasks?due_date_end=DUE_BEFORE_OR_ON_THIS_DATE`

if you want due date on or before 2015-10-30
`~/tasks?due_date_end=2015-10-30`

if you want due date on or after 2015-10-30
`~/tasks?due_date_start=2015-10-30`

if you want resolved on or before 2015-10-30
`~/tasks?resolved_at_end=2015-10-30`

```shell
curl
-F access_token="YOUR_ACCESS_TOKEN"
-X GET https://api.scalus.com/api/external/tasks
-H "Accept: application/vnd.api+json; version=1"
-H "Content-Type: application/vnd.api+json"
```

```ruby
require 'rest-client'
require 'json'

client_id     = '4ea1b...'
client_secret = 'a2982...'

response = RestClient.get 'https://api.scalus.com/api/external/tasks', {
  access_token: 'YOUR_ACCESS_TOKEN'
}

```

> The above command returns JSON structured like this:

```json
{"data"=>
  [{"id"=>"3",
   "type"=>"tasks",
   "links"=>{"self"=>"https://api.scalus.com/api/external/v1/tasks/3"},
   "attributes"=>
    {"title"=>"Sample Task2",
     "created_at"=>"2016-02-09T13:02:12-08:00",
     "updated_at"=>"2016-02-09T13:02:12-08:00",
     "due_date"=>"2016-02-10",
     "last_message"=>nil,
     "team_id"=>7,
     "assignee_id"=>8,
     "requester_id"=>9,
     "status"=>"not_started"},
   "relationships"=>
    {"assignee"=>
      {"links"=>
        {"self"=>
          "https://api.scalus.com/api/external/v1/tasks/3/relationships/assignee",
         "related"=>"https://api.scalus.com/api/external/v1/tasks/3/assignee"},
       "data"=>{"type"=>"users", "id"=>"8"}},
     "creator"=>
      {"links"=>
        {"self"=>
          "https://api.scalus.com/api/external/v1/tasks/3/relationships/creator",
         "related"=>"https://api.scalus.com/api/external/v1/tasks/3/creator"},
       "data"=>{"type"=>"users", "id"=>"10"}},
     "requester"=>
      {"links"=>
        {"self"=>
          "https://api.scalus.com/api/external/v1/tasks/3/relationships/requester",
         "related"=>"https://api.scalus.com/api/external/v1/tasks/3/requester"},
       "data"=>{"type"=>"users", "id"=>"9"}},
     "tasklist"=>
      {"links"=>
        {"self"=>
          "https://api.scalus.com/api/external/v1/tasks/3/relationships/tasklist",
         "related"=>"https://api.scalus.com/api/external/v1/tasks/3/tasklist"}},
     "team"=>
      {"links"=>
        {"self"=>"https://api.scalus.com/api/external/v1/tasks/3/relationships/team",
         "related"=>"https://api.scalus.com/api/external/v1/tasks/3/team"},
       "data"=>{"type"=>"teams", "id"=>"7"}},
     "followers"=>
      {"links"=>
        {"self"=>
          "https://api.scalus.com/api/external/v1/tasks/3/relationships/followers",
         "related"=>"https://api.scalus.com/api/external/v1/tasks/3/followers"}},
     "labels"=>
      {"links"=>
        {"self"=>
          "https://api.scalus.com/api/external/v1/tasks/3/relationships/labels",
         "related"=>"https://api.scalus.com/api/external/v1/tasks/3/labels"}},
     "activity_items"=>
      {"links"=>
        {"self"=>
          "https://api.scalus.com/api/external/v1/tasks/3/relationships/activity_items",
         "related"=>
          "https://api.scalus.com/api/external/v1/tasks/3/activity_items"}},
     "messages"=>
      {"links"=>
        {"self"=>
          "https://api.scalus.com/api/external/v1/tasks/3/relationships/messages",
         "related"=>"https://api.scalus.com/api/external/v1/tasks/3/messages"}}}},
 "included"=>
  [{"id"=>"8",
    "type"=>"users",
    "links"=>{"self"=>"https://api.scalus.com/api/external/v1/users/8"},
    "attributes"=>
     {"first_name"=>"Elise",
      "last_name"=>"Fay",
      "email"=>"alexa@ohara.com",
      "kind"=>"firm",
      "status"=>"active"}},
   {"id"=>"10",
    "type"=>"users",
    "links"=>{"self"=>"https://api.scalus.com/api/external/v1/users/10"},
    "attributes"=>
     {"first_name"=>"John",
      "last_name"=>"Doe",
      "email"=>"user3@backops.co",
      "kind"=>"other",
      "status"=>"active"}},
   {"id"=>"9",
    "type"=>"users",
    "links"=>{"self"=>"https://api.scalus.com/api/external/v1/users/9"},
    "attributes"=>
     {"first_name"=>"Theodora",
      "last_name"=>"Schiller",
      "email"=>"nigel.ankunding@rutherford.name",
      "kind"=>"firm",
      "status"=>"active"}
    }]
  ]
}
```



<h2 id="gettask"><span class='green-btn'>GET</span> Task</h2>

`GET https://api.scalus.com/api/external/tasks/:id`

```shell
curl
-F access_token="YOUR_ACCESS_TOKEN"
-X GET https://api.scalus.com/api/external/tasks/19
-H "Accept: application/vnd.api+json; version=1"
-H "Content-Type: application/vnd.api+json"
```

```ruby
require 'rest-client'
require 'json'

client_id     = '4ea1b...'
client_secret = 'a2982...'

response = RestClient.get 'https://api.scalus.com/api/external/tasks/3', {
  access_token: 'YOUR_ACCESS_TOKEN'
}

```

> The above command returns JSON structured like this:

```json
{"data"=>
  {"id"=>"3",
   "type"=>"tasks",
   "links"=>{"self"=>"https://api.scalus.com/api/external/v1/tasks/3"},
   "attributes"=>
    {"title"=>"Sample Task2",
     "created_at"=>"2016-02-09T13:02:12-08:00",
     "updated_at"=>"2016-02-09T13:02:12-08:00",
     "due_date"=>"2016-02-10",
     "last_message"=>nil,
     "team_id"=>7,
     "assignee_id"=>8,
     "requester_id"=>9,
     "status"=>"not_started"},
   "relationships"=>
    {"assignee"=>
      {"links"=>
        {"self"=>
          "https://api.scalus.com/api/external/v1/tasks/3/relationships/assignee",
         "related"=>"https://api.scalus.com/api/external/v1/tasks/3/assignee"},
       "data"=>{"type"=>"users", "id"=>"8"}},
     "creator"=>
      {"links"=>
        {"self"=>
          "https://api.scalus.com/api/external/v1/tasks/3/relationships/creator",
         "related"=>"https://api.scalus.com/api/external/v1/tasks/3/creator"},
       "data"=>{"type"=>"users", "id"=>"10"}},
     "requester"=>
      {"links"=>
        {"self"=>
          "https://api.scalus.com/api/external/v1/tasks/3/relationships/requester",
         "related"=>"https://api.scalus.com/api/external/v1/tasks/3/requester"},
       "data"=>{"type"=>"users", "id"=>"9"}},
     "tasklist"=>
      {"links"=>
        {"self"=>
          "https://api.scalus.com/api/external/v1/tasks/3/relationships/tasklist",
         "related"=>"https://api.scalus.com/api/external/v1/tasks/3/tasklist"}},
     "team"=>
      {"links"=>
        {"self"=>"https://api.scalus.com/api/external/v1/tasks/3/relationships/team",
         "related"=>"https://api.scalus.com/api/external/v1/tasks/3/team"},
       "data"=>{"type"=>"teams", "id"=>"7"}},
     "followers"=>
      {"links"=>
        {"self"=>
          "https://api.scalus.com/api/external/v1/tasks/3/relationships/followers",
         "related"=>"https://api.scalus.com/api/external/v1/tasks/3/followers"}},
     "labels"=>
      {"links"=>
        {"self"=>
          "https://api.scalus.com/api/external/v1/tasks/3/relationships/labels",
         "related"=>"https://api.scalus.com/api/external/v1/tasks/3/labels"}},
     "activity_items"=>
      {"links"=>
        {"self"=>
          "https://api.scalus.com/api/external/v1/tasks/3/relationships/activity_items",
         "related"=>
          "https://api.scalus.com/api/external/v1/tasks/3/activity_items"}},
     "messages"=>
      {"links"=>
        {"self"=>
          "https://api.scalus.com/api/external/v1/tasks/3/relationships/messages",
         "related"=>"https://api.scalus.com/api/external/v1/tasks/3/messages"}}}},
 "included"=>
  [{"id"=>"8",
    "type"=>"users",
    "links"=>{"self"=>"https://api.scalus.com/api/external/v1/users/8"},
    "attributes"=>
     {"first_name"=>"Elise",
      "last_name"=>"Fay",
      "email"=>"alexa@ohara.com",
      "kind"=>"firm",
      "status"=>"active"}},
   {"id"=>"10",
    "type"=>"users",
    "links"=>{"self"=>"https://api.scalus.com/api/external/v1/users/10"},
    "attributes"=>
     {"first_name"=>"John",
      "last_name"=>"Doe",
      "email"=>"user3@backops.co",
      "kind"=>"other",
      "status"=>"active"}},
   {"id"=>"9",
    "type"=>"users",
    "links"=>{"self"=>"https://api.scalus.com/api/external/v1/users/9"},
    "attributes"=>
     {"first_name"=>"Theodora",
      "last_name"=>"Schiller",
      "email"=>"nigel.ankunding@rutherford.name",
      "kind"=>"firm",
      "status"=>"active"}}]}
```

This endpoint retreives a specific task if the user is authorized.

<aside class="warning">If you request a task that is not in your organization or the logged in user does not have permissions to see the task, the response will return 422 Unprocessable Entity.</aside>


<h2 id="puttask"><span class='blue-btn'>PUT</span> Task</h2>

`PUT https://api.scalus.com/api/external/tasks/:id`

> Definition
> `PUT /api/tasks/:id`
>

> Example Request
>

```shell
curl
-F id="22" \
-F type="tasks" \
-F task[title]="Thank you for looking at our API" \
-F task[requester_id]=1 \
-F task[assignee_id]=1 \
-F task[due_date]="10-25-2021" \
-F access_token="YOUR_ACCESS_TOKEN"
-X POST https://api.scalus.com/api/external/tasks/22
-H "Accept: application/vnd.api+json; version=1"
-H "Content-Type: application/vnd.api+json"
```

```ruby
require 'rest-client'
require 'json'

client_id     = '4ea1b...'
client_secret = 'a2982...'

response = RestClient.put 'https://api.scalus.com/api/external/tasks/22', {
  access_token: 'YOUR_ACCESS_TOKEN',
  "id": 22,
  "type": "tasks",
  "task": {
    "title":        "Thank you for looking at our API, a second time",
    "requester_id": 1,
    "assignee_id":  2,
    "due_date":     "10-25-2021",
    "team_id":      7,
    "status":       "not_started"
  }
}

```

> The above command returns JSON structured like this:

```json
{"data"=>
  {"id"=>"3",
   "type"=>"tasks",
   "links"=>{"self"=>"https://api.scalus.com/api/external/v1/tasks/3"},
   "attributes"=>
    {"title"=>"Thank you for looking at our API, a second time",
     "created_at"=>"2016-02-09T13:02:12-08:00",
     "updated_at"=>"2016-02-09T13:02:12-08:00",
     "due_date"=>"2021-10-25",
     "last_message"=>nil,
     "team_id"=>7,
     "assignee_id"=>2,
     "requester_id"=>1,
     "status"=>"not_started"},
   "relationships"=>
    {"assignee"=>
      {"links"=>
        {"self"=>
          "https://api.scalus.com/api/external/v1/tasks/3/relationships/assignee",
         "related"=>"https://api.scalus.com/api/external/v1/tasks/3/assignee"},
       "data"=>{"type"=>"users", "id"=>"8"}},
     "creator"=>
      {"links"=>
        {"self"=>
          "https://api.scalus.com/api/external/v1/tasks/3/relationships/creator",
         "related"=>"https://api.scalus.com/api/external/v1/tasks/3/creator"},
       "data"=>{"type"=>"users", "id"=>"10"}},
     "requester"=>
      {"links"=>
        {"self"=>
          "https://api.scalus.com/api/external/v1/tasks/3/relationships/requester",
         "related"=>"https://api.scalus.com/api/external/v1/tasks/3/requester"},
       "data"=>{"type"=>"users", "id"=>"9"}},
     "tasklist"=>
      {"links"=>
        {"self"=>
          "https://api.scalus.com/api/external/v1/tasks/3/relationships/tasklist",
         "related"=>"https://api.scalus.com/api/external/v1/tasks/3/tasklist"}},
     "team"=>
      {"links"=>
        {"self"=>"https://api.scalus.com/api/external/v1/tasks/3/relationships/team",
         "related"=>"https://api.scalus.com/api/external/v1/tasks/3/team"},
       "data"=>{"type"=>"teams", "id"=>"7"}},
     "followers"=>
      {"links"=>
        {"self"=>
          "https://api.scalus.com/api/external/v1/tasks/3/relationships/followers",
         "related"=>"https://api.scalus.com/api/external/v1/tasks/3/followers"}},
     "labels"=>
      {"links"=>
        {"self"=>
          "https://api.scalus.com/api/external/v1/tasks/3/relationships/labels",
         "related"=>"https://api.scalus.com/api/external/v1/tasks/3/labels"}},
     "activity_items"=>
      {"links"=>
        {"self"=>
          "https://api.scalus.com/api/external/v1/tasks/3/relationships/activity_items",
         "related"=>
          "https://api.scalus.com/api/external/v1/tasks/3/activity_items"}},
     "messages"=>
      {"links"=>
        {"self"=>
          "https://api.scalus.com/api/external/v1/tasks/3/relationships/messages",
         "related"=>"https://api.scalus.com/api/external/v1/tasks/3/messages"}}}},
 "included"=>
  [{"id"=>"8",
    "type"=>"users",
    "links"=>{"self"=>"https://api.scalus.com/api/external/v1/users/8"},
    "attributes"=>
     {"first_name"=>"Elise",
      "last_name"=>"Fay",
      "email"=>"alexa@ohara.com",
      "kind"=>"firm",
      "status"=>"active"}},
   {"id"=>"10",
    "type"=>"users",
    "links"=>{"self"=>"https://api.scalus.com/api/external/v1/users/10"},
    "attributes"=>
     {"first_name"=>"John",
      "last_name"=>"Doe",
      "email"=>"user3@backops.co",
      "kind"=>"other",
      "status"=>"active"}},
   {"id"=>"9",
    "type"=>"users",
    "links"=>{"self"=>"https://api.scalus.com/api/external/v1/users/9"},
    "attributes"=>
     {"first_name"=>"Theodora",
      "last_name"=>"Schiller",
      "email"=>"nigel.ankunding@rutherford.name",
      "kind"=>"firm",
      "status"=>"active"}}]}
```

<h2 id="posttask"><span class='blue-btn'>POST</span> Task</h2>

`POST https://api.scalus.com/api/external/tasks`

> Definition
> `POST /api/external/tasks`
>

> Example Request
>

```shell
curl
-F type="tasks" \
-F task[title]="Thank you for looking at our API" \
-F task[requester_id]=1 \
-F task[assignee_id]=1 \
-F task[due_date]="10-25-2021" \
-F access_token="YOUR_ACCESS_TOKEN"
-X POST https://api.scalus.com/api/external/tasks
-H "Accept: application/vnd.api+json; version=1"
-H "Content-Type: application/vnd.api+json"
```

```ruby
require 'rest-client'
require 'json'

client_id     = '4ea1b...'
client_secret = 'a2982...'

response = RestClient.post 'https://api.scalus.com/api/external/tasks', 
     {
      access_token: 'YOUR_ACCESS_TOKEN',
      data: {
        type: 'tasks',
        attributes: {
          title:       'Thank you for looking at our API',
          due_date:    "2016-02-20",
          team_id:      7,
          requester_id: 1,
          assignee_id:  8
        }
      }
    } 

```
> The above command returns JSON structured like this:

```json
{"data"=>
  {"id"=>"3",
   "type"=>"tasks",
   "links"=>{"self"=>"https://api.scalus.com/api/external/v1/tasks/3"},
   "attributes"=>
    {"title"=>"Thank you for looking at our API",
     "created_at"=>"2016-02-09T13:02:12-08:00",
     "updated_at"=>"2016-02-09T13:02:12-08:00",
     "due_date"=>"2021-10-25",
     "last_message"=>nil,
     "team_id"=>7,
     "assignee_id"=>8,
     "requester_id"=>1,
     "status"=>"not_started"},
   "relationships"=>
    {"assignee"=>
      {"links"=>
        {"self"=>
          "https://api.scalus.com/api/external/v1/tasks/3/relationships/assignee",
         "related"=>"https://api.scalus.com/api/external/v1/tasks/3/assignee"},
       "data"=>{"type"=>"users", "id"=>"8"}},
     "creator"=>
      {"links"=>
        {"self"=>
          "https://api.scalus.com/api/external/v1/tasks/3/relationships/creator",
         "related"=>"https://api.scalus.com/api/external/v1/tasks/3/creator"},
       "data"=>{"type"=>"users", "id"=>"10"}},
     "requester"=>
      {"links"=>
        {"self"=>
          "https://api.scalus.com/api/external/v1/tasks/3/relationships/requester",
         "related"=>"https://api.scalus.com/api/external/v1/tasks/3/requester"},
       "data"=>{"type"=>"users", "id"=>"9"}},
     "tasklist"=>
      {"links"=>
        {"self"=>
          "https://api.scalus.com/api/external/v1/tasks/3/relationships/tasklist",
         "related"=>"https://api.scalus.com/api/external/v1/tasks/3/tasklist"}},
     "team"=>
      {"links"=>
        {"self"=>"https://api.scalus.com/api/external/v1/tasks/3/relationships/team",
         "related"=>"https://api.scalus.com/api/external/v1/tasks/3/team"},
       "data"=>{"type"=>"teams", "id"=>"7"}},
     "followers"=>
      {"links"=>
        {"self"=>
          "https://api.scalus.com/api/external/v1/tasks/3/relationships/followers",
         "related"=>"https://api.scalus.com/api/external/v1/tasks/3/followers"}},
     "labels"=>
      {"links"=>
        {"self"=>
          "https://api.scalus.com/api/external/v1/tasks/3/relationships/labels",
         "related"=>"https://api.scalus.com/api/external/v1/tasks/3/labels"}},
     "activity_items"=>
      {"links"=>
        {"self"=>
          "https://api.scalus.com/api/external/v1/tasks/3/relationships/activity_items",
         "related"=>
          "https://api.scalus.com/api/external/v1/tasks/3/activity_items"}},
     "messages"=>
      {"links"=>
        {"self"=>
          "https://api.scalus.com/api/external/v1/tasks/3/relationships/messages",
         "related"=>"https://api.scalus.com/api/external/v1/tasks/3/messages"}}}},
 "included"=>
  [{"id"=>"8",
    "type"=>"users",
    "links"=>{"self"=>"https://api.scalus.com/api/external/v1/users/8"},
    "attributes"=>
     {"first_name"=>"Elise",
      "last_name"=>"Fay",
      "email"=>"alexa@ohara.com",
      "kind"=>"firm",
      "status"=>"active"}},
   {"id"=>"10",
    "type"=>"users",
    "links"=>{"self"=>"https://api.scalus.com/api/external/v1/users/10"},
    "attributes"=>
     {"first_name"=>"John",
      "last_name"=>"Doe",
      "email"=>"user3@backops.co",
      "kind"=>"other",
      "status"=>"active"}},
   {"id"=>"9",
    "type"=>"users",
    "links"=>{"self"=>"https://api.scalus.com/api/external/v1/users/9"},
    "attributes"=>
     {"first_name"=>"Theodora",
      "last_name"=>"Schiller",
      "email"=>"nigel.ankunding@rutherford.name",
      "kind"=>"firm",
      "status"=>"active"}}]} 
```

This endpoint creates a task.

<h2 id="deletetask"><span class='red-btn'>DELETE</span> Task</h2>

`DELETE https://api.scalus.com/api/external/tasks/:id`

```ruby
require 'rest-client'
require 'json'

client_id     = '4ea1b...'
client_secret = 'a2982...'

response = RestClient.delete 'https://api.scalus.com/api/external/tasks/8', {
  access_token: 'YOUR_ACCESS_TOKEN'
}

```

> The above command returns JSON structured like this:

``` 
{"data"=>
  {"id"=>"8",
   "type"=>"tasks",
   "links"=>{"self"=>"/api/external/v1/tasks/8"},
   "attributes"=>
    {"title"=>"Sample Task2",
     "created_at"=>"2016-01-19T14:30:33-08:00",
     "updated_at"=>"2016-01-19T14:30:34-08:00",
     "due_date"=>"2016-01-20",
     "last_message"=>nil,
     "team_id"=>2,
     "assignee_id"=>1,
     "requester_id"=>2,
     "status"=>"deleted"},
   "relationships"=>
    {"assignee"=>
      {"links"=>
        {"self"=>"/api/external/v1/tasks/8/relationships/assignee",
         "related"=>"/api/external/v1/tasks/8/assignee"}},
     "creator"=>
      {"links"=>
        {"self"=>"/api/external/v1/tasks/8/relationships/creator",
         "related"=>"/api/external/v1/tasks/8/creator"}},
     "requester"=>
      {"links"=>
        {"self"=>"/api/external/v1/tasks/8/relationships/requester",
         "related"=>"/api/external/v1/tasks/8/requester"}},
     "tasklist"=>
      {"links"=>
        {"self"=>"/api/external/v1/tasks/8/relationships/tasklist",
         "related"=>"/api/external/v1/tasks/8/tasklist"}},
     "team"=>
      {"links"=>
        {"self"=>"/api/external/v1/tasks/8/relationships/team",
         "related"=>"/api/external/v1/tasks/8/team"}},
     "followers"=>
      {"links"=>
        {"self"=>"/api/external/v1/tasks/8/relationships/followers",
         "related"=>"/api/external/v1/tasks/8/followers"}},
     "labels"=>
      {"links"=>
        {"self"=>"/api/external/v1/tasks/8/relationships/labels",
         "related"=>"/api/external/v1/tasks/8/labels"}},
     "activity_items"=>
      {"links"=>
        {"self"=>"/api/external/v1/tasks/8/relationships/activity_items",
         "related"=>"/api/external/v1/tasks/8/activity_items"}},
     "messages"=>
      {"links"=>
        {"self"=>"/api/external/v1/tasks/8/relationships/messages",
         "related"=>"/api/external/v1/tasks/8/messages"}}}}}
```



# Tasklist

<h2 id="gettasklist"><span class='green-btn'>GET</span> Tasklist</h2>

`GET https://api.scalus.com/api/external/tasklists/:id`

Get tasklists and include tasks
`GET https://api.scalus.com/api/external/tasklists/:id?include=tasks`

```ruby
require 'rest-client'
require 'json'

client_id     = '4ea1b...'
client_secret = 'a2982...'

response = RestClient.get 'https://api.scalus.com/api/external/taskslists/1', {
  access_token: 'YOUR_ACCESS_TOKEN'
}

```

> The above command returns JSON structured like this:

```

{"data"=>
  {"id"=>"1",
   "type"=>"tasklists",
   "links"=>{"self"=>"http://test.host/api/external/v1/tasklists/1"},
   "attributes"=>
    {"title"=>"Project Number 1",
     "description"=>"This is a project",
     "status"=>"not_started",
     "due_date"=>nil,
     "completed_task_count"=>0,
     "total_task_count"=>1},
   "relationships"=>
    {"tasks"=>
      {"links"=>
        {"self"=>
          "http://test.host/api/external/v1/tasklists/1/relationships/tasks",
         "related"=>"http://test.host/api/external/v1/tasklists/1/tasks"}},
     "activity_items"=>
      {"links"=>
        {"self"=>
          "http://test.host/api/external/v1/tasklists/1/relationships/activity_items",
         "related"=>
          "http://test.host/api/external/v1/tasklists/1/activity_items"}},
     "team"=>
      {"links"=>
        {"self"=>
          "http://test.host/api/external/v1/tasklists/1/relationships/team",
         "related"=>"http://test.host/api/external/v1/tasklists/1/team"}}}}
}

```

> This is a response if you `include=tasks`

```
{"data"=>
  {"id"=>"1",
   "type"=>"tasklists",
   "links"=>{"self"=>"http://test.host/api/external/v1/tasklists/1"},
   "attributes"=>
    {"title"=>"Project Number 1",
     "description"=>"This is a project",
     "status"=>"not_started",
     "due_date"=>nil,
     "completed_task_count"=>0,
     "total_task_count"=>1},
   "relationships"=>
    {"tasks"=>
      {"links"=>
        {"self"=>
          "http://test.host/api/external/v1/tasklists/1/relationships/tasks",
         "related"=>"http://test.host/api/external/v1/tasklists/1/tasks"},
       "data"=>[{"type"=>"tasks", "id"=>"1"}]},
     "activity_items"=>
      {"links"=>
        {"self"=>
          "http://test.host/api/external/v1/tasklists/1/relationships/activity_items",
         "related"=>
          "http://test.host/api/external/v1/tasklists/1/activity_items"}},
     "team"=>
      {"links"=>
        {"self"=>
          "http://test.host/api/external/v1/tasklists/1/relationships/team",
         "related"=>"http://test.host/api/external/v1/tasklists/1/team"}}}},
 "included"=>
  [{"id"=>"1",
    "type"=>"tasks",
    "links"=>{"self"=>"http://test.host/api/external/v1/tasks/1"},
    "attributes"=>
     {"title"=>"Sample Task2",
      "created_at"=>"2016-02-18T17:43:52-08:00",
      "updated_at"=>"2016-02-18T17:43:52-08:00",
      "due_date"=>"2016-02-19",
      "last_message"=>nil,
      "team_id"=>1,
      "assignee_id"=>1,
      "requester_id"=>2,
      "status"=>"not_started"},
    "relationships"=>
     {"assignee"=>
       {"links"=>
         {"self"=>
           "http://test.host/api/external/v1/tasks/1/relationships/assignee",
          "related"=>"http://test.host/api/external/v1/tasks/1/assignee"}},
      "creator"=>
       {"links"=>
         {"self"=>
           "http://test.host/api/external/v1/tasks/1/relationships/creator",
          "related"=>"http://test.host/api/external/v1/tasks/1/creator"}},
      "requester"=>
       {"links"=>
         {"self"=>
           "http://test.host/api/external/v1/tasks/1/relationships/requester",
          "related"=>"http://test.host/api/external/v1/tasks/1/requester"}},
      "tasklist"=>
       {"links"=>
         {"self"=>
           "http://test.host/api/external/v1/tasks/1/relationships/tasklist",
          "related"=>"http://test.host/api/external/v1/tasks/1/tasklist"}},
      "team"=>
       {"links"=>
         {"self"=>
           "http://test.host/api/external/v1/tasks/1/relationships/team",
          "related"=>"http://test.host/api/external/v1/tasks/1/team"}},
      "followers"=>
       {"links"=>
         {"self"=>
           "http://test.host/api/external/v1/tasks/1/relationships/followers",
          "related"=>"http://test.host/api/external/v1/tasks/1/followers"}},
      "labels"=>
       {"links"=>
         {"self"=>
           "http://test.host/api/external/v1/tasks/1/relationships/labels",
          "related"=>"http://test.host/api/external/v1/tasks/1/labels"}},
      "activity_items"=>
       {"links"=>
         {"self"=>
           "http://test.host/api/external/v1/tasks/1/relationships/activity_items",
          "related"=>
           "http://test.host/api/external/v1/tasks/1/activity_items"}},
      "messages"=>
       {"links"=>
         {"self"=>
           "http://test.host/api/external/v1/tasks/1/relationships/messages",
          "related"=>"http://test.host/api/external/v1/tasks/1/messages"}}}}]}
```

# Reset Password

Pinging the endpoint will send the user an email that they can use to reset their password in the web app from.

AUTHENTICATION is NOT required to ping this endpoint.

`https://api.scalus.com/api/external/reset_passwords`

Parameter | type | Description
--------- | ---------- | -----------
email | string | email of the user that needs to reset their password in the organization
subdomain | string | subdomain of the organization that they want to reset their password.


```ruby
require 'rest-client'
require 'json'

client_id     = '4ea1b...'
client_secret = 'a2982...'

response = RestClient.post 'https://api.scalus.com/api/external/reset_passwords', {
  access_token: 'YOUR_ACCESS_TOKEN',
  email: 'john@doe.com',
  subdomain: 'yourORGANIZATIONSsubdomain'
}

```

> The response will have a status code of 200 or 4XX depending on if it was successful

# Teams

A group inside your Scalus organization made up of assigned team members


Parameter | type | Description
--------- | ---------- | -----------
name | string | Name of the team in the organization
slug | string | unique ID representing the team (can not be updated) Also used in the support email for the team.


<h2 id="getteams"><span class='green-btn'>GET</span> Teams</h2>

`GET https://api.scalus.com/api/external/teams`

Returns all the teams related to the firm of the logged in user.

```shell
curl
-F access_token="YOUR_ACCESS_TOKEN"
-X GET https://api.scalus.com/api/external/teams
-H "Accept: application/vnd.api+json; version=1"
-H "Content-Type: application/vnd.api+json"
```

```ruby
require 'rest-client'
require 'json'

client_id     = '4ea1b...'
client_secret = 'a2982...'

response = RestClient.get 'https://api.scalus.com/api/external/teams', {
  access_token: 'YOUR_ACCESS_TOKEN'
}

```

> The above command returns JSON structured like this:

```json
{"data"=>
  [{"id"=>"1",
    "type"=>"teams",
    "links"=>{"self"=>"https://api.scalus.com/api/external/v1/teams/1"},
    "attributes"=>{"name"=>"Company 1", "slug"=>"testacme1"}},
   {"id"=>"3",
    "type"=>"teams",
    "links"=>{"self"=>"https://api.scalus.com/api/external/v1/teams/3"},
    "attributes"=>{"name"=>"Company 3", "slug"=>"testacme3"}}],
 "links"=>
  {"first"=>
    "https://api.scalus.com/api/external/v1/teams?page%5Bnumber%5D=1&page%5Bsize%5D=20",
   "last"=>
    "https://api.scalus.com/api/external/v1/teams?page%5Bnumber%5D=1&page%5Bsize%5D=20"
   }
}
```

<h2 id="getteam"><span class='green-btn'>GET</span> Team</h2>

`GET https://api.scalus.com/api/external/teams/:id`

Returns a specific team related to the firm of the logged in user.

```shell
curl
-F access_token="YOUR_ACCESS_TOKEN"
-X GET https://api.scalus.com/api/external/teams/4
-H "Accept: application/vnd.api+json; version=1"
-H "Content-Type: application/vnd.api+json"
```

```ruby
require 'rest-client'
require 'json'

client_id     = '4ea1b...'
client_secret = 'a2982...'

response = RestClient.get 'https://api.scalus.com/api/external/teams/4', {
  access_token: 'YOUR_ACCESS_TOKEN'
}

```

> The above command returns JSON structured like this:

```json

{"data"=>
  {"id"=>"4",
   "type"=>"teams",
   "links"=>{"self"=>"https://api.scalus.com/api/external/v1/teams/4"},
   "attributes"=>{
     "name"=>"Company 4", 
     "slug"=>"testacme4",
     "status"=>"active"}
  }
}
```


<h2 id="postteam"><span class='blue-btn'>POST</span> Team</h2>

`POST https://api.scalus.com/api/external/teams`

```ruby
require 'rest-client'
require 'json'

client_id     = '4ea1b...'
client_secret = 'a2982...'

response = RestClient.get 'https://api.scalus.com/api/external/teams', {
  access_token: 'YOUR_ACCESS_TOKEN',
  "team": {
    "name": "Team One",
    "slug": "team-one" # can not contain spaces
  }    
}

```
> The above command returns JSON structured like this:

```
{"data"=>
  {"id"=>"4",
   "type"=>"teams",
   "links"=>{"self"=>"https://api.scalus.com/api/external/v1/teams/4"},
   "attributes"=>{"name"=>"Team One", "slug"=>"team-one", "status"=>"active"}}}
```


<h2 id="putteam"><span class='blue-btn'>PUT</span> Team</h2>

`PUT https://api.scalus.com/api/external/teams/:id`

```ruby
require 'rest-client'
require 'json'

client_id     = '4ea1b...'
client_secret = 'a2982...'

response = RestClient.put 'https://api.scalus.com/api/external/teams/4', {
  access_token: 'YOUR_ACCESS_TOKEN',
  "team": {
    "name": "Team 1"
  }   
}

```

> The above command returns JSON structured like this:

```
{"data"=>
  {"id"=>"4",
   "type"=>"teams",
   "links"=>{"self"=>"https://api.scalus.com/api/external/v1/teams/4"},
   "attributes"=>{"name"=>"Team 1", "slug"=>"team-one", "status"=>"active"}}}
```

<h2 id="deleteteam"><span class='red-btn'>DELETE</span> Team</h2>

`DELETE https://api.scalus.com/api/external/teams/:id`

```ruby
require 'rest-client'
require 'json'

client_id     = '4ea1b...'
client_secret = 'a2982...'

response = RestClient.delete 'https://api.scalus.com/api/external/teams/4', {
  access_token: 'YOUR_ACCESS_TOKEN'
}

```

> The above command returns JSON structured like this:

```
{"data"=>
  {"id"=>"4",
   "type"=>"teams",
   "links"=>{"self"=>"/api/external/v1/teams/4"},
   "attributes"=>
    {"name"=>"Company 5", 
     "slug"=>"testacme5", 
     "status"=>"inactive"}}}
```

<h2 id="archiveteam"><span class='red-btn'>ARCHIVE</span> Team</h2>

`DELETE https://api.scalus.com/api/external/teams/:id/archive`

*Your Team must be inactive before you can archive it.*

<aside class="warning">Once a team is archived their tasks and support email no long will function.</aside>

```ruby
require 'rest-client'
require 'json'

client_id     = '4ea1b...'
client_secret = 'a2982...'

response = RestClient.delete 'https://api.scalus.com/api/external/teams/4/archive', {
  access_token: 'YOUR_ACCESS_TOKEN'
}

```

> The above command returns JSON structured like this:

```
{"data"=>
  {"id"=>"4",
   "type"=>"teams",
   "links"=>{"self"=>"/api/external/v1/teams/4"},
   "attributes"=>
    {"name"=>"Company 5", 
     "slug"=>"testacme5", 
     "status"=>"archived"}}}
```

# Notifications

Notifications the user is involved with.  Notifications are Activity Items, but aggregated for user.

paginated with the offset not the page number

<aside class="notice">
*NOTE* this endpoint is a subset of the user's activity items
</aside>

Parameter | Description
--------- | -----------
event_type | brief word that describes what triggered the change
event_source | where the event was triggered (api, auto, email, webform) 
from | original value
to | new value
secondary_attribute | ...
target_title | this is the source's title if the source that changed has a title 
attribute_name | attribute that changed
read | indicates if the notification has been read or not.  Please POST <a href="#posttactitityitem">read = true</a> if a user reads the notification.
metadata | a hash of more data

<h2 id="getnotifications"><span class='green-btn'>GET</span> Notifications</h2>

`GET https://api.scalus.com/api/external/notifications`

```ruby
require 'rest-client'
require 'json'

client_id     = '4ea1b...'
client_secret = 'a2982...'

response = RestClient.get 'https://api.scalus.com/api/external/notifications', {
  access_token: 'YOUR_ACCESS_TOKEN'
}

```

> The above command returns JSON structured like this:

```
{"data"=>
  [{"id"=>"1",
    "type"=>"notifications",
    "links"=>{"self"=>"https://api.scalus.com/api/external/v1/notifications/1"},
    "attributes"=>
     {"event_type"=>"task_created",
      "event_source"=>"webform",
      "from"=>nil,
      "to"=>nil,
      "created_at"=>"2016-01-19T17:23:01-08:00",
      "secondary_attribute"=>nil,
      "target_title"=>nil,
      "attribute_name"=>nil,
      "read"=>false,
      "resource_url"=>"http://firm-1.lvh.me:3000/api/external/tasks/3"},
    "relationships"=>
     {"activity_itemable"=>
       {"links"=>
         {"self"=>
           "https://api.scalus.com/api/external/v1/notifications/1/relationships/activity_itemable",
          "related"=>
           "https://api.scalus.com/api/external/v1/notifications/1/activity_itemable"}}}}],
 "links"=>
  {"first"=>
    "https://api.scalus.com/api/external/v1/notifications?page%5Blimit%5D=20&page%5Boffset%5D=0",
   "last"=>
    "https://api.scalus.com/api/external/v1/notifications?page%5Blimit%5D=20&page%5Boffset%5D=0"}}
```

<h2 id="getnotification"><span class='green-btn'>GET</span> Notification</h2>

`GET https://api.scalus.com/api/external/notifications/:id`

```ruby
require 'rest-client'
require 'json'

client_id     = '4ea1b...'
client_secret = 'a2982...'

response = RestClient.get 'https://api.scalus.com/api/external/notifications/4', {
  access_token: 'YOUR_ACCESS_TOKEN'
}

```

> The above command returns JSON structured like this:

```
{"data"=>
  {"id"=>"4",
   "type"=>"notifications",
   "links"=>{"self"=>"https://api.scalus.com/api/external/v1/notifications/4"},
   "attributes"=>
    {"event_type"=>"task_created",
     "event_source"=>"webform",
     "from"=>nil,
     "to"=>nil,
     "created_at"=>"2016-01-19T17:18:01-08:00",
     "secondary_attribute"=>nil,
     "target_title"=>nil,
     "attribute_name"=>nil,
     "read"=>false,
     "resource_url"=>"http://firm-1.lvh.me:3000/api/external/tasks/3"},
   "relationships"=>
    {"activity_itemable"=>
      {"links"=>
        {"self"=>
          "https://api.scalus.com/api/external/v1/notifications/4/relationships/activity_itemable",
         "related"=>
          "https://api.scalus.com/api/external/v1/notifications/4/activity_itemable"}}}}}

```

# Saved Searches

To use saved searches you need to:

- Create a saved search in the web application
- GET the <a href="#getsavedsearches">saved search IDS</a> for the logged in user
- Use the `saved search ID` and ping the <a href="#getsavedsearchtasks">saved_search_tasks API endpoint</a>

Parameter | Description
--------- | -----------
title | Names of the searches that the user that is logged in saved
params | parameters that were saved (This is for reference and is not required)

<h2 id="getsavedsearches"><span class='green-btn'>GET</span> Saved Searches</h2>

`GET https://api.scalus.com/api/external/saved_searches`


```ruby
require 'rest-client'
require 'json'

client_id     = '4ea1b...'
client_secret = 'a2982...'

response = RestClient.get 'https://api.scalus.com/api/external/saved_searches', {
  access_token: 'YOUR_ACCESS_TOKEN'
}

```

> The above command returns JSON structured like this:

```json
{"data"=>
  [{"id"=>"7",
    "type"=>"saved_searches",
    "links"=>
     {"self"=>"https://api.scalus.com/api/external/v1/saved_searches/7"},
    "attributes"=>
     {"title"=>"Get In progress", "params"=>{"status"=>["in_progress"]}}},
   {"id"=>"9",
    "type"=>"saved_searches",
    "links"=>
     {"self"=>"https://api.scalus.com/api/external/v1/saved_searches/9"},
    "attributes"=>
     {"title"=>"My completed", "params"=>{"status"=>["completed", "assignee_id"=>2 ]}}}],
 "links"=>
  {"first"=>
    "https://api.scalus.com/api/external/v1/saved_searches?page%5Bnumber%5D=1&page%5Bsize%5D=20",
   "last"=>
    "https://api.scalus.com/api/external/v1/saved_searches?page%5Bnumber%5D=1&page%5Bsize%5D=20"}}
```

<h2 id="getsavedsearch"><span class='green-btn'>GET</span> Saved Search</h2>

`GET https://api.scalus.com/api/external/saved_searches/:id`

```ruby
require 'rest-client'
require 'json'

client_id     = '4ea1b...'
client_secret = 'a2982...'

response = RestClient.get 'https://api.scalus.com/api/external/saved_searches/4', {
  access_token: 'YOUR_ACCESS_TOKEN'
}

```

> The above command returns JSON structured like this:

```json
{"data"=>
  {"id"=>"4",
   "type"=>"saved_searches",
   "links"=>
    {"self"=>"https://api.scalus.com/api/external/v1/saved_searches/4"},
   "attributes"=>
    {"title"=>"John's Completed",
     "params"=>{"status"=>["completed", "assignee_id"=>34]}}}}
```

# Saved Search Tasks

To use saved searches you need to:

- Create a saved search in the web application
- GET the <a href="#getsavedsearches">saved search IDS</a> for the logged in user
- Use the `saved search ID` and ping the saved_search_tasks API endpoint (this endpoint)

<h2 id="getsavedsearchtasks"><span class='green-btn'>GET</span> Saved Search Tasks</h2>

`GET https://api.scalus.com/api/external/saved_search_tasks/:id`

ID is the ID of the saved search.

This endpoint returns the tasks related to the saved search parameters.

```ruby
require 'rest-client'
require 'json'

client_id     = '4ea1b...'
client_secret = 'a2982...'

response = RestClient.get 'https://api.scalus.com/api/external/saved_search_tasks/12', {
  access_token: 'YOUR_ACCESS_TOKEN'
}

```

> The above command returns JSON structured like the `api/external/tasks` endpoint



# Users


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
profile_image_url | returns the users profile image (not updatable via the API)
password   |  not returned in the response but can be used to update the logged in user's password along with password_confirmation
password_confirmation | not returned in the response but can be used to update the logged in user's password along with password

<h2 id="getusers"><span class='green-btn'>GET</span> Users</h2>

`GET https://api.scalus.com/api/external/users`

`GET https://api.scalus.com/api/external/users?filter[kind]=company`

`GET https://api.scalus.com/api/external/users?filter[kind]=firm `

<h2 id="getuser"><span class='green-btn'>GET</span> User</h2>

`GET https://api.scalus.com/api/external/users/:id`

```shell
curl
-F access_token="YOUR_ACCESS_TOKEN"
-X GET https://api.scalus.com/api/external/users/32
-H "Accept: application/vnd.api+json; version=1"
-H "Content-Type: application/vnd.api+json"
```

```ruby
require 'rest-client'
require 'json'

client_id     = '4ea1b...'
client_secret = 'a2982...'

response = RestClient.get 'https://api.scalus.com/api/external/users/32', {
  access_token: 'YOUR_ACCESS_TOKEN'
}

```

> The above command returns JSON structured like this:

```json
{"data"=>
  {"id"=>"32",
   "type"=>"users",
   "links"=>{"self"=>"https://api.scalus.com/api/external/users/32"},
   "attributes"=>
    {"first_name"=>"John",
     "last_name"=>"Goldstein",
     "email"=>"john.gold@scalus.com",
     "kind"=>"firm",
     "status"=>"active",
     "profile_image_url"=> 'http://www.tiny.url/image.jpg'}}}
```





<h2 id="currentuser"><span class='blue-btn'>GET</span> Current User</h2>

`GET https://api.scalus.com/api/external/me`

```ruby
require 'rest-client'
require 'json'

client_id     = '4ea1b...'
client_secret = 'a2982...'

response = RestClient.get 'https://api.scalus.com/api/external/me', {
  access_token: 'YOUR_ACCESS_TOKEN'
}

```

> The above command returns JSON structured like this:

```json
{"data"=>
  {"id"=>"32",
   "type"=>"users",
   "links"=>{"self"=>"https://api.scalus.com/api/external/users/32"},
   "attributes"=>
    {"first_name"=>"John",
     "last_name"=>"Goldstein",
     "email"=>"john.gold@scalus.com",
     "kind"=>"firm",
     "status"=>"active",
     "profile_image_url"=> 'http://www.tiny.url/image.jpg'}}}
```

<h2 id="putuser"><span class='blue-btn'>PUT</span> User</h2>

`PUT https://api.scalus.com/api/external/users/:id`


```shell
curl
-F access_token="YOUR_ACCESS_TOKEN"
-X PUT https://api.scalus.com/api/external/users/32
-H "Accept: application/vnd.api+json; version=1"
-H "Content-Type: application/vnd.api+json"
```

```ruby
require 'rest-client'
require 'json'

client_id     = '4ea1b...'
client_secret = 'a2982...'

response = RestClient.get 'https://api.scalus.com/api/external/users/32', {
  access_token: 'YOUR_ACCESS_TOKEN',
  "id": 32,
  "type": "tasks",
  "task": {
    "first_name"=>"John",
    "last_name"=>"Goldstein",
    "email"=>"john.gold@scalus.com",
    "password"=>              "ItsAGreatDay!2016",
    "password_confirmation"=> "ItsAGreatDay!2016",
		"status":       "active",
    "profile_image_url"=> 'http://www.tiny.url/image.jpg'
  }
}

```

> The above command returns JSON structured like this:

```json
{"data"=>
  {"id"=>"32",
   "type"=>"users",
   "links"=>{"self"=>"https://api.scalus.com/api/external/users/32"},
   "attributes"=>
    {"first_name"=>"John",
     "last_name"=>"Goldstein",
     "email"=>"john.gold@scalus.com",
     "kind"=>"firm",
     "status"=>"active"}}}
```


<h2 id="deleteuser"><span class='red-btn'>DELETE</span> User</h2>

`DELETE https://api.scalus.com/api/users/:id`
