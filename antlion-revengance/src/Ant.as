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
		
		public function Ant(blockModel:Array, tilesheet:BitmapData) 
		{
			super();
			this.blockModel = blockModel;
			// Changed to intialize position here because Ant.x & Ant.y
			// are default at (0,0)
			this.x = 80;
			this.y = 112;
			this.tilesheet = tilesheet;
			render();
		}
		
		public function render():void
		{
			
			this.graphics.beginFill(0xff0000);
			this.graphics.drawCircle(0, 0, 10);
			this.graphics.endFill();
			
			/*
			var sourceRect:Rectangle = new Rectangle(0, 32, BitmapAssets.TILE_WIDTH, BitmapAssets.TILE_WIDTH);
			var point:Point = new Point(0, 0);
			var antBitmapData:BitmapData = new BitmapData(BitmapAssets.TILE_WIDTH, BitmapAssets.TILE_WIDTH, true, 0);
			antBitmapData.copyPixels(tilesheet, sourceRect, point);
			var antBitmap:Bitmap = new Bitmap(antBitmapData);
			addChild(antBitmap);			
			antBitmap.x = -16;
			antBitmap.y = -16;
			*/
			
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
			if ( ( this.x > 512 - 32 || this.x < 0) || ( this.y > 768 || this.y < 0 ) || (tileType == 0) ) {
				this.x = oldx;
				this.y = oldy;
			}			
		}
		
		public function checkBlock(block:Block):int
		{
			var result:int = -1;
			if (block.hitTestObject(this)) {
				trace(block.type);
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
	}

}