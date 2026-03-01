# Class Index

* [EzchaPlugin](#EzchaPlugin)
* [EzchaClient](#EzchaClient)
* [EzchaPlatformAdapterWeb](#EzchaPlatformAdapterWeb)
* [EzchaSingleton](#EzchaSingleton)
* [EzchaUtil](#EzchaUtil)
* [EzchaDatastoresAPI](#EzchaDatastoresAPI)
* [EzchaGamesAPI](#EzchaGamesAPI)
* [EzchaGeneralAPI](#EzchaGeneralAPI)
* [EzchaLeaderboardsAPI](#EzchaLeaderboardsAPI)
* [EzchaNewsAPI](#EzchaNewsAPI)
* [EzchaRelayAPI](#EzchaRelayAPI)
* [EzchaSessionsAPI](#EzchaSessionsAPI)
* [EzchaTrophiesAPI](#EzchaTrophiesAPI)
* [EzchaUsersAPI](#EzchaUsersAPI)
* [EzchaAPI](#EzchaAPI)
* [EzchaAwaitAll](#EzchaAwaitAll)
* [EzchaDto](#EzchaDto)
* [EzchaMultiplayerSpawner](#EzchaMultiplayerSpawner)
* [EzchaPlatformAdapter](#EzchaPlatformAdapter)
* [EzchaRelayMultiplayerPeer](#EzchaRelayMultiplayerPeer)
* [EzchaRelayPacket](#EzchaRelayPacket)
* [EzchaRequestBuilder](#EzchaRequestBuilder)
* [EzchaResponse](#EzchaResponse)
* [EzchaServerPlayer](#EzchaServerPlayer)
* [EzchaWebTexture](#EzchaWebTexture)
* [EzchaGame](#EzchaGame)
* [EzchaLeaderboard](#EzchaLeaderboard)
* [EzchaLeaderboardEntry](#EzchaLeaderboardEntry)
* [EzchaNewsPost](#EzchaNewsPost)
* [EzchaRelayLobby](#EzchaRelayLobby)
* [EzchaRelayServer](#EzchaRelayServer)
* [EzchaTrophyMeta](#EzchaTrophyMeta)
* [EzchaUser](#EzchaUser)
* [EzchaCaptchaResponse](#EzchaCaptchaResponse)
* [EzchaDatastoreValueResponse](#EzchaDatastoreValueResponse)
* [EzchaFriendsResponse](#EzchaFriendsResponse)
* [EzchaGameResponse](#EzchaGameResponse)
* [EzchaGameListResponse](#EzchaGameListResponse)
* [EzchaGeneralStatusResponse](#EzchaGeneralStatusResponse)
* [EzchaGeneralTimeResponse](#EzchaGeneralTimeResponse)
* [EzchaLeaderboardListResponse](#EzchaLeaderboardListResponse)
* [EzchaLeaderboardQueuedResponse](#EzchaLeaderboardQueuedResponse)
* [EzchaPaginatedResponse](#EzchaPaginatedResponse)
* [EzchaPaginatedLeaderboardEntryListResponse](#EzchaPaginatedLeaderboardEntryListResponse)
* [EzchaPaginatedLobbyListResponse](#EzchaPaginatedLobbyListResponse)
* [EzchaPaginatedNewsListResponse](#EzchaPaginatedNewsListResponse)
* [EzchaPaginatedUserListResponse](#EzchaPaginatedUserListResponse)
* [EzchaRelayServerListResponse](#EzchaRelayServerListResponse)
* [EzchaSessionValidationResponse](#EzchaSessionValidationResponse)
* [EzchaTrophyMetaListResponse](#EzchaTrophyMetaListResponse)
* [EzchaTrophyQueuedResponse](#EzchaTrophyQueuedResponse)
* [EzchaUserResponse](#EzchaUserResponse)
* [EzchaUserListResponse](#EzchaUserListResponse)

# Class Documentation

<a name="EzchaPlugin"></a>
## EzchaPlugin

**Inherits:** [EditorPlugin](https://docs.godotengine.org/en/4.5/classes/class_editorplugin.html)

A class for internal use.

### Description

You should never need to use this directly. The "EzchaSingleton" class is a good starting point. 

 Many of the values here are used for the dock within the editor and will not be available within an exported game.

### Properties

|Type|Name|Default|
|-|-|-|
|[EditorExportPlugin](https://docs.godotengine.org/en/4.5/classes/class_editorexportplugin.html)|export_plugin|null|
|[Control](https://docs.godotengine.org/en/4.5/classes/class_control.html)|dock|null|
|[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html)|dock_initialized|false|
|[EzchaGame](#EzchaGame)|game|null|
|[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html)|trophies_cached|false|
|[Array](https://docs.godotengine.org/en/4.5/classes/class_array.html) [ [EzchaTrophyMeta](#EzchaTrophyMeta) ]|trophies|[]|
|[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html)|leaderboards_cached|false|
|[Array](https://docs.godotengine.org/en/4.5/classes/class_array.html) [ [EzchaLeaderboard](#EzchaLeaderboard) ]|leaderboards|[]|

<a name="EzchaClient"></a>
## EzchaClient

**Inherits:** [Object](https://docs.godotengine.org/en/4.5/classes/class_object.html)

A helper class to simplify Ezcha Network API integration within game clients.

### Description

This should be accessed through the "Ezcha" singleton.

### Properties

|Type|Name|Default|
|-|-|-|
|[EzchaUser](#EzchaUser)|[user](#EzchaClient-property-user)|null|
|[Array](https://docs.godotengine.org/en/4.5/classes/class_array.html) [ [EzchaTrophyMeta](#EzchaTrophyMeta) ]|[trophies_obtained](#EzchaClient-property-trophies_obtained)|[]|
|[Array](https://docs.godotengine.org/en/4.5/classes/class_array.html) [ [EzchaLeaderboardEntry](#EzchaLeaderboardEntry) ]|[leaderboard_entries](#EzchaClient-property-leaderboard_entries)|[]|
|[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html)|[moderation_tools](#EzchaClient-property-moderation_tools)|false|

### Methods

|Returns|Name|
|-|-|
|[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html)|[authenticate](#EzchaClient-method-authenticate) ( )
|[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html)|[supports_native_login](#EzchaClient-method-supports_native_login) ( )
|[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html)|[request_login](#EzchaClient-method-request_login) ( )
|[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html)|[request_logout](#EzchaClient-method-request_logout) ( )
|[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html)|[is_authenticated](#EzchaClient-method-is_authenticated) ( )
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[get_session_token](#EzchaClient-method-get_session_token) ( )
|[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html)|[has_trophy](#EzchaClient-method-has_trophy) ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) trophy_id, [bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) include_pending=true )
|[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html)|[grant_trophy](#EzchaClient-method-grant_trophy) ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) trophy_id )
|[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html)|[has_score](#EzchaClient-method-has_score) ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) leaderboard_id )
|[float](https://docs.godotengine.org/en/4.5/classes/class_float.html)|[get_score](#EzchaClient-method-get_score) ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) leaderboard_id, [float](https://docs.godotengine.org/en/4.5/classes/class_float.html) defaults_to=0.0 )
|[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html)|[update_score](#EzchaClient-method-update_score) ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) leaderboard_id, [float](https://docs.godotengine.org/en/4.5/classes/class_float.html) score, [EzchaLeaderboardsAPI.UpdateMode](#EzchaLeaderboardsAPI) mode=EzchaLeaderboardsAPI.UpdateMode.SET )
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[get_datastore](#EzchaClient-method-get_datastore) ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) key )
|[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html)|[set_datastore](#EzchaClient-method-set_datastore) ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) key, [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) value )
|[Array](https://docs.godotengine.org/en/4.5/classes/class_array.html) [ [EzchaRelayServer](#EzchaRelayServer) ]|[order_relay_servers](#EzchaClient-method-order_relay_servers) ( )

### Signals

**authentication_completed** ( [bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) successful )

Emitted once the authentication process has completed.

**logout_completed** ( [bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) successful )

Emitted once logged out (not support on web).

**trophy_grant_completed** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) trophy_id, [bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) successful, [EzchaTrophyMeta](#EzchaTrophyMeta) trophy_data )

Emitted when a trophy grant is queued from the grant_trophy function. trophy_data will be null if the grant could not be queued.

**leaderboard_update_completed** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) leaderboard_id, [bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) successful )

Emitted when a leaderboard update is queued from the update_score function.

**datastore_value_recieved** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) key, [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) value )

Emitted after a datastore value is requested and recieved

**datastore_value_posted** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) key, [bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) successful )

Emitted after a datastore value update is posted.

### Property Descriptions

<a name="EzchaClient-property-user"></a>
[EzchaUser](#EzchaUser) **user** = null

The user who is currently playing the game. Only available after authenticating.

<a name="EzchaClient-property-trophies_obtained"></a>
[Array](https://docs.godotengine.org/en/4.5/classes/class_array.html) [ [EzchaTrophyMeta](#EzchaTrophyMeta) ] **trophies_obtained** = []

The trophies that the currently authenticated user has obtained from this game.

<a name="EzchaClient-property-leaderboard_entries"></a>
[Array](https://docs.godotengine.org/en/4.5/classes/class_array.html) [ [EzchaLeaderboardEntry](#EzchaLeaderboardEntry) ] **leaderboard_entries** = []

The leaderboard entries that the currently authenticated user has for this game.

<a name="EzchaClient-property-moderation_tools"></a>
[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) **moderation_tools** = false

If true the user should have access to any moderation tools.

### Method Descriptions

<a name="EzchaClient-method-authenticate"></a>
[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) **authenticate** ( )

Authenticates and loads the information of the current player if available. This should be ran at the start of the game. The authentication_completed signal is emitted on completion. 

 (Async) Returns true if authentication was successful.

<a name="EzchaClient-method-supports_native_login"></a>
[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) **supports_native_login** ( )

Returns true if the current platform allows for native login/logout.

<a name="EzchaClient-method-request_login"></a>
[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) **request_login** ( )

Requests the native login flow for platforms that support it. This can be ran at the user's request if automatic authentication fails. The authentication_completed signal is emitted on completion. 

 (Async) Returns true if authentication was successful.

<a name="EzchaClient-method-request_logout"></a>
[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) **request_logout** ( )

Requests to logout the current user for platforms that support it. The logout_completed signal is emitted on completion. 

 (Async) Returns true if logout was successful.

<a name="EzchaClient-method-is_authenticated"></a>
[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) **is_authenticated** ( )

Returns true if the client has authenticated and user data is available.

<a name="EzchaClient-method-get_session_token"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **get_session_token** ( )

Returns the player's session token if authenticated.

<a name="EzchaClient-method-has_trophy"></a>
[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) **has_trophy** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) trophy_id, [bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) include_pending=true )

Returns true if the currently authenticated player has the trophy specified.

<a name="EzchaClient-method-grant_trophy"></a>
[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) **grant_trophy** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) trophy_id )

Grants a trophy to the currently authenticated player. The trophy must have the "allow clients" option enabled. The trophy_grant_completed signal is emitted on completion. 

 (Async) Returns true if the trophy grant was queued.

<a name="EzchaClient-method-has_score"></a>
[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) **has_score** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) leaderboard_id )

Checks if the currently authenticated player has a score on a leaderboard.

<a name="EzchaClient-method-get_score"></a>
[float](https://docs.godotengine.org/en/4.5/classes/class_float.html) **get_score** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) leaderboard_id, [float](https://docs.godotengine.org/en/4.5/classes/class_float.html) defaults_to=0.0 )

Returns the currently authenticated player's score on a specific leaderboard.

<a name="EzchaClient-method-update_score"></a>
[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) **update_score** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) leaderboard_id, [float](https://docs.godotengine.org/en/4.5/classes/class_float.html) score, [EzchaLeaderboardsAPI.UpdateMode](#EzchaLeaderboardsAPI) mode=EzchaLeaderboardsAPI.UpdateMode.SET )

Updates a leaderboard entry belonging to the currently authenticated player. The leaderboard must have the "allow clients" option enabled. The leaderboard_update_completed signal is emitted on completion. 

 (Async) Returns true if the score update was queued.

<a name="EzchaClient-method-get_datastore"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **get_datastore** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) key )

Get a datastore value belonging to the currently authenticated player. The datastore_value_recieved signal is emitted when the value is recieved. 

 (Async) Returns a string value. The value will be empty if deleted or not yet set.

<a name="EzchaClient-method-set_datastore"></a>
[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) **set_datastore** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) key, [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) value )

Update a datastore value belonging to the currently authenticated player. Limit of 5 keys per user, limit of 16384 characters per value. Set the value to an empty string to delete the key. The datastore_value_posted signal is emitted on completion. 

 (Async) Returns true if the value was successfully updated.

<a name="EzchaClient-method-order_relay_servers"></a>
[Array](https://docs.godotengine.org/en/4.5/classes/class_array.html) [ [EzchaRelayServer](#EzchaRelayServer) ] **order_relay_servers** ( )

Test relay servers and return them based on latency. (Async) Returns an array of available servers, sorted from lowest to highest latency.

<a name="EzchaPlatformAdapterWeb"></a>
## EzchaPlatformAdapterWeb

**Inherits:** [EzchaPlatformAdapter](#EzchaPlatformAdapter)

A class to handle web specific logic.

### Methods

|Returns|Name|
|-|-|
|void|[login_redirect](#EzchaPlatformAdapterWeb-method-login_redirect) ( )
|void|[close_prompts](#EzchaPlatformAdapterWeb-method-close_prompts) ( )
|[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html)|[avatar_prompt](#EzchaPlatformAdapterWeb-method-avatar_prompt) ( [Image](https://docs.godotengine.org/en/4.5/classes/class_image.html) avatar )
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[captcha_prompt](#EzchaPlatformAdapterWeb-method-captcha_prompt) ( )

### Signals

**avatar_prompt_completed** ( [bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) success )

Emitted once the avatar prompt is completed.

**captcha_prompt_completed** ( [bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) success, [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) response )

Emitted once the captcha prompt is completed.

### Method Descriptions

<a name="EzchaPlatformAdapterWeb-method-login_redirect"></a>
void **login_redirect** ( )

(Experimental) Redirects to the login page and back.

<a name="EzchaPlatformAdapterWeb-method-close_prompts"></a>
void **close_prompts** ( )

(Experimental) Closes all web container prompts.

<a name="EzchaPlatformAdapterWeb-method-avatar_prompt"></a>
[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) **avatar_prompt** ( [Image](https://docs.godotengine.org/en/4.5/classes/class_image.html) avatar )

(Experimental) Prompts the user to change their avatar. The provided image must be 256x256px. (Async) Returns true if user accepts and the upload is successful.

<a name="EzchaPlatformAdapterWeb-method-captcha_prompt"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **captcha_prompt** ( )

(Experimental) Prompts the user to solve a captcha. The response must be validated via the API. (Async) Returns the response if successful, otherwise an empty string.

<a name="EzchaSingleton"></a>
## EzchaSingleton

**Inherits:** [Node](https://docs.godotengine.org/en/4.5/classes/class_node.html)

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
|[EzchaRelayAPI](#EzchaRelayAPI)|[relay](#EzchaSingleton-property-relay)|EzchaRelayAPI.new()|
|[EzchaSessionsAPI](#EzchaSessionsAPI)|[sessions](#EzchaSingleton-property-sessions)|EzchaSessionsAPI.new()|
|[EzchaTrophiesAPI](#EzchaTrophiesAPI)|[trophies](#EzchaSingleton-property-trophies)|EzchaTrophiesAPI.new()|
|[EzchaUsersAPI](#EzchaUsersAPI)|[users](#EzchaSingleton-property-users)|EzchaUsersAPI.new()|

### Methods

|Returns|Name|
|-|-|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[get_game_id](#EzchaSingleton-method-get_game_id) ( )
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[get_api_key](#EzchaSingleton-method-get_api_key) ( )
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[get_signing_key](#EzchaSingleton-method-get_signing_key) ( )
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[get_session_override](#EzchaSingleton-method-get_session_override) ( )
|[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html)|[should_print_request_errors](#EzchaSingleton-method-should_print_request_errors) ( )

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

<a name="EzchaSingleton-property-relay"></a>
[EzchaRelayAPI](#EzchaRelayAPI) **relay** = EzchaRelayAPI.new()

A wrapper for the relay section of the API.

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
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **get_game_id** ( )

A helper to return the currently configured game identifier.

<a name="EzchaSingleton-method-get_api_key"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **get_api_key** ( )

A helper to return the currently configured API key.

<a name="EzchaSingleton-method-get_signing_key"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **get_signing_key** ( )

A helper to return the currently configured signing key.

<a name="EzchaSingleton-method-get_session_override"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **get_session_override** ( )

A helper to return the currently configured session override.

<a name="EzchaSingleton-method-should_print_request_errors"></a>
[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) **should_print_request_errors** ( )

A helper to return if request errors should be printed.

<a name="EzchaUtil"></a>
## EzchaUtil

**Inherits:** [Object](https://docs.godotengine.org/en/4.5/classes/class_object.html)

Common utilities used across the plugin.

<a name="EzchaDatastoresAPI"></a>
## EzchaDatastoresAPI

**Inherits:** [EzchaAPI](#EzchaAPI)

A wrapper for the datastores section of the API.

### Description

This should be accessed through the "Ezcha" singleton.

### Methods

|Returns|Name|
|-|-|
|[EzchaDatastoreValueResponse](#EzchaDatastoreValueResponse)|[get_client](#EzchaDatastoresAPI-method-get_client) ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) key, [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) session_token )
|[EzchaResponse](#EzchaResponse)|[post_client](#EzchaDatastoresAPI-method-post_client) ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) key, [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) value, [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) session_token )
|[EzchaDatastoreValueResponse](#EzchaDatastoreValueResponse)|[get_server](#EzchaDatastoresAPI-method-get_server) ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) user_id, [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) key )
|[EzchaResponse](#EzchaResponse)|[post_server](#EzchaDatastoresAPI-method-post_server) ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) user_id, [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) key, [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) value )

### Method Descriptions

<a name="EzchaDatastoresAPI-method-get_client"></a>
[EzchaDatastoreValueResponse](#EzchaDatastoreValueResponse) **get_client** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) key, [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) session_token )

Requests the value of a client-side datastore from its key.

<a name="EzchaDatastoresAPI-method-post_client"></a>
[EzchaResponse](#EzchaResponse) **post_client** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) key, [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) value, [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) session_token )

Updates the value of a client-side datastore by its key.

<a name="EzchaDatastoresAPI-method-get_server"></a>
[EzchaDatastoreValueResponse](#EzchaDatastoreValueResponse) **get_server** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) user_id, [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) key )

Requests the value of a server-side datastore for a player from its key.

<a name="EzchaDatastoresAPI-method-post_server"></a>
[EzchaResponse](#EzchaResponse) **post_server** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) user_id, [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) key, [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) value )

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
|[EzchaGameResponse](#EzchaGameResponse)|[get_from_id](#EzchaGamesAPI-method-get_from_id) ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) game_id )
|[EzchaGameResponse](#EzchaGameResponse)|[get_from_slug](#EzchaGamesAPI-method-get_from_slug) ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) game_slug )
|[EzchaGameListResponse](#EzchaGameListResponse)|[get_many](#EzchaGamesAPI-method-get_many) ( [PackedStringArray](https://docs.godotengine.org/en/4.5/classes/class_packedstringarray.html) game_ids, [PackedStringArray](https://docs.godotengine.org/en/4.5/classes/class_packedstringarray.html) game_slugs=PackedStringArray() )
|[EzchaGameResponse](#EzchaGameResponse)|[get_random](#EzchaGamesAPI-method-get_random) ( [bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) include_elite_exclusives=false )
|[EzchaGameResponse](#EzchaGameResponse)|[get_game_of_the_day](#EzchaGamesAPI-method-get_game_of_the_day) ( )
|[EzchaTrophyMetaListResponse](#EzchaTrophyMetaListResponse)|[get_trophies](#EzchaGamesAPI-method-get_trophies) ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) game_id, [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) session_token="" )
|[EzchaLeaderboardListResponse](#EzchaLeaderboardListResponse)|[get_leaderboards](#EzchaGamesAPI-method-get_leaderboards) ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) game_id, [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) session_token="" )

### Method Descriptions

<a name="EzchaGamesAPI-method-get_from_id"></a>
[EzchaGameResponse](#EzchaGameResponse) **get_from_id** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) game_id )

Requests a game from its ID.

<a name="EzchaGamesAPI-method-get_from_slug"></a>
[EzchaGameResponse](#EzchaGameResponse) **get_from_slug** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) game_slug )

Requests a game from its slug.

<a name="EzchaGamesAPI-method-get_many"></a>
[EzchaGameListResponse](#EzchaGameListResponse) **get_many** ( [PackedStringArray](https://docs.godotengine.org/en/4.5/classes/class_packedstringarray.html) game_ids, [PackedStringArray](https://docs.godotengine.org/en/4.5/classes/class_packedstringarray.html) game_slugs=PackedStringArray() )

Requests several games at once.

<a name="EzchaGamesAPI-method-get_random"></a>
[EzchaGameResponse](#EzchaGameResponse) **get_random** ( [bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) include_elite_exclusives=false )

Requests a randomly chosen game.

<a name="EzchaGamesAPI-method-get_game_of_the_day"></a>
[EzchaGameResponse](#EzchaGameResponse) **get_game_of_the_day** ( )

Requests the current game of the day.

<a name="EzchaGamesAPI-method-get_trophies"></a>
[EzchaTrophyMetaListResponse](#EzchaTrophyMetaListResponse) **get_trophies** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) game_id, [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) session_token="" )

Requests the trophies belonging to a game. A session with sufficient permissions can be provided to include unlisted trophies, but is not required.

<a name="EzchaGamesAPI-method-get_leaderboards"></a>
[EzchaLeaderboardListResponse](#EzchaLeaderboardListResponse) **get_leaderboards** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) game_id, [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) session_token="" )

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
|[EzchaCaptchaResponse](#EzchaCaptchaResponse)|[post_captcha](#EzchaGeneralAPI-method-post_captcha) ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) response )

### Method Descriptions

<a name="EzchaGeneralAPI-method-get_status"></a>
[EzchaGeneralStatusResponse](#EzchaGeneralStatusResponse) **get_status** ( )

Returns the current status of the API.

<a name="EzchaGeneralAPI-method-get_time"></a>
[EzchaGeneralTimeResponse](#EzchaGeneralTimeResponse) **get_time** ( )

Returns the current time from API.

<a name="EzchaGeneralAPI-method-post_captcha"></a>
[EzchaCaptchaResponse](#EzchaCaptchaResponse) **post_captcha** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) response )

Validates a captcha response.

<a name="EzchaLeaderboardsAPI"></a>
## EzchaLeaderboardsAPI

**Inherits:** [EzchaAPI](#EzchaAPI)

A wrapper for the leaderboards section of the API.

### Description

This should be accessed through the "Ezcha" singleton.

### Methods

|Returns|Name|
|-|-|
|[EzchaPaginatedLeaderboardEntryListResponse](#EzchaPaginatedLeaderboardEntryListResponse)|[get_entries](#EzchaLeaderboardsAPI-method-get_entries) ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) leaderboard_id, [int](https://docs.godotengine.org/en/4.5/classes/class_int.html) page=1, [int](https://docs.godotengine.org/en/4.5/classes/class_int.html) items_per_page=-1, [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) session_token="" )
|[EzchaLeaderboardQueuedResponse](#EzchaLeaderboardQueuedResponse)|[post_entry_client](#EzchaLeaderboardsAPI-method-post_entry_client) ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) leaderboard_id, [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) session_token, [float](https://docs.godotengine.org/en/4.5/classes/class_float.html) score, [UpdateMode](https://docs.godotengine.org/en/4.5/classes/class_updatemode.html) mode=UpdateMode.SET )
|[EzchaLeaderboardQueuedResponse](#EzchaLeaderboardQueuedResponse)|[post_entry_server](#EzchaLeaderboardsAPI-method-post_entry_server) ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) leaderboard_id, [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) user_id, [float](https://docs.godotengine.org/en/4.5/classes/class_float.html) score, [UpdateMode](https://docs.godotengine.org/en/4.5/classes/class_updatemode.html) mode=UpdateMode.SET )

### Enumerations

enum **UpdateMode**:

* UpdateMode **SET** = 0
* UpdateMode **ADD** = 1
* UpdateMode **SUBTRACT** = 2

### Method Descriptions

<a name="EzchaLeaderboardsAPI-method-get_entries"></a>
[EzchaPaginatedLeaderboardEntryListResponse](#EzchaPaginatedLeaderboardEntryListResponse) **get_entries** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) leaderboard_id, [int](https://docs.godotengine.org/en/4.5/classes/class_int.html) page=1, [int](https://docs.godotengine.org/en/4.5/classes/class_int.html) items_per_page=-1, [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) session_token="" )

Returns a paginated list of entries for a specific leaderboard. A session token is only required when attempting to access an unlisted leaderboard.

<a name="EzchaLeaderboardsAPI-method-post_entry_client"></a>
[EzchaLeaderboardQueuedResponse](#EzchaLeaderboardQueuedResponse) **post_entry_client** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) leaderboard_id, [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) session_token, [float](https://docs.godotengine.org/en/4.5/classes/class_float.html) score, [UpdateMode](https://docs.godotengine.org/en/4.5/classes/class_updatemode.html) mode=UpdateMode.SET )

Updates a score from a game client using a session token. Requires a signing key to be configured.

<a name="EzchaLeaderboardsAPI-method-post_entry_server"></a>
[EzchaLeaderboardQueuedResponse](#EzchaLeaderboardQueuedResponse) **post_entry_server** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) leaderboard_id, [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) user_id, [float](https://docs.godotengine.org/en/4.5/classes/class_float.html) score, [UpdateMode](https://docs.godotengine.org/en/4.5/classes/class_updatemode.html) mode=UpdateMode.SET )

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
|[EzchaPaginatedNewsListResponse](#EzchaPaginatedNewsListResponse)|[get_list](#EzchaNewsAPI-method-get_list) ( [int](https://docs.godotengine.org/en/4.5/classes/class_int.html) page=1, [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) category="", [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) series="", [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) order="" )

### Method Descriptions

<a name="EzchaNewsAPI-method-get_list"></a>
[EzchaPaginatedNewsListResponse](#EzchaPaginatedNewsListResponse) **get_list** ( [int](https://docs.godotengine.org/en/4.5/classes/class_int.html) page=1, [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) category="", [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) series="", [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) order="" )

Returns a paginated list of news posts based on the criteria provided.

<a name="EzchaRelayAPI"></a>
## EzchaRelayAPI

**Inherits:** [EzchaAPI](#EzchaAPI)

A wrapper for the relay section of the API.

### Description

This should be accessed through the "Ezcha" singleton.

### Methods

|Returns|Name|
|-|-|
|[EzchaRelayServerListResponse](#EzchaRelayServerListResponse)|[get_list](#EzchaRelayAPI-method-get_list) ( )

### Method Descriptions

<a name="EzchaRelayAPI-method-get_list"></a>
[EzchaRelayServerListResponse](#EzchaRelayServerListResponse) **get_list** ( )

Returns a list of available relay servers.

<a name="EzchaSessionsAPI"></a>
## EzchaSessionsAPI

**Inherits:** [EzchaAPI](#EzchaAPI)

A wrapper for the sessions section of the API.

### Description

This should be accessed through the "Ezcha" singleton.

### Methods

|Returns|Name|
|-|-|
|[EzchaSessionValidationResponse](#EzchaSessionValidationResponse)|[post_validation](#EzchaSessionsAPI-method-post_validation) ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) session_token="", [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) game_id="" )

### Method Descriptions

<a name="EzchaSessionsAPI-method-post_validation"></a>
[EzchaSessionValidationResponse](#EzchaSessionValidationResponse) **post_validation** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) session_token="", [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) game_id="" )

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
|[EzchaTrophyQueuedResponse](#EzchaTrophyQueuedResponse)|[post_grant_client](#EzchaTrophiesAPI-method-post_grant_client) ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) trophy_id, [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) session_token )
|[EzchaTrophyQueuedResponse](#EzchaTrophyQueuedResponse)|[post_grant_server](#EzchaTrophiesAPI-method-post_grant_server) ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) trophy_id, [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) user_id )

### Method Descriptions

<a name="EzchaTrophiesAPI-method-post_grant_client"></a>
[EzchaTrophyQueuedResponse](#EzchaTrophyQueuedResponse) **post_grant_client** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) trophy_id, [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) session_token )

Updates a score from a game client using a session token. Requires a signing key to be configured.

<a name="EzchaTrophiesAPI-method-post_grant_server"></a>
[EzchaTrophyQueuedResponse](#EzchaTrophyQueuedResponse) **post_grant_server** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) trophy_id, [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) user_id )

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
|[EzchaUserResponse](#EzchaUserResponse)|[get_from_id](#EzchaUsersAPI-method-get_from_id) ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) user_id )
|[EzchaUserResponse](#EzchaUserResponse)|[get_from_name](#EzchaUsersAPI-method-get_from_name) ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) username )
|[EzchaUserListResponse](#EzchaUserListResponse)|[get_many](#EzchaUsersAPI-method-get_many) ( [PackedStringArray](https://docs.godotengine.org/en/4.5/classes/class_packedstringarray.html) user_ids, [PackedStringArray](https://docs.godotengine.org/en/4.5/classes/class_packedstringarray.html) usernames=PackedStringArray() )
|[EzchaPaginatedUserListResponse](#EzchaPaginatedUserListResponse)|[get_list](#EzchaUsersAPI-method-get_list) ( [int](https://docs.godotengine.org/en/4.5/classes/class_int.html) page=1, [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) category="", [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) order="" )
|[EzchaTrophyMetaListResponse](#EzchaTrophyMetaListResponse)|[get_trophies](#EzchaUsersAPI-method-get_trophies) ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) user_id, [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) game_id )
|[EzchaFriendsResponse](#EzchaFriendsResponse)|[check_friends](#EzchaUsersAPI-method-check_friends) ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) user_id_a, [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) user_id_b )

### Method Descriptions

<a name="EzchaUsersAPI-method-get_from_id"></a>
[EzchaUserResponse](#EzchaUserResponse) **get_from_id** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) user_id )

Requests a user from their ID.

<a name="EzchaUsersAPI-method-get_from_name"></a>
[EzchaUserResponse](#EzchaUserResponse) **get_from_name** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) username )

Requests a user from their name.

<a name="EzchaUsersAPI-method-get_many"></a>
[EzchaUserListResponse](#EzchaUserListResponse) **get_many** ( [PackedStringArray](https://docs.godotengine.org/en/4.5/classes/class_packedstringarray.html) user_ids, [PackedStringArray](https://docs.godotengine.org/en/4.5/classes/class_packedstringarray.html) usernames=PackedStringArray() )

Requests several users at once.

<a name="EzchaUsersAPI-method-get_list"></a>
[EzchaPaginatedUserListResponse](#EzchaPaginatedUserListResponse) **get_list** ( [int](https://docs.godotengine.org/en/4.5/classes/class_int.html) page=1, [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) category="", [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) order="" )

Returns a paginated list of user based on the criteria provided.

<a name="EzchaUsersAPI-method-get_trophies"></a>
[EzchaTrophyMetaListResponse](#EzchaTrophyMetaListResponse) **get_trophies** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) user_id, [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) game_id )

Lists the trophies a user has obtained for the game specified

<a name="EzchaUsersAPI-method-check_friends"></a>
[EzchaFriendsResponse](#EzchaFriendsResponse) **check_friends** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) user_id_a, [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) user_id_b )

Check if two users are friends

<a name="EzchaAPI"></a>
## EzchaAPI

**Inherits:** [Object](https://docs.godotengine.org/en/4.5/classes/class_object.html)

A base class for handling calls to the Ezcha Network API.

<a name="EzchaAwaitAll"></a>
## EzchaAwaitAll

**Inherits:** [RefCounted](https://docs.godotengine.org/en/4.5/classes/class_refcounted.html)

A helper class to conveniently monitor multiple async coroutines.

### Description

Emits a signal once all provided coroutines have completed. Provides its own async function that can be used to block execution.

### Methods

|Returns|Name|
|-|-|
|void|[add](#EzchaAwaitAll-method-add) ( [Callable](https://docs.godotengine.org/en/4.5/classes/class_callable.html) target, [Variant](https://docs.godotengine.org/en/4.5/classes/class_variant.html)  )
|[int](https://docs.godotengine.org/en/4.5/classes/class_int.html)|[count](#EzchaAwaitAll-method-count) ( )
|void|[block](#EzchaAwaitAll-method-block) ( )

### Signals

**completed** ( )

Emitted once all coroutines have completed.

### Method Descriptions

<a name="EzchaAwaitAll-method-add"></a>
void **add** ( [Callable](https://docs.godotengine.org/en/4.5/classes/class_callable.html) target, [Variant](https://docs.godotengine.org/en/4.5/classes/class_variant.html)  )

Add a coroutine to be watched

<a name="EzchaAwaitAll-method-count"></a>
[int](https://docs.godotengine.org/en/4.5/classes/class_int.html) **count** ( )

Returns how many coroutines are being watched

<a name="EzchaAwaitAll-method-block"></a>
void **block** ( )

(Async) Blocks execution until all coroutines complete

<a name="EzchaDto"></a>
## EzchaDto

**Inherits:** [RefCounted](https://docs.godotengine.org/en/4.5/classes/class_refcounted.html)

A base class for handling data returned by the Ezcha Network API.

<a name="EzchaMultiplayerSpawner"></a>
## EzchaMultiplayerSpawner

**Inherits:** [MultiplayerSpawner](https://docs.godotengine.org/en/4.5/classes/class_multiplayerspawner.html)

<a name="EzchaPlatformAdapter"></a>
## EzchaPlatformAdapter

**Inherits:** [RefCounted](https://docs.godotengine.org/en/4.5/classes/class_refcounted.html)

A class for internal use to handle platform specific logic.

### Description

You should never need to use this directly.

### Methods

|Returns|Name|
|-|-|
|[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html)|supports_login ( )

### Signals

**auth_flow_completed** ( [Variant](https://docs.godotengine.org/en/4.5/classes/class_variant.html) token )



**login_flow_completed** ( [Variant](https://docs.godotengine.org/en/4.5/classes/class_variant.html) token )



**logout_completed** ( [bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) success )



<a name="EzchaRelayMultiplayerPeer"></a>
## EzchaRelayMultiplayerPeer

**Inherits:** [MultiplayerPeerExtension](https://docs.godotengine.org/en/4.5/classes/class_multiplayerpeerextension.html)

A lobby based MultiplayerPeer implementation which uses Ezcha Relay for networking.

### Properties

|Type|Name|Default|
|-|-|-|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[address](#EzchaRelayMultiplayerPeer-property-address)|"relay-main.ezcha.net"|

### Methods

|Returns|Name|
|-|-|
|[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html)|[handshake](#EzchaRelayMultiplayerPeer-method-handshake) ( )
|[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html)|[join_lobby](#EzchaRelayMultiplayerPeer-method-join_lobby) ( [int](https://docs.godotengine.org/en/4.5/classes/class_int.html) lobby_id )
|[int](https://docs.godotengine.org/en/4.5/classes/class_int.html)|[create_lobby](#EzchaRelayMultiplayerPeer-method-create_lobby) ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) name, [int](https://docs.godotengine.org/en/4.5/classes/class_int.html) max_players, [int](https://docs.godotengine.org/en/4.5/classes/class_int.html) game_mode=0, [Visibility](https://docs.godotengine.org/en/4.5/classes/class_visibility.html) visibility=Visibility.PUBLIC, [bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) host_migration=false )
|void|[kick](#EzchaRelayMultiplayerPeer-method-kick) ( [int](https://docs.godotengine.org/en/4.5/classes/class_int.html) peer_id, [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) message="" )
|[int](https://docs.godotengine.org/en/4.5/classes/class_int.html)|[get_lobby_id](#EzchaRelayMultiplayerPeer-method-get_lobby_id) ( )
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[get_lobby_name](#EzchaRelayMultiplayerPeer-method-get_lobby_name) ( )
|[int](https://docs.godotengine.org/en/4.5/classes/class_int.html)|[get_game_mode](#EzchaRelayMultiplayerPeer-method-get_game_mode) ( )
|[int](https://docs.godotengine.org/en/4.5/classes/class_int.html)|[get_max_players](#EzchaRelayMultiplayerPeer-method-get_max_players) ( )
|[Visibility](https://docs.godotengine.org/en/4.5/classes/class_visibility.html)|[get_visibility_mode](#EzchaRelayMultiplayerPeer-method-get_visibility_mode) ( )
|[int](https://docs.godotengine.org/en/4.5/classes/class_int.html)|[get_host_id](#EzchaRelayMultiplayerPeer-method-get_host_id) ( )
|[Array](https://docs.godotengine.org/en/4.5/classes/class_array.html) [ [int](https://docs.godotengine.org/en/4.5/classes/class_int.html) ]|[get_peers](#EzchaRelayMultiplayerPeer-method-get_peers) ( )
|[EzchaUser](#EzchaUser)|[get_user](#EzchaRelayMultiplayerPeer-method-get_user) ( [int](https://docs.godotengine.org/en/4.5/classes/class_int.html) peer_id )
|[Operation](https://docs.godotengine.org/en/4.5/classes/class_operation.html)|[get_operation](#EzchaRelayMultiplayerPeer-method-get_operation) ( )
|void|[set_lobby_name](#EzchaRelayMultiplayerPeer-method-set_lobby_name) ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) new_name )
|void|[set_game_mode](#EzchaRelayMultiplayerPeer-method-set_game_mode) ( [int](https://docs.godotengine.org/en/4.5/classes/class_int.html) new_mode )
|void|[set_max_players](#EzchaRelayMultiplayerPeer-method-set_max_players) ( [int](https://docs.godotengine.org/en/4.5/classes/class_int.html) new_limit )
|void|[set_visibility](#EzchaRelayMultiplayerPeer-method-set_visibility) ( [Visibility](https://docs.godotengine.org/en/4.5/classes/class_visibility.html) new_visibility )
|void|[migrate_host](#EzchaRelayMultiplayerPeer-method-migrate_host) ( [int](https://docs.godotengine.org/en/4.5/classes/class_int.html) peer_id )
|void|[close_lobby](#EzchaRelayMultiplayerPeer-method-close_lobby) ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) message="" )
|[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html)|[in_lobby](#EzchaRelayMultiplayerPeer-method-in_lobby) ( )
|[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html)|[is_host](#EzchaRelayMultiplayerPeer-method-is_host) ( )
|[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html)|[can_modify_lobby](#EzchaRelayMultiplayerPeer-method-can_modify_lobby) ( )
|void|close ( )

### Signals

**lobby_connected** ( [int](https://docs.godotengine.org/en/4.5/classes/class_int.html) lobby_id )

Emitted after connecting to a lobby.

**lobby_created** ( [int](https://docs.godotengine.org/en/4.5/classes/class_int.html) lobby_id )

Emitted after creating a new lobby.

**lobby_joined** ( [int](https://docs.godotengine.org/en/4.5/classes/class_int.html) lobby_id )

Emitted after joining an existing lobby. The list is a dictionary mapping user data to their peer IDs.

**user_connected** ( [int](https://docs.godotengine.org/en/4.5/classes/class_int.html) peer_id, [EzchaUser](#EzchaUser) user )

Emitted when a peer joins the lobby. Mirrors peer_connected but includes user data and emits upon lobby creation.

**user_disconnected** ( [int](https://docs.godotengine.org/en/4.5/classes/class_int.html) peer_id, [EzchaUser](#EzchaUser) user )

Emitted when a peer leaves the lobby. Mirrors peer_disconnected but includes user data.

**name_changed** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) new_name )

Emitted when the name of the lobby changes.

**game_mode_changed** ( [int](https://docs.godotengine.org/en/4.5/classes/class_int.html) new_mode )

Emitted when the current game mode changes.

**max_players_changed** ( [int](https://docs.godotengine.org/en/4.5/classes/class_int.html) new_limit )

Emitted when the max player limit changes.

**visibility_changed** ( [Visibility](https://docs.godotengine.org/en/4.5/classes/class_visibility.html) new_visibility )

Emitted when visibility of the lobby changes.

**host_migrated** ( [int](https://docs.godotengine.org/en/4.5/classes/class_int.html) old_host_id, [int](https://docs.godotengine.org/en/4.5/classes/class_int.html) new_host_id )

Emitted when the lobby migrates hosts to a new peer.

**error** ( [int](https://docs.godotengine.org/en/4.5/classes/class_int.html) code, [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) message )

Emitted when an error occurs during relay operations.

**kicked** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) message )

Emitted when kicked from the lobby.

### Enumerations

enum **ErrorType**:

* ErrorType **CLIENT_EXCEPTION** = -1
* ErrorType **INVALID_REQUEST** = 100
* ErrorType **NO_PERMISSION** = 101
* ErrorType **RATE_LIMIT** = 102
* ErrorType **UNSUPPORTED_PROTOCOL** = 200
* ErrorType **AUTH_FAILED** = 201
* ErrorType **GAME_ID_MISMATCH** = 300
* ErrorType **VERSION_MISMATCH** = 301
* ErrorType **LOBBY_NOT_FOUND** = 310
* ErrorType **LOBBY_FULL** = 320
* ErrorType **NOT_FRIENDS** = 321
* ErrorType **REFUSING_CONNECTIONS** = 322
* ErrorType **KICKED** = 400
* ErrorType **INVALID_PEER** = 401
* ErrorType **INTERNAL** = 500

enum **Visibility**:

* Visibility **PUBLIC** = 0
* Visibility **UNLISTED** = 1
* Visibility **FRIENDS_ONLY** = 2

enum **Operation**:

* Operation **NONE** = 0
* Operation **HANDSHAKE** = 1
* Operation **CREATE_LOBBY** = 2
* Operation **JOIN_LOBBY** = 3

### Property Descriptions

<a name="EzchaRelayMultiplayerPeer-property-address"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **address** = "relay-main.ezcha.net"

The address of the Ezcha Relay server to attempt connection with. Use `Ezcha.client.order_relay_servers()` to determine ideal servers.

### Method Descriptions

<a name="EzchaRelayMultiplayerPeer-method-handshake"></a>
[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) **handshake** ( )

Opens a connection with the Ezcha Relay system and attempts handshake/authentication. Required before creating or joining a lobby. (Async) Returns true if the connection and authentication were successful.

<a name="EzchaRelayMultiplayerPeer-method-join_lobby"></a>
[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) **join_lobby** ( [int](https://docs.godotengine.org/en/4.5/classes/class_int.html) lobby_id )

Join an existing lobby through the relay system. Handshake must be completed first. (Async) Returns true if joining the lobby was successful.

<a name="EzchaRelayMultiplayerPeer-method-create_lobby"></a>
[int](https://docs.godotengine.org/en/4.5/classes/class_int.html) **create_lobby** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) name, [int](https://docs.godotengine.org/en/4.5/classes/class_int.html) max_players, [int](https://docs.godotengine.org/en/4.5/classes/class_int.html) game_mode=0, [Visibility](https://docs.godotengine.org/en/4.5/classes/class_visibility.html) visibility=Visibility.PUBLIC, [bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) host_migration=false )

Request a new lobby from the relay system. Handshake must be completed first. (Async) Returns a lobby ID if successful, otherwise -1.

<a name="EzchaRelayMultiplayerPeer-method-kick"></a>
void **kick** ( [int](https://docs.godotengine.org/en/4.5/classes/class_int.html) peer_id, [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) message="" )

Kick another player from the lobby. (host/moderator only)

<a name="EzchaRelayMultiplayerPeer-method-get_lobby_id"></a>
[int](https://docs.godotengine.org/en/4.5/classes/class_int.html) **get_lobby_id** ( )

Returns the ID of the current lobby.

<a name="EzchaRelayMultiplayerPeer-method-get_lobby_name"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **get_lobby_name** ( )

Returns the name of the current lobby.

<a name="EzchaRelayMultiplayerPeer-method-get_game_mode"></a>
[int](https://docs.godotengine.org/en/4.5/classes/class_int.html) **get_game_mode** ( )

Returns the game mode of the current lobby.

<a name="EzchaRelayMultiplayerPeer-method-get_max_players"></a>
[int](https://docs.godotengine.org/en/4.5/classes/class_int.html) **get_max_players** ( )

Returns the max player count of the current lobby.

<a name="EzchaRelayMultiplayerPeer-method-get_visibility_mode"></a>
[Visibility](https://docs.godotengine.org/en/4.5/classes/class_visibility.html) **get_visibility_mode** ( )

Returns the visibility mode of the current lobby.

<a name="EzchaRelayMultiplayerPeer-method-get_host_id"></a>
[int](https://docs.godotengine.org/en/4.5/classes/class_int.html) **get_host_id** ( )

Returns the peer ID of the current host.

<a name="EzchaRelayMultiplayerPeer-method-get_peers"></a>
[Array](https://docs.godotengine.org/en/4.5/classes/class_array.html) [ [int](https://docs.godotengine.org/en/4.5/classes/class_int.html) ] **get_peers** ( )

Returns a list of connected peer IDs.

<a name="EzchaRelayMultiplayerPeer-method-get_user"></a>
[EzchaUser](#EzchaUser) **get_user** ( [int](https://docs.godotengine.org/en/4.5/classes/class_int.html) peer_id )

Returns locally cached user data for a given peer ID. Prefer to use this over relaying information from the host.

<a name="EzchaRelayMultiplayerPeer-method-get_operation"></a>
[Operation](https://docs.godotengine.org/en/4.5/classes/class_operation.html) **get_operation** ( )

Returns what the current pending operation is.

<a name="EzchaRelayMultiplayerPeer-method-set_lobby_name"></a>
void **set_lobby_name** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) new_name )

Change the name of the lobby. (host/moderator only, requires migration to be enabled)

<a name="EzchaRelayMultiplayerPeer-method-set_game_mode"></a>
void **set_game_mode** ( [int](https://docs.godotengine.org/en/4.5/classes/class_int.html) new_mode )

Change the game mode of the lobby. (host/moderator only, requires migration to be enabled)

<a name="EzchaRelayMultiplayerPeer-method-set_max_players"></a>
void **set_max_players** ( [int](https://docs.godotengine.org/en/4.5/classes/class_int.html) new_limit )

Change the game mode of the lobby. (host/moderator only, requires migration to be enabled)

<a name="EzchaRelayMultiplayerPeer-method-set_visibility"></a>
void **set_visibility** ( [Visibility](https://docs.godotengine.org/en/4.5/classes/class_visibility.html) new_visibility )

Change the visibility of the lobby. (host/moderator only, requires migration to be enabled)

<a name="EzchaRelayMultiplayerPeer-method-migrate_host"></a>
void **migrate_host** ( [int](https://docs.godotengine.org/en/4.5/classes/class_int.html) peer_id )

Manually migrate host to another peer. (host/moderator only, requires migration to be enabled)

<a name="EzchaRelayMultiplayerPeer-method-close_lobby"></a>
void **close_lobby** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) message="" )

Close the lobby and kick all players. (host/moderator only)

<a name="EzchaRelayMultiplayerPeer-method-in_lobby"></a>
[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) **in_lobby** ( )

Returns true if currently connected to a lobby

<a name="EzchaRelayMultiplayerPeer-method-is_host"></a>
[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) **is_host** ( )

Returns if the current peer is the host.

<a name="EzchaRelayMultiplayerPeer-method-can_modify_lobby"></a>
[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) **can_modify_lobby** ( )

Returns if the current peer can modify the current lobby.

<a name="EzchaRelayPacket"></a>
## EzchaRelayPacket

**Inherits:** [RefCounted](https://docs.godotengine.org/en/4.5/classes/class_refcounted.html)

The class representing a relay packet received via Ezcha Relay. Stores Godot-specific metadata (transfer mode, channel) extracted from payload. Internal use only.

### Properties

|Type|Name|Default|
|-|-|-|
|[PackedByteArray](https://docs.godotengine.org/en/4.5/classes/class_packedbytearray.html)|data|PackedByteArray()|
|[int](https://docs.godotengine.org/en/4.5/classes/class_int.html)|from|-1|
|[MultiplayerPeer.TransferMode](https://docs.godotengine.org/en/4.5/classes/class_multiplayerpeer.html)|transfer_mode|MultiplayerPeer.TransferMode.TRANSFER_MODE_RELIABLE|
|[int](https://docs.godotengine.org/en/4.5/classes/class_int.html)|channel|0|

<a name="EzchaRequestBuilder"></a>
## EzchaRequestBuilder

**Inherits:** [RefCounted](https://docs.godotengine.org/en/4.5/classes/class_refcounted.html)

A class for building and making requests to the Ezcha Network API.

### Methods

|Returns|Name|
|-|-|
|[EzchaRequestBuilder](#EzchaRequestBuilder)|[set_hostname](#EzchaRequestBuilder-method-set_hostname) ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) value )
|[EzchaRequestBuilder](#EzchaRequestBuilder)|[set_endpoint](#EzchaRequestBuilder-method-set_endpoint) ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) value )
|[EzchaRequestBuilder](#EzchaRequestBuilder)|[set_method](#EzchaRequestBuilder-method-set_method) ( [HTTPClient.Method](https://docs.godotengine.org/en/4.5/classes/class_httpclient.html) value )
|[EzchaRequestBuilder](#EzchaRequestBuilder)|[set_authentication](#EzchaRequestBuilder-method-set_authentication) ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) token )
|[EzchaRequestBuilder](#EzchaRequestBuilder)|[set_signing_key](#EzchaRequestBuilder-method-set_signing_key) ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) key )
|[EzchaRequestBuilder](#EzchaRequestBuilder)|[set_parse_response](#EzchaRequestBuilder-method-set_parse_response) ( [bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) enabled )
|[EzchaRequestBuilder](#EzchaRequestBuilder)|[set_response_object](#EzchaRequestBuilder-method-set_response_object) ( [EzchaResponse](#EzchaResponse) obj )
|[EzchaRequestBuilder](#EzchaRequestBuilder)|[set_timeout](#EzchaRequestBuilder-method-set_timeout) ( [float](https://docs.godotengine.org/en/4.5/classes/class_float.html) time )
|[EzchaRequestBuilder](#EzchaRequestBuilder)|[add_query_parameter](#EzchaRequestBuilder-method-add_query_parameter) ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) key, [Variant](https://docs.godotengine.org/en/4.5/classes/class_variant.html) value )
|[EzchaRequestBuilder](#EzchaRequestBuilder)|[add_body_data](#EzchaRequestBuilder-method-add_body_data) ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) key, [Variant](https://docs.godotengine.org/en/4.5/classes/class_variant.html) value )
|void|[fetch](#EzchaRequestBuilder-method-fetch) ( )

### Method Descriptions

<a name="EzchaRequestBuilder-method-set_hostname"></a>
[EzchaRequestBuilder](#EzchaRequestBuilder) **set_hostname** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) value )

Sets the target hostname.

<a name="EzchaRequestBuilder-method-set_endpoint"></a>
[EzchaRequestBuilder](#EzchaRequestBuilder) **set_endpoint** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) value )

Sets the target endpoint.

<a name="EzchaRequestBuilder-method-set_method"></a>
[EzchaRequestBuilder](#EzchaRequestBuilder) **set_method** ( [HTTPClient.Method](https://docs.godotengine.org/en/4.5/classes/class_httpclient.html) value )

Sets the method to be used.

<a name="EzchaRequestBuilder-method-set_authentication"></a>
[EzchaRequestBuilder](#EzchaRequestBuilder) **set_authentication** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) token )

Sets the authentication header for the request.

<a name="EzchaRequestBuilder-method-set_signing_key"></a>
[EzchaRequestBuilder](#EzchaRequestBuilder) **set_signing_key** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) key )

Enables request signing and defines the signing key to use. Requires authentication to be set to a session token.

<a name="EzchaRequestBuilder-method-set_parse_response"></a>
[EzchaRequestBuilder](#EzchaRequestBuilder) **set_parse_response** ( [bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) enabled )

Enable/disable response parsing for performance.

<a name="EzchaRequestBuilder-method-set_response_object"></a>
[EzchaRequestBuilder](#EzchaRequestBuilder) **set_response_object** ( [EzchaResponse](#EzchaResponse) obj )

Set the response object.

<a name="EzchaRequestBuilder-method-set_timeout"></a>
[EzchaRequestBuilder](#EzchaRequestBuilder) **set_timeout** ( [float](https://docs.godotengine.org/en/4.5/classes/class_float.html) time )

Set the request timeout. Defaults to 10 seconds.

<a name="EzchaRequestBuilder-method-add_query_parameter"></a>
[EzchaRequestBuilder](#EzchaRequestBuilder) **add_query_parameter** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) key, [Variant](https://docs.godotengine.org/en/4.5/classes/class_variant.html) value )

Adds a parameter to the query string. The value should either be a string or an array of strings.

<a name="EzchaRequestBuilder-method-add_body_data"></a>
[EzchaRequestBuilder](#EzchaRequestBuilder) **add_body_data** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) key, [Variant](https://docs.godotengine.org/en/4.5/classes/class_variant.html) value )

Adds a value to the body data.

<a name="EzchaRequestBuilder-method-fetch"></a>
void **fetch** ( )

Makes the request.

<a name="EzchaResponse"></a>
## EzchaResponse

**Inherits:** [RefCounted](https://docs.godotengine.org/en/4.5/classes/class_refcounted.html)

The base class for handling Ezcha Network API responses.

### Methods

|Returns|Name|
|-|-|
|[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html)|[is_successful](#EzchaResponse-method-is_successful) ( )
|[int](https://docs.godotengine.org/en/4.5/classes/class_int.html)|[get_status](#EzchaResponse-method-get_status) ( )
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[get_error](#EzchaResponse-method-get_error) ( )
|[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html)|[is_pending](#EzchaResponse-method-is_pending) ( )

### Signals

**completed** ( )

Emitted once the response has been received and processed or upon failure.

### Method Descriptions

<a name="EzchaResponse-method-is_successful"></a>
[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) **is_successful** ( )

Returns if the response is okay and is not an error.

<a name="EzchaResponse-method-get_status"></a>
[int](https://docs.godotengine.org/en/4.5/classes/class_int.html) **get_status** ( )

Returns the status code.

<a name="EzchaResponse-method-get_error"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **get_error** ( )

Returns the error message if available.

<a name="EzchaResponse-method-is_pending"></a>
[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) **is_pending** ( )

Returns if the response is pending or not.

<a name="EzchaServerPlayer"></a>
## EzchaServerPlayer

**Inherits:** [RefCounted](https://docs.godotengine.org/en/4.5/classes/class_refcounted.html)

A helper class for managing player data (sessions, user info, trophies, etc) on a server.

### Description

You shouldn't use this client-side or when making a singleplayer game. In those cases you should use Ezcha.client instead.

### Properties

|Type|Name|Default|
|-|-|-|
|[EzchaUser](#EzchaUser)|[user](#EzchaServerPlayer-property-user)|null|
|[Array](https://docs.godotengine.org/en/4.5/classes/class_array.html) [ [EzchaTrophyMeta](#EzchaTrophyMeta) ]|[trophies_obtained](#EzchaServerPlayer-property-trophies_obtained)|[]|
|[Array](https://docs.godotengine.org/en/4.5/classes/class_array.html) [ [EzchaLeaderboardEntry](#EzchaLeaderboardEntry) ]|[leaderboard_entries](#EzchaServerPlayer-property-leaderboard_entries)|[]|
|[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html)|[moderation_tools](#EzchaServerPlayer-property-moderation_tools)|false|

### Methods

|Returns|Name|
|-|-|
|[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html)|[authenticate](#EzchaServerPlayer-method-authenticate) ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) session_token )
|[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html)|[is_authenticated](#EzchaServerPlayer-method-is_authenticated) ( )
|[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html)|[has_trophy](#EzchaServerPlayer-method-has_trophy) ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) trophy_id, [bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) include_pending=true )
|[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html)|[grant_trophy](#EzchaServerPlayer-method-grant_trophy) ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) trophy_id )
|[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html)|[has_score](#EzchaServerPlayer-method-has_score) ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) leaderboard_id )
|[float](https://docs.godotengine.org/en/4.5/classes/class_float.html)|[get_score](#EzchaServerPlayer-method-get_score) ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) leaderboard_id, [float](https://docs.godotengine.org/en/4.5/classes/class_float.html) defaults_to=0.0 )
|[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html)|[update_score](#EzchaServerPlayer-method-update_score) ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) leaderboard_id, [float](https://docs.godotengine.org/en/4.5/classes/class_float.html) score, [EzchaLeaderboardsAPI.UpdateMode](#EzchaLeaderboardsAPI) mode=EzchaLeaderboardsAPI.UpdateMode.SET )
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[get_datastore](#EzchaServerPlayer-method-get_datastore) ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) key )
|[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html)|[set_datastore](#EzchaServerPlayer-method-set_datastore) ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) key, [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) value )

### Signals

**authentication_completed** ( [bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) successful )

Emitted once a session token has been authenticated.

**trophy_grant_completed** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) trophy_id, [bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) successful, [EzchaTrophyMeta](#EzchaTrophyMeta) trophy_data )

Emitted when a trophy grant is queued from the grant_trophy function. trophy_data will be null if the grant could not be queued.

**leaderboard_update_completed** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) leaderboard_id, [bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) successful )

Emitted when a leaderboard update is queued from the update_score function.

**datastore_value_recieved** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) key, [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) value )

Emitted after a datastore value is requested and recieved

**datastore_value_posted** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) key, [bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) successful )

Emitted after a datastore value update is posted.

### Property Descriptions

<a name="EzchaServerPlayer-property-user"></a>
[EzchaUser](#EzchaUser) **user** = null

The user data of the player. Only available after authenticating.

<a name="EzchaServerPlayer-property-trophies_obtained"></a>
[Array](https://docs.godotengine.org/en/4.5/classes/class_array.html) [ [EzchaTrophyMeta](#EzchaTrophyMeta) ] **trophies_obtained** = []

The trophies that the user has obtained from this game.

<a name="EzchaServerPlayer-property-leaderboard_entries"></a>
[Array](https://docs.godotengine.org/en/4.5/classes/class_array.html) [ [EzchaLeaderboardEntry](#EzchaLeaderboardEntry) ] **leaderboard_entries** = []

The leaderboard entries that the currently authenticated user has for this game.

<a name="EzchaServerPlayer-property-moderation_tools"></a>
[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) **moderation_tools** = false

If true the user should have access to any moderation tools.

### Method Descriptions

<a name="EzchaServerPlayer-method-authenticate"></a>
[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) **authenticate** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) session_token )

Authenticates a session token and loads player information. 

 (Async) Returns true if authentication was successful. 

 The authentication_completed signal is emitted on completion.

<a name="EzchaServerPlayer-method-is_authenticated"></a>
[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) **is_authenticated** ( )

Returns true if the player has authenticated and user data is available.

<a name="EzchaServerPlayer-method-has_trophy"></a>
[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) **has_trophy** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) trophy_id, [bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) include_pending=true )

Returns true if the player has the trophy specified.

<a name="EzchaServerPlayer-method-grant_trophy"></a>
[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) **grant_trophy** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) trophy_id )

Grants a trophy to the currently authenticated user. 

 (Async) Returns true if the trophy grant was queued.

<a name="EzchaServerPlayer-method-has_score"></a>
[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) **has_score** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) leaderboard_id )

Checks if the player has a score on a leaderboard.

<a name="EzchaServerPlayer-method-get_score"></a>
[float](https://docs.godotengine.org/en/4.5/classes/class_float.html) **get_score** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) leaderboard_id, [float](https://docs.godotengine.org/en/4.5/classes/class_float.html) defaults_to=0.0 )

Returns the players's score on a specific leaderboard.

<a name="EzchaServerPlayer-method-update_score"></a>
[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) **update_score** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) leaderboard_id, [float](https://docs.godotengine.org/en/4.5/classes/class_float.html) score, [EzchaLeaderboardsAPI.UpdateMode](#EzchaLeaderboardsAPI) mode=EzchaLeaderboardsAPI.UpdateMode.SET )

Updates a leaderboard entry belonging to the player. 

 (Async) Returns true if the score update was queued.

<a name="EzchaServerPlayer-method-get_datastore"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **get_datastore** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) key )

Get a datastore value belonging to the currently authenticated player. The datastore_value_recieved signal is emitted when the value is recieved. 

 (Async) Returns a string value. The value will be empty if deleted or not yet set.

<a name="EzchaServerPlayer-method-set_datastore"></a>
[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) **set_datastore** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) key, [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) value )

Update a datastore value belonging to the currently authenticated player. Limit of 5 keys per user, limit of 16384 characters per value. Set the value to an empty string to delete the key. The datastore_value_posted signal is emitted on completion. 

 (Async) Returns true if the value was successfully updated.

<a name="EzchaWebTexture"></a>
## EzchaWebTexture

**Inherits:** [ImageTexture](https://docs.godotengine.org/en/4.5/classes/class_imagetexture.html)

A helper texture resource that loads an image from the internet.

### Methods

|Returns|Name|
|-|-|
|[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html)|[is_successful](#EzchaWebTexture-method-is_successful) ( )
|void|fetch ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) url )

### Signals

**loaded** ( )

Emitted when the image is downloaded and ready to be displayed.

**error** ( )

Emitted if the image could not be loaded.

### Method Descriptions

<a name="EzchaWebTexture-method-is_successful"></a>
[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) **is_successful** ( )

Returns true if the image has been downloaded and parsed.

<a name="EzchaGame"></a>
## EzchaGame

**Inherits:** [EzchaDto](#EzchaDto)

### Properties

|Type|Name|Default|
|-|-|-|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[id](#EzchaGame-property-id)|""|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[slug](#EzchaGame-property-slug)|""|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[name](#EzchaGame-property-name)|""|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[description](#EzchaGame-property-description)|""|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[version](#EzchaGame-property-version)|""|
|[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html)|[elite_exclusive](#EzchaGame-property-elite_exclusive)|false|
|[EzchaUser](#EzchaUser)|[developer](#EzchaGame-property-developer)|null|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[url](#EzchaGame-property-url)|""|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[banner_url](#EzchaGame-property-banner_url)|""|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[thumbnail_url](#EzchaGame-property-thumbnail_url)|""|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[released_timestamp](#EzchaGame-property-released_timestamp)|""|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[original_released_timestamp](#EzchaGame-property-original_released_timestamp)|""|

### Property Descriptions

<a name="EzchaGame-property-id"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **id** = ""

The game's unique identifier.

<a name="EzchaGame-property-slug"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **slug** = ""

The user-friendly identifier for the game in URLs.

<a name="EzchaGame-property-name"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **name** = ""

The display name of the game.

<a name="EzchaGame-property-description"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **description** = ""

The description for the game.

<a name="EzchaGame-property-version"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **version** = ""

The version the game is specified to be at. This does not follow any specific format.

<a name="EzchaGame-property-elite_exclusive"></a>
[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) **elite_exclusive** = false

If true the game can only be accessed by users who have elite membership.

<a name="EzchaGame-property-developer"></a>
[EzchaUser](#EzchaUser) **developer** = null

The developer for the game.

<a name="EzchaGame-property-url"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **url** = ""

The URL the game can be viewed and played at.

<a name="EzchaGame-property-banner_url"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **banner_url** = ""

The URL for the game's banner image. This will be a png file.

<a name="EzchaGame-property-thumbnail_url"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **thumbnail_url** = ""

The URL for the game's thumbnail image. This will be a png file.

<a name="EzchaGame-property-released_timestamp"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **released_timestamp** = ""

The timestamp for when the game was released on Ezcha.

<a name="EzchaGame-property-original_released_timestamp"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **original_released_timestamp** = ""

The timestamp for when the game was published on other platforms before Ezcha. Not all games will have this.

<a name="EzchaLeaderboard"></a>
## EzchaLeaderboard

**Inherits:** [EzchaDto](#EzchaDto)

### Properties

|Type|Name|Default|
|-|-|-|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[id](#EzchaLeaderboard-property-id)|""|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[name](#EzchaLeaderboard-property-name)|""|
|[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html)|[unlisted](#EzchaLeaderboard-property-unlisted)|false|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[sorting](#EzchaLeaderboard-property-sorting)|""|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[value_type](#EzchaLeaderboard-property-value_type)|""|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[value_prefix](#EzchaLeaderboard-property-value_prefix)|""|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[value_suffix](#EzchaLeaderboard-property-value_suffix)|""|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[created_timestamp](#EzchaLeaderboard-property-created_timestamp)|""|

### Property Descriptions

<a name="EzchaLeaderboard-property-id"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **id** = ""

The leaderboard's unique identifier.

<a name="EzchaLeaderboard-property-name"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **name** = ""

The display name of the leaderboard.

<a name="EzchaLeaderboard-property-unlisted"></a>
[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) **unlisted** = false

Indicates if the leaderboard is hidden from public view.

<a name="EzchaLeaderboard-property-sorting"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **sorting** = ""

The sort mode of the leaderboard. ("asc" or "desc")

<a name="EzchaLeaderboard-property-value_type"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **value_type** = ""

The value type the leaderboard represents. (Score, Points, Wins, etc)

<a name="EzchaLeaderboard-property-value_prefix"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **value_prefix** = ""

The prefix to show before the values when displayed.

<a name="EzchaLeaderboard-property-value_suffix"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **value_suffix** = ""

The suffix to show after the values when displayed.

<a name="EzchaLeaderboard-property-created_timestamp"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **created_timestamp** = ""

The timestamp of when the leaderboard was created.

<a name="EzchaLeaderboardEntry"></a>
## EzchaLeaderboardEntry

**Inherits:** [EzchaDto](#EzchaDto)

### Properties

|Type|Name|Default|
|-|-|-|
|[float](https://docs.godotengine.org/en/4.5/classes/class_float.html)|[score](#EzchaLeaderboardEntry-property-score)|0.0|
|[int](https://docs.godotengine.org/en/4.5/classes/class_int.html)|[ranking](#EzchaLeaderboardEntry-property-ranking)|-1|
|[EzchaLeaderboard](#EzchaLeaderboard)|[leaderboard](#EzchaLeaderboardEntry-property-leaderboard)|null|
|[EzchaUser](#EzchaUser)|[user](#EzchaLeaderboardEntry-property-user)|null|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[created_timestamp](#EzchaLeaderboardEntry-property-created_timestamp)|""|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[last_updated_timestamp](#EzchaLeaderboardEntry-property-last_updated_timestamp)|""|

### Property Descriptions

<a name="EzchaLeaderboardEntry-property-score"></a>
[float](https://docs.godotengine.org/en/4.5/classes/class_float.html) **score** = 0.0

The entry's current score.

<a name="EzchaLeaderboardEntry-property-ranking"></a>
[int](https://docs.godotengine.org/en/4.5/classes/class_int.html) **ranking** = -1

The player's current ranking if available.

<a name="EzchaLeaderboardEntry-property-leaderboard"></a>
[EzchaLeaderboard](#EzchaLeaderboard) **leaderboard** = null

The leaderboard that the entry belongs to. Not all responses will included this data.

<a name="EzchaLeaderboardEntry-property-user"></a>
[EzchaUser](#EzchaUser) **user** = null

The user that the entry belongs to. Not all responses will included this data.

<a name="EzchaLeaderboardEntry-property-created_timestamp"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **created_timestamp** = ""

The timestamp of when this entry was first created.

<a name="EzchaLeaderboardEntry-property-last_updated_timestamp"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **last_updated_timestamp** = ""

The timestamp of when this entry was last updated.

<a name="EzchaNewsPost"></a>
## EzchaNewsPost

**Inherits:** [EzchaDto](#EzchaDto)

### Properties

|Type|Name|Default|
|-|-|-|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[id](#EzchaNewsPost-property-id)|""|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[slug](#EzchaNewsPost-property-slug)|""|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[title](#EzchaNewsPost-property-title)|""|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[summary](#EzchaNewsPost-property-summary)|""|
|[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html)|[elite_exclusive](#EzchaNewsPost-property-elite_exclusive)|false|
|[EzchaUser](#EzchaUser)|[author](#EzchaNewsPost-property-author)|null|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[published_timestamp](#EzchaNewsPost-property-published_timestamp)|""|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[edited_timestamp](#EzchaNewsPost-property-edited_timestamp)|""|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[url](#EzchaNewsPost-property-url)|""|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[image_url](#EzchaNewsPost-property-image_url)|""|

### Property Descriptions

<a name="EzchaNewsPost-property-id"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **id** = ""

The news post's unique identifier.

<a name="EzchaNewsPost-property-slug"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **slug** = ""

The user-friendly identifier for the news post in URLs.

<a name="EzchaNewsPost-property-title"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **title** = ""

The title of the news post.

<a name="EzchaNewsPost-property-summary"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **summary** = ""

A short summary of the news post.

<a name="EzchaNewsPost-property-elite_exclusive"></a>
[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) **elite_exclusive** = false

If true the news post can only be accessed by users who have elite membership.

<a name="EzchaNewsPost-property-author"></a>
[EzchaUser](#EzchaUser) **author** = null

The author of the news post.

<a name="EzchaNewsPost-property-published_timestamp"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **published_timestamp** = ""

The timestamp of when the news post was published.

<a name="EzchaNewsPost-property-edited_timestamp"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **edited_timestamp** = ""

The timestamp of when the news post was last edited. Not all news posts will have this.

<a name="EzchaNewsPost-property-url"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **url** = ""

The URL that the news post can be viewed at.

<a name="EzchaNewsPost-property-image_url"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **image_url** = ""

The URL of the news post's featured image. Not all news posts will have this.

<a name="EzchaRelayLobby"></a>
## EzchaRelayLobby

**Inherits:** [EzchaDto](#EzchaDto)

### Properties

|Type|Name|Default|
|-|-|-|
|[int](https://docs.godotengine.org/en/4.5/classes/class_int.html)|[id](#EzchaRelayLobby-property-id)|-1|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[name](#EzchaRelayLobby-property-name)|""|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[version](#EzchaRelayLobby-property-version)|""|
|[int](https://docs.godotengine.org/en/4.5/classes/class_int.html)|[game_mode](#EzchaRelayLobby-property-game_mode)|-1|
|[Variant](https://docs.godotengine.org/en/4.5/classes/class_variant.html)|[player_count](#EzchaRelayLobby-property-player_count)|-1|
|[Variant](https://docs.godotengine.org/en/4.5/classes/class_variant.html)|[max_player_count](#EzchaRelayLobby-property-max_player_count)|-1|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[created_at](#EzchaRelayLobby-property-created_at)|""|
|[EzchaUser](#EzchaUser)|[host](#EzchaRelayLobby-property-host)|null|

### Property Descriptions

<a name="EzchaRelayLobby-property-id"></a>
[int](https://docs.godotengine.org/en/4.5/classes/class_int.html) **id** = -1

The 6 digit identifier/pin of the lobby.

<a name="EzchaRelayLobby-property-name"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **name** = ""

The name of the lobby.

<a name="EzchaRelayLobby-property-version"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **version** = ""

The game version the lobby supports.

<a name="EzchaRelayLobby-property-game_mode"></a>
[int](https://docs.godotengine.org/en/4.5/classes/class_int.html) **game_mode** = -1

The game mode the lobby currently is in.

<a name="EzchaRelayLobby-property-player_count"></a>
[Variant](https://docs.godotengine.org/en/4.5/classes/class_variant.html) **player_count** = -1

The current player count.

<a name="EzchaRelayLobby-property-max_player_count"></a>
[Variant](https://docs.godotengine.org/en/4.5/classes/class_variant.html) **max_player_count** = -1

The lobby's player limit.

<a name="EzchaRelayLobby-property-created_at"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **created_at** = ""

A timestamp of when the lobby was created.

<a name="EzchaRelayLobby-property-host"></a>
[EzchaUser](#EzchaUser) **host** = null

The current host of the lobby.

<a name="EzchaRelayServer"></a>
## EzchaRelayServer

**Inherits:** [EzchaDto](#EzchaDto)

### Properties

|Type|Name|Default|
|-|-|-|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[id](#EzchaRelayServer-property-id)|""|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[name](#EzchaRelayServer-property-name)|""|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[country](#EzchaRelayServer-property-country)|""|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[address](#EzchaRelayServer-property-address)|""|
|[int](https://docs.godotengine.org/en/4.5/classes/class_int.html)|[lobby_count](#EzchaRelayServer-property-lobby_count)|-1|
|[Variant](https://docs.godotengine.org/en/4.5/classes/class_variant.html)|[player_count](#EzchaRelayServer-property-player_count)|-1|

### Methods

|Returns|Name|
|-|-|
|[EzchaPaginatedLobbyListResponse](#EzchaPaginatedLobbyListResponse)|[get_lobbies](#EzchaRelayServer-method-get_lobbies) ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) game_id, [int](https://docs.godotengine.org/en/4.5/classes/class_int.html) page=1, [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) version="", [int](https://docs.godotengine.org/en/4.5/classes/class_int.html) game_mode=-1 )
|[int](https://docs.godotengine.org/en/4.5/classes/class_int.html)|[ping](#EzchaRelayServer-method-ping) ( )

### Property Descriptions

<a name="EzchaRelayServer-property-id"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **id** = ""

The server's unique identifier.

<a name="EzchaRelayServer-property-name"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **name** = ""

The user friendly name of the region.

<a name="EzchaRelayServer-property-country"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **country** = ""

2 character country code (ISO 3166).

<a name="EzchaRelayServer-property-address"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **address** = ""

The address of the relay server.

<a name="EzchaRelayServer-property-lobby_count"></a>
[int](https://docs.godotengine.org/en/4.5/classes/class_int.html) **lobby_count** = -1

The cached lobby count.

<a name="EzchaRelayServer-property-player_count"></a>
[Variant](https://docs.godotengine.org/en/4.5/classes/class_variant.html) **player_count** = -1

The cached player count.

### Method Descriptions

<a name="EzchaRelayServer-method-get_lobbies"></a>
[EzchaPaginatedLobbyListResponse](#EzchaPaginatedLobbyListResponse) **get_lobbies** ( [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) game_id, [int](https://docs.godotengine.org/en/4.5/classes/class_int.html) page=1, [String](https://docs.godotengine.org/en/4.5/classes/class_string.html) version="", [int](https://docs.godotengine.org/en/4.5/classes/class_int.html) game_mode=-1 )

Returns a list of public lobbies.

<a name="EzchaRelayServer-method-ping"></a>
[int](https://docs.godotengine.org/en/4.5/classes/class_int.html) **ping** ( )

Attempt to ping the server. (Async) Returns the time spent in milliseconds or -1 if failed.

<a name="EzchaTrophyMeta"></a>
## EzchaTrophyMeta

**Inherits:** [EzchaDto](#EzchaDto)

### Properties

|Type|Name|Default|
|-|-|-|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[id](#EzchaTrophyMeta-property-id)|""|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[name](#EzchaTrophyMeta-property-name)|""|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[description](#EzchaTrophyMeta-property-description)|""|
|[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html)|[unlisted](#EzchaTrophyMeta-property-unlisted)|false|
|[int](https://docs.godotengine.org/en/4.5/classes/class_int.html)|[experience_points](#EzchaTrophyMeta-property-experience_points)|0|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[created_timestamp](#EzchaTrophyMeta-property-created_timestamp)|""|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[icon_url](#EzchaTrophyMeta-property-icon_url)|""|

### Property Descriptions

<a name="EzchaTrophyMeta-property-id"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **id** = ""

The trophy's unique identifier.

<a name="EzchaTrophyMeta-property-name"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **name** = ""

The display name of the trophy.

<a name="EzchaTrophyMeta-property-description"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **description** = ""

The description of the trophy. This typically includes its criteria.

<a name="EzchaTrophyMeta-property-unlisted"></a>
[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) **unlisted** = false

Indicates if the trophy is hidden from public view.

<a name="EzchaTrophyMeta-property-experience_points"></a>
[int](https://docs.godotengine.org/en/4.5/classes/class_int.html) **experience_points** = 0

The number of experience points the trophy rewards once recieved.

<a name="EzchaTrophyMeta-property-created_timestamp"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **created_timestamp** = ""

The timestamp of when the trophy was created.

<a name="EzchaTrophyMeta-property-icon_url"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **icon_url** = ""

The URL for the trophy's icon image. This will be a png file.

<a name="EzchaUser"></a>
## EzchaUser

**Inherits:** [EzchaDto](#EzchaDto)

### Properties

|Type|Name|Default|
|-|-|-|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[id](#EzchaUser-property-id)|""|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[name](#EzchaUser-property-name)|""|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[bio](#EzchaUser-property-bio)|""|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[role](#EzchaUser-property-role)|""|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[title](#EzchaUser-property-title)|""|
|[int](https://docs.godotengine.org/en/4.5/classes/class_int.html)|[level](#EzchaUser-property-level)|-1|
|[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html)|[elite](#EzchaUser-property-elite)|false|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[registered_timestamp](#EzchaUser-property-registered_timestamp)|""|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[last_seen_timestamp](#EzchaUser-property-last_seen_timestamp)|""|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[url](#EzchaUser-property-url)|""|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[avatar_url](#EzchaUser-property-avatar_url)|""|

### Property Descriptions

<a name="EzchaUser-property-id"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **id** = ""

The user's unique identifier.

<a name="EzchaUser-property-name"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **name** = ""

The user's unique username.

<a name="EzchaUser-property-bio"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **bio** = ""

A description provided by the user. This is displayed in the "about me" section on Ezcha profiles.

<a name="EzchaUser-property-role"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **role** = ""

The user's role if they currently have one.

<a name="EzchaUser-property-title"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **title** = ""

The user's title if they currently have one.

<a name="EzchaUser-property-level"></a>
[int](https://docs.godotengine.org/en/4.5/classes/class_int.html) **level** = -1

The total level the user is currently at.

<a name="EzchaUser-property-elite"></a>
[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) **elite** = false

If true the user currently has elite membership.

<a name="EzchaUser-property-registered_timestamp"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **registered_timestamp** = ""

The timestamp of when the user registered their account.

<a name="EzchaUser-property-last_seen_timestamp"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **last_seen_timestamp** = ""

The timestamp of when the user was last seen online.

<a name="EzchaUser-property-url"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **url** = ""

The URL to view the user's profile.

<a name="EzchaUser-property-avatar_url"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **avatar_url** = ""

The URL for the user's avatar/profile picture. This will be a png file.

<a name="EzchaCaptchaResponse"></a>
## EzchaCaptchaResponse

**Inherits:** [EzchaResponse](#EzchaResponse)

A response from the API that returns if a captcha response was valid or not.

### Properties

|Type|Name|Default|
|-|-|-|
|[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html)|[valid](#EzchaCaptchaResponse-property-valid)|false|

### Property Descriptions

<a name="EzchaCaptchaResponse-property-valid"></a>
[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) **valid** = false

Returns true if the captcha response was valid.

<a name="EzchaDatastoreValueResponse"></a>
## EzchaDatastoreValueResponse

**Inherits:** [EzchaResponse](#EzchaResponse)

A paginated response from the API.

### Properties

|Type|Name|Default|
|-|-|-|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[value](#EzchaDatastoreValueResponse-property-value)|""|

### Property Descriptions

<a name="EzchaDatastoreValueResponse-property-value"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **value** = ""

The value of the requested key. Returns an empty string if deleted or not set.

<a name="EzchaFriendsResponse"></a>
## EzchaFriendsResponse

**Inherits:** [EzchaResponse](#EzchaResponse)

A response from the API that returns whether or not two users are friends.

### Properties

|Type|Name|Default|
|-|-|-|
|[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html)|[friends](#EzchaFriendsResponse-property-friends)|false|

### Property Descriptions

<a name="EzchaFriendsResponse-property-friends"></a>
[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) **friends** = false

Returns true if the two users are friends.

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
|[Array](https://docs.godotengine.org/en/4.5/classes/class_array.html) [ [EzchaGame](#EzchaGame) ]|[games](#EzchaGameListResponse-property-games)|[]|

### Property Descriptions

<a name="EzchaGameListResponse-property-games"></a>
[Array](https://docs.godotengine.org/en/4.5/classes/class_array.html) [ [EzchaGame](#EzchaGame) ] **games** = []

The list of games returned by the API request.

<a name="EzchaGeneralStatusResponse"></a>
## EzchaGeneralStatusResponse

**Inherits:** [EzchaResponse](#EzchaResponse)

A response from the API containing the status of the API.

### Properties

|Type|Name|Default|
|-|-|-|
|[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html)|[online](#EzchaGeneralStatusResponse-property-online)|false|

### Property Descriptions

<a name="EzchaGeneralStatusResponse-property-online"></a>
[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) **online** = false

Indicates if the Ezcha Network API is online and accessible.

<a name="EzchaGeneralTimeResponse"></a>
## EzchaGeneralTimeResponse

**Inherits:** [EzchaResponse](#EzchaResponse)

A response from the API containing the current time.

### Properties

|Type|Name|Default|
|-|-|-|
|[String](https://docs.godotengine.org/en/4.5/classes/class_string.html)|[timestamp](#EzchaGeneralTimeResponse-property-timestamp)|""|
|[int](https://docs.godotengine.org/en/4.5/classes/class_int.html)|[epoch](#EzchaGeneralTimeResponse-property-epoch)|-1|

### Property Descriptions

<a name="EzchaGeneralTimeResponse-property-timestamp"></a>
[String](https://docs.godotengine.org/en/4.5/classes/class_string.html) **timestamp** = ""

The server's current time as an ISO 8601 datestring.

<a name="EzchaGeneralTimeResponse-property-epoch"></a>
[int](https://docs.godotengine.org/en/4.5/classes/class_int.html) **epoch** = -1

The server's current time as a unix epoch measured in milliseconds.

<a name="EzchaLeaderboardListResponse"></a>
## EzchaLeaderboardListResponse

**Inherits:** [EzchaResponse](#EzchaResponse)

A response from the API containing a list of leaderboards.

### Properties

|Type|Name|Default|
|-|-|-|
|[Array](https://docs.godotengine.org/en/4.5/classes/class_array.html) [ [EzchaLeaderboard](#EzchaLeaderboard) ]|[leaderboards](#EzchaLeaderboardListResponse-property-leaderboards)|[]|

### Property Descriptions

<a name="EzchaLeaderboardListResponse-property-leaderboards"></a>
[Array](https://docs.godotengine.org/en/4.5/classes/class_array.html) [ [EzchaLeaderboard](#EzchaLeaderboard) ] **leaderboards** = []

The list of leaderboards returned by the API request.

<a name="EzchaLeaderboardQueuedResponse"></a>
## EzchaLeaderboardQueuedResponse

**Inherits:** [EzchaResponse](#EzchaResponse)

A response from the API that returns if a leaderboard update has been queued.

### Properties

|Type|Name|Default|
|-|-|-|
|[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html)|[queued](#EzchaLeaderboardQueuedResponse-property-queued)|false|

### Property Descriptions

<a name="EzchaLeaderboardQueuedResponse-property-queued"></a>
[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) **queued** = false

Returns true if an update has been queued.

<a name="EzchaPaginatedResponse"></a>
## EzchaPaginatedResponse

**Inherits:** [EzchaResponse](#EzchaResponse)

A paginated response from the API.

### Properties

|Type|Name|Default|
|-|-|-|
|[int](https://docs.godotengine.org/en/4.5/classes/class_int.html)|[page](#EzchaPaginatedResponse-property-page)|-1|
|[int](https://docs.godotengine.org/en/4.5/classes/class_int.html)|[page_count](#EzchaPaginatedResponse-property-page_count)|-1|
|[int](https://docs.godotengine.org/en/4.5/classes/class_int.html)|[items_per_page](#EzchaPaginatedResponse-property-items_per_page)|-1|
|[int](https://docs.godotengine.org/en/4.5/classes/class_int.html)|[total_results](#EzchaPaginatedResponse-property-total_results)|-1|

### Property Descriptions

<a name="EzchaPaginatedResponse-property-page"></a>
[int](https://docs.godotengine.org/en/4.5/classes/class_int.html) **page** = -1

The current page.

<a name="EzchaPaginatedResponse-property-page_count"></a>
[int](https://docs.godotengine.org/en/4.5/classes/class_int.html) **page_count** = -1

The total number of pages available.

<a name="EzchaPaginatedResponse-property-items_per_page"></a>
[int](https://docs.godotengine.org/en/4.5/classes/class_int.html) **items_per_page** = -1

The limit of how many items can be displayed on each page.

<a name="EzchaPaginatedResponse-property-total_results"></a>
[int](https://docs.godotengine.org/en/4.5/classes/class_int.html) **total_results** = -1

The total number of results returned.

<a name="EzchaPaginatedLeaderboardEntryListResponse"></a>
## EzchaPaginatedLeaderboardEntryListResponse

**Inherits:** [EzchaPaginatedResponse](#EzchaPaginatedResponse)

A response from the API containing a paginated list of leaderboards.

### Properties

|Type|Name|Default|
|-|-|-|
|[Array](https://docs.godotengine.org/en/4.5/classes/class_array.html) [ [EzchaLeaderboardEntry](#EzchaLeaderboardEntry) ]|[entries](#EzchaPaginatedLeaderboardEntryListResponse-property-entries)|[]|

### Property Descriptions

<a name="EzchaPaginatedLeaderboardEntryListResponse-property-entries"></a>
[Array](https://docs.godotengine.org/en/4.5/classes/class_array.html) [ [EzchaLeaderboardEntry](#EzchaLeaderboardEntry) ] **entries** = []

The list of leaderboards returned by the API request.

<a name="EzchaPaginatedLobbyListResponse"></a>
## EzchaPaginatedLobbyListResponse

**Inherits:** [EzchaPaginatedResponse](#EzchaPaginatedResponse)

A response from the relay API containing a list of games.

### Properties

|Type|Name|Default|
|-|-|-|
|[Array](https://docs.godotengine.org/en/4.5/classes/class_array.html) [ [EzchaRelayLobby](#EzchaRelayLobby) ]|[lobbies](#EzchaPaginatedLobbyListResponse-property-lobbies)|[]|

### Property Descriptions

<a name="EzchaPaginatedLobbyListResponse-property-lobbies"></a>
[Array](https://docs.godotengine.org/en/4.5/classes/class_array.html) [ [EzchaRelayLobby](#EzchaRelayLobby) ] **lobbies** = []

The list of lobbies returned by the API request.

<a name="EzchaPaginatedNewsListResponse"></a>
## EzchaPaginatedNewsListResponse

**Inherits:** [EzchaPaginatedResponse](#EzchaPaginatedResponse)

A response from the API containing a paginated list of leaderboards.

### Properties

|Type|Name|Default|
|-|-|-|
|[Array](https://docs.godotengine.org/en/4.5/classes/class_array.html) [ [EzchaNewsPost](#EzchaNewsPost) ]|[posts](#EzchaPaginatedNewsListResponse-property-posts)|[]|

### Property Descriptions

<a name="EzchaPaginatedNewsListResponse-property-posts"></a>
[Array](https://docs.godotengine.org/en/4.5/classes/class_array.html) [ [EzchaNewsPost](#EzchaNewsPost) ] **posts** = []

The list of news posts returned by the API request.

<a name="EzchaPaginatedUserListResponse"></a>
## EzchaPaginatedUserListResponse

**Inherits:** [EzchaPaginatedResponse](#EzchaPaginatedResponse)

A response from the API containing a paginated list of users.

### Properties

|Type|Name|Default|
|-|-|-|
|[Array](https://docs.godotengine.org/en/4.5/classes/class_array.html) [ [EzchaUser](#EzchaUser) ]|[users](#EzchaPaginatedUserListResponse-property-users)|[]|

### Property Descriptions

<a name="EzchaPaginatedUserListResponse-property-users"></a>
[Array](https://docs.godotengine.org/en/4.5/classes/class_array.html) [ [EzchaUser](#EzchaUser) ] **users** = []

The list of users returned by the API request.

<a name="EzchaRelayServerListResponse"></a>
## EzchaRelayServerListResponse

**Inherits:** [EzchaResponse](#EzchaResponse)

A response from the API containing a list of available relay servers.

### Properties

|Type|Name|Default|
|-|-|-|
|[Array](https://docs.godotengine.org/en/4.5/classes/class_array.html) [ [EzchaRelayServer](#EzchaRelayServer) ]|[servers](#EzchaRelayServerListResponse-property-servers)|[]|

### Property Descriptions

<a name="EzchaRelayServerListResponse-property-servers"></a>
[Array](https://docs.godotengine.org/en/4.5/classes/class_array.html) [ [EzchaRelayServer](#EzchaRelayServer) ] **servers** = []

The list of relay servers returned by the API request.

<a name="EzchaSessionValidationResponse"></a>
## EzchaSessionValidationResponse

**Inherits:** [EzchaResponse](#EzchaResponse)

A response from the API containing the information related to a validated session.

### Properties

|Type|Name|Default|
|-|-|-|
|[EzchaUser](#EzchaUser)|[user](#EzchaSessionValidationResponse-property-user)|null|
|[Array](https://docs.godotengine.org/en/4.5/classes/class_array.html) [ [EzchaTrophyMeta](#EzchaTrophyMeta) ]|[trophies_obtained](#EzchaSessionValidationResponse-property-trophies_obtained)|[]|
|[Array](https://docs.godotengine.org/en/4.5/classes/class_array.html) [ [EzchaLeaderboardEntry](#EzchaLeaderboardEntry) ]|[leaderboard_entries](#EzchaSessionValidationResponse-property-leaderboard_entries)|[]|
|[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html)|[moderation_tools](#EzchaSessionValidationResponse-property-moderation_tools)|false|

### Property Descriptions

<a name="EzchaSessionValidationResponse-property-user"></a>
[EzchaUser](#EzchaUser) **user** = null

The user associated with the session.

<a name="EzchaSessionValidationResponse-property-trophies_obtained"></a>
[Array](https://docs.godotengine.org/en/4.5/classes/class_array.html) [ [EzchaTrophyMeta](#EzchaTrophyMeta) ] **trophies_obtained** = []

The trophies that the user has obtained from this game.

<a name="EzchaSessionValidationResponse-property-leaderboard_entries"></a>
[Array](https://docs.godotengine.org/en/4.5/classes/class_array.html) [ [EzchaLeaderboardEntry](#EzchaLeaderboardEntry) ] **leaderboard_entries** = []

The leaderboard entries the user has for this game.

<a name="EzchaSessionValidationResponse-property-moderation_tools"></a>
[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) **moderation_tools** = false

If true the user should have access to any available moderation tools.

<a name="EzchaTrophyMetaListResponse"></a>
## EzchaTrophyMetaListResponse

**Inherits:** [EzchaResponse](#EzchaResponse)

A response from the API containing a list of trophies.

### Properties

|Type|Name|Default|
|-|-|-|
|[Array](https://docs.godotengine.org/en/4.5/classes/class_array.html) [ [EzchaTrophyMeta](#EzchaTrophyMeta) ]|[trophies](#EzchaTrophyMetaListResponse-property-trophies)|[]|

### Property Descriptions

<a name="EzchaTrophyMetaListResponse-property-trophies"></a>
[Array](https://docs.godotengine.org/en/4.5/classes/class_array.html) [ [EzchaTrophyMeta](#EzchaTrophyMeta) ] **trophies** = []

The list of trophies returned by the API request.

<a name="EzchaTrophyQueuedResponse"></a>
## EzchaTrophyQueuedResponse

**Inherits:** [EzchaResponse](#EzchaResponse)

A response from the API that returns if a trophy grant has been queued.

### Properties

|Type|Name|Default|
|-|-|-|
|[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html)|[queued](#EzchaTrophyQueuedResponse-property-queued)|false|
|[EzchaTrophyMeta](#EzchaTrophyMeta)|[trophy](#EzchaTrophyQueuedResponse-property-trophy)|null|

### Property Descriptions

<a name="EzchaTrophyQueuedResponse-property-queued"></a>
[bool](https://docs.godotengine.org/en/4.5/classes/class_bool.html) **queued** = false

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
|[Array](https://docs.godotengine.org/en/4.5/classes/class_array.html) [ [EzchaUser](#EzchaUser) ]|[users](#EzchaUserListResponse-property-users)|[]|

### Property Descriptions

<a name="EzchaUserListResponse-property-users"></a>
[Array](https://docs.godotengine.org/en/4.5/classes/class_array.html) [ [EzchaUser](#EzchaUser) ] **users** = []

The users returned by the API request.
