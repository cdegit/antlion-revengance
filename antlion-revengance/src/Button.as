package  
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
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
	public class Button extends Sprite 
	{	
		private var clicked:Boolean = false;
		
		[Embed(source = '../assets/start_btn.jpg')] // embed the image file
		private static const StartButton:Class;	
		private var startButton:Bitmap = new StartButton();
		
		public function Button() 
		{
			this.buttonMode = true;
			this.mouseChildren = false;
			super();
			this.x = 512 / 4;
			this.y = 768 / 2;
			addChild(startButton);
			
			addEventListener(MouseEvent.CLICK, buttonClicked);
		}
		
		private function buttonClicked(event:Event):void {
			//trace(clicked);
			clicked = true;	
		}
		
		public function get finished():Boolean {
			return clicked;
		}
		
		public function dispose():void
		{
			removeEventListener(MouseEvent.CLICK, buttonClicked);
		}
				
	}

}