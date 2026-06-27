# Version 2.6.0

- Builds can now be uploaded directly to the site from the editor
	- The plugin now adds a new "Ezcha Network" export target
	- The selected save location is discarded, all work is done in a temp directory
	- When used it will automatically build, bundle and upload the game
	- Allows the embed configuration to be set from the export preset
- Added the `EzchaUploader` class
	- Handles file upload streams over HTTPS
	- Uses multipart/form-data encoding
- `EzchaWebTexture` improvements
	- No longer duplicates the data of the placeholder texture
	- Replaced the `fetch` function with an exported `url` variable
- Updated dock UI
	- Reorganized the plugin config menu
	- Renamed the "session override" field to "test session" for clarity
	- Cleaner styling
	- Added an export progress widget
- General `EzchaRequestBuilder` improvements
- `EzchaTrophyQueuedResponse` now uses `TrophyObtained` for its `trophy` field instead of `Trophy`
- Centralized settings, config and misc parameters in `EzchaOpts`
- Added local developer config file
	- Automatically gets added to .gitignore when created
- Moved session override to local config file
- Added new a build key config option
- Improved documentation standardization and consistency

# Version 2.5.3

This update mainly improves the plugin development pipeline but also brings some small,
general improvements.

- Added the [GD Mark It](https://github.com/ezcha-network/gd-mark-it) plugin to the repo to replace the previous NodeJS script
- Added the [GD Plugin Bundler](https://github.com/ezcha-network/gd-plugin-bundler) plugin to the repo to make packaging the plugin quicker
- Properly deleted the old "ezcha_platform_adapter_web.gd" script conflicting with the rename.
- Improved settings handling
- Added missing typings
- Made the definitions under the `EzchaPlugin` class private
	- This is technically breaking but you shouldn't be using them anyways
- Updated the dock menu requests to use the new `.async()` syntax
- Fixed copy and paste errors in doc comments across the entire project

---

# Version 2.5.2

This version implements the new partial guest support for Ezcha Relay, along with various
other improvements. Joining a lobby as a guest will now simulate authentication as a temporary user,
allowing you to get user data like you normally would. To enable guests developers must toggle the
new option in the developer panel under the "API" tab. Users can now also be banned from lobbies.

- Access errors now print to the output
- Added `is_guest()` helper function to `EzchaClient`
- Added a `guest` bool field to `EzchaUser`
- Added `equals(other)` helper function to all DTO objects.
- Added `ban(peer_id, message = "")` to `EzchaRelayMultiplayerPeer`

---

# Version 2.5.1

- **BREAKING!** Renamed `EzchaPlatformAdapterWeb` to `EzchaWebAdapter`
- The editor plugin now keeps the override session alive
- Added a `request_account_management()` function to `EzchaClient`
	- Only supported on platforms where `supports_native_login()` is `true`
- Added a `session_expired` signal to `EzchaClient`
	- Emits when a previously valid session expires or is otherwise detected as invalid
- Added a `login_completed` signal to `EzchaClient`
- General behind the scenes improvements for the native login flow

---

# Version 2.5.0

- **BREAKING!** Renamed `EzchaTrophyMeta` to `EzchaTrophy`
- **BREAKING!** Renamed `EzchaTrophyMetaListResponse` to `EzchaTrophyListResponse`
- Added `EzchaTrophyObtained` (extends `EzchaTrophy`)
	- Contains a `obtained_timestamp` field
- Added `Ezcha.client.get_trophy(id)`
- `EzchaSessionValidationResponse.trophies_obtained` is now `EzchaTrophyObtained[]` instead of `EzchaTrophy[]`
- `Ezcha.client.trophies_obtained` is now `EzchaTrophyObtained[]` instead of `EzchaTrophy[]`
- `EzchaServerPlayer.trophies_obtained` is now `EzchaTrophyObtained[]` instead of `EzchaTrophy[]`
- `Ezcha.users.get_trophies(user_id, game_id)` now returns `EzchaTrophyObtainedListResponse` instead of `EzchaTrophyListResponse`
- Added `EzchaServerPlayer.get_trophy(id)`
- `interstitial_ad_prompt()` and `rewarded_ad_prompt()` now automatically toggles game audio

---

# Version 2.4.2

General bug fixes and improvements.

- Split `EzchaPlatformAdapterWeb`'s `ad_prompt` function into two
	- `interstitial_ad_prompt`: shown during breaks, automatically skipped for elite members
	- `rewarded_ad_prompt`: visible to all players, may reward in-game bonuses
- General `EzchaAsyncBatch` improvements
	- Now uses `call_deferred` when starting the added async functions
	- The `add` and `watch` functions can now be chained together
	- Made the `completed` signal private, use `await batch.watch()` instead
- `EzchaRequestBuilder` now uses `call_deferred` upon making the request

---

# Version 2.4.1

Version 2.4.1 makes improvements to the plugin's platform adapter system. The adapter
is now exposed and its functions are no longer marked as experimental. These enable platform
specific features and interoperability. It also brings some nice quality of life changes to
the request/response classes.

- New `get_adapter` function in `EzchaClient`
	- Exposes the current platform adapter
	- Returns `EzchaPlatformAdapterWeb` for web embeds uploaded to the platform
- General `EzchaPlatformAdapterWeb` improvements
	- Improved event/message handling
	- The `login_redirect`, `avatar_prompt`, `captcha_prompt` functions are no longer marked as experimental
	- New `register_redirect` function
- Implemented new rewarded ad functionality to `EzchaPlatformAdapterWeb`
	- Enables the game to display short video ads to the player and reward them
	- New async `ad_prompt` function, returns the `rewarded` value
	- New `ad_prompt_completed` signal
- New `get_relay_lobbies` method in `EzchaClient`
	- Automatically supplies game ID and version when making the request
	- Returns `EzchaLobbyListResponse`
- **BREAKING!** Renamed `EzchaUserListResponse` to `EzchaUsersResponse`
- **BREAKING!** Removed "Paginated" from applicable response class names
	- `EzchaPaginatedLeaderboardEntryListResponse` is now `EzchaLeaderboardEntryListResponse`
	- `EzchaPaginatedLobbyListResponse` is now `EzchaLobbyListResponse`
	- `EzchaPaginatedNewsListResponse` is now `EzchaNewsListResponse`
	- `EzchaPaginatedUserListResponse` is now `EzchaUserListResponse`
- General `EzchaRequestBuilder` improvements
	- The `fetch` function now returns `EzchaResponse` instead of `void`
- New `async` method in `EzchaResponse`
	- Waits for the request to be completed and returns itself
- Cleaned up API wrappers

---

# Version 2.4.0

Version 2.4.0 is a major update which integrates Ezcha Relay. This is a service that allows
developers to quickly and easily add online multiplayer to their games. It provides a built in
lobby system, supports Godot's high level multiplayer system and uses websocket for transport. It
conceals the IP address of each peer and ties into the main Ezcha API to provide user data which
(when correctly used) the host cannot tamper with.

## Ezcha Relay Integration

- New `EzchaRelayAPI` class, accessible via `Ezcha.relay`
	- Includes `get_server` function which lists available relay servers
	- Includes `get_lobbies` function which lists public relay lobbies
	- Includes `resolve_lobby` function which finds a lobby from its join code
- New `EzchaRelayServer` class
	- Includes `ping` function to test latency
- New `EzchaRelayLobby` class
	- Includes general information about a lobby accessible as properties
- New `EzchaRelayMultiplayerPeer` class
	- Custom multiplayer peer which allows Godot's high level multiplayer system to work over Ezcha Relay
- New `EzchaMultiplayerSpawner` class
	- Simple wrapper around `MultiplayerSpawner` which supports Ezcha Relay host migration
	- This is needed (when supporting migration) as the node tracks things differently when acting as the host
	- Tracked nodes will be removed and added back to the scene tree upon migration, emitting the related signals
- Added a `order_relay_servers()` function to `EzchaClient` that sorts and returns available relay servers based on latency

## Miscellaneous

- New `EzchaUtil` class
	- Data unpacking has been relocated here as multiple classes now rely on it
	- Includes a `get_game_version` function to get the version value as defined in project settings
	- Includes a `get_start_argument` function to retrieve a start argument depending on the platform
- Fixes applied to the `EzchaClient` class
	- **BREAKING!** Renamed `datastore_value_recieved` signal (mispelled oops) to `datastore_value_received`
- Improvements to the `EzchaResponse` class
	- **BREAKING!** Renamed `recieved` signal to `completed` for clarity (also emits on failure)
- **BREAKING!** Renamed `EzchaAwaitAll` class to `EzchaAsyncBatch` and made improvements
	- Coroutine return values are now tracked and retrievable
	- `completed` signal now includes results
	- Renamed `block` function to `watch` which now also returns results (async)
	- Execution of coroutines now happens when `watch` is called instead of when they are added
	- Added `is_completed` function which returns true if all coroutines have completed
	- Added `is_pending` function which returns true if any coroutines are processing
	- Added `count_pending` function which returns how many coroutines are yet to be completed
	- Added `count_completed` function which returns how many coroutines have been completed
	- Added `get_results` function function which returns available coroutine results
- Improvements to the `EzchaUsersAPI` class
	- Added support for `/v1/users/friends/check` endpoint, accessible via `Ezcha.users.check_friends`
- Improvements to the `EzchaRequestBuilder` class
	- Hostnames other than "api.ezcha.net" can now be specified via `set_hostname`
	- Per request timeouts can now be specified via `set_timeout`
	- Cleaned up error checking & data unpacking
- Improvements to the `EzchaWebTexture` class
	- Now supports mipmap generation, toggleable via a new `generate_mipmaps` property (defaults to `true`)

---

You're gonna have to check the commit history to look further back.
