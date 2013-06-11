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
		public static const GAME_OVER_WIN:int = 3;
		public static const GAME_OVER_LOSE:int = 4;
		
		private var button:Button;
		
		[Embed(source = '../assets/startscreen.jpg')] // embed the image file
		private static const StartScreen:Class;	
		private var startScreen:Bitmap = new StartScreen();
		
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
					
				case GAME_OVER_WIN:
					break;
					
				case GAME_OVER_LOSE:
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