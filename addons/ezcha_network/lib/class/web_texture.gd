@tool
extends ImageTexture
class_name EzchaWebTexture
## A helper texture resource that loads an image from the internet.

## Emitted when the image is downloaded and ready to be displayed.
signal loaded()

## Emitted if the image could not be loaded.
signal error()

## The placeholder image to display while the target image is being requested.
@export var placeholder: Texture2D = null :
	set(value):
		placeholder = value
		if (_loaded): return
		set_image(placeholder.get_image())

## If the image type cannot be determined it will set it to this value.
@export var assume_type: String = ""

var _url: String = ""
var _loaded: bool = false
var _errored: bool = false
var _http_req: HTTPRequest = null

## Returns true if the image has been downloaded and parsed.
func is_successful() -> bool:
	return (_loaded && !_errored)

func fetch(url: String) -> void:
	if (url == _url): return
	_url = url
	_loaded = false
	_errored = false
	if (placeholder != null): set_image(placeholder.get_image())
	
	if (_http_req != null):
		_http_req.cancel_request()
		_http_req.queue_free()
		_http_req = null
	if (url == ""):
		error.emit()
		return
	_http_req = HTTPRequest.new()
	_http_req.request_completed.connect(_on_http_req_completed)
	Engine.get_main_loop().root.add_child(_http_req)
	_http_req.request(url)

func _on_http_req_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	_http_req.queue_free()
	_http_req = null
	
	if (response_code < 200 && response_code >= 300):
		printerr("EzchaWebImage: Invalid server response.")
		_errored = true
		error.emit()
		return
	
	# Determine image type
	var content_type: String = assume_type
	for header: String in headers:
		var cleaned: String = header.strip_edges()
		if (!cleaned.begins_with("Content-Type")): continue
		var content_split: PackedStringArray = header.split(" ", false, 2)
		if (content_split.size() != 2): continue
		if (!content_split[1].begins_with("image/")): continue
		var mime_split: PackedStringArray = content_split[1].split("/", false, 2)
		if (mime_split.size() != 2): continue
		content_type = mime_split[1]
	
	var err: Error = FAILED
	var img: Image = Image.new()
	match(content_type):
		"bmp": err = img.load_bmp_from_buffer(body)
		"jpg": err = img.load_jpg_from_buffer(body)
		"jpeg": err = img.load_jpg_from_buffer(body)
		"ktx": err = img.load_ktx_from_buffer(body)
		"png": err = img.load_png_from_buffer(body)
		"svg": err = img.load_svg_from_buffer(body)
		"tga": err = img.load_tga_from_buffer(body)
		"webp": err = img.load_webp_from_buffer(body)
		_:
			printerr("EzchaWebImage: Unsupported image type.")
			_errored = true
			error.emit()
			return
	
	if (err != OK):
		printerr("EzchaWebImage: The downloaded image failed to load.")
		_errored = true
		error.emit()
		return
	
	set_image(img)
	_loaded = true
	loaded.emit()
