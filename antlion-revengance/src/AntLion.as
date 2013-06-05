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
		
		// Using A* pathfinding instead
		private var chokepoints:Array = [];
		private var walkablePoints:Array = [];
		
		public function AntLion(blockModel:Array) 
		{
			super();
			this.blockModel = blockModel;
			this.x = 16;
			this.y = 16;
			render();
			
			analyzeMaze();
		}
		
		public function render():void
		{
			this.graphics.beginFill(0x000000);
			this.graphics.drawCircle(0, 0, 15);
			this.graphics.endFill();
		}
		
		private function resetWalkablePoints():void 
		{
			for (var i:int = 0; i < walkablePoints.length; i++) {
				if (walkablePoints[i] > -1) {
					walkablePoints[i] = 0;
				}
			}
		}
		
		private function printWalkablePoints():void
		{
			for (var i:int = 0; i < walkablePoints.length; i++) {
				trace("wp: " + walkablePoints[i]);
			}
		}
		
		private function aStarPathfinding(antx:int, anty:int):int {			
			// Need to get these dynamically, for now they are constants
			var mazeWidth:int = 16;
			var mazeHeight:int = 24;
			
			var antIndex:int = coordToGrid(antx, anty);
			var antLionIndex:int = coordToGrid(this.x, this.y);
			
			// A* pathfinding
			var queue:Array = [antIndex];
			walkablePoints[antIndex] = 1;
			var counter:int = 2;
			var indexInQueue:int = 0;
			
			var curIndex:int = -1;
			// In case the loop takes too long, end it after a certain amount of tries
			while ( (curIndex != antLionIndex ) && ( counter < 15 ) ) {
				var curQueueLength:int = queue.length;
				for (var i:int = 0; i < curQueueLength; i++) {
					curIndex = queue[indexInQueue];
					
					var topIndex:int = curIndex - mazeWidth;
					var bottomIndex:int = curIndex + mazeWidth;
					var leftIndex:int = curIndex - 1;
					var rightIndex:int = curIndex + 1;
					
					if ( canMoveHere( curIndex, topIndex ) ) {
						queue.push(topIndex);
						if ( walkablePoints[topIndex] == 0 ) {
							walkablePoints[topIndex] = counter;
						}
					}
					
					if ( canMoveHere( curIndex, bottomIndex ) ) {
						queue.push(bottomIndex);
						if ( walkablePoints[bottomIndex] == 0 ) {
							walkablePoints[bottomIndex] = counter;
						}
					}
					
					if ( canMoveHere( curIndex, leftIndex ) ) {
						queue.push(leftIndex);
						if ( walkablePoints[leftIndex] == 0 ) {
							walkablePoints[leftIndex] = counter;
						}
					}
					
					if ( canMoveHere( curIndex, rightIndex ) ) {
						queue.push(rightIndex);
						if ( walkablePoints[rightIndex] == 0 ) {
							walkablePoints[rightIndex] = counter;
						}
					}
					
					if (curIndex == antLionIndex) {
						//trace("solved");
						break;
					}
					
					indexInQueue++;
				}
				
				counter++;
			}
			
			// Return the move that leads to the Ant
			var antLionTopIndex:int = antLionIndex - mazeWidth;
			var antLionBottomIndex:int = antLionIndex + mazeWidth;
			var antLionLeftIndex:int = antLionIndex - 1;
			var antLionRightIndex:int = antLionIndex + 1;
			
			var lowestVal:int = walkablePoints[antLionIndex];
			var nextStep:int = antLionIndex;
			
			if ( canMoveHere( antLionIndex, antLionTopIndex ) && ( walkablePoints[antLionTopIndex] <= lowestVal ) ) {
				lowestVal = walkablePoints[antLionTopIndex];
				nextStep = antLionTopIndex;
			}
			
			if ( canMoveHere( antLionIndex, antLionBottomIndex ) && ( walkablePoints[antLionBottomIndex] <= lowestVal ) ) {
				lowestVal = walkablePoints[antLionBottomIndex];
				nextStep = antLionBottomIndex;
			}
			
			if ( canMoveHere( antLionIndex, antLionLeftIndex ) && ( walkablePoints[antLionLeftIndex] <= lowestVal ) ) {
				lowestVal = walkablePoints[antLionLeftIndex];
				nextStep = antLionLeftIndex;
			}
			
			if ( canMoveHere( antLionIndex, antLionRightIndex ) && ( walkablePoints[antLionRightIndex] <= lowestVal ) ) {
				lowestVal = walkablePoints[antLionRightIndex];
				nextStep = antLionRightIndex;
			}
			
			return nextStep;
		}
		
		private function coordToGrid(x:int, y:int):int {
			// Currently a constant, but should get it dynamically
			var blockSize:int = 32;
			var mazeWidth:int = 16;
			
			var gridX:int = x / blockSize;
			var gridY:int = y / blockSize;
			
			//trace("gridX: " + gridX);
			//trace("gridY: " + gridY);
			
			var index:int = gridY * mazeWidth + gridX;
			//trace("index: " + index);
			return index;
		}
		
		private function analyzeMaze():void
		{
			for (var i:int = 0; i < blockModel.length; i++) {
				// If the cell is walkable, ie not ROCK or off edge
				if ( !isBlockRock(blockModel[i]) ) {
					// Stores the index as a walkable square,
					// used later to save space when deciding how to get to square
					walkablePoints.push(0);
					
					if ( isChokepoint(i) ) {
						chokepoints.push(i);
					}
				}
				else {
					walkablePoints.push(-1);
				}
			}
			
			// Testing if isChokepoint() works
			for (var j:int = 0; j < chokepoints.length; j++) {
				//trace("ckpt: " + chokepoints[j]);
			}
			
			// Testing if walkablePoints is correct
			for (var k:int = 0; k < walkablePoints.length; k++) {
				//trace("walk: " + walkablePoints[k]);
			}
		}
		
		private function findNearestChokepoint(walkableIndex:int):int {
			return -1;
		}
		
		// Later, may need to check if 3 or 4 ways are blocked, those are useless chokepoints
		private function isChokepoint(curIndex:int):Boolean {
			// Need to get these dynamically, for now they are constants
			var mazeWidth:int = 16;
			var mazeHeight:int = 24;
			
			var topBlocked:Boolean = false;
			var bottomBlocked:Boolean = false;
			var leftBlocked:Boolean = false;
			var rightBlocked:Boolean = false;
			
			var topIndex:int = curIndex - mazeWidth;
			var bottomIndex:int = curIndex + mazeWidth;
			var leftIndex:int = curIndex - 1;
			var rightIndex:int = curIndex + 1;
			
			var result:Boolean = false;
			
			// Check if top and bottom are blocked
			if ( !canMoveHere( curIndex, topIndex ) ) {
				topBlocked = true;
			}
			if ( !canMoveHere( curIndex, bottomIndex ) ) {
				bottomBlocked = true;
			}
			// If they are, it is a chokepoint
			if ( topBlocked && bottomBlocked ) {
				result = true;
			}
			
			// Check if left and right are blocked
			if ( !canMoveHere( curIndex, leftIndex ) ) {
				leftBlocked = true;
			}
			if ( !canMoveHere( curIndex, rightIndex ) ) {
				rightBlocked = true;
			}
			// If they are, it is a chokepoint
			if ( leftBlocked && rightBlocked ) {
				result = true;
			}
			
			return result;
		}
		
		// Need currentIndex so that we can test if we are currently at the edge
		// and so cannot move if we are past the edge
		private function canMoveHere(curIndex:int, nextIndex:int):Boolean {
			// Need to get these dynamically, for now they are constants
			var mazeWidth:int = 16;
			var mazeHeight:int = 24;
			
			var result:Boolean = true;
			
			// Next step goes off the top edge or bottom edge
			if ( ( nextIndex < 0 ) || ( nextIndex > ( mazeWidth * mazeHeight - 1 ) ) ) {
				result = false;
			}
			else {
				// Next step is ROCK
				if ( isBlockRock(blockModel[nextIndex]) ) {
					result = false;
				}
			}
			
			// If current step is on left edge, and next step is past left edge
			if ( ( curIndex % mazeWidth == 0 ) && ( nextIndex == curIndex - 1 ) ) {
				result = false;
			}
			
			// If current step is on right edge, and next step is past right edge
			if ( ( curIndex % mazeWidth == ( mazeWidth - 1 ) ) && ( nextIndex == curIndex + 1 ) ) {
				result = false;
			}
			
			return result;
		}
		
		private function isBlockRock(block:Block):Boolean {
			var result:Boolean = false;
			if (block.type == 0) {
				result = true;
			}
			return result;
		}
		
		public function chase(antx:int, anty:int):void
		{
			resetWalkablePoints();
			var nextStep:int = aStarPathfinding(antx, anty);
			
			// Currently a constant, but should get it dynamically
			var blockSize:int = 32;
			var mazeWidth:int = 16;
			
			this.x = ( nextStep % mazeWidth ) * blockSize + 16;
			this.y = ( Math.floor( nextStep / mazeWidth ) ) * blockSize + 16;
			
			printWalkablePoints();
			
			/*
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
			*/

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