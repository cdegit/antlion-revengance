package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	/**
	 * Ant Lion 2.0 - The Revengance
	 * @author Green Mesa
	 */
	public class Game extends Sprite 
	{
		private var ant:Ant;
		
		private var lvlArray:Array =   [1, 1, 1, 1, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 1,
										2, 3, 4, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 1,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 1,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 1,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 1,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 1,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 1,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 1,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 1,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 1,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 1,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 1,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 1,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 1,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 1,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 1,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 1,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 1,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 1,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 1,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 1,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 1,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 1];
		private var blockModel:Array = [];
		
		public function Game():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			
			buildLevel();
			ant = new Ant(blockModel);
			addChild(ant);
		}
		
		private function buildLevel():void
		{
			for (var i:int = 0; i < lvlArray.length; i++) {
				var x:int = 0;
				var y:int = 0;
				x = 32 * (i % 16);
				y = 32 * Math.floor(i/16);
				var temp:Block = new Block(lvlArray[i], x, y); 
				blockModel.push(temp);
				addChild(temp);
			}
		}
		
		private function keyDownHandler(event:KeyboardEvent):void
		{
			switch(event.keyCode) 
			{
				case Keyboard.UP:
					ant.move(0, -Ant.SPEED);
					break;
				case Keyboard.DOWN:
					ant.move(0, Ant.SPEED);
					break;
				case Keyboard.LEFT:
					ant.move(-Ant.SPEED, 0);
					break;
				case Keyboard.RIGHT:
					ant.move(Ant.SPEED, 0);
					break;	
			}
			
		}
	}
	
}