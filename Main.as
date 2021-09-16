package {
	import flash.display.*;
	import flash.events.*;
	import flash.ui.Keyboard;
	import flash.display.Sprite;
	import fl.motion.MotionEvent;

	public class Main extends MovieClip {

		var numBirds: int = 0;
		var maxSpeed: Number = 1;
		var attraction_radius: Number = 50;
		var repulsion_radius: Number = 25;
		var alignment_radius: Number = 30;

		var arr: Array = [];
		var ATTRACTION: Number = 0;
		var REPULSION: Number = 0;
		var ALIGNMENT: Number = 0;
		var baseSpeed: Number = 5;
		var clickDone: Boolean = false;
		
		var bd:BitmapData;
		var bmp:Bitmap;
		var BG_COLOR:uint = 0x000000;
		


		public function Main() {
			// constructor code
			attractionTF.text = "ATTRACTION " + ATTRACTION;
			repulstionTF.text = "REPULSION " + REPULSION;
			alignmentTF.text = "ALIGNMENT " + ALIGNMENT;
			
			
			bd = new BitmapData(stage.stageWidth, stage.stageHeight, false, BG_COLOR);
			bmp = new Bitmap(bd);
			stage.addChildAt(bmp,0);
			


			for (var i: int = 0; i < numBirds; i++) {


				/*
				b.attraction_circle = new Sprite();
				b.attraction_circle.alpha = 0.1;
				b.addChild(b.attraction_circle);
				
				b.attraction_circle.graphics.clear();
				b.attraction_circle.graphics.beginFill(0x990000, 1);
				b.attraction_circle.graphics.drawCircle(0, 0, attraction_radius); 
				b.attraction_circle.graphics.endFill(); 
				
				b.repulsion_circle = new Sprite();
				b.repulsion_circle.alpha = 0.1;
				b.addChild(b.repulsion_circle);
				
				b.repulsion_circle.graphics.clear();
				b.repulsion_circle.graphics.beginFill(0x00cc33, 1);
				b.repulsion_circle.graphics.drawCircle(0, 0, repulsion_radius); 
				b.repulsion_circle.graphics.endFill(); 
				
				b.alignment_circle = new Sprite();
				b.alignment_circle.alpha = 0.1;
				b.addChild(b.alignment_circle);
				
				b.alignment_circle.graphics.clear();
				b.alignment_circle.graphics.beginFill(0x3333cc, 1);
				b.alignment_circle.graphics.drawCircle(0, 0, alignment_radius); 
				b.alignment_circle.graphics.endFill(); 
				
				*/


			}

			stage.addEventListener(Event.ENTER_FRAME, update);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, reportKeyDown);

			stage.addEventListener(MouseEvent.CLICK, onClick)
		}

		function onClick(e: MouseEvent): void {



			clickDone = true;
		}

		function distance(mc: Boid, mc1: Boid): Number {
			var a: Number = mc1.x - mc.x;
			var b: Number = mc1.y - mc.y;

			var distance: Number = Math.sqrt(a * a + b * b);
			return distance;
		}


		//move in same dir
		function move(me: Boid): void {
			/*
			if(myIndex == 0)
			{
				var destX:Number = stage.mouseX;
				var destY:Number = stage.mouseY;
				
				var radAngleToDest:Number = Math.atan2(destY - me.y, destX - me.x);
				var newX:Number = Math.cos(radAngleToDest) * baseSpeed;
				var newY:Number = Math.sin(radAngleToDest) * baseSpeed;
				
				me.dirX += (newX  * ALIGNMENT);
				me.dirY += (newY * ALIGNMENT);
				
				return;
			}
			*/

			var i: int = 0;
			var b: Boid;
			//----------ALIGNMENT--------///
			if (ALIGNMENT > 0) {
				var avgX_align: Number = 0;
				var avgY_align: Number = 0;
				var numBoids_align: Number = 0;

				for (i = 0; i < me.alignment_iter; i++) {
					b = me.alignmentArr[i];
					avgX_align += b.dirX;
					avgY_align += b.dirY;
					numBoids_align++;
				}

				if (numBoids_align > 0) {
					//trace("numBoids_align", numBoids_align);
					avgX_align /= numBoids_align;
					avgY_align /= numBoids_align;

					me.dirX += (avgX_align * ALIGNMENT);
					me.dirY += (avgY_align * ALIGNMENT);
				}
			}



			//-------------REPULSION------------///
			if (REPULSION > 0) {
				var avgX_repulsion: Number = 0;
				var avgY_repulsion: Number = 0;
				var numBoids_repulsion: Number = 0;

				for (i = 0; i < me.repulsion_iter; i++) {
					b = me.repulsionArr[i];
					avgX_repulsion += b.x;
					avgY_repulsion += b.y;
					numBoids_repulsion++; // (1 - (dist / radius));
				}

				if (numBoids_repulsion > 0) {
					//trace("numBoids_repulsion", numBoids_repulsion);
					avgX_repulsion /= numBoids_repulsion;
					avgY_repulsion /= numBoids_repulsion;

					me.dirX -= ((avgX_repulsion - me.x) * REPULSION);
					me.dirY -= ((avgY_repulsion - me.y) * REPULSION);
				}
			}


			//------ATTRACTION----////
			if (ATTRACTION > 0) {
				var avgX_attraction: Number = 0;
				var avgY_attraction: Number = 0;
				var numBoids_attraction: Number = 0;

				for (i = 0; i < me.attraction_iter; i++) {
					b = me.attractionArr[i];
					avgX_attraction += b.x;
					avgY_attraction += b.y;
					numBoids_attraction++;

				}

				if (numBoids_attraction > 0) {
					//trace("numBoids_attraction", numBoids_attraction);
					avgX_attraction /= numBoids_attraction;
					avgY_attraction /= numBoids_attraction;

					me.dirX += ((avgX_attraction - me.x) * ATTRACTION);
					me.dirY += ((avgY_attraction - me.y) * ATTRACTION);
				}
			}

		}

		function setVector(me: Boid): void {

			var radAngle: Number = me.rotation * (Math.PI / 180);
			var newX: Number = Math.cos(radAngle) * baseSpeed;
			var newY: Number = Math.sin(radAngle) * baseSpeed;

			me.dirX = newX;
			me.dirY = newY;

			if (clickDone) {
				//trace(me.rotation, radAngle, "dirX", me.dirX, "dirY", me.dirY);
			}


		}

		function getProximityBoids(myIndex: int, me: Boid): void {

			if (ATTRACTION == 0 && REPULSION == 0 && ALIGNMENT == 0)
			{
				return;
			}
			
			for (var i: int = 0; i < numBirds; i++) {
				var b: Boid = arr[i];
				if (myIndex != i) {
					var dist: Number = distance(b, me);
					if (dist < attraction_radius) {
						me.attractionArr[me.attraction_iter] = b;
						me.attraction_iter++;
					}
					if (dist < repulsion_radius) {
						me.repulsionArr[me.repulsion_iter] = b;
						me.repulsion_iter++;
					}
					if (dist < alignment_radius) {
						me.alignmentArr[me.alignment_iter] = b;
						me.alignment_iter++;
					}
				}
			}
		}


		function update(e: Event): void {
			for (var i: int = 0; i < numBirds; i++) {
				var b: Boid = arr[i];

				b.attraction_iter = 0;
				b.repulsion_iter = 0;
				b.alignment_iter = 0;

				if (isNaN(b.rotation)) {
					//b.x = stage.mouseX;
					//b.y = stage.mouseY;
					b.rotation = 30;
					trace("fuck " + i + " " + numBirds);
					//stage.removeChild(b);
					numBirds--;
					arr.splice(i, 1);
					return;
				}
				setVector(b);
				getProximityBoids(i, b);
				move(b);

				//var row: int = int(b.y / TILE_SIZE);
				//var col: int = int(b.x / TILE_SIZE);

				//if (grid[row][col] == b) {
				//	grid[row][col] = null;
				//}
				bd.setPixel(b.x, b.y, BG_COLOR);


				
				
				while(b.dirX > maxSpeed || b.dirY > maxSpeed || b.dirX < -maxSpeed ||  b.dirY < -maxSpeed)
				{
					b.dirX *= 0.9;
					b.dirY *= 0.9;
				}
				
				var newX: Number = b.x + b.dirX;
				var newY: Number = b.y + b.dirY;
				

				b.rotation = (Math.atan2(newY - b.y, newX - b.x) * 180 / Math.PI);

				b.x = newX;
				b.y = newY;

				if (b.y < 0) {
					b.y = stage.stageHeight;
				}
				if (b.y > stage.stageHeight) {
					b.y = 0;
				}

				if (b.x < 0) {
					b.x = stage.stageWidth;
				}
				if (b.x > stage.stageWidth) {
					b.x = 0;
				}
				
				bd.setPixel(b.x, b.y, b.color);
			}
			
			

			//var row = int(b.y / TILE_SIZE);
			//var col = int(b.x / TILE_SIZE);
			//grid[row][col] = b;

			if (clickDone) {
				createBoid();
			}
			clickDone = false;

		}

		function createBoid(): void {
			var b: Boid = new Boid();
			//stage.addChild(b);
			b.x = stage.mouseX;
			b.y = stage.mouseY;
			b.rotation = int(Math.random() * 360);

			b.attraction_iter = 0;
			b.attractionArr = [];


			b.repulsion_iter = 0;
			b.repulsionArr = [];


			b.alignment_iter = 0;
			b.alignmentArr = [];
			arr.push(b);
			numBirds++;
		}

		function reportKeyDown(event: KeyboardEvent): void {
			if (event.keyCode == Keyboard.Q) {
				ATTRACTION += 0.001;
			}
			if (event.keyCode == Keyboard.A) {
				ATTRACTION -= 0.001;
			}

			if (event.keyCode == Keyboard.W) {
				REPULSION += 0.001;
			}
			if (event.keyCode == Keyboard.S) {
				REPULSION -= 0.001;
			}

			if (event.keyCode == Keyboard.E) {
				ALIGNMENT += 0.001;
			}
			if (event.keyCode == Keyboard.D) {
				ALIGNMENT -= 0.001;
			}

			if (ALIGNMENT < 0) {
				ALIGNMENT = 0;
			}

			if (REPULSION < 0) {
				REPULSION = 0;
			}

			if (ATTRACTION < 0) {
				ATTRACTION = 0;
			}
			
			var attractionStr:String = String(ATTRACTION);
			var repulstionStr:String = String(REPULSION);
			var alignmentStr:String = String(ALIGNMENT);

			attractionTF.text = "ATTRACTION " + attractionStr.substr(0,6);
			repulstionTF.text = "REPULSION " + repulstionStr.substr(0,6);
			alignmentTF.text = "ALIGNMENT " + alignmentStr.substr(0,6);
		}
	}
}




