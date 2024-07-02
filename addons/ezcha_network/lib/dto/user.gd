extends EzchaDto
class_name EzchaUser

## The user's unique identifier.
var id: String = ""

## The user's unique username.
var name: String = ""

## A description provided by the user.
## This is displayed in the "about me" section on Ezcha profiles.
var bio: String = ""

## The user's role if they currently have one.
var role: String = ""

## The user's title if they currently have one.
var title: String = ""

## The total level the user is currently at.
var level: int = -1

## If true the user currently has elite membership.
var elite: bool = false

## The timestamp of when the user registered their account.
var registered_timestamp: String = ""

## The timestamp of when the user was last seen online.
var last_seen_timestamp: String = ""

## The URL to view the user's profile.
var url: String = ""

## The URL for the user's avatar/profile picture.
## This will be a png file.
var avatar_url: String = ""
