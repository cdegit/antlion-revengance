package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * Ant Lion 2.0 - The Revengance
	 * @author Green Mesa
	 */
	public class Game extends Sprite 
	{
	
		// Level Creation Constants - Tile Types
		public static const TILE_ROCK:int = 0;
		public static const TILE_DIRT:int = 1;
		public static const TILE_MUD:int = 2;
		public static const TILE_RUBBLE:int = 3;
		public static const TILE_TWIG:int = 4;
		
		private var lvlArray:Array =   [0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0];
		
		public function Game():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
		}
		
	}
	
}