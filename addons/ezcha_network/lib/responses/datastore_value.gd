extends EzchaResponse
class_name EzchaDatastoreValueResponse
## A response from the API containing a datastore value.

## The value of the requested key. Returns an empty string if deleted or not set.
var value: String = ""
