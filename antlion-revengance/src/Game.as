package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * Ant Lion 2.0 - The Revengance
	 * @author Cassandra de Git and Jason Ngan
	 */
	public class Game extends Sprite 
	{
		
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