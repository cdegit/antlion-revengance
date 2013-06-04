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
		
		public function Ant() 
		{
			super();
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
			if ( this.x + x > 512 - 32 || this.x + x < 0) {
				return;
			} else if ( this.y + y > 768 - 32 || this.y + y < 0 ) {
				return;
			}
			this.x += x;
			this.y += y;				
		}
		
		public function update():void
		{
			
		}
	}

}