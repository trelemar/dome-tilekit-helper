import "graphics" for Canvas, Color, ImageData, Point, Font
import "io" for FileSystem
import "math" for Math, Vector
import "json" for Json, JsonOptions, JsonError
import "dome" for Platform

class TileMap {
	static init_() {
		__verbose = false
	}
	construct new(jsonfile) {
		var jsonString = FileSystem.load(jsonfile)
		var mapString = jsonString[0..(jsonString.indexOf("objects") - 3)].trim("{}")
		mapString = mapString[6..mapString.count-1] + "}"

		_mapData = Json.decode(mapString)
		_tileSheet = ImageData.loadFromFile(_mapData["image_filename"])

		var animationsIndex = mapString.indexOf("\"animations\":[")
		var animationsEnd =  mapString.indexOf("\"tags\"", animationsIndex) - 2
		__verbose && System.print("Span of animations chunk : " + animationsIndex.toString + "-" + animationsEnd.toString)

		var animationsString = mapString[animationsIndex+13..animationsEnd] // 13 is the length of: "animations":

		if (animationsString.count > 5) {
			__verbose && System.print("Adding Animations...")
			var animations = Json.decode(animationsString)
			var total_tiles = (_tileSheet.width / (_mapData["tile_w"] + _mapData["tile_spacing"])) * (_tileSheet.height / (_mapData["tile_h"] + _mapData["tile_spacing"]))
			__verbose && System.print("Counted " + total_tiles.toString + " tiles in tilesheet")
			_animationsList = List.filled(total_tiles + 1, false)
			for (entry in animations) {
				var idx = entry["idx"]
				__verbose && System.print("adding tile " + idx.toString)
				_animationsList[idx] = {
					"frames"	: entry["frames"],
					"rate"		: entry["rate"]
				}
				
			}
		}

	}

	width {_mapData["w"]}
	height {_mapData["h"]}
	tileWidth {_mapData["tile_w"]}
	tileHeight {_mapData["tile_h"]}

	drawTile(tile, x, y) {
		var w = _mapData["tile_w"]
		var h = _mapData["tile_h"]
		var s = _mapData["tile_spacing"]

		var spritesPerRow = _tileSheet.width / (w + s)
		var xPixel = (tile - 1) % spritesPerRow
		var yPixel = ((tile - 1) / spritesPerRow).floor
		_tileSheet.drawArea(xPixel * (w + s), yPixel * (h + s), w, h, x, y)
	}

	draw(x, y, dt) {
		var mw = _mapData["w"]
		var mh = _mapData["h"]
		var tiles = _mapData["data"]
		for (tile in 0...tiles.count) {
			if (tiles[tile] != 0) {
				var sprite = tiles[tile]
				if (_animationsList && _animationsList[sprite]) {
					var frames = _animationsList[sprite]["frames"]
					var rate = _animationsList[sprite]["rate"]
					var duration = rate / 1000
					var frame = ((System.clock / duration) % frames.count).floor
					sprite = frames[frame]
				}
				
				drawTile(sprite, (tile % mw) * _mapData["tile_w"], (tile / mw).floor * _mapData["tile_w"])
			}
		}
	}
}

TileMap.init_()