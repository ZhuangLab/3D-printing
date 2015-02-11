//
// Filter cube for TiU. Fits both Olympus and Nikon dichroics.
//
// Hazen 12/14
//

$fn = 100;

show_thread = 0;
testing = 1;

// reverse trapezoid
module reverse_trapezoid(p0, p1, p2, p3, p4, p5, p6, p7)
{
	polyhedron(
		points = [p0, p1, p2, p3, p4, p5, p6, p7],
		faces = [[0,1,2,3],[0,4,5,1],[0,3,7,4],
				  [6,5,4,7],[6,2,1,5],[6,7,3,2]]);
}

// thread.
module inner_thread (radius = 12.9,
			          thread_height = 0.45,
				      thread_base_width = 0.6,
				      thread_top_width = 0.05,
				      thread_length = 6.5,
				      threads_per_mm = 0.635,
				      extra = -0.5,
				      overlap = 0.01)
{
	cylinder_radius = radius + thread_height;
	inner_diameter = 2.0 * 3.14159 * radius;

	number_divisions = 180;
	overshoot = extra * number_divisions;
	angle_step = 360.0/number_divisions;
	turns = thread_length/threads_per_mm;
	z_step = threads_per_mm/number_divisions;

	fudge = angle_step * overlap;

	p0 = [cylinder_radius * cos(-0.5 * (angle_step + fudge)),
         cylinder_radius * sin(-0.5 * (angle_step + fudge)),
         -0.5 * thread_base_width];
	p1 = [radius * cos(-0.5 * (angle_step + fudge)),
         radius * sin(-0.5 * (angle_step + fudge)),
         -0.5 * thread_top_width];

	p2 = [radius * cos(-0.5 * (angle_step + fudge)),
         radius * sin(-0.5 * (angle_step + fudge)),
         0.5 * thread_top_width];
   p3 = [cylinder_radius * cos(-0.5 * (angle_step + fudge)),
         cylinder_radius * sin(-0.5 * (angle_step + fudge)),
         0.5 * thread_base_width];

	p4 = [cylinder_radius * cos(0.5 * (angle_step + fudge)),
         cylinder_radius * sin(0.5 * (angle_step + fudge)),
         -0.5 * thread_base_width + z_step];
	p5 = [radius * cos(0.5 * (angle_step + fudge)),
         radius * sin(0.5 * (angle_step + fudge)),
         -0.5 * thread_top_width + z_step];

	p6 = [radius * cos(0.5 * (angle_step + fudge)),
         radius * sin(0.5 * (angle_step + fudge)),
         0.5 * thread_top_width + z_step];
	p7 = [cylinder_radius * cos(0.5 * (angle_step + fudge)),
         cylinder_radius * sin(0.5 * (angle_step + fudge)),
         0.5 * thread_base_width + z_step];

	difference(){
		union(){
			for(i = [-overshoot:(turns*number_divisions+overshoot)]){
			//for(i= [0:1]){
				rotate([0,0,i*angle_step])
				translate([0,0,i*z_step])
				reverse_trapezoid(p0, p1, p2, p3, p4, p5, p6, p7);
			}
		}
		translate([0,0,-2])
		cylinder(r = cylinder_radius+0.1, h = 2);

		translate([0,0,thread_length])
		cylinder(r = cylinder_radius+0.1, h = 2);
	}
}

module lock_groove()
{
	length = 8.3;

	difference(){
		union(){
			translate([-0.75,0,0])
			cube(size = [1.5,length,0.7]);

			translate([-0.75,0,0])
			rotate([0,-45,0])
			cube(size = [1.5,length,1.2]);

			mirror([1,0,0])
			translate([-0.75,0,0])
			rotate([0,-45,0])
			cube(size = [1.5,length,1.2]);
		}
		translate([-5,-0.5,0.61])
		cube(size = [10,length+1,5]);
	}	
}

