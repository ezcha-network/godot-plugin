extends EzchaDto
class_name EzchaProduct

## The product's unique identifier.
var id: String = ""

## The display name of the product.
var name: String = ""

## The description of the product. This typically includes its criteria.
var description: String = ""

## Indicates if the product is hidden from public view.
var unlisted: bool = false

## Indicates if the product is consumable or permanent.
var consumable: bool = false

## The price of the product in USD cents.
var price: int = -1

## The timestamp of when the product was created.
var created_timestamp: String = ""

## The URL for the product's icon image.
## This will be a png file.
var icon_url: String = ""

## Check if two instances represent the same product.
## Data can vary if requested at different times.
func equals(other: EzchaProduct) -> bool:
	return (id == other.id)
