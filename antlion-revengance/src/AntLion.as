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
			var antlionx:int = indexToCoordX(antLionIndex);
			var antliony:int = indexToCoordY(antLionIndex);
			
			// A* pathfinding:
			
			var havePath:Boolean = false;
			// Switched to 11 because it starts to lag if set to 12
			var counterLimit:int = 110;
			// Initialize the queue, which stores the cell index of all cells checked 
			// (ie, initial index, its neighbours, its' neighbours... etc)
			var antNode:Node = new Node(null, 0, antIndex);
			var queue:Array = [antNode];
			// Acts as the head of the queue, a workaround since we cannot pop the first element
			//var indexInQueue:int = 0;
			var checked:Array = [];
			
			// Place initial value in the map
			walkablePoints[antIndex] = 1;
			// Its neighbouring cells are 1 step away, incremented every ring of neighbours we check
			var counter:int = 2;
			
			var curIndex:int = -1;
			// In case the loop takes too long, end it after a certain amount of tries
			while ( (curIndex != antLionIndex ) && ( counter < counterLimit ) ) {
				// Store the current length of queue as a constant, as we will be continually adding to it
				// This allows the function to go through one ring of neighbours at a time
				var curQueueLength:int = queue.length;
				for (var i:int = 0; i < curQueueLength; i++) {
					curIndex = queue.shift().getIndex();
					checked.push(curIndex);
					
					// Convenience variables that hold the indices of the cell above, below, left, and right
					var topIndex:int = curIndex - mazeWidth;
					var bottomIndex:int = curIndex + mazeWidth;
					var leftIndex:int = curIndex - 1;
					var rightIndex:int = curIndex + 1;
					
					// Check if cell above is walkable, if it is, mark its distance from Ant
					if ( canMoveHere( curIndex, topIndex ) && ( checked.indexOf( topIndex ) == -1 ) ) {
						var curx:int = indexToCoordX(topIndex);
						var cury:int = indexToCoordY(topIndex);
						var dist:Number = Math.sqrt( Math.pow( antlionx - curx, 2 ) + Math.pow( antliony - cury, 2 ) );
						var topNode:Node = new Node(null, dist, topIndex);
						queue = insertIntoArray(topNode, queue);
						
						if ( walkablePoints[topIndex] == 0 ) {
							walkablePoints[topIndex] = counter;
						}
					}
					// Check if cell below is walkable, if it is, mark its distance from Ant
					if ( canMoveHere( curIndex, bottomIndex ) && ( checked.indexOf( bottomIndex ) == -1 ) ) {
						var curx2:int = indexToCoordX(bottomIndex);
						var cury2:int = indexToCoordY(bottomIndex);
						var dist2:Number = Math.sqrt( Math.pow( antlionx - curx2, 2 ) + Math.pow( antliony - cury2, 2 ) );
						var bottomNode:Node = new Node(null, dist2, bottomIndex);
						queue = insertIntoArray(bottomNode, queue);
						
						if ( walkablePoints[bottomIndex] == 0 ) {
							walkablePoints[bottomIndex] = counter;
						}
					}
					// Check if cell to the left is walkable, if it is, mark its distance from Ant
					if ( canMoveHere( curIndex, leftIndex )&& ( checked.indexOf( leftIndex ) == -1 ) ) {
						var curx3:int = indexToCoordX(leftIndex);
						var cury3:int = indexToCoordY(leftIndex);
						var dist3:Number = Math.sqrt( Math.pow( antlionx - curx3, 2 ) + Math.pow( antliony - cury3, 2 ) );
						var leftNode:Node = new Node(null, dist3, leftIndex);
						queue = insertIntoArray(leftNode, queue);
						
						if ( walkablePoints[leftIndex] == 0 ) {
							walkablePoints[leftIndex] = counter;
						}
					}
					// Check if cell to the right is walkable, if it is, mark its distance from Ant
					if ( canMoveHere( curIndex, rightIndex ) && ( checked.indexOf( rightIndex ) == -1 ) ) {
						var curx4:int = indexToCoordX(rightIndex);
						var cury4:int = indexToCoordY(rightIndex);
						var dist4:Number = Math.sqrt( Math.pow( antlionx - curx4, 2 ) + Math.pow( antliony - cury4, 2 ) );
						var rightNode:Node = new Node(null, dist4, rightIndex);
						queue = insertIntoArray(rightNode, queue);
						
						if ( walkablePoints[rightIndex] == 0 ) {
							walkablePoints[rightIndex] = counter;
						}
					}
					
					// If we are at the Ant Lion, then we have all the information we need to move towards the Ant
					if (curIndex == antLionIndex) {
						havePath = true;
						break;
					}
					
					// For each index checked, increment to represent "head" of the queue
					//indexInQueue++;
				}
				
				// For each ring of neighbours, increase distance from Ant by 1
				counter++;
			}
			
			// If we could not find a path, return failed
			if (!havePath && counter >= counterLimit) {
				return -1;
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
			
			// Check if left and right are blocked
			if ( !canMoveHere( curIndex, leftIndex ) ) {
				leftBlocked = true;
			}
			if ( !canMoveHere( curIndex, rightIndex ) ) {
				rightBlocked = true;
			}
			
			// If they are, it is a chokepoint
			if ( topBlocked && bottomBlocked && !leftBlocked && !rightBlocked ) {
				result = true;
			}
			
			// If they are, it is a chokepoint
			if ( leftBlocked && rightBlocked && !topBlocked && !bottomBlocked ) {
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
			
			// Uses A* algorithm to get the index that it should move next
			var nextStep:int = aStarPathfinding(antx, anty);
			
			if (nextStep > -1) {
				// Currently a constant, but should get it dynamically
				var blockSize:int = 32;
				var mazeWidth:int = 16;
				
				// Move the Ant Lion there
				this.x = ( nextStep % mazeWidth ) * blockSize + 16;
				this.y = ( Math.floor( nextStep / mazeWidth ) ) * blockSize + 16;
			}
			else if (nextStep == -1) { // Failed to find path
				
			}
			
			
			/*
			resetWalkablePoints();
			var nextStep:int = modifiedSearch(antx, anty);
			trace("test:" + nextStep);
			
			// Currently a constant, but should get it dynamically
			var blockSize:int = 32;
			var mazeWidth:int = 16;
			
			// Move the Ant Lion there
			this.x = ( nextStep % mazeWidth ) * blockSize + 16;
			this.y = ( Math.floor( nextStep / mazeWidth ) ) * blockSize + 16;
			*/
		}
		
		// Does not make it much more efficient
		private function modifiedSearch(antx:int, anty:int):int
		{
			// Need to get these dynamically, for now they are constants
			var mazeWidth:int = 16;
			var mazeHeight:int = 24;
			
			// Convert Ant location and Ant Lion location to indices
			var antIndex:int = coordToGrid(antx, anty);
			var antLionIndex:int = coordToGrid(this.x, this.y);
			
			// Nodes to check puts lowest distance to Ant as first node
			var nodesToCheck:Array = [];
			var checkedNodes:Array = [];
			
			// Add Ant Lion Node as first Node
			var antLionNode:Node = new Node(null, -1, antLionIndex);
			var antNode:Node;
			nodesToCheck.push(antLionNode);
			
			var counter:int = 0;
			var curIndex:int = antLionIndex;
			var prevNode:Node = antLionNode;
			var solved:Boolean = false;
			
			while ( ( counter < 12000 ) && ( nodesToCheck.length > 0 ) && !solved )
			{
				prevNode = nodesToCheck.shift();
				checkedNodes.push(prevNode);
				
				curIndex = prevNode.getIndex();
				// Convenience variables that hold the indices of the cell above, below, left, and right
				var topIndex:int = curIndex - mazeWidth;
				var bottomIndex:int = curIndex + mazeWidth;
				var leftIndex:int = curIndex - 1;
				var rightIndex:int = curIndex + 1;
				
				// Check if cell above is walkable, if it is, mark its distance from Ant
				if ( canMoveHere( curIndex, topIndex ) ) {
					// keep going up, if isChokepoint, until !isChokepoint
					// return Node at !isChokepoint
					var tempCurIndex:int = topIndex;
					var tempTopIndex:int = topIndex - mazeWidth;
					
					while (isChokepoint(tempCurIndex)) {
						if ( tempCurIndex == antIndex ) {
							solved = true;
							antNode = new Node(prevNode, 0, antIndex);
							checkedNodes.push(antNode);
							break;
						}
						
						tempCurIndex = tempTopIndex;
						tempTopIndex = tempTopIndex - mazeWidth;
					}
					// tempCurIndex is not a chokepoint anymore
					var cellx:int = indexToCoordX(tempCurIndex);
					var celly:int = indexToCoordY(tempCurIndex);
					var distToAnt:Number = Math.sqrt( Math.pow( antx - cellx, 2 ) + Math.pow( anty - celly, 2 ) );
					var jumpNode:Node = new Node(prevNode, distToAnt, tempCurIndex);
					
					nodesToCheck = insertIntoArray(jumpNode, nodesToCheck);
				}
				// Check if cell below is walkable, if it is, mark its distance from Ant
				if ( canMoveHere( curIndex, bottomIndex ) ) {
					// keep going up, if isChokepoint, until !isChokepoint
					// return Node at !isChokepoint
					var tempCurIndex2:int = bottomIndex;
					var tempBottomIndex:int = bottomIndex + mazeWidth;
					
					while (isChokepoint(tempCurIndex2)) {
						if ( tempCurIndex2 == antIndex ) {
							solved = true;
							antNode = new Node(prevNode, 0, antIndex);
							checkedNodes.push(antNode);
							break;
						}
						
						tempCurIndex2 = tempBottomIndex;
						tempBottomIndex = tempBottomIndex + mazeWidth;
					}
					// tempCurIndex is not a chokepoint anymore
					var cellx2:int = indexToCoordX(tempCurIndex2);
					var celly2:int = indexToCoordY(tempCurIndex2);
					var distToAnt2:Number = Math.sqrt( Math.pow( antx - cellx2, 2 ) + Math.pow( anty - celly2, 2 ) );
					var jumpNode2:Node = new Node(prevNode, distToAnt2, tempCurIndex2);
					
					nodesToCheck = insertIntoArray(jumpNode2, nodesToCheck);
				}
				// Check if cell to the left is walkable, if it is, mark its distance from Ant
				if ( canMoveHere( curIndex, leftIndex ) ) {
					// keep going up, if isChokepoint, until !isChokepoint
					// return Node at !isChokepoint
					var tempCurIndex3:int = leftIndex;
					var tempLeftIndex:int = leftIndex - 1;
					
					while (isChokepoint(tempCurIndex3)) {
						if ( tempCurIndex3 == antIndex ) {
							solved = true;
							antNode = new Node(prevNode, 0, antIndex);
							checkedNodes.push(antNode);
							break;
						}
						
						tempCurIndex3 = tempLeftIndex;
						tempLeftIndex = tempLeftIndex - 1;
					}
					// tempCurIndex is not a chokepoint anymore
					var cellx3:int = indexToCoordX(tempCurIndex3);
					var celly3:int = indexToCoordY(tempCurIndex3);
					var distToAnt3:Number = Math.sqrt( Math.pow( antx - cellx3, 2 ) + Math.pow( anty - celly3, 2 ) );
					var jumpNode3:Node = new Node(prevNode, distToAnt3, tempCurIndex3);
					
					nodesToCheck = insertIntoArray(jumpNode3, nodesToCheck);
				}
				// Check if cell to the right is walkable, if it is, mark its distance from Ant
				if ( canMoveHere( curIndex, rightIndex ) ) {
					// keep going up, if isChokepoint, until !isChokepoint
					// return Node at !isChokepoint
					var tempCurIndex4:int = rightIndex;
					var tempRightIndex:int = rightIndex + 1;
					
					while (isChokepoint(tempCurIndex4)) {
						if ( tempCurIndex4 == antIndex ) {
							solved = true;
							antNode = new Node(prevNode, 0, antIndex);
							checkedNodes.push(antNode);
							break;
						}
						
						tempCurIndex4 = tempRightIndex;
						tempRightIndex = tempRightIndex + 1;
					}
					// tempCurIndex is not a chokepoint anymore
					var cellx4:int = indexToCoordX(tempCurIndex4);
					var celly4:int = indexToCoordY(tempCurIndex4);
					var distToAnt4:Number = Math.sqrt( Math.pow( antx - cellx4, 2 ) + Math.pow( anty - celly4, 2 ) );
					var jumpNode4:Node = new Node(prevNode, distToAnt4, tempCurIndex4);
					
					nodesToCheck = insertIntoArray(jumpNode4, nodesToCheck);
				}
				
				if ( curIndex == antIndex ) {
					solved = true;
					antNode = new Node(prevNode, 0, antIndex);
					checkedNodes.push(antNode);
					break;
				}
				
				counter++;
			}
			
			var nextStep:int = -1;
			
			var currentNode:Node;
			var previousNode:Node;
			if (solved) {
				// get Ant node
				// trace back to Ant Lion
				// get next node
				// walk towards it
				currentNode = antNode;
				previousNode = antNode.getPrevNode();
				while ( previousNode.getPrevNode() != null ) {
					currentNode = previousNode;
					previousNode = previousNode.getPrevNode();
				}
				// curNode now holds next Node, which is straight from the Ant Lion
				
				// now, find whether to move up, down, left, or right to get to Node
				var nextIndex:int = currentNode.getIndex();
				
				if ( ( ( Math.floor( antLionIndex % mazeWidth ) ) == ( Math.floor( nextIndex % mazeWidth ) ) ) && ( nextIndex < antLionIndex ) ) {
					// Go up
					nextStep = antLionIndex - mazeWidth;
				}
				else if ( ( ( Math.floor( antLionIndex % mazeWidth ) ) == ( Math.floor( nextIndex % mazeWidth ) ) ) && ( nextIndex > antLionIndex ) ) {
					// Go down
					nextStep = antLionIndex + mazeWidth;
				}
				else if ( ( ( Math.floor( antLionIndex / mazeWidth ) ) == ( Math.floor( nextIndex / mazeWidth ) ) ) && ( nextIndex < antLionIndex ) ) {
					// Go left
					nextStep = antLionIndex - 1;
				}
				else if ( ( ( Math.floor( antLionIndex / mazeWidth ) ) == ( Math.floor( nextIndex / mazeWidth ) ) ) && ( nextIndex > antLionIndex ) ) {
					// Go right
					nextStep = antLionIndex + 1;
				}
			}
			
			return nextStep;
		}
		
		private function indexToCoordX(index:int):int
		{
			var mazeWidth:int = 16;
			var blockSize:int = 32;
			return ( ( index % mazeWidth ) * blockSize );
		}
		
		private function indexToCoordY(index:int):int
		{
			var mazeWidth:int = 16;
			var blockSize:int = 32;
			return ( ( index / mazeWidth ) * blockSize );
		}
		
		//private function findNextJumpNode(parentNode:Node):Node
		//{
			
		//}
		
		// http://www.beautifycode.com/array-prototypes-insertindexvalue-removeindex
		// Inserts so that lowest distance to ant is first
		private function insertIntoArray(node:Node, array:Array):Array
		{
			var newArray:Array;
			//array1: slice up to index
			//push Node onto array 1:
			//array2: slice from index to end
			//concat array1 and array2
			if ( array.length <= 0 ) {
				array.push(node);
				return array;
			}
			
			var nodeDist:Number = node.getDistance();
			
			var indexToInsert:int = -1;
			for ( var i:int = 0; i < array.length; i++ ) {
				if ( nodeDist < array[i].getDistance() ) {
					indexToInsert = i;
				}
			}
			
			// It is the largest distance
			if ( indexToInsert == -1 ) {
				array.push(node);
				return array;
			}
			else if ( indexToInsert >= 0 ) {
				var array1:Array = array.slice(0, indexToInsert);
				array1.push(node);
				var array2:Array = array.slice(indexToInsert);
				newArray = array1.concat(array2);
			}
			
			return newArray;
		}
		
		public function update():void
		{
			
		}
	}

}