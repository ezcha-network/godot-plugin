@tool
extends Texture2D
class_name EzchaWebTexture
## A helper texture resource that loads an image from the internet.

## Emitted when the image is downloaded and ready to be displayed.
signal loaded()

## Emitted if the image could not be loaded.
signal error()

## The URL to download the image from.
@export var url: String = "" :
	set(value):
		if (value == url): return
		url = value
		if (value.is_empty()): _clear()
		else: _fetch()

## The placeholder image to display before/while the URL is downloaded.
@export var placeholder: Texture2D = null

## If the image type cannot be determined it will set it to this value.
@export var assume_type: String = ""

## Generate mipmaps for the downloaded image.
@export var generate_mipmaps: bool = true

var _http_req: HTTPRequest = null
var _dl_texture: ImageTexture = null

# Texture

func _target_tex() -> Texture2D:
	return placeholder if (_dl_texture == null) else _dl_texture

func _get_rid() -> RID:
	var target: Texture2D = _target_tex()
	return null if (target == null) else target.get_rid()

func _draw(to_canvas_item: RID, pos: Vector2, modulate: Color, transpose: bool) -> void:
	var target: Texture2D = _target_tex()
	if (target == null): return
	target.draw(to_canvas_item, pos, modulate, transpose)

func _draw_rect(to_canvas_item: RID, rect: Rect2, tile: bool, modulate: Color, transpose: bool) -> void:
	var target: Texture2D = _target_tex()
	if (target == null): return
	target.draw_rect(to_canvas_item, rect, tile, modulate, transpose)

func _draw_rect_region(to_canvas_item: RID, rect: Rect2, src_rect: Rect2, modulate: Color, transpose: bool, clip_uv: bool) -> void:
	var target: Texture2D = _target_tex()
	if (target == null): return
	target.draw_rect_region(to_canvas_item, rect, src_rect, modulate, transpose, clip_uv)

func _get_height() -> int:
	var target: Texture2D = _target_tex()
	if (target == null): return 0
	return target.get_height()

func _get_width() -> int:
	var target: Texture2D = _target_tex()
	if (target == null): return 0
	return target.get_width()

func _has_alpha() -> bool:
	var target: Texture2D = _target_tex()
	if (target == null): return true
	return target.has_alpha()

func _is_pixel_opaque(x: int, y: int) -> bool:
	var target: Texture2D = _target_tex()
	if (target == null): return false
	return target.get_image().get_pixel(x, y).a == 0.0

# Interface

## Returns true if the image has been downloaded and parsed.
func is_successful() -> bool:
	return (_http_req != null && _dl_texture != null)

# Internal helpers

func _fetch() -> void:
	_dl_texture = null
	emit_changed()
	if (_http_req != null):
		_http_req.cancel_request()
		_http_req.queue_free()
		_http_req = null
	if (url == ""):
		error.emit()
		return
	_http_req = HTTPRequest.new()
	_http_req.request_completed.connect(_on_http_req_completed)
	EzchaSingleton._get_instance().add_child(_http_req)
	_http_req.request(url)

func _clear() -> void:
	_dl_texture = null
	emit_changed()

# Events

func _on_http_req_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	_http_req.queue_free()
	_http_req = null
	
	if (response_code < 200 && response_code >= 300):
		printerr("[EzchaWebTexture] Invalid server response.")
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
			printerr("[EzchaWebTexture] Unsupported image type.")
			error.emit()
			return
	
	if (err != OK):
		printerr("[EzchaWebTexture] The downloaded image failed to load.")
		error.emit()
		return
	
	if (generate_mipmaps): img.generate_mipmaps()
	_dl_texture = ImageTexture.create_from_image(img)
	emit_changed()
	loaded.emit()
