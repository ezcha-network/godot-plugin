# Class Index

* [EzchaPlugin](#EzchaPlugin)
* [EzchaClient](#EzchaClient)
* [EzchaPlatformAdapterWeb](#EzchaPlatformAdapterWeb)
* [EzchaSingleton](#EzchaSingleton)
* [EzchaDatastoresAPI](#EzchaDatastoresAPI)
* [EzchaGamesAPI](#EzchaGamesAPI)
* [EzchaGeneralAPI](#EzchaGeneralAPI)
* [EzchaLeaderboardsAPI](#EzchaLeaderboardsAPI)
* [EzchaNewsAPI](#EzchaNewsAPI)
* [EzchaSessionsAPI](#EzchaSessionsAPI)
* [EzchaTrophiesAPI](#EzchaTrophiesAPI)
* [EzchaUsersAPI](#EzchaUsersAPI)
* [EzchaAPI](#EzchaAPI)
* [EzchaAwaitAll](#EzchaAwaitAll)
* [EzchaDto](#EzchaDto)
* [EzchaPlatformAdapter](#EzchaPlatformAdapter)
* [EzchaRequestBuilder](#EzchaRequestBuilder)
* [EzchaResponse](#EzchaResponse)
* [EzchaServerPlayer](#EzchaServerPlayer)
* [EzchaWebTexture](#EzchaWebTexture)
* [EzchaGame](#EzchaGame)
* [EzchaLeaderboard](#EzchaLeaderboard)
* [EzchaLeaderboardEntry](#EzchaLeaderboardEntry)
* [EzchaNewsPost](#EzchaNewsPost)
* [EzchaTrophyMeta](#EzchaTrophyMeta)
* [EzchaUser](#EzchaUser)
* [EzchaDatastoreValueResponse](#EzchaDatastoreValueResponse)
* [EzchaGameResponse](#EzchaGameResponse)
* [EzchaGameListResponse](#EzchaGameListResponse)
* [EzchaGeneralStatusResponse](#EzchaGeneralStatusResponse)
* [EzchaGeneralTimeResponse](#EzchaGeneralTimeResponse)
* [EzchaLeaderboardListResponse](#EzchaLeaderboardListResponse)
* [EzchaLeaderboardQueuedResponse](#EzchaLeaderboardQueuedResponse)
* [EzchaPaginatedResponse](#EzchaPaginatedResponse)
* [EzchaPaginatedLeaderboardEntryListResponse](#EzchaPaginatedLeaderboardEntryListResponse)
* [EzchaPaginatedNewsListResponse](#EzchaPaginatedNewsListResponse)
* [EzchaPaginatedUserListResponse](#EzchaPaginatedUserListResponse)
* [EzchaSessionValidationResponse](#EzchaSessionValidationResponse)
* [EzchaTrophyMetaListResponse](#EzchaTrophyMetaListResponse)
* [EzchaTrophyQueuedResponse](#EzchaTrophyQueuedResponse)
* [EzchaUserResponse](#EzchaUserResponse)
* [EzchaUserListResponse](#EzchaUserListResponse)

# Class Documentation

<a name="EzchaPlugin"></a>
## EzchaPlugin

**Inherits:** [EditorPlugin](https://docs.godotengine.org/en/4.3/classes/class_editorplugin.html)

A class for internal use.

### Description

You should never need to use this directly. The "EzchaSingleton" class is a good starting point. 

 Many of the values here are used for the dock within the editor and will not be available within an exported game.

### Properties

|Type|Name|Default|
|-|-|-|
|[EditorExportPlugin](https://docs.godotengine.org/en/4.3/classes/class_editorexportplugin.html)|export_plugin|null|
|[Control](https://docs.godotengine.org/en/4.3/classes/class_control.html)|dock|null|
|[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html)|dock_initialized|false|
|[EzchaGame](#EzchaGame)|game|null|
|[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html)|trophies_cached|false|
|[Array](https://docs.godotengine.org/en/4.3/classes/class_array.html) [ [EzchaTrophyMeta](#EzchaTrophyMeta) ]|trophies|[]|
|[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html)|leaderboards_cached|false|
|[Array](https://docs.godotengine.org/en/4.3/classes/class_array.html) [ [EzchaLeaderboard](#EzchaLeaderboard) ]|leaderboards|[]|

<a name="EzchaClient"></a>
## EzchaClient

**Inherits:** [Object](https://docs.godotengine.org/en/4.3/classes/class_object.html)

A helper class to simplify Ezcha Network API integration within game clients.

### Description

This should be accessed through the "Ezcha" singleton.

### Properties

|Type|Name|Default|
|-|-|-|
|[EzchaUser](#EzchaUser)|[user](#EzchaClient-property-user)|null|
|[Array](https://docs.godotengine.org/en/4.3/classes/class_array.html) [ [EzchaTrophyMeta](#EzchaTrophyMeta) ]|[trophies_obtained](#EzchaClient-property-trophies_obtained)|[]|
|[Array](https://docs.godotengine.org/en/4.3/classes/class_array.html) [ [EzchaLeaderboardEntry](#EzchaLeaderboardEntry) ]|[leaderboard_entries](#EzchaClient-property-leaderboard_entries)|[]|
|[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html)|[moderation_tools](#EzchaClient-property-moderation_tools)|false|

### Methods

|Returns|Name|
|-|-|
|[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html)|[authenticate](#EzchaClient-method-authenticate) ( )
|[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html)|[supports_native_login](#EzchaClient-method-supports_native_login) ( )
|[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html)|[request_login](#EzchaClient-method-request_login) ( )
|[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html)|[request_logout](#EzchaClient-method-request_logout) ( )
|[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html)|[is_authenticated](#EzchaClient-method-is_authenticated) ( )
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[get_session_token](#EzchaClient-method-get_session_token) ( )
|[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html)|[has_trophy](#EzchaClient-method-has_trophy) ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) trophy_id, [bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html) include_pending=true )
|[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html)|[grant_trophy](#EzchaClient-method-grant_trophy) ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) trophy_id )
|[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html)|[has_score](#EzchaClient-method-has_score) ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) leaderboard_id )
|[float](https://docs.godotengine.org/en/4.3/classes/class_float.html)|[get_score](#EzchaClient-method-get_score) ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) leaderboard_id, [float](https://docs.godotengine.org/en/4.3/classes/class_float.html) defaults_to=0.0 )
|[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html)|[update_score](#EzchaClient-method-update_score) ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) leaderboard_id, [float](https://docs.godotengine.org/en/4.3/classes/class_float.html) score, [EzchaLeaderboardsAPI.UpdateMode](#EzchaLeaderboardsAPI) mode=EzchaLeaderboardsAPI.UpdateMode.SET )
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[get_datastore](#EzchaClient-method-get_datastore) ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) key )
|[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html)|[set_datastore](#EzchaClient-method-set_datastore) ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) key, [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) value )

### Signals

**authentication_completed** ( [bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html) successful )

Emitted once the authentication process has completed.

**logout_completed** ( [bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html) successful )

Emitted once logged out (not support on web).

**trophy_grant_completed** ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) trophy_id, [bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html) successful, [EzchaTrophyMeta](#EzchaTrophyMeta) trophy_data )

Emitted when a trophy grant is queued from the grant_trophy function. trophy_data will be null if the grant could not be queued.

**leaderboard_update_completed** ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) leaderboard_id, [bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html) successful )

Emitted when a leaderboard update is queued from the update_score function.

**datastore_value_recieved** ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) key, [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) value )

Emitted after a datastore value is requested and recieved

**datastore_value_posted** ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) key, [bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html) successful )

Emitted after a datastore value update is posted.

### Property Descriptions

<a name="EzchaClient-property-user"></a>
[EzchaUser](#EzchaUser) **user** = null

The user who is currently playing the game. Only available after authenticating.

<a name="EzchaClient-property-trophies_obtained"></a>
[Array](https://docs.godotengine.org/en/4.3/classes/class_array.html) [ [EzchaTrophyMeta](#EzchaTrophyMeta) ] **trophies_obtained** = []

The trophies that the currently authenticated user has obtained from this game.

<a name="EzchaClient-property-leaderboard_entries"></a>
[Array](https://docs.godotengine.org/en/4.3/classes/class_array.html) [ [EzchaLeaderboardEntry](#EzchaLeaderboardEntry) ] **leaderboard_entries** = []

The leaderboard entries that the currently authenticated user has for this game.

<a name="EzchaClient-property-moderation_tools"></a>
[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html) **moderation_tools** = false

If true the user should have access to any moderation tools.

### Method Descriptions

<a name="EzchaClient-method-authenticate"></a>
[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html) **authenticate** ( )

Authenticates and loads the information of the current player if available. This should be ran at the start of the game. The authentication_completed signal is emitted on completion. 

 (Async) Returns true if authentication was successful.

<a name="EzchaClient-method-supports_native_login"></a>
[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html) **supports_native_login** ( )

Returns true if the current platform allows for native login/logout.

<a name="EzchaClient-method-request_login"></a>
[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html) **request_login** ( )

Requests the native login flow for platforms that support it. This can be ran at the user's request if automatic authentication fails. The authentication_completed signal is emitted on completion. 

 (Async) Returns true if authentication was successful.

<a name="EzchaClient-method-request_logout"></a>
[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html) **request_logout** ( )

Requests to logout the current user for platforms that support it. The logout_completed signal is emitted on completion. 

 (Async) Returns true if logout was successful.

<a name="EzchaClient-method-is_authenticated"></a>
[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html) **is_authenticated** ( )

Returns true if the client has authenticated and user data is available.

<a name="EzchaClient-method-get_session_token"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **get_session_token** ( )

Returns the player's session token if authenticated.

<a name="EzchaClient-method-has_trophy"></a>
[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html) **has_trophy** ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) trophy_id, [bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html) include_pending=true )

Returns true if the currently authenticated player has the trophy specified.

<a name="EzchaClient-method-grant_trophy"></a>
[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html) **grant_trophy** ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) trophy_id )

Grants a trophy to the currently authenticated player. The trophy must have the "allow clients" option enabled. The trophy_grant_completed signal is emitted on completion. 

 (Async) Returns true if the trophy grant was queued.

<a name="EzchaClient-method-has_score"></a>
[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html) **has_score** ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) leaderboard_id )

Checks if the currently authenticated player has a score on a leaderboard.

<a name="EzchaClient-method-get_score"></a>
[float](https://docs.godotengine.org/en/4.3/classes/class_float.html) **get_score** ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) leaderboard_id, [float](https://docs.godotengine.org/en/4.3/classes/class_float.html) defaults_to=0.0 )

Returns the currently authenticated player's score on a specific leaderboard.

<a name="EzchaClient-method-update_score"></a>
[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html) **update_score** ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) leaderboard_id, [float](https://docs.godotengine.org/en/4.3/classes/class_float.html) score, [EzchaLeaderboardsAPI.UpdateMode](#EzchaLeaderboardsAPI) mode=EzchaLeaderboardsAPI.UpdateMode.SET )

Updates a leaderboard entry belonging to the currently authenticated player. The leaderboard must have the "allow clients" option enabled. The leaderboard_update_completed signal is emitted on completion. 

 (Async) Returns true if the score update was queued.

<a name="EzchaClient-method-get_datastore"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **get_datastore** ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) key )

Get a datastore value belonging to the currently authenticated player. The datastore_value_recieved signal is emitted when the value is recieved. 

 (Async) Returns a string value. The value will be empty if deleted or not yet set.

<a name="EzchaClient-method-set_datastore"></a>
[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html) **set_datastore** ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) key, [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) value )

Update a datastore value belonging to the currently authenticated player. Limit of 5 keys per user, limit of 16384 characters per value. Set the value to an empty string to delete the key. The datastore_value_posted signal is emitted on completion. 

 (Async) Returns true if the value was successfully updated.

<a name="EzchaPlatformAdapterWeb"></a>
## EzchaPlatformAdapterWeb

**Inherits:** [EzchaPlatformAdapter](#EzchaPlatformAdapter)

A class for internal use to handle web specific logic.

### Description

You should never need to use this directly.

### Properties

|Type|Name|Default|
|-|-|-|
|[float](https://docs.godotengine.org/en/4.3/classes/class_float.html)|RESPONSE_WAIT_TIME|0.2|
|[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html)|requesting_session_token|false|
|[SceneTreeTimer](https://docs.godotengine.org/en/4.3/classes/class_scenetreetimer.html)|session_response_timer|null|
|[JavaScriptObject](https://docs.godotengine.org/en/4.3/classes/class_javascriptobject.html)|window_ref|null|
|[JavaScriptObject](https://docs.godotengine.org/en/4.3/classes/class_javascriptobject.html)|window_event_ref|null|

<a name="EzchaSingleton"></a>
## EzchaSingleton

**Inherits:** [Node](https://docs.godotengine.org/en/4.3/classes/class_node.html)

The class representing the "Ezcha" singleton.

### Description

This is where most of the functionality the plugin offers is accessed from.

### Properties

|Type|Name|Default|
|-|-|-|
|[EzchaClient](#EzchaClient)|[client](#EzchaSingleton-property-client)|EzchaClient.new()|
|[EzchaDatastoresAPI](#EzchaDatastoresAPI)|[datastores](#EzchaSingleton-property-datastores)|EzchaDatastoresAPI.new()|
|[EzchaGamesAPI](#EzchaGamesAPI)|[games](#EzchaSingleton-property-games)|EzchaGamesAPI.new()|
|[EzchaGeneralAPI](#EzchaGeneralAPI)|[general](#EzchaSingleton-property-general)|EzchaGeneralAPI.new()|
|[EzchaLeaderboardsAPI](#EzchaLeaderboardsAPI)|[leaderboards](#EzchaSingleton-property-leaderboards)|EzchaLeaderboardsAPI.new()|
|[EzchaNewsAPI](#EzchaNewsAPI)|[news](#EzchaSingleton-property-news)|EzchaNewsAPI.new()|
|[EzchaSessionsAPI](#EzchaSessionsAPI)|[sessions](#EzchaSingleton-property-sessions)|EzchaSessionsAPI.new()|
|[EzchaTrophiesAPI](#EzchaTrophiesAPI)|[trophies](#EzchaSingleton-property-trophies)|EzchaTrophiesAPI.new()|
|[EzchaUsersAPI](#EzchaUsersAPI)|[users](#EzchaSingleton-property-users)|EzchaUsersAPI.new()|

### Methods

|Returns|Name|
|-|-|
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[get_game_id](#EzchaSingleton-method-get_game_id) ( )
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[get_api_key](#EzchaSingleton-method-get_api_key) ( )
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[get_signing_key](#EzchaSingleton-method-get_signing_key) ( )
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[get_session_override](#EzchaSingleton-method-get_session_override) ( )
|[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html)|[should_print_request_errors](#EzchaSingleton-method-should_print_request_errors) ( )

### Property Descriptions

<a name="EzchaSingleton-property-client"></a>
[EzchaClient](#EzchaClient) **client** = EzchaClient.new()

A helper class to simplify Ezcha Network API integration within game clients.

<a name="EzchaSingleton-property-datastores"></a>
[EzchaDatastoresAPI](#EzchaDatastoresAPI) **datastores** = EzchaDatastoresAPI.new()

A wrapper for the datastores section of the API.

<a name="EzchaSingleton-property-games"></a>
[EzchaGamesAPI](#EzchaGamesAPI) **games** = EzchaGamesAPI.new()

A wrapper for the games section of the API.

<a name="EzchaSingleton-property-general"></a>
[EzchaGeneralAPI](#EzchaGeneralAPI) **general** = EzchaGeneralAPI.new()

A wrapper for the general section of the API.

<a name="EzchaSingleton-property-leaderboards"></a>
[EzchaLeaderboardsAPI](#EzchaLeaderboardsAPI) **leaderboards** = EzchaLeaderboardsAPI.new()

A wrapper for the leaderboards section of the API.

<a name="EzchaSingleton-property-news"></a>
[EzchaNewsAPI](#EzchaNewsAPI) **news** = EzchaNewsAPI.new()

A wrapper for the news section of the API.

<a name="EzchaSingleton-property-sessions"></a>
[EzchaSessionsAPI](#EzchaSessionsAPI) **sessions** = EzchaSessionsAPI.new()

A wrapper for the sessions section of the API.

<a name="EzchaSingleton-property-trophies"></a>
[EzchaTrophiesAPI](#EzchaTrophiesAPI) **trophies** = EzchaTrophiesAPI.new()

A wrapper for the trophies section of the API.

<a name="EzchaSingleton-property-users"></a>
[EzchaUsersAPI](#EzchaUsersAPI) **users** = EzchaUsersAPI.new()

A wrapper for the users section of the API.

### Method Descriptions

<a name="EzchaSingleton-method-get_game_id"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **get_game_id** ( )

A helper to return the currently configured game identifier.

<a name="EzchaSingleton-method-get_api_key"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **get_api_key** ( )

A helper to return the currently configured API key.

<a name="EzchaSingleton-method-get_signing_key"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **get_signing_key** ( )

A helper to return the currently configured signing key.

<a name="EzchaSingleton-method-get_session_override"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **get_session_override** ( )

A helper to return the currently configured session override.

<a name="EzchaSingleton-method-should_print_request_errors"></a>
[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html) **should_print_request_errors** ( )

A helper to return if request errors should be printed.

<a name="EzchaDatastoresAPI"></a>
## EzchaDatastoresAPI

**Inherits:** [EzchaAPI](#EzchaAPI)

A wrapper for the datastores section of the API.

### Description

This should be accessed through the "Ezcha" singleton.

### Methods

|Returns|Name|
|-|-|
|[EzchaDatastoreValueResponse](#EzchaDatastoreValueResponse)|[get_client](#EzchaDatastoresAPI-method-get_client) ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) key, [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) session_token )
|[EzchaResponse](#EzchaResponse)|[post_client](#EzchaDatastoresAPI-method-post_client) ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) key, [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) value, [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) session_token )
|[EzchaDatastoreValueResponse](#EzchaDatastoreValueResponse)|[get_server](#EzchaDatastoresAPI-method-get_server) ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) user_id, [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) key )
|[EzchaResponse](#EzchaResponse)|[post_server](#EzchaDatastoresAPI-method-post_server) ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) user_id, [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) key, [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) value )

### Method Descriptions

<a name="EzchaDatastoresAPI-method-get_client"></a>
[EzchaDatastoreValueResponse](#EzchaDatastoreValueResponse) **get_client** ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) key, [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) session_token )

Requests the value of a client-side datastore from its key.

<a name="EzchaDatastoresAPI-method-post_client"></a>
[EzchaResponse](#EzchaResponse) **post_client** ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) key, [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) value, [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) session_token )

Updates the value of a client-side datastore by its key.

<a name="EzchaDatastoresAPI-method-get_server"></a>
[EzchaDatastoreValueResponse](#EzchaDatastoreValueResponse) **get_server** ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) user_id, [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) key )

Requests the value of a server-side datastore for a player from its key.

<a name="EzchaDatastoresAPI-method-post_server"></a>
[EzchaResponse](#EzchaResponse) **post_server** ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) user_id, [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) key, [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) value )

Updates the value of a server-side datastore for a player by its key.

<a name="EzchaGamesAPI"></a>
## EzchaGamesAPI

**Inherits:** [EzchaAPI](#EzchaAPI)

A wrapper for the games section of the API.

### Description

This should be accessed through the "Ezcha" singleton.

### Methods

|Returns|Name|
|-|-|
|[EzchaGameResponse](#EzchaGameResponse)|[get_from_id](#EzchaGamesAPI-method-get_from_id) ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) game_id )
|[EzchaGameResponse](#EzchaGameResponse)|[get_from_slug](#EzchaGamesAPI-method-get_from_slug) ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) game_slug )
|[EzchaGameListResponse](#EzchaGameListResponse)|[get_many](#EzchaGamesAPI-method-get_many) ( [PackedStringArray](https://docs.godotengine.org/en/4.3/classes/class_packedstringarray.html) game_ids, [PackedStringArray](https://docs.godotengine.org/en/4.3/classes/class_packedstringarray.html) game_slugs=PackedStringArray() )
|[EzchaGameResponse](#EzchaGameResponse)|[get_random](#EzchaGamesAPI-method-get_random) ( [bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html) include_elite_exclusives=false )
|[EzchaGameResponse](#EzchaGameResponse)|[get_game_of_the_day](#EzchaGamesAPI-method-get_game_of_the_day) ( )
|[EzchaTrophyMetaListResponse](#EzchaTrophyMetaListResponse)|[get_trophies](#EzchaGamesAPI-method-get_trophies) ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) game_id, [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) session_token="" )
|[EzchaLeaderboardListResponse](#EzchaLeaderboardListResponse)|[get_leaderboards](#EzchaGamesAPI-method-get_leaderboards) ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) game_id, [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) session_token="" )

### Method Descriptions

<a name="EzchaGamesAPI-method-get_from_id"></a>
[EzchaGameResponse](#EzchaGameResponse) **get_from_id** ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) game_id )

Requests a game from its ID.

<a name="EzchaGamesAPI-method-get_from_slug"></a>
[EzchaGameResponse](#EzchaGameResponse) **get_from_slug** ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) game_slug )

Requests a game from its slug.

<a name="EzchaGamesAPI-method-get_many"></a>
[EzchaGameListResponse](#EzchaGameListResponse) **get_many** ( [PackedStringArray](https://docs.godotengine.org/en/4.3/classes/class_packedstringarray.html) game_ids, [PackedStringArray](https://docs.godotengine.org/en/4.3/classes/class_packedstringarray.html) game_slugs=PackedStringArray() )

Requests several games at once.

<a name="EzchaGamesAPI-method-get_random"></a>
[EzchaGameResponse](#EzchaGameResponse) **get_random** ( [bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html) include_elite_exclusives=false )

Requests a randomly chosen game.

<a name="EzchaGamesAPI-method-get_game_of_the_day"></a>
[EzchaGameResponse](#EzchaGameResponse) **get_game_of_the_day** ( )

Requests the current game of the day.

<a name="EzchaGamesAPI-method-get_trophies"></a>
[EzchaTrophyMetaListResponse](#EzchaTrophyMetaListResponse) **get_trophies** ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) game_id, [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) session_token="" )

Requests the trophies belonging to a game. A session with sufficient permissions can be provided to include unlisted trophies, but is not required.

<a name="EzchaGamesAPI-method-get_leaderboards"></a>
[EzchaLeaderboardListResponse](#EzchaLeaderboardListResponse) **get_leaderboards** ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) game_id, [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) session_token="" )

Requests the leaderboards belonging to a game. A session with sufficient permissions can be provided to include unlisted leaderboards, but is not required.

<a name="EzchaGeneralAPI"></a>
## EzchaGeneralAPI

**Inherits:** [EzchaAPI](#EzchaAPI)

A wrapper for the general section of the API.

### Description

This should be accessed through the "Ezcha" singleton.

### Methods

|Returns|Name|
|-|-|
|[EzchaGeneralStatusResponse](#EzchaGeneralStatusResponse)|[get_status](#EzchaGeneralAPI-method-get_status) ( )
|[EzchaGeneralTimeResponse](#EzchaGeneralTimeResponse)|[get_time](#EzchaGeneralAPI-method-get_time) ( )

### Method Descriptions

<a name="EzchaGeneralAPI-method-get_status"></a>
[EzchaGeneralStatusResponse](#EzchaGeneralStatusResponse) **get_status** ( )

Returns the current status of the API.

<a name="EzchaGeneralAPI-method-get_time"></a>
[EzchaGeneralTimeResponse](#EzchaGeneralTimeResponse) **get_time** ( )

Returns the current time from API.

<a name="EzchaLeaderboardsAPI"></a>
## EzchaLeaderboardsAPI

**Inherits:** [EzchaAPI](#EzchaAPI)

A wrapper for the leaderboards section of the API.

### Description

This should be accessed through the "Ezcha" singleton.

### Methods

|Returns|Name|
|-|-|
|[EzchaPaginatedLeaderboardEntryListResponse](#EzchaPaginatedLeaderboardEntryListResponse)|[get_entries](#EzchaLeaderboardsAPI-method-get_entries) ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) leaderboard_id, [int](https://docs.godotengine.org/en/4.3/classes/class_int.html) page=1, [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) session_token="" )
|[EzchaLeaderboardQueuedResponse](#EzchaLeaderboardQueuedResponse)|[post_entry_client](#EzchaLeaderboardsAPI-method-post_entry_client) ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) leaderboard_id, [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) session_token, [float](https://docs.godotengine.org/en/4.3/classes/class_float.html) score, [UpdateMode](https://docs.godotengine.org/en/4.3/classes/class_updatemode.html) mode=UpdateMode.SET )
|[EzchaLeaderboardQueuedResponse](#EzchaLeaderboardQueuedResponse)|[post_entry_server](#EzchaLeaderboardsAPI-method-post_entry_server) ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) leaderboard_id, [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) user_id, [float](https://docs.godotengine.org/en/4.3/classes/class_float.html) score, [UpdateMode](https://docs.godotengine.org/en/4.3/classes/class_updatemode.html) mode=UpdateMode.SET )

### Enumerations

enum **UpdateMode**:

* UpdateMode **SET** = 0
* UpdateMode **ADD** = 1
* UpdateMode **SUBTRACT** = 2

### Method Descriptions

<a name="EzchaLeaderboardsAPI-method-get_entries"></a>
[EzchaPaginatedLeaderboardEntryListResponse](#EzchaPaginatedLeaderboardEntryListResponse) **get_entries** ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) leaderboard_id, [int](https://docs.godotengine.org/en/4.3/classes/class_int.html) page=1, [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) session_token="" )

Returns a paginated list of entries for a specific leaderboard. A session token is only required when attempting to access an unlisted leaderboard.

<a name="EzchaLeaderboardsAPI-method-post_entry_client"></a>
[EzchaLeaderboardQueuedResponse](#EzchaLeaderboardQueuedResponse) **post_entry_client** ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) leaderboard_id, [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) session_token, [float](https://docs.godotengine.org/en/4.3/classes/class_float.html) score, [UpdateMode](https://docs.godotengine.org/en/4.3/classes/class_updatemode.html) mode=UpdateMode.SET )

Updates a score from a game client using a session token. Requires a signing key to be configured.

<a name="EzchaLeaderboardsAPI-method-post_entry_server"></a>
[EzchaLeaderboardQueuedResponse](#EzchaLeaderboardQueuedResponse) **post_entry_server** ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) leaderboard_id, [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) user_id, [float](https://docs.godotengine.org/en/4.3/classes/class_float.html) score, [UpdateMode](https://docs.godotengine.org/en/4.3/classes/class_updatemode.html) mode=UpdateMode.SET )

Updates a score from a game server using an API key. Requires an API key to be configured.

<a name="EzchaNewsAPI"></a>
## EzchaNewsAPI

**Inherits:** [EzchaAPI](#EzchaAPI)

A wrapper for the news section of the API.

### Description

This should be accessed through the "Ezcha" singleton.

### Methods

|Returns|Name|
|-|-|
|[EzchaPaginatedNewsListResponse](#EzchaPaginatedNewsListResponse)|[get_list](#EzchaNewsAPI-method-get_list) ( [int](https://docs.godotengine.org/en/4.3/classes/class_int.html) page=1, [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) category="", [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) series="", [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) order="" )

### Method Descriptions

<a name="EzchaNewsAPI-method-get_list"></a>
[EzchaPaginatedNewsListResponse](#EzchaPaginatedNewsListResponse) **get_list** ( [int](https://docs.godotengine.org/en/4.3/classes/class_int.html) page=1, [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) category="", [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) series="", [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) order="" )

Returns a paginated list of news posts based on the criteria provided.

<a name="EzchaSessionsAPI"></a>
## EzchaSessionsAPI

**Inherits:** [EzchaAPI](#EzchaAPI)

A wrapper for the sessions section of the API.

### Description

This should be accessed through the "Ezcha" singleton.

### Methods

|Returns|Name|
|-|-|
|[EzchaSessionValidationResponse](#EzchaSessionValidationResponse)|[post_validation](#EzchaSessionsAPI-method-post_validation) ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) session_token="", [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) game_id="" )

### Method Descriptions

<a name="EzchaSessionsAPI-method-post_validation"></a>
[EzchaSessionValidationResponse](#EzchaSessionValidationResponse) **post_validation** ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) session_token="", [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) game_id="" )

Returns a paginated list of news posts based on the criteria provided. Category and series are mutually exclusive and cannot be used together.

<a name="EzchaTrophiesAPI"></a>
## EzchaTrophiesAPI

**Inherits:** [EzchaAPI](#EzchaAPI)

A wrapper for the trophies section of the API.

### Description

This should be accessed through the "Ezcha" singleton.

### Methods

|Returns|Name|
|-|-|
|[EzchaTrophyQueuedResponse](#EzchaTrophyQueuedResponse)|[post_grant_client](#EzchaTrophiesAPI-method-post_grant_client) ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) trophy_id, [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) session_token )
|[EzchaTrophyQueuedResponse](#EzchaTrophyQueuedResponse)|[post_grant_server](#EzchaTrophiesAPI-method-post_grant_server) ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) trophy_id, [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) user_id )

### Method Descriptions

<a name="EzchaTrophiesAPI-method-post_grant_client"></a>
[EzchaTrophyQueuedResponse](#EzchaTrophyQueuedResponse) **post_grant_client** ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) trophy_id, [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) session_token )

Updates a score from a game client using a session token. Requires a signing key to be configured.

<a name="EzchaTrophiesAPI-method-post_grant_server"></a>
[EzchaTrophyQueuedResponse](#EzchaTrophyQueuedResponse) **post_grant_server** ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) trophy_id, [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) user_id )

Updates a score from a game server using an API key. Requires an API key to be configured.

<a name="EzchaUsersAPI"></a>
## EzchaUsersAPI

**Inherits:** [EzchaAPI](#EzchaAPI)

A wrapper for the users section of the API.

### Description

This should be accessed through the "Ezcha" singleton.

### Methods

|Returns|Name|
|-|-|
|[EzchaUserResponse](#EzchaUserResponse)|[get_from_id](#EzchaUsersAPI-method-get_from_id) ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) user_id )
|[EzchaUserResponse](#EzchaUserResponse)|[get_from_name](#EzchaUsersAPI-method-get_from_name) ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) username )
|[EzchaUserListResponse](#EzchaUserListResponse)|[get_many](#EzchaUsersAPI-method-get_many) ( [PackedStringArray](https://docs.godotengine.org/en/4.3/classes/class_packedstringarray.html) user_ids, [PackedStringArray](https://docs.godotengine.org/en/4.3/classes/class_packedstringarray.html) usernames=PackedStringArray() )
|[EzchaPaginatedUserListResponse](#EzchaPaginatedUserListResponse)|[get_list](#EzchaUsersAPI-method-get_list) ( [int](https://docs.godotengine.org/en/4.3/classes/class_int.html) page=1, [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) category="", [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) order="" )

### Method Descriptions

<a name="EzchaUsersAPI-method-get_from_id"></a>
[EzchaUserResponse](#EzchaUserResponse) **get_from_id** ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) user_id )

Requests a user from their ID.

<a name="EzchaUsersAPI-method-get_from_name"></a>
[EzchaUserResponse](#EzchaUserResponse) **get_from_name** ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) username )

Requests a user from their name.

<a name="EzchaUsersAPI-method-get_many"></a>
[EzchaUserListResponse](#EzchaUserListResponse) **get_many** ( [PackedStringArray](https://docs.godotengine.org/en/4.3/classes/class_packedstringarray.html) user_ids, [PackedStringArray](https://docs.godotengine.org/en/4.3/classes/class_packedstringarray.html) usernames=PackedStringArray() )

Requests several users at once.

<a name="EzchaUsersAPI-method-get_list"></a>
[EzchaPaginatedUserListResponse](#EzchaPaginatedUserListResponse) **get_list** ( [int](https://docs.godotengine.org/en/4.3/classes/class_int.html) page=1, [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) category="", [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) order="" )

Returns a paginated list of user based on the criteria provided.

<a name="EzchaAPI"></a>
## EzchaAPI

**Inherits:** [Object](https://docs.godotengine.org/en/4.3/classes/class_object.html)

A base class for handling calls to the Ezcha Network API.

<a name="EzchaAwaitAll"></a>
## EzchaAwaitAll

**Inherits:** [RefCounted](https://docs.godotengine.org/en/4.3/classes/class_refcounted.html)

A helper class to conveniently monitor multiple async coroutines.

### Description

Emits a signal once all provided coroutines have completed. Provides its own async function that can be used to block execution.

### Methods

|Returns|Name|
|-|-|
|void|[add](#EzchaAwaitAll-method-add) ( [Callable](https://docs.godotengine.org/en/4.3/classes/class_callable.html) target, [Variant](https://docs.godotengine.org/en/4.3/classes/class_variant.html)  )
|[int](https://docs.godotengine.org/en/4.3/classes/class_int.html)|[count](#EzchaAwaitAll-method-count) ( )
|void|[block](#EzchaAwaitAll-method-block) ( )

### Signals

**completed** ( )

Emitted once all coroutines have completed.

### Method Descriptions

<a name="EzchaAwaitAll-method-add"></a>
void **add** ( [Callable](https://docs.godotengine.org/en/4.3/classes/class_callable.html) target, [Variant](https://docs.godotengine.org/en/4.3/classes/class_variant.html)  )

Add a coroutine to be watched

<a name="EzchaAwaitAll-method-count"></a>
[int](https://docs.godotengine.org/en/4.3/classes/class_int.html) **count** ( )

Returns how many coroutines are being watched

<a name="EzchaAwaitAll-method-block"></a>
void **block** ( )

(Async) Blocks execution until all coroutines complete

<a name="EzchaDto"></a>
## EzchaDto

**Inherits:** [RefCounted](https://docs.godotengine.org/en/4.3/classes/class_refcounted.html)

A base class for handling data returned by the Ezcha Network API.

<a name="EzchaPlatformAdapter"></a>
## EzchaPlatformAdapter

**Inherits:** [RefCounted](https://docs.godotengine.org/en/4.3/classes/class_refcounted.html)

A class for internal use to handle platform specific logic.

### Description

You should never need to use this directly.

### Methods

|Returns|Name|
|-|-|
|[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html)|supports_login ( )

### Signals

**auth_flow_completed** ( [Variant](https://docs.godotengine.org/en/4.3/classes/class_variant.html) token )



**login_flow_completed** ( [Variant](https://docs.godotengine.org/en/4.3/classes/class_variant.html) token )



**logout_completed** ( [bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html) success )



<a name="EzchaRequestBuilder"></a>
## EzchaRequestBuilder

**Inherits:** [RefCounted](https://docs.godotengine.org/en/4.3/classes/class_refcounted.html)

A class for building and making requests to the Ezcha Network API.

### Methods

|Returns|Name|
|-|-|
|[EzchaRequestBuilder](#EzchaRequestBuilder)|[set_endpoint](#EzchaRequestBuilder-method-set_endpoint) ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) value )
|[EzchaRequestBuilder](#EzchaRequestBuilder)|[set_method](#EzchaRequestBuilder-method-set_method) ( [HTTPClient.Method](https://docs.godotengine.org/en/4.3/classes/class_httpclient.html) value )
|[EzchaRequestBuilder](#EzchaRequestBuilder)|[set_authentication](#EzchaRequestBuilder-method-set_authentication) ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) token )
|[EzchaRequestBuilder](#EzchaRequestBuilder)|[set_signing_key](#EzchaRequestBuilder-method-set_signing_key) ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) key )
|[EzchaRequestBuilder](#EzchaRequestBuilder)|[set_response_object](#EzchaRequestBuilder-method-set_response_object) ( [EzchaResponse](#EzchaResponse) obj )
|[EzchaRequestBuilder](#EzchaRequestBuilder)|[add_query_parameter](#EzchaRequestBuilder-method-add_query_parameter) ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) key, [Variant](https://docs.godotengine.org/en/4.3/classes/class_variant.html) value )
|[EzchaRequestBuilder](#EzchaRequestBuilder)|[add_body_data](#EzchaRequestBuilder-method-add_body_data) ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) key, [Variant](https://docs.godotengine.org/en/4.3/classes/class_variant.html) value )
|void|[fetch](#EzchaRequestBuilder-method-fetch) ( )

### Method Descriptions

<a name="EzchaRequestBuilder-method-set_endpoint"></a>
[EzchaRequestBuilder](#EzchaRequestBuilder) **set_endpoint** ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) value )

Sets the target endpoint.

<a name="EzchaRequestBuilder-method-set_method"></a>
[EzchaRequestBuilder](#EzchaRequestBuilder) **set_method** ( [HTTPClient.Method](https://docs.godotengine.org/en/4.3/classes/class_httpclient.html) value )

Sets the method to be used.

<a name="EzchaRequestBuilder-method-set_authentication"></a>
[EzchaRequestBuilder](#EzchaRequestBuilder) **set_authentication** ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) token )

Sets the authentication header for the request.

<a name="EzchaRequestBuilder-method-set_signing_key"></a>
[EzchaRequestBuilder](#EzchaRequestBuilder) **set_signing_key** ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) key )

Enables request signing and defines the signing key to use. Requires authentication to be set to a session token.

<a name="EzchaRequestBuilder-method-set_response_object"></a>
[EzchaRequestBuilder](#EzchaRequestBuilder) **set_response_object** ( [EzchaResponse](#EzchaResponse) obj )

Set the response object.

<a name="EzchaRequestBuilder-method-add_query_parameter"></a>
[EzchaRequestBuilder](#EzchaRequestBuilder) **add_query_parameter** ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) key, [Variant](https://docs.godotengine.org/en/4.3/classes/class_variant.html) value )

Adds a parameter to the query string. The value should either be a string or an array of strings.

<a name="EzchaRequestBuilder-method-add_body_data"></a>
[EzchaRequestBuilder](#EzchaRequestBuilder) **add_body_data** ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) key, [Variant](https://docs.godotengine.org/en/4.3/classes/class_variant.html) value )

Adds a value to the body data.

<a name="EzchaRequestBuilder-method-fetch"></a>
void **fetch** ( )

Makes the request.

<a name="EzchaResponse"></a>
## EzchaResponse

**Inherits:** [RefCounted](https://docs.godotengine.org/en/4.3/classes/class_refcounted.html)

The base class for handling Ezcha Network API responses.

### Methods

|Returns|Name|
|-|-|
|[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html)|[is_successful](#EzchaResponse-method-is_successful) ( )
|[int](https://docs.godotengine.org/en/4.3/classes/class_int.html)|[get_status](#EzchaResponse-method-get_status) ( )
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[get_error](#EzchaResponse-method-get_error) ( )
|[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html)|[is_pending](#EzchaResponse-method-is_pending) ( )

### Signals

**recieved** ( )

Emitted once the response has been recieved and processed.

### Method Descriptions

<a name="EzchaResponse-method-is_successful"></a>
[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html) **is_successful** ( )

Returns if the response is okay and is not an error.

<a name="EzchaResponse-method-get_status"></a>
[int](https://docs.godotengine.org/en/4.3/classes/class_int.html) **get_status** ( )

Returns the status code.

<a name="EzchaResponse-method-get_error"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **get_error** ( )

Returns the error message if available.

<a name="EzchaResponse-method-is_pending"></a>
[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html) **is_pending** ( )

Returns if the response is pending or not.

<a name="EzchaServerPlayer"></a>
## EzchaServerPlayer

**Inherits:** [RefCounted](https://docs.godotengine.org/en/4.3/classes/class_refcounted.html)

A helper class for managing player data (sessions, user info, trophies, etc) on a server.

### Description

You shouldn't use this client-side or when making a singleplayer game. In those cases you should use Ezcha.client instead.

### Properties

|Type|Name|Default|
|-|-|-|
|[EzchaUser](#EzchaUser)|[user](#EzchaServerPlayer-property-user)|null|
|[Array](https://docs.godotengine.org/en/4.3/classes/class_array.html) [ [EzchaTrophyMeta](#EzchaTrophyMeta) ]|[trophies_obtained](#EzchaServerPlayer-property-trophies_obtained)|[]|
|[Array](https://docs.godotengine.org/en/4.3/classes/class_array.html) [ [EzchaLeaderboardEntry](#EzchaLeaderboardEntry) ]|[leaderboard_entries](#EzchaServerPlayer-property-leaderboard_entries)|[]|
|[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html)|[moderation_tools](#EzchaServerPlayer-property-moderation_tools)|false|

### Methods

|Returns|Name|
|-|-|
|[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html)|[authenticate](#EzchaServerPlayer-method-authenticate) ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) session_token )
|[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html)|[is_authenticated](#EzchaServerPlayer-method-is_authenticated) ( )
|[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html)|[has_trophy](#EzchaServerPlayer-method-has_trophy) ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) trophy_id, [bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html) include_pending=true )
|[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html)|[grant_trophy](#EzchaServerPlayer-method-grant_trophy) ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) trophy_id )
|[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html)|[has_score](#EzchaServerPlayer-method-has_score) ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) leaderboard_id )
|[float](https://docs.godotengine.org/en/4.3/classes/class_float.html)|[get_score](#EzchaServerPlayer-method-get_score) ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) leaderboard_id, [float](https://docs.godotengine.org/en/4.3/classes/class_float.html) defaults_to=0.0 )
|[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html)|[update_score](#EzchaServerPlayer-method-update_score) ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) leaderboard_id, [float](https://docs.godotengine.org/en/4.3/classes/class_float.html) score, [EzchaLeaderboardsAPI.UpdateMode](#EzchaLeaderboardsAPI) mode=EzchaLeaderboardsAPI.UpdateMode.SET )
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[get_datastore](#EzchaServerPlayer-method-get_datastore) ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) key )
|[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html)|[set_datastore](#EzchaServerPlayer-method-set_datastore) ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) key, [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) value )

### Signals

**authentication_completed** ( [bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html) successful )

Emitted once a session token has been authenticated.

**trophy_grant_completed** ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) trophy_id, [bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html) successful, [EzchaTrophyMeta](#EzchaTrophyMeta) trophy_data )

Emitted when a trophy grant is queued from the grant_trophy function. trophy_data will be null if the grant could not be queued.

**leaderboard_update_completed** ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) leaderboard_id, [bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html) successful )

Emitted when a leaderboard update is queued from the update_score function.

**datastore_value_recieved** ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) key, [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) value )

Emitted after a datastore value is requested and recieved

**datastore_value_posted** ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) key, [bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html) successful )

Emitted after a datastore value update is posted.

### Property Descriptions

<a name="EzchaServerPlayer-property-user"></a>
[EzchaUser](#EzchaUser) **user** = null

The user data of the player. Only available after authenticating.

<a name="EzchaServerPlayer-property-trophies_obtained"></a>
[Array](https://docs.godotengine.org/en/4.3/classes/class_array.html) [ [EzchaTrophyMeta](#EzchaTrophyMeta) ] **trophies_obtained** = []

The trophies that the user has obtained from this game.

<a name="EzchaServerPlayer-property-leaderboard_entries"></a>
[Array](https://docs.godotengine.org/en/4.3/classes/class_array.html) [ [EzchaLeaderboardEntry](#EzchaLeaderboardEntry) ] **leaderboard_entries** = []

The leaderboard entries that the currently authenticated user has for this game.

<a name="EzchaServerPlayer-property-moderation_tools"></a>
[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html) **moderation_tools** = false

If true the user should have access to any moderation tools.

### Method Descriptions

<a name="EzchaServerPlayer-method-authenticate"></a>
[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html) **authenticate** ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) session_token )

Authenticates a session token and loads player information. 

 (Async) Returns true if authentication was successful. 

 The authentication_completed signal is emitted on completion.

<a name="EzchaServerPlayer-method-is_authenticated"></a>
[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html) **is_authenticated** ( )

Returns true if the player has authenticated and user data is available.

<a name="EzchaServerPlayer-method-has_trophy"></a>
[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html) **has_trophy** ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) trophy_id, [bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html) include_pending=true )

Returns true if the player has the trophy specified.

<a name="EzchaServerPlayer-method-grant_trophy"></a>
[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html) **grant_trophy** ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) trophy_id )

Grants a trophy to the currently authenticated user. 

 (Async) Returns true if the trophy grant was queued.

<a name="EzchaServerPlayer-method-has_score"></a>
[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html) **has_score** ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) leaderboard_id )

Checks if the player has a score on a leaderboard.

<a name="EzchaServerPlayer-method-get_score"></a>
[float](https://docs.godotengine.org/en/4.3/classes/class_float.html) **get_score** ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) leaderboard_id, [float](https://docs.godotengine.org/en/4.3/classes/class_float.html) defaults_to=0.0 )

Returns the players's score on a specific leaderboard.

<a name="EzchaServerPlayer-method-update_score"></a>
[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html) **update_score** ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) leaderboard_id, [float](https://docs.godotengine.org/en/4.3/classes/class_float.html) score, [EzchaLeaderboardsAPI.UpdateMode](#EzchaLeaderboardsAPI) mode=EzchaLeaderboardsAPI.UpdateMode.SET )

Updates a leaderboard entry belonging to the player. 

 (Async) Returns true if the score update was queued.

<a name="EzchaServerPlayer-method-get_datastore"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **get_datastore** ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) key )

Get a datastore value belonging to the currently authenticated player. The datastore_value_recieved signal is emitted when the value is recieved. 

 (Async) Returns a string value. The value will be empty if deleted or not yet set.

<a name="EzchaServerPlayer-method-set_datastore"></a>
[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html) **set_datastore** ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) key, [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) value )

Update a datastore value belonging to the currently authenticated player. Limit of 5 keys per user, limit of 16384 characters per value. Set the value to an empty string to delete the key. The datastore_value_posted signal is emitted on completion. 

 (Async) Returns true if the value was successfully updated.

<a name="EzchaWebTexture"></a>
## EzchaWebTexture

**Inherits:** [ImageTexture](https://docs.godotengine.org/en/4.3/classes/class_imagetexture.html)

A helper texture resource that loads an image from the internet.

### Methods

|Returns|Name|
|-|-|
|[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html)|[is_successful](#EzchaWebTexture-method-is_successful) ( )
|void|fetch ( [String](https://docs.godotengine.org/en/4.3/classes/class_string.html) url )

### Signals

**loaded** ( )

Emitted when the image is downloaded and ready to be displayed.

**error** ( )

Emitted if the image could not be loaded.

### Method Descriptions

<a name="EzchaWebTexture-method-is_successful"></a>
[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html) **is_successful** ( )

Returns true if the image has been downloaded and parsed.

<a name="EzchaGame"></a>
## EzchaGame

**Inherits:** [EzchaDto](#EzchaDto)

### Properties

|Type|Name|Default|
|-|-|-|
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[id](#EzchaGame-property-id)|""|
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[slug](#EzchaGame-property-slug)|""|
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[name](#EzchaGame-property-name)|""|
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[description](#EzchaGame-property-description)|""|
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[version](#EzchaGame-property-version)|""|
|[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html)|[elite_exclusive](#EzchaGame-property-elite_exclusive)|false|
|[EzchaUser](#EzchaUser)|[developer](#EzchaGame-property-developer)|null|
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[url](#EzchaGame-property-url)|""|
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[banner_url](#EzchaGame-property-banner_url)|""|
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[thumbnail_url](#EzchaGame-property-thumbnail_url)|""|
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[released_timestamp](#EzchaGame-property-released_timestamp)|""|
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[original_released_timestamp](#EzchaGame-property-original_released_timestamp)|""|

### Property Descriptions

<a name="EzchaGame-property-id"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **id** = ""

The game's unique identifier.

<a name="EzchaGame-property-slug"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **slug** = ""

The user-friendly identifier for the game in URLs.

<a name="EzchaGame-property-name"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **name** = ""

The display name of the game.

<a name="EzchaGame-property-description"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **description** = ""

The description for the game.

<a name="EzchaGame-property-version"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **version** = ""

The version the game is specified to be at. This does not follow any specific format.

<a name="EzchaGame-property-elite_exclusive"></a>
[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html) **elite_exclusive** = false

If true the game can only be accessed by users who have elite membership.

<a name="EzchaGame-property-developer"></a>
[EzchaUser](#EzchaUser) **developer** = null

The developer for the game.

<a name="EzchaGame-property-url"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **url** = ""

The URL the game can be viewed and played at.

<a name="EzchaGame-property-banner_url"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **banner_url** = ""

The URL for the game's banner image. This will be a png file.

<a name="EzchaGame-property-thumbnail_url"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **thumbnail_url** = ""

The URL for the game's thumbnail image. This will be a png file.

<a name="EzchaGame-property-released_timestamp"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **released_timestamp** = ""

The timestamp for when the game was released on Ezcha.

<a name="EzchaGame-property-original_released_timestamp"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **original_released_timestamp** = ""

The timestamp for when the game was published on other platforms before Ezcha. Not all games will have this.

<a name="EzchaLeaderboard"></a>
## EzchaLeaderboard

**Inherits:** [EzchaDto](#EzchaDto)

### Properties

|Type|Name|Default|
|-|-|-|
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[id](#EzchaLeaderboard-property-id)|""|
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[name](#EzchaLeaderboard-property-name)|""|
|[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html)|[unlisted](#EzchaLeaderboard-property-unlisted)|false|
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[sorting](#EzchaLeaderboard-property-sorting)|""|
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[value_type](#EzchaLeaderboard-property-value_type)|""|
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[value_prefix](#EzchaLeaderboard-property-value_prefix)|""|
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[value_suffix](#EzchaLeaderboard-property-value_suffix)|""|
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[created_timestamp](#EzchaLeaderboard-property-created_timestamp)|""|

### Property Descriptions

<a name="EzchaLeaderboard-property-id"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **id** = ""

The leaderboard's unique identifier.

<a name="EzchaLeaderboard-property-name"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **name** = ""

The display name of the leaderboard.

<a name="EzchaLeaderboard-property-unlisted"></a>
[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html) **unlisted** = false

Indicates if the leaderboard is hidden from public view.

<a name="EzchaLeaderboard-property-sorting"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **sorting** = ""

The sort mode of the leaderboard. ("asc" or "desc")

<a name="EzchaLeaderboard-property-value_type"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **value_type** = ""

The value type the leaderboard represents. (Score, Points, Wins, etc)

<a name="EzchaLeaderboard-property-value_prefix"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **value_prefix** = ""

The prefix to show before the values when displayed.

<a name="EzchaLeaderboard-property-value_suffix"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **value_suffix** = ""

The suffix to show after the values when displayed.

<a name="EzchaLeaderboard-property-created_timestamp"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **created_timestamp** = ""

The timestamp of when the leaderboard was created.

<a name="EzchaLeaderboardEntry"></a>
## EzchaLeaderboardEntry

**Inherits:** [EzchaDto](#EzchaDto)

### Properties

|Type|Name|Default|
|-|-|-|
|[float](https://docs.godotengine.org/en/4.3/classes/class_float.html)|[score](#EzchaLeaderboardEntry-property-score)|0.0|
|[EzchaLeaderboard](#EzchaLeaderboard)|[leaderboard](#EzchaLeaderboardEntry-property-leaderboard)|null|
|[EzchaUser](#EzchaUser)|[user](#EzchaLeaderboardEntry-property-user)|null|
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[created_timestamp](#EzchaLeaderboardEntry-property-created_timestamp)|""|
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[last_updated_timestamp](#EzchaLeaderboardEntry-property-last_updated_timestamp)|""|

### Property Descriptions

<a name="EzchaLeaderboardEntry-property-score"></a>
[float](https://docs.godotengine.org/en/4.3/classes/class_float.html) **score** = 0.0

The entry's current score.

<a name="EzchaLeaderboardEntry-property-leaderboard"></a>
[EzchaLeaderboard](#EzchaLeaderboard) **leaderboard** = null

The leaderboard that the entry belongs to. Not all responses will included this data.

<a name="EzchaLeaderboardEntry-property-user"></a>
[EzchaUser](#EzchaUser) **user** = null

The user that the entry belongs to. Not all responses will included this data.

<a name="EzchaLeaderboardEntry-property-created_timestamp"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **created_timestamp** = ""

The timestamp of when this entry was first created.

<a name="EzchaLeaderboardEntry-property-last_updated_timestamp"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **last_updated_timestamp** = ""

The timestamp of when this entry was last updated.

<a name="EzchaNewsPost"></a>
## EzchaNewsPost

**Inherits:** [EzchaDto](#EzchaDto)

### Properties

|Type|Name|Default|
|-|-|-|
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[id](#EzchaNewsPost-property-id)|""|
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[slug](#EzchaNewsPost-property-slug)|""|
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[title](#EzchaNewsPost-property-title)|""|
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[summary](#EzchaNewsPost-property-summary)|""|
|[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html)|[elite_exclusive](#EzchaNewsPost-property-elite_exclusive)|false|
|[EzchaUser](#EzchaUser)|[author](#EzchaNewsPost-property-author)|null|
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[published_timestamp](#EzchaNewsPost-property-published_timestamp)|""|
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[edited_timestamp](#EzchaNewsPost-property-edited_timestamp)|""|
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[url](#EzchaNewsPost-property-url)|""|
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[image_url](#EzchaNewsPost-property-image_url)|""|

### Property Descriptions

<a name="EzchaNewsPost-property-id"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **id** = ""

The news post's unique identifier.

<a name="EzchaNewsPost-property-slug"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **slug** = ""

The user-friendly identifier for the news post in URLs.

<a name="EzchaNewsPost-property-title"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **title** = ""

The title of the news post.

<a name="EzchaNewsPost-property-summary"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **summary** = ""

A short summary of the news post.

<a name="EzchaNewsPost-property-elite_exclusive"></a>
[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html) **elite_exclusive** = false

If true the news post can only be accessed by users who have elite membership.

<a name="EzchaNewsPost-property-author"></a>
[EzchaUser](#EzchaUser) **author** = null

The author of the news post.

<a name="EzchaNewsPost-property-published_timestamp"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **published_timestamp** = ""

The timestamp of when the news post was published.

<a name="EzchaNewsPost-property-edited_timestamp"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **edited_timestamp** = ""

The timestamp of when the news post was last edited. Not all news posts will have this.

<a name="EzchaNewsPost-property-url"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **url** = ""

The URL that the news post can be viewed at.

<a name="EzchaNewsPost-property-image_url"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **image_url** = ""

The URL of the news post's featured image. Not all news posts will have this.

<a name="EzchaTrophyMeta"></a>
## EzchaTrophyMeta

**Inherits:** [EzchaDto](#EzchaDto)

### Properties

|Type|Name|Default|
|-|-|-|
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[id](#EzchaTrophyMeta-property-id)|""|
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[name](#EzchaTrophyMeta-property-name)|""|
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[description](#EzchaTrophyMeta-property-description)|""|
|[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html)|[unlisted](#EzchaTrophyMeta-property-unlisted)|false|
|[int](https://docs.godotengine.org/en/4.3/classes/class_int.html)|[experience_points](#EzchaTrophyMeta-property-experience_points)|0|
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[created_timestamp](#EzchaTrophyMeta-property-created_timestamp)|""|
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[icon_url](#EzchaTrophyMeta-property-icon_url)|""|

### Property Descriptions

<a name="EzchaTrophyMeta-property-id"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **id** = ""

The trophy's unique identifier.

<a name="EzchaTrophyMeta-property-name"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **name** = ""

The display name of the trophy.

<a name="EzchaTrophyMeta-property-description"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **description** = ""

The description of the trophy. This typically includes its criteria.

<a name="EzchaTrophyMeta-property-unlisted"></a>
[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html) **unlisted** = false

Indicates if the trophy is hidden from public view.

<a name="EzchaTrophyMeta-property-experience_points"></a>
[int](https://docs.godotengine.org/en/4.3/classes/class_int.html) **experience_points** = 0

The number of experience points the trophy rewards once recieved.

<a name="EzchaTrophyMeta-property-created_timestamp"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **created_timestamp** = ""

The timestamp of when the trophy was created.

<a name="EzchaTrophyMeta-property-icon_url"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **icon_url** = ""

The URL for the trophy's icon image. This will be a png file.

<a name="EzchaUser"></a>
## EzchaUser

**Inherits:** [EzchaDto](#EzchaDto)

### Properties

|Type|Name|Default|
|-|-|-|
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[id](#EzchaUser-property-id)|""|
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[name](#EzchaUser-property-name)|""|
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[bio](#EzchaUser-property-bio)|""|
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[role](#EzchaUser-property-role)|""|
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[title](#EzchaUser-property-title)|""|
|[int](https://docs.godotengine.org/en/4.3/classes/class_int.html)|[level](#EzchaUser-property-level)|-1|
|[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html)|[elite](#EzchaUser-property-elite)|false|
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[registered_timestamp](#EzchaUser-property-registered_timestamp)|""|
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[last_seen_timestamp](#EzchaUser-property-last_seen_timestamp)|""|
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[url](#EzchaUser-property-url)|""|
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[avatar_url](#EzchaUser-property-avatar_url)|""|

### Property Descriptions

<a name="EzchaUser-property-id"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **id** = ""

The user's unique identifier.

<a name="EzchaUser-property-name"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **name** = ""

The user's unique username.

<a name="EzchaUser-property-bio"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **bio** = ""

A description provided by the user. This is displayed in the "about me" section on Ezcha profiles.

<a name="EzchaUser-property-role"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **role** = ""

The user's role if they currently have one.

<a name="EzchaUser-property-title"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **title** = ""

The user's title if they currently have one.

<a name="EzchaUser-property-level"></a>
[int](https://docs.godotengine.org/en/4.3/classes/class_int.html) **level** = -1

The total level the user is currently at.

<a name="EzchaUser-property-elite"></a>
[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html) **elite** = false

If true the user currently has elite membership.

<a name="EzchaUser-property-registered_timestamp"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **registered_timestamp** = ""

The timestamp of when the user registered their account.

<a name="EzchaUser-property-last_seen_timestamp"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **last_seen_timestamp** = ""

The timestamp of when the user was last seen online.

<a name="EzchaUser-property-url"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **url** = ""

The URL to view the user's profile.

<a name="EzchaUser-property-avatar_url"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **avatar_url** = ""

The URL for the user's avatar/profile picture. This will be a png file.

<a name="EzchaDatastoreValueResponse"></a>
## EzchaDatastoreValueResponse

**Inherits:** [EzchaResponse](#EzchaResponse)

A paginated response from the API.

### Properties

|Type|Name|Default|
|-|-|-|
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[value](#EzchaDatastoreValueResponse-property-value)|""|

### Property Descriptions

<a name="EzchaDatastoreValueResponse-property-value"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **value** = ""

The value of the requested key. Returns an empty string if deleted or not set.

<a name="EzchaGameResponse"></a>
## EzchaGameResponse

**Inherits:** [EzchaResponse](#EzchaResponse)

A response from the API containing a single game.

### Properties

|Type|Name|Default|
|-|-|-|
|[EzchaGame](#EzchaGame)|[game](#EzchaGameResponse-property-game)|null|

### Property Descriptions

<a name="EzchaGameResponse-property-game"></a>
[EzchaGame](#EzchaGame) **game** = null

The game returned by the API request.

<a name="EzchaGameListResponse"></a>
## EzchaGameListResponse

**Inherits:** [EzchaResponse](#EzchaResponse)

A response from the API containing a list of games.

### Properties

|Type|Name|Default|
|-|-|-|
|[Array](https://docs.godotengine.org/en/4.3/classes/class_array.html) [ [EzchaGame](#EzchaGame) ]|[games](#EzchaGameListResponse-property-games)|[]|

### Property Descriptions

<a name="EzchaGameListResponse-property-games"></a>
[Array](https://docs.godotengine.org/en/4.3/classes/class_array.html) [ [EzchaGame](#EzchaGame) ] **games** = []

The list of games returned by the API request.

<a name="EzchaGeneralStatusResponse"></a>
## EzchaGeneralStatusResponse

**Inherits:** [EzchaResponse](#EzchaResponse)

A response from the API containing the status of the API.

### Properties

|Type|Name|Default|
|-|-|-|
|[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html)|[online](#EzchaGeneralStatusResponse-property-online)|false|

### Property Descriptions

<a name="EzchaGeneralStatusResponse-property-online"></a>
[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html) **online** = false

Indicates if the Ezcha Network API is online and accessible.

<a name="EzchaGeneralTimeResponse"></a>
## EzchaGeneralTimeResponse

**Inherits:** [EzchaResponse](#EzchaResponse)

A response from the API containing the current time.

### Properties

|Type|Name|Default|
|-|-|-|
|[String](https://docs.godotengine.org/en/4.3/classes/class_string.html)|[timestamp](#EzchaGeneralTimeResponse-property-timestamp)|""|
|[int](https://docs.godotengine.org/en/4.3/classes/class_int.html)|[epoch](#EzchaGeneralTimeResponse-property-epoch)|-1|

### Property Descriptions

<a name="EzchaGeneralTimeResponse-property-timestamp"></a>
[String](https://docs.godotengine.org/en/4.3/classes/class_string.html) **timestamp** = ""

The server's current time as an ISO 8601 datestring.

<a name="EzchaGeneralTimeResponse-property-epoch"></a>
[int](https://docs.godotengine.org/en/4.3/classes/class_int.html) **epoch** = -1

The server's current time as a unix epoch measured in milliseconds.

<a name="EzchaLeaderboardListResponse"></a>
## EzchaLeaderboardListResponse

**Inherits:** [EzchaResponse](#EzchaResponse)

A response from the API containing a list of leaderboards.

### Properties

|Type|Name|Default|
|-|-|-|
|[Array](https://docs.godotengine.org/en/4.3/classes/class_array.html) [ [EzchaLeaderboard](#EzchaLeaderboard) ]|[leaderboards](#EzchaLeaderboardListResponse-property-leaderboards)|[]|

### Property Descriptions

<a name="EzchaLeaderboardListResponse-property-leaderboards"></a>
[Array](https://docs.godotengine.org/en/4.3/classes/class_array.html) [ [EzchaLeaderboard](#EzchaLeaderboard) ] **leaderboards** = []

The list of leaderboards returned by the API request.

<a name="EzchaLeaderboardQueuedResponse"></a>
## EzchaLeaderboardQueuedResponse

**Inherits:** [EzchaResponse](#EzchaResponse)

A response from the API that returns if a leaderboard update has been queued.

### Properties

|Type|Name|Default|
|-|-|-|
|[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html)|[queued](#EzchaLeaderboardQueuedResponse-property-queued)|false|

### Property Descriptions

<a name="EzchaLeaderboardQueuedResponse-property-queued"></a>
[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html) **queued** = false

Returns true if an update has been queued.

<a name="EzchaPaginatedResponse"></a>
## EzchaPaginatedResponse

**Inherits:** [EzchaResponse](#EzchaResponse)

A paginated response from the API.

### Properties

|Type|Name|Default|
|-|-|-|
|[int](https://docs.godotengine.org/en/4.3/classes/class_int.html)|[page](#EzchaPaginatedResponse-property-page)|-1|
|[int](https://docs.godotengine.org/en/4.3/classes/class_int.html)|[page_count](#EzchaPaginatedResponse-property-page_count)|-1|
|[int](https://docs.godotengine.org/en/4.3/classes/class_int.html)|[items_per_page](#EzchaPaginatedResponse-property-items_per_page)|-1|
|[int](https://docs.godotengine.org/en/4.3/classes/class_int.html)|[total_results](#EzchaPaginatedResponse-property-total_results)|-1|

### Property Descriptions

<a name="EzchaPaginatedResponse-property-page"></a>
[int](https://docs.godotengine.org/en/4.3/classes/class_int.html) **page** = -1

The current page.

<a name="EzchaPaginatedResponse-property-page_count"></a>
[int](https://docs.godotengine.org/en/4.3/classes/class_int.html) **page_count** = -1

The total number of pages available.

<a name="EzchaPaginatedResponse-property-items_per_page"></a>
[int](https://docs.godotengine.org/en/4.3/classes/class_int.html) **items_per_page** = -1

The limit of how many items can be displayed on each page.

<a name="EzchaPaginatedResponse-property-total_results"></a>
[int](https://docs.godotengine.org/en/4.3/classes/class_int.html) **total_results** = -1

The total number of results returned.

<a name="EzchaPaginatedLeaderboardEntryListResponse"></a>
## EzchaPaginatedLeaderboardEntryListResponse

**Inherits:** [EzchaPaginatedResponse](#EzchaPaginatedResponse)

A response from the API containing a paginated list of leaderboards.

### Properties

|Type|Name|Default|
|-|-|-|
|[Array](https://docs.godotengine.org/en/4.3/classes/class_array.html) [ [EzchaLeaderboardEntry](#EzchaLeaderboardEntry) ]|[entries](#EzchaPaginatedLeaderboardEntryListResponse-property-entries)|[]|

### Property Descriptions

<a name="EzchaPaginatedLeaderboardEntryListResponse-property-entries"></a>
[Array](https://docs.godotengine.org/en/4.3/classes/class_array.html) [ [EzchaLeaderboardEntry](#EzchaLeaderboardEntry) ] **entries** = []

The list of leaderboards returned by the API request.

<a name="EzchaPaginatedNewsListResponse"></a>
## EzchaPaginatedNewsListResponse

**Inherits:** [EzchaPaginatedResponse](#EzchaPaginatedResponse)

A response from the API containing a paginated list of leaderboards.

### Properties

|Type|Name|Default|
|-|-|-|
|[Array](https://docs.godotengine.org/en/4.3/classes/class_array.html) [ [EzchaNewsPost](#EzchaNewsPost) ]|[posts](#EzchaPaginatedNewsListResponse-property-posts)|[]|

### Property Descriptions

<a name="EzchaPaginatedNewsListResponse-property-posts"></a>
[Array](https://docs.godotengine.org/en/4.3/classes/class_array.html) [ [EzchaNewsPost](#EzchaNewsPost) ] **posts** = []

The list of news posts returned by the API request.

<a name="EzchaPaginatedUserListResponse"></a>
## EzchaPaginatedUserListResponse

**Inherits:** [EzchaPaginatedResponse](#EzchaPaginatedResponse)

A response from the API containing a paginated list of users.

### Properties

|Type|Name|Default|
|-|-|-|
|[Array](https://docs.godotengine.org/en/4.3/classes/class_array.html) [ [EzchaUser](#EzchaUser) ]|[users](#EzchaPaginatedUserListResponse-property-users)|[]|

### Property Descriptions

<a name="EzchaPaginatedUserListResponse-property-users"></a>
[Array](https://docs.godotengine.org/en/4.3/classes/class_array.html) [ [EzchaUser](#EzchaUser) ] **users** = []

The list of users returned by the API request.

<a name="EzchaSessionValidationResponse"></a>
## EzchaSessionValidationResponse

**Inherits:** [EzchaResponse](#EzchaResponse)

A response from the API containing the information related to a validated session.

### Properties

|Type|Name|Default|
|-|-|-|
|[EzchaUser](#EzchaUser)|[user](#EzchaSessionValidationResponse-property-user)|null|
|[Array](https://docs.godotengine.org/en/4.3/classes/class_array.html) [ [EzchaTrophyMeta](#EzchaTrophyMeta) ]|[trophies_obtained](#EzchaSessionValidationResponse-property-trophies_obtained)|[]|
|[Array](https://docs.godotengine.org/en/4.3/classes/class_array.html) [ [EzchaLeaderboardEntry](#EzchaLeaderboardEntry) ]|[leaderboard_entries](#EzchaSessionValidationResponse-property-leaderboard_entries)|[]|
|[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html)|[moderation_tools](#EzchaSessionValidationResponse-property-moderation_tools)|false|

### Property Descriptions

<a name="EzchaSessionValidationResponse-property-user"></a>
[EzchaUser](#EzchaUser) **user** = null

The user associated with the session.

<a name="EzchaSessionValidationResponse-property-trophies_obtained"></a>
[Array](https://docs.godotengine.org/en/4.3/classes/class_array.html) [ [EzchaTrophyMeta](#EzchaTrophyMeta) ] **trophies_obtained** = []

The trophies that the user has obtained from this game.

<a name="EzchaSessionValidationResponse-property-leaderboard_entries"></a>
[Array](https://docs.godotengine.org/en/4.3/classes/class_array.html) [ [EzchaLeaderboardEntry](#EzchaLeaderboardEntry) ] **leaderboard_entries** = []

The leaderboard entries the user has for this game.

<a name="EzchaSessionValidationResponse-property-moderation_tools"></a>
[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html) **moderation_tools** = false

If true the user should have access to any available moderation tools.

<a name="EzchaTrophyMetaListResponse"></a>
## EzchaTrophyMetaListResponse

**Inherits:** [EzchaResponse](#EzchaResponse)

A response from the API containing a list of trophies.

### Properties

|Type|Name|Default|
|-|-|-|
|[Array](https://docs.godotengine.org/en/4.3/classes/class_array.html) [ [EzchaTrophyMeta](#EzchaTrophyMeta) ]|[trophies](#EzchaTrophyMetaListResponse-property-trophies)|[]|

### Property Descriptions

<a name="EzchaTrophyMetaListResponse-property-trophies"></a>
[Array](https://docs.godotengine.org/en/4.3/classes/class_array.html) [ [EzchaTrophyMeta](#EzchaTrophyMeta) ] **trophies** = []

The list of trophies returned by the API request.

<a name="EzchaTrophyQueuedResponse"></a>
## EzchaTrophyQueuedResponse

**Inherits:** [EzchaResponse](#EzchaResponse)

A response from the API that returns if a trophy grant has been queued.

### Properties

|Type|Name|Default|
|-|-|-|
|[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html)|[queued](#EzchaTrophyQueuedResponse-property-queued)|false|
|[EzchaTrophyMeta](#EzchaTrophyMeta)|[trophy](#EzchaTrophyQueuedResponse-property-trophy)|null|

### Property Descriptions

<a name="EzchaTrophyQueuedResponse-property-queued"></a>
[bool](https://docs.godotengine.org/en/4.3/classes/class_bool.html) **queued** = false

Returns true if the grant has been queued.

<a name="EzchaTrophyQueuedResponse-property-trophy"></a>
[EzchaTrophyMeta](#EzchaTrophyMeta) **trophy** = null

The data of the trophy queued to be granted.

<a name="EzchaUserResponse"></a>
## EzchaUserResponse

**Inherits:** [EzchaResponse](#EzchaResponse)

A response from the API containing a single user.

### Properties

|Type|Name|Default|
|-|-|-|
|[EzchaUser](#EzchaUser)|[user](#EzchaUserResponse-property-user)|null|

### Property Descriptions

<a name="EzchaUserResponse-property-user"></a>
[EzchaUser](#EzchaUser) **user** = null

The user returned by the API request.

<a name="EzchaUserListResponse"></a>
## EzchaUserListResponse

**Inherits:** [EzchaResponse](#EzchaResponse)

A response from the API containing a single game.

### Properties

|Type|Name|Default|
|-|-|-|
|[Array](https://docs.godotengine.org/en/4.3/classes/class_array.html) [ [EzchaUser](#EzchaUser) ]|[users](#EzchaUserListResponse-property-users)|[]|

### Property Descriptions

<a name="EzchaUserListResponse-property-users"></a>
[Array](https://docs.godotengine.org/en/4.3/classes/class_array.html) [ [EzchaUser](#EzchaUser) ] **users** = []

The users returned by the API request.
