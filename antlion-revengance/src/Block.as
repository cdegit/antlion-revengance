package  
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Green Mesa
	 */
	public class Block extends Sprite 
	{
		public static const TILE_WIDTH:int = 32;	// Tiles across: 16
		public static const TILE_HEIGHT:int = 32; 	// Tiles up: 24
		
		// Tile Types
		public static const TILE_ROCK:int = 0;
		public static const TILE_DIRT:int = 1;
		public static const TILE_MUD:int = 2;
		public static const TILE_RUBBLE:int = 3;
		public static const TILE_TWIG:int = 4;
		public static const TILE_EXIT:int = 5;
		public static const TILE_VENT:int = 6;
		public static const TILE_STONE:int = 7;
		public static const TILE_GRASS:int = 8;
		
		public var type:int;
		private var tileNumber:int;
		private var imageNumber:int = -1;
		private var fillColor:uint = 0x000000;
		
		private var tilesheet:BitmapData;
		
		public function Block(type:int, x:int, y:int, tilesheet:BitmapData) 
		{
			super();
			this.type = type;
			this.x = x;
			this.y = y;
			
			/*
			switch(type)
			{
				case TILE_ROCK:
					fillColor = 0x333333;
					imageNumber = BitmapAssets.TILE_ROCK;
					break;
				case TILE_DIRT:
					fillColor = 0xdddddd;
					imageNumber = BitmapAssets.TILE_DIRT;
					break;
				case TILE_MUD: // so we know nearby ones must be mud. Check those cells to figure out which this one should be.
					fillColor = 0x33ee88;
					// if there isn't mud to the left or above, this one is first
						//above: current index - width of grid?
					// if one to left but not above, is second
					// if none to left but one above, third
					// if one to left and one above, is fourth
					break;
				case TILE_RUBBLE:
					fillColor = 0xee3883;
					break;
				case TILE_TWIG:
					fillColor = 0x883333;
					break;
				case TILE_EXIT:
					fillColor = 0xffd700;
					break;
			}
			*/
			
			this.tilesheet = tilesheet;
			
			//render();
		}
		
		public function render(lvlArray:Array, index:int):void
		{
			
			switch(type)
			{
				case TILE_ROCK:
					fillColor = 0x333333;
					imageNumber = BitmapAssets.TILE_ROCK;
					break;
				case TILE_DIRT:
					fillColor = 0xdddddd;
					imageNumber = BitmapAssets.TILE_DIRT;
					break;
				case TILE_MUD: // so we know nearby ones must be mud. Check those cells to figure out which this one should be.
					fillColor = 0x33ee88;
					// if there isn't mud to the left or above, this one is first
						//above: current index - width of grid?
					if (lvlArray[index - 16] != TILE_MUD) { 		// if the one above isn't mud
						if (lvlArray[index-1] !=TILE_MUD) {
							imageNumber = BitmapAssets.TILE_MUD1;
						} else {
							imageNumber = BitmapAssets.TILE_MUD2;
						}
					} else { 	// if the one above is mud
						if (lvlArray[index-1] !=TILE_MUD) {
							imageNumber = BitmapAssets.TILE_MUD3;
						} else {
							imageNumber = BitmapAssets.TILE_MUD4;
						}
					}
					// if one to left but not above, is second
					// if none to left but one above, third
					// if one to left and one above, is fourth
					break;
				case TILE_RUBBLE:
					fillColor = 0xee3883;
					break;
				case TILE_TWIG:
					fillColor = 0x883333;
					break;
				case TILE_EXIT:
					fillColor = 0xffd700;
					break;
				case TILE_GRASS:
					imageNumber = BitmapAssets.TILE_GRASS;
					break;
			}			
			
			this.graphics.beginFill(fillColor);
			this.graphics.drawRect(0,0,TILE_HEIGHT,TILE_WIDTH);
			this.graphics.endFill();
			
			if (imageNumber != -1) {
				var sourceRect:Rectangle = new Rectangle(imageNumber * BitmapAssets.TILE_WIDTH, 0, BitmapAssets.TILE_WIDTH, BitmapAssets.TILE_WIDTH);
				var point:Point = new Point(0, 0);
				var blockBitmapData:BitmapData = new BitmapData(BitmapAssets.TILE_WIDTH, BitmapAssets.TILE_WIDTH, true, 0);
				blockBitmapData.copyPixels(tilesheet, sourceRect, point);
				var blockBitmap:Bitmap = new Bitmap(blockBitmapData);
				addChild(blockBitmap);
			}
		}
		
	}

}