# tilekit-helper

## Quickly import and process [TileKit](https://rxi.itch.io/tilekit) maps in [DOME](https://domeengine.com/)

### Example main.wren
```ruby
import "graphics" for Canvas, Color, ImageData, Point, Font
import "dome" for Process, Window, Platform
import "io" for FileSystem

import "./tilekit-helper"

var OurMap = TileMap.new("map.json")

class Main {
  construct new() {}
  init() {
    Canvas.resize(OurMap.width * OurMap.tileWidth, OurMap.height * OurMap.tileHeight)
  }
  update() {}
  draw(alpha) {
    OurMap.draw(0, 0)
  }
}
var Game = Main.new()
```

## TileMap
An instance of `TileMap` class contains information about a map created with TileKit. It can be used to easily manipulate, process, and draw the map the the Canvas.

### Constructors

#### `construct new(jsonfile: String)`
Creates a new instance of a TileMap object. `String` should be in same directory as this module.

### Instance Fields

#### `width: Number`
Width of tilemap in tiles

#### `height: Number`
Height of tilemap in tiles

#### `tileWidth: Number`
Width of tiles in pixels

#### `tileHeight: Number`
Height of tiles in pixels

### Instance Methods

#### `getTile(x: Number, y: Number): Number`
Returns tile at Map coordinates (x, y)

#### `setTile(x: Number, y: Number, tile: Number)`
Sets tile at Map coordinates (x, y)

#### `drawTile(tile: Number, x: Number, y: Number)`
Draw a single `tile` to Canvas at (x, y)

#### `draw(x: Number, y: Number)`
Draws entire TileMap to Canvas at (x, y)