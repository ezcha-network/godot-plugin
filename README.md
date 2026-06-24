# Ezcha Network for Godot 4

[![Get this plugin on the Godot Asset Store](https://cdn.ezcha.net/static/git-badge/godot-asset-store.svg)](https://store.godotengine.org/asset/ezcha/network/)

This plugin enables developers to quickly and easily add online multiplayer, lobbies, trophies, leaderboards, cloud saves, and more to their games. These features are all free and powered by Ezcha Network, a small (but quickly growing) indie games platform. The API is first class, all handwritten to work best with how Godot and your project already function. Here at Ezcha LLC we love Godot and naturally use this plugin in our own original games. This allows us to ensure a high-quality developer experience, as we want one too!

[Looking for the Godot 3 version?](https://github.com/ezcha-network/godot-plugin/tree/godot-3.x)

![A gif showcasing a trophy being granted.](https://ezchacdn.com/ezcha3/user-img/4630c25a-12ba-420a-93b5-e27ffa27ff24)

## Links & Resources

* [Apply now (it's quick!)](https://ezcha.net/developer)
* [More information](https://ezcha.net/news/8-26-24-call-for-developers)
* [Getting started guide](https://ezcha.net/news/11-30-25-godot-engine-ezcha-network)
* [Documentation](docs.md)

## Features

Here is a list of all the features and services provided by Ezcha Network.

* Hosting
    * Web embeds
    * Traditional downloads
* Accounts
* Authentication
* Trophies
* Leaderboards
* Multiplayer relay
    * Built-in lobby system and list
    * Seamlessly integrates with Godot's high-level system
    * Three current server locations
        * Colorado (US)
        * Quebec (CA)
        * Switzerland (EU)
    * (Dedicated servers can be used as well)
* Cloud saves
* Statistics
* General API (time, captchas, etc)
* Basic anti-cheat
    * Signed client-side requests
    * Replay attacks are blocked
    * Specific trophies and leaderboards can be locked to server updates only
* Real-time notifications for trophy grants and leaderboard updates

## User Interface

Along with the actual game features/services, the plugin provides a convenient user interface as well. Here the developer can configure their game, view its trophies/leaderboards, and quickly navigate to its developer panel on the site. It also includes useful links to the developer forums and plugin documentation.

![Browsing through the "Ezcha" menu that the plugin adds](https://ezchacdn.com/ezcha3/user-img/835466af-a981-472c-af4e-0450b7292bf0)

## Usage

### Singleplayer/Client-side

**Authentication**

Before trying to grant any trophies or updating any leaderboard scores, you must first
authenticate the user. You would typically do this at the start of the game. Upon successful
completion information about the current user can be accessed at `Ezcha.client.user`.

```gdscript
func do_auth() -> void:
	var success: bool = await Ezcha.client.authenticate()
	
	# Error handling
	if (!success):
		print("Failed to authenticate user!")
		return
	
	# Authentication successful
	print("Authenticated as %s!" % [Ezcha.client.user.name])
```

You can also use signals instead of await if preferred.

```gdscript
func do_auth() -> void:
	Ezcha.client.authentication_completed.connect(_on_authentication_completed)
	Ezcha.client.authenticate()

func _on_authentication_completed(success: bool) -> void:
	# Error handling
	if (!success):
		print("Failed to authenticate user!")
		return
	
	# Authentication successful
	print("Authenticated as %s!" % [Ezcha.client.user.name])
```

**Granting a trophy**

```gdscript
func _on_epic_accomplishment() -> void:
	Ezcha.client.grant_trophy("TROPHY_ID_GOES_HERE")
```

**Updating a leaderboard score**

```gdscript
func complete_level(final_score: int, cheese_consumed: int) -> void:
	# Set a score to a fixed value
	# (When there is an existing score the new one will only be saved if its an improvement)
	Ezcha.client.update_score("LEVEL_SCORE_LEADERBOARD_ID", final_score)
	
	# Add points to a total score
	Ezcha.client.update_score("CHEESE_CONSUMED_LEADERBOARD_ID", cheese_consumed, EzchaLeaderboardsAPI.UpdateMode.ADD)
```

Please note that for leaderboards with time elapsed formatting the submitted score should be in **milliseconds**, not seconds which many of the time functions built into Godot will return.

```gdscript
func _on_speedrun_completed(time_elapsed: float) -> void:
	# This assumes time_elapsed is a float representing seconds.
	var milliseconds: int = roundi(time_elapsed * 1000.0)
	Ezcha.client.update_score("SPEEDRUN_LEADERBOARD_ID", milliseconds)
```

### Server-side

**Authentication**

When making a multiplayer game you should validate sessions server-side as players connect.
This is done by having the client send the server its session token.
In the server you will need to create an instance of the `EzchaServerPlayer` class
instead of using the `client` helper. The client can get its session token with the
`Ezcha.client.get_session_token()` function after local authentication.

```gdscript
var player_map: Dictionary = {}

@rpc("any_peer", "call_remote", "reliable")
func rpc_auth(session_token: String) -> void:
	var peer_id: int = multiplayer.get_remote_sender_id()
	
	# Block if user has already authenticated
	if (player_map.has(peer_id)):
		return

	var player: EzchaServerPlayer = EzchaServerPlayer.new()
	var success: bool = await player.authenticate(session_token)
	
	# Error handling
	if (!success):
		print("Failed to authenticate peer %s!" % [peer_id])
		return
	
	# Authentication successful
	player_map[peer_id] = player
	print("Peer %s authenticated as %s!" % [peer_id, player.user.name])
```

**Granting a trophy**

```gdscript
var score_map: Dictionary = {}

@rpc("any_peer", "call_remote", "reliable")
func rpc_button_pushed() -> void:
	var peer_id: int = multiplayer.get_remote_sender_id()
	
	# Block unauthenticated players
	if (!player_map.has(peer_id)):
		return
	
	# Set initial value in map if missing
	if (!score_map.has(peer_id)):
		score_map[peer_id] = 0
	
	# Increment score
	score_map[peer_id] += 1
	
	# Grant a trophy when the player reaches 100 points
	if (score_map[peer_id] == 100):
		player_map[peer_id].grant_trophy("TROPHY_ID_GOES_HERE")
```

**Updating a leaderboard score**

```gdscript
func _on_peer_disconnected(peer_id: int) -> void:
	# Skip if user has not authenticated
	if (!player_map.has(peer_id)):
		return
	
	# Submit score
	if (score_map.has(peer_id)):
		player_map[peer_id].update_score("LEADERBOARD_ID_GOES_HERE", score_map[peer_id])
		score_map.erase(peer_id)
	
	player_map.erase(peer_id)
```

### API Wrappers

**Listing trophies**

```gdscript
func print_trophies() -> void:
	# Get the game's ID
	var game_id: String = Ezcha.get_game_id()
	
	# Request the information
	var trophy_resp: EzchaTrophyListResponse = await Ezcha.games.get_trophies(game_id).async()
	
	# Error handling
	if (!trophy_resp.is_successful()):
		print("Failed to fetch trophies: %s (%s)" % [
			trophy_resp.get_error(),
			trophy_resp.get_status()
		])
		return
	
	# Print a list with the name and ID of each trophy
	for trophy: EzchaTrophy in trophy_resp.trophies:
		print("%s (ID: %s)" % [
			trophy.name,
			trophy.id
		])
```

**Listing leaderboard scores**

```gdscript
func print_leaderboard(leaderboard_id: String, page: int = 1) -> void:
	# Request the information
	var entries_resp: EzchaPaginatedLeaderboardEntryListResponse = await Ezcha.leaderboards.get_entries(leaderboard_id, page).async()
	
	# Error handling
	if (!entries_resp.is_successful()):
		print("Failed to fetch leaderboard entries: %s (%s)" % [
			entries_resp.get_error(),
			entries_resp.get_status()
		])
		return
	
	# Print a list with the username and score of each entry
	for idx: int in entries_resp.entries.size():
		var entry: EzchaLeaderboardEntry = entries_resp.entries[idx]
		var ranking: int = (entries_resp.page - 1) * entries_resp.items_per_page + idx + 1
		print("#%s. %s %s" % [
			ranking,
			entry.user.name,
			entry.score
		])
``` 

## Feature Flags

The plugin also supports some feature flags:

- `ezcha_exclude_api_key`
  - Removes the API key from the export.
- `ezcha_exclude_signing_key`
  - Removes the signing key from the export.
