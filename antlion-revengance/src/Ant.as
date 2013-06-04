package  
{
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	
	/**
	 * ...
	 * @author Cassandra de Git and Charlie Chao
	 */
	public class Ant extends Sprite 
	{
		
		public static const SPEED:int = 32;
		public var blockModel:Array = [];
		
		public function Ant(blockModel:Array) 
		{
			super();
			this.blockModel = blockModel;
			render();
		}
		
		public function render():void
		{
			this.graphics.beginFill(0xff0000);
			this.graphics.drawCircle(16, 16, 10);
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
				if (temp != -1) {
					tileType = temp;
					break;
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
	}

}