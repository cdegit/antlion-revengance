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
		
		private var timer:Timer;
		
		private var exitIndex:int;
		
		private var lvlArray:Array =   [1, 1, 1, 1, 1, 2, 3, 1, 1, 1, 1, 5, 0, 0, 0, 0,
										0, 3, 4, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0,
										0, 0, 0, 0, 1, 2, 3, 1, 0, 1, 1, 0, 0, 0, 0, 0,
										0, 0, 0, 0, 1, 2, 3, 1, 0, 0, 1, 0, 0, 0, 0, 0,
										0, 0, 0, 0, 1, 2, 3, 1, 0, 0, 1, 0, 0, 0, 0, 0,
										0, 0, 0, 0, 1, 2, 3, 1, 0, 0, 1, 0, 0, 0, 0, 0,
										0, 0, 0, 0, 1, 2, 3, 1, 0, 0, 1, 0, 0, 0, 0, 0,
										0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 1, 0, 0, 0, 0,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 1, 0, 0, 0, 0,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 1, 0, 0, 0, 0,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 1, 1, 0, 0, 0, 0,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 1, 0, 0, 0, 0, 0,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 1, 0, 0, 0, 0, 0,
										0, 0, 0, 0, 1, 2, 3, 1, 1, 1, 1, 0, 0, 0, 0, 0,
										0, 0, 0, 0, 1, 2, 3, 1, 0, 0, 0, 0, 0, 0, 0, 0,
										0, 0, 0, 0, 1, 2, 3, 1, 0, 0, 0, 0, 0, 0, 0, 0,
										0, 0, 0, 0, 1, 2, 3, 1, 1, 1, 1, 0, 0, 0, 0, 0,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 1, 0, 0, 0, 0, 0,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 1, 0, 0, 0, 0, 0,
										0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 1, 0, 0, 0, 0, 0,
										0, 0, 0, 0, 1, 2, 3, 4, 1, 1, 1, 0, 0, 0, 0, 0,
										0, 0, 0, 0, 1, 2, 3, 4, 1, 0, 0, 0, 0, 0, 0, 0,
										0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0];
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
			
			startScreen();
		}
		
		private function startScreen():void
		{
			// draw start screen. Based on user interaction:
			startGame();
		}
		
		private function startGame():void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			
			timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, gameLoop);
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
				
				// If block is EXIT, save its index for convenience
				if (temp.type == Block.TILE_EXIT) {
					exitIndex = i;
				}
			}
		}
		
		private function gameLoop(event:TimerEvent):void
		{
			moveAntLion();
			
			// Check Lose Conditions
			
			// After Ant Lion moves, check if it has hit the Ant
			if ( antLion.hitTestObject(ant) ) {
				trace("Game over!");
				gameOver();
			}
		}
		
		private function keyDownHandler(event:KeyboardEvent):void
		{
			if (ant.inMud) {
				return;
			}
			
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
			
			// After Ant moves, check if it has reached exit
			var exit:Block = blockModel[exitIndex];
			if ( ant.hitTestObject(exit) ) {
				trace("You win!");
				winGame();
			}
			
			if (ant.dead) {
				trace("you lose!");
				gameOver();
			}
		}
		
		private function moveAntLion():void 
		{
			var antx:int = ant.getX();
			var anty:int = ant.getY();
			antLion.chase(antx, anty);
		}
		
		// clean up game assets
		private function gameEnd():void 
		{
			timer.removeEventListener(TimerEvent.TIMER, gameLoop);	// stop game loop
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);	// stop listening for keyboard events
			removeChild(ant);
			ant = null;	// delete ant
			removeChild(antLion);
			antLion = null;
			
			for each(var block:Block in blockModel) {
				removeChild(block);
				block = null;
			}
			
			blockModel = null;
		}
		
		private function gameOver():void
		{
			gameEnd();
			// display end game screen
		}
		
		private function winGame():void 
		{
			gameEnd();
			// display end game screen
		}
	}
}