# Ezcha Network for Godot 4

[Looking for the Godot 3 version?](https://github.com/ezcha-network/godot-plugin/tree/godot-3.x)

This repository contains the official Ezcha Network plugin for Godot. It allows you to
integrate the [Ezcha Network](https://ezcha.net/) platform and its features into your games.
This includes authentication, trophies, leaderboards and more.

![Browsing through the "Ezcha" menu that the plugin adds](https://github.com/ezcha-network/godot-plugin/assets/15235673/ce7b24e4-d997-4089-a0c8-1c081145a517)

## Developer Applications

Applications to become a developer on the Ezcha Network are now open.
Get more info [here](https://ezcha.net/news/8-26-24-call-for-developers)
or [apply now](https://ezcha.net/developer/apply). You must be a verified developer
on the platform to list your game and to access its API and features. You will not
be able to use this plugin otherwise.

## Documentation

Full documentation/reference for the plugin can be viewed [here](docs.md).

## Setup

Follow the steps below to setup the plugin in your project.

1. Create a game listing on Ezcha Network.
2. Copy the game ID from its developer panel, found under the "API" tab.
3. Add the plugin to the `/addons` directory of your Godot project.
4. Enable the "Ezcha Network" plugin in the project settings.
5. Find the new "Ezcha" menu below the inspector.
6. Use the menu to configure your game's ID.

If you are working on a singleplayer game and want to grant trophies or update the player's
leaderboard scores, you will also need to configure a **signing** key. If you are working on
a dedicated server for a game use an API key instead. These can be
created from within the "API" tab of your game's developer panel on Ezcha Network.

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
	var trophy_resp: EzchaTrophyMetaListResponse = await Ezcha.games.get_trophies(game_id)
	
	# Error handling
	if (!trophy_resp.is_successful()):
		print("Failed to fetch trophies: %s (%s)" % [
			trophy_resp.get_error(),
			trophy_resp.get_status()
		])
		return
	
	# Print a list with the name and ID of each trophy
	for trophy: EzchaTrophyMeta in trophy_resp.trophies:
		print("%s (ID: %s)" % [
			trophy.name,
			trophy.id
		])
```

**Listing leaderboard scores**

```gdscript
func print_leaderboard(leaderboard_id: String, page: int = 1) -> void:
	# Request the information
	var entries_resp: EzchaPaginatedLeaderboardEntryListResponse = await Ezcha.leaderboards.get_entries(leaderboard_id, page)
	
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
