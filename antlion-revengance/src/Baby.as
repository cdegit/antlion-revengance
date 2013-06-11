package 
{
	import flash.display.Sprite;
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
	public class Baby extends Sprite
	{
		private var tilesheet:BitmapData;
		private var state:int = 0;
		private var stateTimer:Timer;
		
		private var sourceRect:Rectangle;
		private var point:Point;
		private var antBitmapData:BitmapData;
		private var antBitmap:Bitmap;
		
		public function Baby(tileSheet:BitmapData)
		{
			super();
			this.x = 464;
			this.y = 720;
			this.tilesheet = tileSheet;
			render();
			
			stateTimer = new Timer(1000);	
			stateTimer.addEventListener(TimerEvent.TIMER, changeState);
			stateTimer.start();
		}
		
		public function render():void
		{
				sourceRect= new Rectangle(64, 32, BitmapAssets.TILE_WIDTH-2, BitmapAssets.TILE_WIDTH-2);
				point = new Point(0, 0);
				antBitmapData = new BitmapData(BitmapAssets.TILE_WIDTH-2, BitmapAssets.TILE_WIDTH-2, true, 0);
				antBitmapData.copyPixels(tilesheet, sourceRect, point);
				antBitmap = new Bitmap(antBitmapData);
				addChild(antBitmap);			
				antBitmap.x = -15;
				antBitmap.y = -15;
		}
		
		private function update():void
		{
			removeChild(antBitmap);
			
			if (state == 0) {
				sourceRect = new Rectangle(64, 32, BitmapAssets.TILE_WIDTH-2, BitmapAssets.TILE_WIDTH-2);
				point = new Point(0, 0);
				antBitmapData = new BitmapData(BitmapAssets.TILE_WIDTH-2, BitmapAssets.TILE_WIDTH-2, true, 0);
				antBitmapData.copyPixels(tilesheet, sourceRect, point);
				antBitmap = new Bitmap(antBitmapData);
				addChild(antBitmap);			
				antBitmap.x = -15;
				antBitmap.y = -15;
			}
			else if (state == 1) {
				sourceRect = new Rectangle(96, 32, BitmapAssets.TILE_WIDTH-2, BitmapAssets.TILE_WIDTH-2);
				point = new Point(0, 0);
				antBitmapData = new BitmapData(BitmapAssets.TILE_WIDTH-2, BitmapAssets.TILE_WIDTH-2, true, 0);
				antBitmapData.copyPixels(tilesheet, sourceRect, point);
				antBitmap = new Bitmap(antBitmapData);
				addChild(antBitmap);			
				antBitmap.x = -15;
				antBitmap.y = -15;
			}
		}
		
		private function changeState(e:TimerEvent):void
		{
			if (state == 0) {
				state = 1;
			}
			else if (state == 1) {
				state = 0;
			}
			update();
		}
		
		public function pickedUp():void
		{
			removeChild(antBitmap);
			stateTimer.stop();
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
	}
	
}