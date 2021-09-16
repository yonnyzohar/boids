package  {
	
	public class Boid {
		public var color:int = 0xffffff;
		public var x:Number;
		public var y:Number;
		public var rotation:Number ;
		
		public var dirX:Number;
		public var dirY:Number;

		public var attraction_iter:int;
		public var attractionArr:Array;;

		public var repulsion_iter:int;
		public var repulsionArr:Array;

		public var alignment_iter:int;
		public var alignmentArr:Array;

		public function Boid() {
			// constructor code
		}

	}
	
}
