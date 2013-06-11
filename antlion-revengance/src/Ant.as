package  
{
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Green Mesa
	 */
	public class Ant extends Sprite 
	{
		
		public static const SPEED:int = 32;
		public var blockModel:Array = [];
		
		public var dead:Boolean = false;
		public var inMud:Boolean = false;
		private var mudTimer:Timer;
		private var tilesheet:BitmapData;
		
		private var hasBaby:Boolean = false;
		private var sourceRect:Rectangle;
		private var point:Point;
		private var antBitmapData:BitmapData;
		private var antBitmap:Bitmap;
		
		public function Ant(blockModel:Array, tilesheet:BitmapData) 
		{
			super();
			this.blockModel = blockModel;
			// Changed to intialize position here because Ant.x & Ant.y
			// are default at (0,0)
			this.x = 16;
			this.y = 752;
			this.tilesheet = tilesheet;
			render();
		}
		
		public function render():void
		{
			// (0,32) for accessing the cell that's directly below the first one in the tileset image
			sourceRect= new Rectangle(0, 32, BitmapAssets.TILE_WIDTH-2, BitmapAssets.TILE_WIDTH-2);
			point = new Point(0, 0);
			antBitmapData = new BitmapData(BitmapAssets.TILE_WIDTH-2, BitmapAssets.TILE_WIDTH-2, true, 0);
			antBitmapData.copyPixels(tilesheet, sourceRect, point);
			antBitmap = new Bitmap(antBitmapData);
			addChild(antBitmap);			
			antBitmap.x = -15;
			antBitmap.y = -15;
		}
		
		public function move(x:int, y:int):void
		{
			var oldx:int = this.x;
			var oldy:int = this.y;
			
			if (inMud) {	
				
			} else {
				this.x += x;
				this.y += y;	
			}
			
			var tileType:int = -1; 
			for (var i:int = 0; i < blockModel.length; i++) {
				var temp:int = checkBlock(blockModel[i]);
				
				//if (temp > -1) {
				//	trace("blk: " + i);
				//}
				
				switch(temp)	// handle interactions with different tile types 
				{
					case -1:
						break;
					case Block.TILE_MUD:
						// something here
						// maybe have timer, mess up ant movement until timer is up
						inMud = true;
						
						mudTimer = new Timer(1000, 1);	
						mudTimer.addEventListener(TimerEvent.TIMER, escapeMud);
						mudTimer.start();
						
						tileType = temp;
						break;
					case Block.TILE_RUBBLE:
						// something here, ant is able to pick up
						// however, ant cannot walk on this?
						inMud = false;
						tileType = temp;
						break;
					case Block.TILE_TWIG:
						// ant is killed
						trace("you hit a twig!");
						trace(Block.TILE_TWIG);
						dead = true;
						break;
					default:
						inMud = false;
						tileType = temp;
				}
			}
			if ( ( this.x > 512 || this.x < 0) || ( this.y > 768 || this.y < 0 ) || (tileType == 0) ) {
				this.x = oldx;
				this.y = oldy;
			}			
		}
		
		public function checkBlock(block:Block):int
		{
			var result:int = -1;
			if (block.hitTestObject(this)) {
				//trace("blk: " + block.type);
				result = block.type;
			}
			return result;
		}
		
		public function update():void
		{
			
		}
		
		public function getX():int
		{
			return this.x;
		}
		
		public function getY():int
		{
			return this.y;
		}
		
		public function escapeMud(e:TimerEvent):void
		{
			inMud = false;
		}
		
		// Takes an (x,y) coordinate input and returns the index of the cell it is in
		private function coordToGrid(x:int, y:int):int {
			// Currently a constant, but should get it dynamically
			var blockSize:int = 32;
			var mazeWidth:int = 16;
			
			// Converts x & y to the number of cells it spans (ie, 80/blockSize = 80/32 = 2 cells rounded down)
			var gridX:int = x / blockSize;
			var gridY:int = y / blockSize;
			
			// Every increment of y is an entire row (ie, mazeWidth),
			// while 0 <= x < mazeWidth
			var index:int = gridY * mazeWidth + gridX;

			return index;
		}
		
		public function getIndex():int {
			return coordToGrid(this.x, this.y);
		}
		
		public function gotBaby():void 
		{
			hasBaby = true;
			updateImage();
		}
		
		private function updateImage():void 
		{
			removeChild(antBitmap);
			
			// (0,32) for accessing the cell that's directly below the first one in the tileset image
			sourceRect= new Rectangle(128, 32, BitmapAssets.TILE_WIDTH-2, BitmapAssets.TILE_WIDTH-2);
			point = new Point(0, 0);
			antBitmapData = new BitmapData(BitmapAssets.TILE_WIDTH-2, BitmapAssets.TILE_WIDTH-2, true, 0);
			antBitmapData.copyPixels(tilesheet, sourceRect, point);
			antBitmap = new Bitmap(antBitmapData);
			addChild(antBitmap);			
			antBitmap.x = -15;
			antBitmap.y = -15;
		}
	}

}