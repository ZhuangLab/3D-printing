/*
 * Filter holder for a nikon inverted microscope. This is designed to
 * go in the groove under the lower fluorescence turret.
 *
 * Hazen 11/14
 */

$fn = 100;

module cutout()
{
	difference(){
		hull(){
			cylinder(r = 2, h = 4);

			translate([0,43,0])
			cylinder(r = 2, h = 4);

			translate([32,43,0])
			cylinder(r = 2, h = 4);

			translate([32,0,0])
			cylinder(r = 2, h = 4);
		}

		translate([16,65,0])
		cylinder(r = 25, h = 4);
	}
}

difference(){
	union(){

		// body.
		translate([-24,-75,0])
		cube(size = [48,150,3]);

		// end plates.
		translate([-21.5,-75,0])
		cube([43,5,10]);

		translate([-21.5,70,0])
		cube([43,5,10]);

		// side plates.
		translate([-24,-75,0])
		cube([3,150,7.5]);

		translate([21,-75,0])
		cube([3,150,7.5]);

		// filter holder.
		cylinder(r = 21.5, h = 10);

		// indent
		translate([18,-10,0])
		cube([6,20,7.5]);

		translate([-24,-10,0])
		cube([6,20,7.5]);
	}

	// filter holder.
	translate([0,0,-0.5])
	cylinder(r = 10.7, h = 11);

	translate([0,0,2])
	cylinder(r = 13.2, h = 9);

	translate([0,0,5])
	cylinder(r = 18, h = 6);

	// indent
	translate([23,5,-0.5])
	cube([2,2,8.5]);

	translate([-25,-7,-0.5])
	cube([2,2,8.5]);

	// cut-outs
	translate([-16,-65,-0.5])
	cutout();

	mirror([0,1,0])
	translate([-16,-65,-0.5])
	cutout();

}

