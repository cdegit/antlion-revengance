package  
{
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	
	/**
	 * ...
	 * @author Green Mesa
	 */
	public class Ant extends Sprite 
	{
		
		public static const SPEED:int = 32;
		public var blockModel:Array = [];
		
		public function Ant(blockModel:Array) 
		{
			super();
			this.blockModel = blockModel;
			// Changed to intialize position here because Ant.x & Ant.y
			// are default at (0,0)
			this.x = 80;
			this.y = 16;
			render();
		}
		
		public function render():void
		{
			this.graphics.beginFill(0xff0000);
			this.graphics.drawCircle(0, 0, 10);
			this.graphics.endFill();
		}
		
		public function move(x:int, y:int):void
		{
			var oldx:int = this.x;
			var oldy:int = this.y;
			
			this.x += x;
			this.y += y;	
			
			var tileType:int = -1; 
			for (var i:int = 0; i < blockModel.length; i++) {
				var temp:int = checkBlock(blockModel[i]);
				
				switch(temp)	// handle interactions with different tile types 
				{
					case -1:
						break;
					case Block.TILE_MUD:
						// something here
					case Block.TILE_RUBBLE:
						// something here, ant is able to pick up
					case Block.TILE_TWIG:
						// ant is killed
					default:
						tileType = temp;
				}
			}
			if ( ( this.x > 512 - 32 || this.x < 0) || ( this.y > 768 - 32 || this.y < 0 ) || (tileType == 0) ) {
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
	}

}