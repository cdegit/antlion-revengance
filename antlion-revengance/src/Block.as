package  
{
	import flash.display.Sprite;
	
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
		
		public var type:int;
		private var tileNumber:int;
		private var fillColor:uint = 0x000000;
		
		public function Block(type:int, x:int, y:int) 
		{
			super();
			this.type = type;
			this.x = x;
			this.y = y;
			
			switch(type)
			{
				case TILE_ROCK:
					fillColor = 0x333333;
					break;
				case TILE_DIRT:
					fillColor = 0xdddddd;
					break;
				case TILE_MUD:
					fillColor = 0x33ee88;
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
			
			render();
		}
		
		public function render():void
		{
			this.graphics.beginFill(fillColor);
			this.graphics.drawRect(0,0,TILE_HEIGHT,TILE_WIDTH);
			this.graphics.endFill();
		}
		
	}

}