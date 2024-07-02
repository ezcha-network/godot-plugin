extends EzchaDto
class_name EzchaTrophyMeta

## The trophy's unique identifier.
var id: String = ""

## The display name of the trophy.
var name: String = ""

## The description of the trophy. This typically includes its criteria.
var description: String = ""

## The number of experience points the trophy rewards once recieved.
var experience_points: int = 0

## The timestamp of when the trophy was created.
var created_timestamp: String = ""

## The URL for the trophy's icon image.
## This will be a png file.
var icon_url: String = ""
