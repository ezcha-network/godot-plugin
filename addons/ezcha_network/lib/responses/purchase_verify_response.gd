extends EzchaResponse
class_name EzchaProductVerifyResponse
## A response from the API revealing if a purchase is legitimate.

## The ID of the purchase.
var id: String = ""

## The product associated with the purchase.
var product: EzchaProduct = null

## The time when the purchase was completed.
var completed_timestamp: String = ""

## Indicates if the purchase was consumed.
var consumed: bool = false
