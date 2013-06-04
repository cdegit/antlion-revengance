package 
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Green Mesa
	 */
	
	public class AntLion extends Sprite
	{
		private static const SPEED:int = 32;
		private var blockModel:Array = [];
		
		public function AntLion(blockModel:Array) 
		{
			super();
			this.blockModel = blockModel;
			this.x = 16;
			this.y = 16;
			render();
		}
		
		public function render():void
		{
			this.graphics.beginFill(0x000000);
			this.graphics.drawCircle(0, 0, 15);
			this.graphics.endFill();
		}
		
		public function chase(antx:int, anty:int):void
		{
			var oldx:int = this.x;
			var oldy:int = this.y;
			
			var antDir:int = -1; // where Ant is relative to AntLion
			antDir = getAntDirection(antx, anty);
			
			// Assumes that there are 2 directions to reach Ant (ie, can go left or up 
			// if Ant is top left relative to Ant Lion).  If neither path works, does nothing
			// I hope to improve this AI, as this is very basic
			switch (antDir) {
				case 0:
					chaseUp();
					if (!canMoveThere()) {
						resetPos(oldx, oldy);
						chaseLeft();
					}
					break;
				case 1:
					chaseUp();
					break;
				case 2:
					chaseUp();
					if (!canMoveThere()) {
						resetPos(oldx, oldy);
						chaseRight();
					}
					break;
				case 3:
					chaseLeft();
					break;
				case 4:
					chaseRight();
					break;
				case 5:
					chaseDown();
					if (!canMoveThere()) {
						resetPos(oldx, oldy);
						chaseLeft();
					}
					break;
				case 6:
					chaseDown();
					break;
				case 7:
					chaseDown();
					if (!canMoveThere()) {
						resetPos(oldx, oldy);
						chaseRight();
					}
					break;
				default:
					// Do nothing
			}
			
			if (!canMoveThere()) {
				resetPos(oldx, oldy);
			}
			

		}
		
		private function resetPos(oldx:int, oldy:int):void
		{
			this.x = oldx;
			this.y = oldy;
		}
		
		private function canMoveThere():Boolean
		{
			// Set to false so that false positives may be avoided
			var result:Boolean = false;
			
			var tileType:int = -1; 
			for (var i:int = 0; i < blockModel.length; i++) {
				var temp:int = checkBlock(blockModel[i]);
				if (temp != -1) {
					tileType = temp;
					break;
				}
			}
			
			if ( ( this.x > 512 - 32 || this.x < 0) || ( this.y > 768 - 32 || this.y < 0 ) || (tileType == 0) ) {
				result = false;
			}
			else { // Need code to check if move is valid, but this will do for now
				result = true;
			}
			
			return result;
		}
		
		private function chaseRight():void 
		{
			this.x += SPEED;
		}
		
		private function chaseLeft():void 
		{
			this.x -= SPEED;
		}
		
		private function chaseDown():void
		{
			this.y += SPEED;
		}
		
		private function chaseUp():void 
		{
			this.y -= SPEED;
		}
		
		private function getAntDirection(antx:int, anty:int):int 
		{
			var result:int = -1;
			if ( ( antx < this.x ) && ( anty < this.y ) ) {
				result = 0; // Ant is up & left from Ant Lion
			}
			else if ( ( antx == this.x ) && ( anty < this.y ) ) {
				result = 1; // Ant is directly up
			}
			else if ( ( antx > this.x ) && ( anty < this.y ) ) {
				result = 2; // Ant is up & right
			}
			else if ( ( antx < this.x ) && ( anty == this.y ) ) {
				result = 3; // Ant is directly left
			}
			else if ( ( antx > this.x ) && ( anty == this.y ) ) {
				result = 4; // Ant is directly right
			}
			else if ( ( antx < this.x ) && ( anty > this.y ) ) {
				result = 5; // Ant is down & left
			}
			else if ( ( antx == this.x ) && ( anty > this.y ) ) {
				result = 6; // Ant is directly down
			}
			else if ( ( antx > this.x ) && ( anty > this.y ) ) {
				result = 7; // Ant is down & right
			}

			return result;
		}
		
		private function checkBlock(block:Block):int
		{
			var result:int = -1;
			if (block.hitTestObject(this)) {
				trace(block.type);
				result = block.type;
			}
			return result;
		}
		
		public function update():void
		{
			
		}
	}

}