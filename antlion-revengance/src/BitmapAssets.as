package  
{
	/**
	 * ...
	 * @author Cassandra de Git and Charlie Chao
	 */
	public class BitmapAssets 
	{
		public static const TILE_ROCK:int = 0;
		public static const TILE_DIRT:int = 1;
		public static const TILE_MUD1:int = 2;
		public static const TILE_MUD2:int = 3;
		public static const TILE_MUD3:int = 4;
		public static const TILE_MUD4:int = 5;
		public static const TILE_RUBBLE:int = 6;
		public static const TILE_TWIG:int = 7;
		public static const TILE_EXIT:int = 8;
		public static const TILE_VENT:int = 9;
		public static const TILE_STONE:int = 10;
		public static const TILE_GRASS:int = 11;
		public static const TILE_SKY:int = 12;
		
		public static const TILE_WIDTH:int = 32;
		
		[Embed(source = '../assets/tilesheet.png')] // embed the image file
		public static const Tilesheet:Class;	
		
		public function BitmapAssets() 
		{
			
		}
		
	}

}