package 
{
	
	/**
	 * ...
	 * @author Green Mesa
	 */
	public class Node
	{
		private var previousNode:Node = null;
		private var distance:Number;
		private var index:int;
		
		public function Node(prevNode:Node, distToAnt:Number, indexNum:int)
		{
			previousNode = prevNode;
			distance = distToAnt;
			index = indexNum;
		}
		
		public function getPrevNode():Node
		{
			if (previousNode == null) {
				return null;
			}
			return previousNode;
		}
		
		public function getDistance():Number
		{
			return distance;
		}
		
		public function getIndex():int {
			return index;
		}
	}
	
}