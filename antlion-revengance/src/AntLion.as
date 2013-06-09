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
		
		// Using A* pathfinding instead, but has potential for future use
		//private var chokepoints:Array = [];
		private var walkablePoints:Array = [];
		
		public function AntLion(blockModel:Array) 
		{
			super();
			this.blockModel = blockModel;
			this.x = 16;
			this.y = 112;
			render();
			
			// Create a map of which cells are walkable
			analyzeMaze();
		}
		
		public function render():void
		{
			this.graphics.beginFill(0x000000);
			this.graphics.drawCircle(0, 0, 15);
			this.graphics.endFill();
		}
		
		// WalkablePoints[] is used to store a map of the number of steps to reach the Ant in each cell
		// This resets those cell values so that we can recalculate
		private function resetWalkablePoints():void 
		{
			for (var i:int = 0; i < walkablePoints.length; i++) {
				// Only reset cell if it is walkable (unwalkable cells do not change, more efficient this way)
				if (walkablePoints[i] > -1) {
					walkablePoints[i] = 0;
				}
			}
		}
		
		// Simply prints the value of each cell in walkablePoints[], used for testing
		private function printWalkablePoints():void
		{
			for (var i:int = 0; i < walkablePoints.length; i++) {
				trace("wp: " + walkablePoints[i]);
			}
		}
		
		// A*Pathfinding:
		// Starting from Ant location, get each neighbouring cell (up, down, left, right) and mark it as 1 step from Ant
		// Then, for each of those neighbouring cells, add their neighbours and mark as 2 steps from Ant.
		// Continue until we reach the Ant Lion
		// Ant Lion will look at its neighbouring cells and move to the cell with the lowest number of steps from Ant
		private function aStarPathfinding(antx:int, anty:int):int {			
			// Need to get these dynamically, for now they are constants
			var mazeWidth:int = 16;
			var mazeHeight:int = 24;
			
			// Convert Ant location and Ant Lion location to indices
			var antIndex:int = coordToGrid(antx, anty);
			var antLionIndex:int = coordToGrid(this.x, this.y);
			
			// A* pathfinding:
			
			// Initialize the queue, which stores the cell index of all cells checked 
			// (ie, initial index, its neighbours, its' neighbours... etc)
			var queue:Array = [antIndex];
			// Acts as the head of the queue, a workaround since we cannot pop the first element
			var indexInQueue:int = 0;
			
			// Place initial value in the map
			walkablePoints[antIndex] = 1;
			// Its neighbouring cells are 1 step away, incremented every ring of neighbours we check
			var counter:int = 2;
			
			var curIndex:int = -1;
			// In case the loop takes too long, end it after a certain amount of tries
			while ( (curIndex != antLionIndex ) && ( counter < 15 ) ) {
				// Store the current length of queue as a constant, as we will be continually adding to it
				// This allows the function to go through one ring of neighbours at a time
				var curQueueLength:int = queue.length;
				for (var i:int = 0; i < curQueueLength; i++) {
					curIndex = queue[indexInQueue];
					
					// Convenience variables that hold the indices of the cell above, below, left, and right
					var topIndex:int = curIndex - mazeWidth;
					var bottomIndex:int = curIndex + mazeWidth;
					var leftIndex:int = curIndex - 1;
					var rightIndex:int = curIndex + 1;
					
					// Check if cell above is walkable, if it is, mark its distance from Ant
					if ( canMoveHere( curIndex, topIndex ) ) {
						queue.push(topIndex);
						if ( walkablePoints[topIndex] == 0 ) {
							walkablePoints[topIndex] = counter;
						}
					}
					// Check if cell below is walkable, if it is, mark its distance from Ant
					if ( canMoveHere( curIndex, bottomIndex ) ) {
						queue.push(bottomIndex);
						if ( walkablePoints[bottomIndex] == 0 ) {
							walkablePoints[bottomIndex] = counter;
						}
					}
					// Check if cell to the left is walkable, if it is, mark its distance from Ant
					if ( canMoveHere( curIndex, leftIndex ) ) {
						queue.push(leftIndex);
						if ( walkablePoints[leftIndex] == 0 ) {
							walkablePoints[leftIndex] = counter;
						}
					}
					// Check if cell to the right is walkable, if it is, mark its distance from Ant
					if ( canMoveHere( curIndex, rightIndex ) ) {
						queue.push(rightIndex);
						if ( walkablePoints[rightIndex] == 0 ) {
							walkablePoints[rightIndex] = counter;
						}
					}
					
					// If we are at the Ant Lion, then we have all the information we need to move towards the Ant
					if (curIndex == antLionIndex) {
						//trace("solved");
						break;
					}
					
					// For each index checked, increment to represent "head" of the queue
					indexInQueue++;
				}
				
				// For each ring of neighbours, increase distance from Ant by 1
				counter++;
			}
			
			// Now we find the neighbouring cell that has the lowest value (lowest value = faster path to Ant)
			
			// Convenience variables to represent indices of cells above, below, left, and right
			var antLionTopIndex:int = antLionIndex - mazeWidth;
			var antLionBottomIndex:int = antLionIndex + mazeWidth;
			var antLionLeftIndex:int = antLionIndex - 1;
			var antLionRightIndex:int = antLionIndex + 1;
			
			// Track the current lowest value (initially at Ant Lion)
			var lowestVal:int = walkablePoints[antLionIndex];
			// And track which cell held that lowest value
			var nextStep:int = antLionIndex;
			
			// Check if cell above has lowest value
			if ( canMoveHere( antLionIndex, antLionTopIndex ) && ( walkablePoints[antLionTopIndex] <= lowestVal ) ) {
				lowestVal = walkablePoints[antLionTopIndex];
				nextStep = antLionTopIndex;
			}
			// Check if cell below has lowest value
			if ( canMoveHere( antLionIndex, antLionBottomIndex ) && ( walkablePoints[antLionBottomIndex] <= lowestVal ) ) {
				lowestVal = walkablePoints[antLionBottomIndex];
				nextStep = antLionBottomIndex;
			}
			// Check if cell to the left has lowest value
			if ( canMoveHere( antLionIndex, antLionLeftIndex ) && ( walkablePoints[antLionLeftIndex] <= lowestVal ) ) {
				lowestVal = walkablePoints[antLionLeftIndex];
				nextStep = antLionLeftIndex;
			}
			// Check if cell to the right has lowest value
			if ( canMoveHere( antLionIndex, antLionRightIndex ) && ( walkablePoints[antLionRightIndex] <= lowestVal ) ) {
				lowestVal = walkablePoints[antLionRightIndex];
				nextStep = antLionRightIndex;
			}
			
			// Return the index of the cell holding the lowest value
			return nextStep;
		}
		
		// Takes an (x,y) coordinate input and returns the index of the cell it is in
		private function coordToGrid(x:int, y:int):int {
			// Currently a constant, but should get it dynamically
			var blockSize:int = 32;
			var mazeWidth:int = 16;
			
			// Converts x & y to the number of cells it spans (ie, 80/blockSize = 80/32 = 2 cells rounded down)
			var gridX:int = x / blockSize;
			var gridY:int = y / blockSize;
			
			// Every increment of y is an entire row (ie, mazeWidth),
			// while 0 <= x < mazeWidth
			var index:int = gridY * mazeWidth + gridX;

			return index;
		}
		
		// Currently used to create a map of which cells are walkable for the Ant Lion
		// A* algorithm will write the distances to the Ant on this map
		private function analyzeMaze():void
		{
			// Marks each cell as walkable or not
			for (var i:int = 0; i < blockModel.length; i++) {
				// If the cell is walkable, ie not ROCK or off edge
				if ( !isBlockRock(blockModel[i]) ) {
					walkablePoints.push(0);
					
					//if ( isChokepoint(i) ) {
					//	chokepoints.push(i);
					//}
				}
				else {
					walkablePoints.push(-1);
				}
			}
		}
		
		// Potential for future use with chokepoint code
		private function findNearestChokepoint(walkableIndex:int):int {
			return -1;
		}
		
		// Currently unused, it was the foundation of the AI update until A* was chosen
		// It returns true if the current index is a tunnel (ie, top & bottom are blocked, or left & right are blocked)
		// Original intention was to use those chokepoints (which we have to go through) to direct the Ant Lion around the maze
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
		
		// This tests if the nextIndex is walkable
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
		
		// Simply tests if the block is of type ROCK
		private function isBlockRock(block:Block):Boolean {
			var result:Boolean = false;
			if (block.type == Block.TILE_ROCK || block.type == Block.TILE_TWIG) {
				result = true;
			}
			return result;
		}
		
		// This function is what is called to move the Ant Lion
		// Current chase method: A* algorithm
		// A* creates a map, cell by cell, of the number of steps needed to get to the Ant from where Ant Lion is
		// The Ant Lion finds the lowest value (lowest number of steps to Ant) in the 4 squares around it and moves there
		// The map is cleared and recalculated every move
		public function chase(antx:int, anty:int):void
		{
			// Clear the map (only resets the walkable cells, unwalkable steps are untouched for efficiency)
			resetWalkablePoints();
			
			var distance:Number = Math.sqrt(Math.pow(antx - this.x, 2) + Math.pow(anty - this.y, 2));
			trace("ant x:");
			trace(antx);
			
			trace("ant y:");
			trace(anty);
			
			trace("this x:");
			trace(this.x);
			
			trace("this y:");
			trace(this.y);		
			
			trace(Math.pow(144 - 144, 2));
			
			trace(distance);
			if (distance <= 300) {
				// Uses A* algorithm to get the index that it should move next
				var nextStep:int = aStarPathfinding(antx, anty);
				
				// Currently a constant, but should get it dynamically
				var blockSize:int = 32;
				var mazeWidth:int = 16;
				
				// Move the Ant Lion there
				this.x = ( nextStep % mazeWidth ) * blockSize + 16;
				this.y = ( Math.floor( nextStep / mazeWidth ) ) * blockSize + 16;
			} else {
				trace("ant is out of ant lion's range!");
			}
		}
		
		public function update():void
		{
			
		}
	}

}