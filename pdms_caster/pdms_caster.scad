//
// Jig for casting PDMS on wafers.
//
// Hazen 09/15
//

$fn = 200;

show_wafer = 0;
testing = 0;

module wafer()
{
	difference(){
		cylinder(r = 38, h = 0.5);
		translate([-20,36,-0.1])
		cube(size = [40,4,0.7]);
	}
}

// trapezoid
module trapezoid(p0, p1, p2, p3, p4, p5, p6, p7)
{
	polyhedron(
		points = [p0, p1, p2, p3, p4, p5, p6, p7],
		faces = [[0,3,2,1],[0,1,5,4],[0,4,7,3],
					[6,7,4,5],[6,5,1,2],[6,2,3,7]]);
}

// reverse trapezoid
module reverse_trapezoid(p0, p1, p2, p3, p4, p5, p6, p7)
{
	polyhedron(
		points = [p0, p1, p2, p3, p4, p5, p6, p7],
		faces = [[0,1,2,3],[0,4,5,1],[0,3,7,4],
					[6,5,4,7],[6,2,1,5],[6,7,3,2]]);
}

// inner thread.
module inner_thread (radius = 42.5,
			            thread_height = 1.1,
				         thread_base_width = 1.5,
				         thread_top_width = 0.5,
				         thread_length = 6.5,
				         threads_per_mm = 2.0,
				         extra = -0.26,
				         overlap = 0.01)
{
	cylinder_radius = radius + thread_height;
	inner_diameter = 2.0 * 3.14159 * radius;

	number_divisions = 120;
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

// outer thread.
module outer_thread (radius = 43,
				    thread_height = 1.1,
					thread_base_width = 1.5,
					thread_top_width = 0.5,
					thread_length = 7,
					threads_per_mm = 2.0,
					extra = -0.26,
					overlap = 0.01)
{
	cylinder_radius = radius - thread_height;
	inner_diameter = 2.0 * 3.14159 * cylinder_radius;

	number_divisions = 120;
	overshoot = extra * number_divisions;
	angle_step = 360.0/number_divisions;
	turns = thread_length/threads_per_mm;
	z_step = threads_per_mm/number_divisions;

	//echo("advance per turn in mm:", z_step * number_divisions);

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
			//cylinder(r = cylinder_radius, h = thread_length);
			for(i = [-overshoot:(turns*number_divisions+overshoot)]){
				rotate([0,0,i*angle_step])
				translate([0,0,i*z_step])
				trapezoid(p0, p1, p2, p3, p4, p5, p6, p7);
			}
		}
		translate([0,0,-2])
		cylinder(r = radius+0.1, h = 2);

		translate([0,0,thread_length])
		cylinder(r = radius+0.1, h = 2);
	}
}


// bottom plate.
module bottom()
{
	difference(){
		union(){
			// body
			cylinder(r = 42, h = 9);

			// base
			cylinder(r = 45.5, h = 3.5);
		}

		// hole in the bottom.
		translate([0,0,-1])
		cylinder(r = 33, h = 5);

		// cutout for the wafer.
		translate([0,0,3])
		cylinder(r = 39, h = 13);

		// groove for o-ring.
		translate([0,0,1.5])
		difference(){
			cylinder(r = 36, h = 2);
			translate([0,0,-0.1])
			cylinder(r = 34, h = 2.2);
		}

		// slots for aligment tabs.
		for (i = [0:10]){
			rotate([0,0,i*30])
			translate([38,-1.25,3])
			cube(size=[2.5,2.5,13]);
		}
		
		rotate([0,0,310])
		translate([38,-1.25,3])
		cube(size=[2.5,2.5,13]);

	}

	// knurls
	for (i = [0:36]){
		rotate([0,0,i*10])
		translate([45,0,0])
		cylinder(r = 1.5, h = 3.5);
	}

	// thread
	translate([0,0,2])
	outer_thread();
	
}

module clamp()
{
	height = 7.5;

	difference(){
		cylinder(r = 45.5, h = height);

		// cutout for threads.
		translate([0,0,-0.1])
		cylinder(r = 43.25, h = height - 1.9);

		// center hole.
		translate([0,0,-0.1])
		cylinder(r = 35, h = height + 1.2);

	}

	// knurls
	for (i = [0:36]){
		rotate([0,0,i*10])
		translate([45.0,0,height - 3.5])
		cylinder(r = 1.5, h = 3.5);
	}

	rotate([0,0,-120])
	inner_thread();
}


module top()
{
	height = 6;

	difference(){
		union(){
			cylinder(r = 38.5, h = height);
			cylinder(r = 34.5, h = height + 3);

			// alignment tabs.
			for (i = [0:10]){
				rotate([0,0,i*30])
				translate([37.25,-1,0])
				cube(size=[3,2,height]);
			}	

			rotate([0,0,310])
			translate([37.25,-1,0])
			cube(size=[3,2,height]);

		}

		// center hole.
		translate([0,0,-0.1])
		cylinder(r = 33, h = height + 3.2);

		// groove for o-ring.
		translate([0,0,-0.5])
		difference(){
			cylinder(r = 36, h = 2);
			translate([0,0,-0.1])
			cylinder(r = 34, h = 2.2);
		}
	}
}


if (testing){
	difference(){
		union(){
			bottom();

			translate([0,0,3.7])
			//translate([0,0,20])
			top();

			translate([0,0,4.3])
			//translate([0,0,40])
			clamp();
	
			if(show_wafer){
				rotate([0,0,90])
				translate([0,0,3.1])
				wafer();
			}
		}

		if(0){
			translate([-50,0.1,-1])
			cube(size = [100,49.9,20]);

			translate([-50,-50,-1])
			cube(size = [100,49.9,20]);
		}

		if(0){
			offset = 4;
			translate([-50,-50,-14 + offset])
			cube(size = [100,100,20]);

			translate([-50,-50,6.1 + offset])
			cube(size = [100,100,20]);
		}

	}
}
else{
	bottom();

	translate([48,74,9])
	rotate([180,0,0])
	top();

	translate([94,0,7.5])
	rotate([180,0,0])
	clamp();

}