module base()
{
	difference(){
		union(){
			difference(){
				union(){
					translate([0,-19,0])
					cube(size = [37,38,8.5]);
				
					translate([0,-15,8.5])
					cube(size = [37,30.0,27.5]);
				}

				// optical clearance for dichroic.
				hull(){
					translate([7.4,10,7])
					cylinder(r = 0.5, h = 40);
					translate([7.4,-10,7])
					cylinder(r = 0.5, h = 40);
					translate([28.4,-10,7])
					cylinder(r = 0.5, h = 40);
					translate([28.4,10,7])
					cylinder(r = 0.5, h = 40);
				}
				translate([17.4,0,16.6])
				rotate([0,45,0])
				hull(){
					translate([0,10,-1.1])
					cylinder(r=0.5,h=2.2);

					translate([-14.2,10,-1.1])
					cylinder(r=0.5,h=2.2);

					translate([-14.2,-10,-1.1])
					cylinder(r=0.5,h=2.2);

					translate([0,-10,-1.1])
					cylinder(r=0.5,h=2.2);
				}

				// clear out inside under dichroic.
				hull(){
					translate([7.4,12.5,8])
					cylinder(r = 0.5, h = 17);
					translate([7.4,-12.5,8])
					cylinder(r = 0.5, h = 17);
					translate([24.4,-12.5,8])
					cylinder(r = 0.5, h = 0.1);
					translate([24.4,12.5,8])
					cylinder(r = 0.5, h = 0.1);
				}

				// taper clearance.
				hull(){
					translate([2.0,10,8])
					cylinder(r = 0.5, h = 21.9);
					translate([2.0,-10,8])
					cylinder(r = 0.5, h = 21.9);
					translate([7.4,-12.5,8])
					cylinder(r = 0.5, h = 17);
					translate([7.4,12.5,8])
					cylinder(r = 0.5, h = 17);
				}

				// optical clearance for emission filter.
				translate([17.4,0,-0.1])
				cylinder(r = 10.5, h = 8);

				//
				// dichroic mount
				//

				// slot
				translate([-2,-13.5,37.2])
				rotate([0,45,0])
				cube(size = [50,27,30]);

				// trim top
				translate([0,-15.5,35.2])
				rotate([0,45,0])
				cube(size = [5,31,10]);

				translate([-1,-15.5,34.2])
				cube(size = [5,31,10]);

				//
				// side flanges
				//
				translate([-0.5,19,2])
				rotate([31.61,0,0])
				cube(size = [42.5,5,7.632]);

				mirror([0,1,0])
				translate([-0.5,19,2])
				rotate([31.61,0,0])
				cube(size = [42.5,5,7.632]);		

				// rear taper
				translate([0,12.25,-0.5])
				rotate([0,0,29.36])
				cube(size = [16,10,40]);

				mirror([0,1,0])
				translate([0,12.25,-0.5])
				rotate([0,0,29.36])
				cube(size = [16,10,40]);

				// front taper
				translate([33,-19,-0.5])
				rotate([0,0,-45])
				cube(size = [10,10,10]);

				mirror([0,1,0])
				translate([33,-19,-0.5])
				rotate([0,0,-45])
				cube(size = [10,10,10]);

				// lock groove
				translate([24,-19,1.15])
				rotate([58.39,0,0])
				lock_groove();

				mirror([0,1,0])
				translate([24,-19,1.15])
				rotate([58.39,0,0])
				lock_groove();
			}

			//
			// front assembly
			//

			// bottom part /w dichroic stop
			difference(){
				translate([28,-15,0])
				cube(size = [9,30,7.5]);

				translate([30.9,-15.1,9.7])
				rotate([0,-135,0])
				cube(size = [5,30.2,5]);

				translate([17.5,0,-0.1])
				cylinder(r = 13.1, h = 8.15);

			}

			// upper part w/ emission filter mount
			translate([31,-15,6])
			cube(size = [6,30,30]);

			// excitation filter mount.
			translate([38,0,21.2])
			rotate([0,-90,0])
			cylinder(r = 14.1, h = 1.0);
		}
	
		// bottom rails.
		translate([-1,-15,-1])
		cube(size = [50,30,1.5]);

		translate([36,-20,-1])
		cube(size = [5,40,1.5]);

		//
		// dichroic holder slots.
		//

		translate([16.8,13.49,17.3])
		difference(){
			cube(size = [1.2,0.6,40]);
			translate([-0.1,-0.1,-3])
			rotate([0,-45,0])
			cube(size = [3,3,3]);
		}

		mirror([0,1,0])
		translate([16.8,13.49,17.3])
		difference(){
			cube(size = [1.2,0.6,40]);
			translate([-0.1,-0.1,-3])
			rotate([0,-45,0])
			cube(size = [3,3,3]);
		}

		//
		// emission filter holder slot.
		//

		// main slot
		hull(){
			translate([-1,0,-0.1])
			cylinder(r = 14.2, h = 5.1);

			translate([17.5,0,-0.1])
			cylinder(r = 14.2, h = 5.1);
		}

		// upper clearance
		hull(){
			translate([-1,0,-0.1])
			cylinder(r = 13.1, h = 7.15);

			translate([17.5,0,-0.1])
			cylinder(r = 13.1, h = 7.15);
		}

		// mounting groove
		hull(){
			translate([-1,0,1.45])
			cylinder(r = 15.5, h = 1.1);

			translate([17.5,0,1.45])
			cylinder(r = 15.5, h = 1.1);
		}

		translate([0,-20,-0.1])
		cube(size = [7.1,40,7.15]);

		//
		// excitation filter mount.
		//

		// optical clearance (front / excitation)
		translate([38.1,0,21.2])
		rotate([0,-90,0])
		cylinder(r = 10.5, h = 7.2);

		// excitation filter clearance
		translate([38.1,0,21.2])
		rotate([0,-90,0])
		cylinder(r = 13.32, h = 6.1);

		//
		// Remove some excess material from the bottom.
		//
		/*
		translate([36.5,0,0])
		cylinder(r = 3, h = 7.5);

		translate([35.5,9,0])
		cylinder(r = 4, h = 7.5);

		translate([35.5,-9,0])
		cylinder(r = 4, h = 7.5);
		*/

	}

