package  
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	import flash.display.Bitmap;
	import mx.resources.LocaleSorter;
	
	/**
	 * ...
	 * @author Green Mesa
	 */
	public class SplashScreen extends Sprite 
	{
		private var title:String = "";
		private var msg:String = "";
		private var buttonText:String = "";
		private var type:int;	
		
		public var addedToStage:Boolean = false;
		
		public static const TITLE_SCREEN:int = 1;
		public static const GAME_OVER_WIN_WITH_BABY:int = 3;
		public static const GAME_OVER_WIN_NO_BABY:int = 4;
		public static const GAME_OVER_LOSE:int = 5;
		
		private var button:Button;
		
		[Embed(source = '../assets/startscreen.jpg')] // embed the image file
		private static const StartScreen:Class;	
		private var startScreen:Bitmap = new StartScreen();
		
		[Embed(source = '../assets/winWithBaby.jpg')]
		private static const WinWithBaby:Class;
		private var winWithBabyScreen:Bitmap = new WinWithBaby();
		
		[Embed(source = '../assets/winNoBaby.jpg')]
		private static const WinNoBaby:Class;
		private var winNoBabyScreen:Bitmap = new WinNoBaby();
		
		[Embed(source = '../assets/lose.jpg')]
		private static const Lose:Class;
		private var loseScreen:Bitmap = new Lose();
		
		public function SplashScreen(type:int) 
		{
			super();
			this.type = type;
			switch(type)										// Set up text for each splashScreen based on their type
			{
				case TITLE_SCREEN:
					addChild(startScreen);
					button = new Button();
					addChild(button);
					addedToStage = true;
					break;
					
				case GAME_OVER_WIN_WITH_BABY:
					addChild(winWithBabyScreen);
					addedToStage = true;
					break;
				
				case GAME_OVER_WIN_NO_BABY:
					addChild(winNoBabyScreen);
					addedToStage = true;
					break;
					
				case GAME_OVER_LOSE:
					addChild(loseScreen);
					addedToStage = true;
					break;
			}
			
		}
		
		public function get finished():Boolean {
			return button.finished;
		}
		
		public function dispose():void
		{
			button.dispose();									// Remove event listeners from button just to make sure everything is cleaned up 
		}
		
	}

}