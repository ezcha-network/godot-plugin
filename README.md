# Ezcha Network for Godot 4

[![Get this plugin on the Godot Asset Store](https://cdn.ezcha.net/static/git-badge/godot-asset-store.svg)](https://store.godotengine.org/asset/ezcha/network/)

This plugin enables developers to quickly and easily add online multiplayer, lobbies, trophies, leaderboards, cloud saves, and more to their games. These features are all free and powered by Ezcha Network, a small (but quickly growing) indie games platform. The API is first-class and completely handwritten to work seamlessly with how Godot and your project already function. Here at Ezcha LLC we love Godot and naturally use this plugin in our own original games. This allows us to ensure a high-quality developer experience, as we want one too!

[Looking for the Godot 3 version?](https://github.com/ezcha-network/godot-plugin/tree/godot-3.x)

![A gif showcasing a trophy being granted.](https://ezchacdn.com/ezcha3/user-img/4630c25a-12ba-420a-93b5-e27ffa27ff24)

## Links & Resources

- [Apply now (it's quick!)](https://ezcha.net/developer)
- [More information](https://ezcha.net/news/8-26-24-call-for-developers)
- [Getting started guide](https://ezcha.net/news/11-30-25-godot-engine-ezcha-network)
- [Online documentation](docs.md)

## Features & Services

Here is a list of all the features and services provided by Ezcha Network.

- Cross-platform
	- Mobile support releasing to the public soon
	- Players take their progress with them across devices
	- The plugin adapts to the platform (write once, run everywhere!)
- Hosting
    - Web embeds (with mobile compatibility)
    - Traditional downloads
- Accounts & authentication
	- Supports login/register with Apple & Google
- Trophies
	- Can be categorized
	- Includes experience points which players can collect to level up
- Leaderboards
	- Highly customizable
	- Supports elapsed times
- Multiplayer relay
    - Built-in lobby system and list
	- Seamlessly integrates with Godot's high-level system
	- Three current server locations
		- Colorado (US)
		- Quebec (CA)
		- Switzerland (EU)
	- (You can host your own dedicated servers as well)
- Cloud saves
- Player statistics
- General API (time, captchas, etc)
- Basic anti-cheat
	- Signed client-side requests
	- Replay attacks are blocked
	- Specific trophies and leaderboards can be locked to server updates only
- Real-time notifications for trophy grants and leaderboard updates

## Workflow

### User Interface

The plugin provides a convenient user interface. The developer can use it to configure their game, view its trophies/leaderboards, and to quickly navigate to its developer panel on the website. It also includes useful links to the developer forums and plugin documentation.

![A gif showing the user browsing through the "Ezcha" dock that the plugin adds.](https://ezchacdn.com/ezcha3/user-img/835466af-a981-472c-af4e-0450b7292bf0)

### Upload From Godot

The plugin also allows developers to quickly upload their games directly from the editor. It adds a new "Ezcha Network" export platform which automatically builds the game for web, prepares it into a bundle, uploads that the site, and waits for it all to be processed.

![A gif showing the export/upload progress being displayed in the "Ezcha" dock.](https://cdn.ezcha.net/ezcha3/user-img/07c2f14b-2197-4f73-bb71-8bde21dbc972)

## Examples

See for yourself how easy it is to integrate Ezcha Network into your games!

0. [Authentication](examples/0_authentication/authentication.gd)
1. [Profile](examples/1_profile/profile.gd)
2. [Trophies](examples/2_trophies/trophies.gd)
3. [Leaderboards](examples/3_leaderboards/leaderboards.gd)
4. [Datastores](examples/4_datastores/datastores.gd)

## Feature Flags

- `ezcha_exclude_api_key`
	- Removes the API key from the export.
- `ezcha_exclude_signing_key`
	- Removes the signing key from the export.
