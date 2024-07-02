extends EzchaDto
class_name EzchaNewsPost

func _get_type_map() -> Dictionary:
	return {
		"author": EzchaUser
	}

## The news post's unique identifier.
var id: String = ""

## The user-friendly identifier for the news post in URLs.
var slug: String = ""

## The title of the news post.
var title: String = ""

## A short summary of the news post.
var summary: String = ""

## If true the news post can only be accessed by users who have elite membership.
var elite_exclusive: bool = false

## The author of the news post.
var author: EzchaUser = null

## The timestamp of when the news post was published.
var published_timestamp: String = ""

## The timestamp of when the news post was last edited.
## Not all news posts will have this.
var edited_timestamp: String = ""

## The URL that the news post can be viewed at.
var url: String = ""

## The URL of the news post's featured image.
## Not all news posts will have this.
var image_url: String = ""