	// tabs to keep dichroic from sliding out the top.
	translate([0,0,33.2])
	rotate([0,-45,0]){
		translate([0,9.25,0])
		difference(){
			cube(size = [2,3,1]);
			rotate([0,-45,0])
			translate([0,-0.1,0])
			cube(size = [3,3.2,1]);
		}
		translate([0,-12.25,0])
		difference(){
			cube(size = [2,3,1]);
			rotate([0,-45,0])
			translate([0,-0.1,0])
			cube(size = [3,3.2,1]);
		}
	}

	// SM1 thread for excitation filter.
	if (show_thread){
		translate([38,0,21.2])
		rotate([0,-90,0])
		inner_thread();
	}

}

module emission_filter_holder()
{
	difference(){
		union(){
			translate([17.4,0,0])
			cylinder(r = 14.1, h = 4.3);

			hull(){
				translate([-1,0,0])
				cylinder(r = 14.1, h = 3);

				translate([17.4,0,0])
				cylinder(r = 14.1, h = 3);
			}

			// mounting ring.
			hull(){
				translate([-1,0,1])
				cylinder(r = 15.45, h = 1);

				translate([17.4,0,1])
				cylinder(r = 15.45, h = 1);
			}

			translate([0,-20,0])
			cube(size = [7,40,5.4]);

			translate([0,-15,0])
			cube(size = [7,30,6.4]);
		}

		// optical clearance.
		translate([17.4,0,-1])
		cylinder(r = 10.5, h = 4);

		// filter mount.
		translate([17.4,0,1])
		cylinder(r = 13.1, h = 6);
		
		// square off end.
		translate([-20,-20,-0.1])
		cube(size = [20,40,6.1]);

		// slot
		hull(){
			translate([2.5,-10,-0.1])
			cylinder(r=1,h=1);

			translate([2.5,10,-0.1])
			cylinder(r=1,h=1);
		}

		// rear taper
		translate([0,12.25,-0.5])
		rotate([0,0,29.36])
		cube(size = [16,10,40]);

		mirror([0,1,0])
		translate([0,12.25,-0.5])
		rotate([0,0,29.36])
		cube(size = [16,10,40]);

	}
}

