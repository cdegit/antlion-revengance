package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	/**
	 * Ant Lion 2.0 - The Revengance
	 * @author Green Mesa
	 */
	public class Game extends Sprite 
	{
		private var ant:Ant;
		private var antLion:AntLion;
		
		private var lvlArray:Array =   [1, 1, 1, 1, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 0,
										0, 3, 4, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 0,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 0,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 0,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 0,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 0,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 0,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 0,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 0,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 0,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 0,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 0,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 0,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 0,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 0,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 0,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 0,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 0,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 0,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 0,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 0,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 0,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 0];
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
			
			var timer:Timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, moveAntLion);
			timer.start();
			
			buildLevel();
			ant = new Ant(blockModel);
			addChild(ant);
			
			antLion = new AntLion(blockModel);
			addChild(antLion);
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
		
		private function moveAntLion(event:TimerEvent):void 
		{
			var antx:int = ant.getX();
			var anty:int = ant.getY();
			antLion.chase(antx, anty);
		}
	}
}