/*
//move towards center mass
function moveTowardsCenter(myIndex: int, me: Boid): void {
	var avgX: Number = 0;
	var avgY: Number = 0;
	var numBoids: Number = 0;


	for (var i: int = 0; i < numBirds; i++) {
		if (myIndex != i) {
			var b: Boid = arr[i];
			var dist: Number = distance(b, me);
			if (dist < radius) {
				avgX += b.x;
				avgY += b.y;
				numBoids++;
			}
		}
	}

	if (numBoids > 0) {
		avgX /= numBoids;
		avgY /= numBoids;

		me.dirX += ((avgX - me.x) * ATTRACTION);
		me.dirY += ((avgY - me.y) * ATTRACTION);
	}
}

//move away center mass
function moveAwayCenter(myIndex: int, me: Boid): void {
	var avgX: Number = 0;
	var avgY: Number = 0;
	var numBoids: Number = 0;


	for (var i: int = 0; i < numBirds; i++) {
		if (myIndex != i) {
			var b: Boid = arr[i];
			var dist: Number = distance(b, me);
			if (dist < radius) {
				avgX += b.x;
				avgY += b.y;
				numBoids += (1 - (dist / radius));
			}
			1
		}
	}

	if (numBoids > 0) {
		avgX /= numBoids;
		avgY /= numBoids;

		me.dirX -= ((avgX - me.x) * REPULSION);
		me.dirY -= ((avgY - me.y) * REPULSION);
	}
}
*/