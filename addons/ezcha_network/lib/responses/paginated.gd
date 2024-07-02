extends EzchaResponse
class_name EzchaPaginatedResponse
## A paginated response from the API.

## The current page.
var page: int = -1

## The total number of pages available.
var page_count: int = -1

## The limit of how many items can be displayed on each page.
var items_per_page: int = -1

## The total number of results returned.
var total_results: int = -1
