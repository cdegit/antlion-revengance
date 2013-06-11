package 
{
	import flash.display.DisplayObject;
	import flash.display.BitmapData;
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
		// Game States
		public static const STATE_INIT:int = 10;
		public static const STATE_TITLESCREEN:int = 15;
		public static const STATE_STARTGAME:int = 20;
		public static const STATE_PLAY:int = 25;
		public static const STATE_GAMEOVER:int = 35;
		
		public var gamestate:int = STATE_INIT;
		
		private var ant:Ant;
		private var antLion:AntLion;
		private var baby:Baby;
		
		private var tileSheetData:BitmapData;
		
		private var timer:Timer;
		
		private var exitIndex:int;
		
		private var splashScreen:SplashScreen;
		private var splashScreenVisible:Boolean = false;
		
		private var lvlArray:Array =   [9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9,
										8, 8, 8, 5, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8,
										0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
										1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
										0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 2, 2,
										0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2,
										0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 1, 0,
										0, 0, 0, 0, 0, 0, 2, 2, 1, 1, 1, 1, 1, 1, 1, 0,
										1, 1, 1, 1, 1, 1, 2, 2, 0, 0, 1, 0, 0, 0, 1, 1,
										1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1,
										1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1,
										2, 2, 0, 1, 1, 1, 0, 0, 2, 2, 1, 0, 0, 0, 0, 1,
										2, 2, 0, 0, 0, 1, 1, 1, 2, 2, 0, 0, 0, 0, 0, 1,
										1, 1, 1, 0, 0, 1, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1,
										0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1,
										0, 0, 1, 0, 0, 1, 2, 2, 0, 0, 0, 0, 0, 0, 0, 1,
										0, 0, 1, 1, 1, 1, 2, 2, 1, 1, 1, 1, 0, 0, 0, 1,
										0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1,
										0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 1, 1, 0, 1, 1, 1,
										0, 0, 1, 0, 0, 1, 0, 0, 2, 2, 0, 1, 0, 1, 0, 0,
										0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0,
										0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 1, 1,
										1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 1, 0, 1, 1, 1,
										1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1];
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
			
			timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, gameLoop);
			timer.start();
			
			gamestate = STATE_TITLESCREEN;
		}
		
		private function startScreen():void
		{
			// draw start screen. Based on user interaction:
			
			if(!splashScreenVisible) {
				splashScreen = new SplashScreen(SplashScreen.TITLE_SCREEN);
				stage.addChild(splashScreen);
				splashScreenVisible = true;
			}
			
			if (splashScreen != null && splashScreen.finished) {
				splashScreen.dispose();
				stage.removeChild(splashScreen);
				splashScreen = null;
				gamestate = STATE_STARTGAME;
			}
			
		}
		
		private function startGame():void
		{	
			// Add global tilesheet bitmap data object
			var tilesheetpng:DisplayObject = new BitmapAssets.Tilesheet();
			tileSheetData = new BitmapData(tilesheetpng.width, tilesheetpng.height, true, 0);
			tileSheetData.draw(tilesheetpng);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			
			buildLevel();
			ant = new Ant(blockModel, tileSheetData);
			addChild(ant);
			
			antLion = new AntLion(blockModel, tileSheetData);
			addChild(antLion);
			
			baby = new Baby(tileSheetData);
			addChild(baby);
			
			gamestate = STATE_PLAY;
		}
		
		private function buildLevel():void
		{	
			for (var i:int = 0; i < lvlArray.length; i++) {
				var x:int = 0;
				var y:int = 0;
				x = 32 * (i % 16);
				y = 32 * Math.floor(i/16);
				var temp:Block = new Block(lvlArray[i], x, y, tileSheetData); 
				blockModel.push(temp);
				addChild(temp);
			
				temp.render(lvlArray, i);
				// If block is EXIT, save its index for convenience
				if (temp.type == Block.TILE_EXIT) {
					exitIndex = i;
				}
			}
		}
		
		private function gameLoop(event:TimerEvent):void
		{
			switch(gamestate) {					// gameState is a global variable which holds the current game mode
				case STATE_INIT :
					//initGame();					// Start a new game
					break;
				case STATE_TITLESCREEN:
					//showScore(SplashScreen.TITLE_SCREEN);			// Create a title screen
					startScreen();
					break;		
				case STATE_STARTGAME:
					startGame();
					break;
				case STATE_PLAY:
					stage.focus = this;
					play();
					break;
			}
		}
		
		private function play():void
		{
			moveAntLion();
			// After Ant Lion moves, check if it has hit the Ant
			if ( antLion.hitTestObject(ant) ) {
				trace("Game over!");
				loseGame();
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
			
			if ( ant.getIndex() == baby.getIndex() ) {
				baby.pickedUp();
				ant.gotBaby();
			}
			
			// After Ant moves, check if it has reached exit
			var exit:Block = blockModel[exitIndex];
			if ( ant.hitTestObject(exit) ) {
				//trace("You win!");
				winGame();
			} else if (ant.dead) {
				//trace("you lose!");
				loseGame();
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
		
		private function loseGame():void
		{
			gameEnd();
			splashScreen = new SplashScreen(SplashScreen.GAME_OVER_LOSE);
			stage.addChild(splashScreen);
			splashScreenVisible = true;
		}
		
		private function winGame():void 
		{
			var savedBaby:Boolean = ant.getHasBaby();
			gameEnd();
			
			if (savedBaby == true) {
				splashScreen = new SplashScreen(SplashScreen.GAME_OVER_WIN_WITH_BABY);
				stage.addChild(splashScreen);
				splashScreenVisible = true;
			}
			else if (savedBaby == false) {
				splashScreen = new SplashScreen(SplashScreen.GAME_OVER_WIN_NO_BABY);
				stage.addChild(splashScreen);
				splashScreenVisible = true;
			}
		}
	}
}