module dichroic_tab(){

	translate([17.4,11.4,33.7]){
		hull(){
			translate([-2.0,0,0])
			rotate([-90,0,0])
			cylinder(r =0.5, h = 1);

			translate([2.0,0,0])
			rotate([-90,0,0])
			cylinder(r =0.5, h = 1);
		}
	}

	translate([0,11.9,0])
	hull(){
		translate([22.65,0,16.25])
		rotate([-90,0,0])
		cylinder(r =0.25, h = 1.5);

		translate([20.65,0,34.15])
		rotate([-90,0,0])
		cylinder(r =0.25, h = 1.5);

		translate([14.15,0,34.15])
		rotate([-90,0,0])
		cylinder(r =0.25, h = 1.5);

		translate([9.15,0,29.15])
		rotate([-90,0,0])
		cylinder(r =0.25, h = 1.5);

	}

}

module dichroic_holder() {
	difference(){
		union(){
			translate([17.4,0,20.6])
			rotate([0,45,0])
			hull(){
				translate([17,12.9,-1])
				cylinder(r=0.5,h=2);

				translate([-17,12.9,-1])
				cylinder(r=0.5,h=2);

				translate([-17,-12.9,-1])
				cylinder(r=0.5,h=2);

				translate([17,-12.9,-1])
				cylinder(r=0.5,h=2);
			}

			// match slots in base.
			translate([16.9,13,21])
			cube(size = [1.0,1.1,10]);

			mirror([0,1,0])
			translate([16.9,13,21])
			cube(size = [1.0,1.1,10]);

			// side panels
			dichroic_tab();
			mirror([0,1,0])
			dichroic_tab();

			// pressure points at corners
			translate([17.4,0,20.6])
			rotate([0,45,0]){
				translate([15.7,11.7,-0.4])
				sphere(r=1);
				translate([15.7,-11.7,-0.4])
				sphere(r=1);
				translate([-15.7,11.7,-0.4])
				sphere(r=1);
				translate([-15.7,-11.7,-0.4])
				sphere(r=1);

			}
		}

		// optical clearance for dichroic.
		translate([17.4,0,20.6])
		rotate([0,45,0])
		hull(){
			translate([15,10.9,-1.5])
			cylinder(r=0.5,h=3);

			translate([-15,10.9,-1.5])
			cylinder(r=0.5,h=3);

			translate([-15,-10.9,-1.5])
			cylinder(r=0.5,h=3);

			translate([15,-10.9,-1.5])
			cylinder(r=0.5,h=3);
		}
	}
}

if (testing){

	//inner_thread();

	difference(){
		union(){
			base();

			translate([-20,0,0.5])
			emission_filter_holder();

			translate([0,0,15])
			dichroic_holder();
		}

		/*
		translate([-1,-20,25])
		cube(size = [45,40,40]);
		*/

		/*
		translate([-1,-20,0])
		cube(size = [45,40,24]);
		*/

		/*
		translate([-10,-20,-1])
		cube(size = [30,40,40]);
		*/

		/*
		translate([-1,-31,-1])
		cube(size = [45,30,40]);
		*/
	}
}
else{
	base();

	translate([20,26,0])
	rotate([0,-90,90])
	emission_filter_holder();

	translate([25,6,15.2])
	rotate([90,90,0])
	rotate([0,-45,0])
	dichroic_holder();
}

//translate([17.4,0,6])

	//translate([0,-34,-38.58])
