//
// Rack for holding Thorlabs CFH2-F filter holders.
//
// Hazen 07/15
//

$fn = 100;

module bottom()
{
	difference(){
		hull(){
			translate([0,-63.5,0])
			cylinder(r = 8, h = 2);

			translate([0,63.5,0])
			cylinder(r = 8, h = 2);

			translate([-21,-50,0])
			cylinder(r = 2, h = 2);

			translate([-21,50,0])
			cylinder(r = 2, h = 2);

			translate([21,-50,0])
			cylinder(r = 2, h = 2);

			translate([21,50,0])
			cylinder(r = 2, h = 2);

		}

		translate([0,0,-0.1]){
			translate([0,-63.5,0])
			cylinder(r = 3.3, h = 2.2);

			translate([0,63.5,0])
			cylinder(r = 3.3, h = 2.2);

			hull(){
				translate([-14,-41,0])
				cylinder(r = 5, h = 2.2);

				translate([14,-41,0])
				cylinder(r = 5, h = 2.2);

				translate([-14,-7.5,0])
				cylinder(r = 5, h = 2.2);

				translate([14,-7.5,0])
				cylinder(r = 5, h = 2.2);
			}
			hull(){
				translate([-14,41,0])
				cylinder(r = 5, h = 2.2);

				translate([14,41,0])
				cylinder(r = 5, h = 2.2);

				translate([-14,7.5,0])
				cylinder(r = 5, h = 2.2);

				translate([14,7.5,0])
				cylinder(r = 5, h = 2.2);
			}
		}
	}
}

module end()
{
	translate([0,1,16])
	rotate([90,0,0])
	difference(){
		translate([-23,-17,0])
		cube([46,34,2]);
	
		translate([0,0,-0.1])
		hull(){
			translate([-14,-9,0])
			cylinder(r = 5, h = 2.2);

			translate([-14,9,0])
			cylinder(r = 5, h = 2.2);

			translate([14,-9,0])
			cylinder(r = 5, h = 2.2);

			translate([14,9,0])
			cylinder(r = 5, h = 2.2);
		}
	}
}

module side()
{
	translate([-1,0,16])
	rotate([90,0,90])
	difference(){
		translate([-50,-17,0])
		cube([100,34,2]);

		translate([0,0,-0.1]){
			hull(){
				translate([-41,-9,0])
				cylinder(r = 5, h = 2.2);

				translate([-41,9,0])
				cylinder(r = 5, h = 2.2);

				translate([-7.5,-9,0])
				cylinder(r = 5, h = 2.2);

				translate([-7.5,9,0])
				cylinder(r = 5, h = 2.2);
			}
			hull(){
				translate([41,-9,0])
				cylinder(r = 5, h = 2.2);

				translate([41,9,0])
				cylinder(r = 5, h = 2.2);

				translate([7.5,-9,0])
				cylinder(r = 5, h = 2.2);

				translate([7.5,9,0])
				cylinder(r = 5, h = 2.2);
			}
		}
	}
}

module slot()
{
	difference(){
		translate([-23,-10,0])
		cube([46,20,2]);

		translate([0,0,-0.1]){
		hull(){
			translate([-18.5,5.9,0])
			cylinder(r = 0.1, h = 2.2);

			translate([-18.5,3.5,0])
			cylinder(r = 0.1, h = 2.2);

			translate([18.5,5.9,0])
			cylinder(r = 0.1, h = 2.2);

			translate([18.5,3.5,0])
			cylinder(r = 0.1, h = 2.2);

			translate([-14.4,-3.5,0])
			cylinder(r = 0.1, h = 2.2);

			translate([14.4,-3.5,0])
			cylinder(r = 0.1, h = 2.2);

		}

		hull(){
			translate([-14.4,-5.9,0])
			cylinder(r = 0.1, h = 2.2);

			translate([-14.4,-3.5,0])
			cylinder(r = 0.1, h = 2.2);

			translate([14.4,-5.9,0])
			cylinder(r = 0.1, h = 2.2);

			translate([14.4,-3.5,0])
			cylinder(r = 0.1, h = 2.2);
		}
		}
		/*
		hull(){
			translate([-14.4,-5.9,0])
			cylinder(r = 0.1, h = 2.2);

			translate([-18.5,5.9,0])
			cylinder(r = 0.1, h = 2.2);

			translate([-18.5,3.5,0])
			cylinder(r = 0.1, h = 2.2);

			translate([14.4,-5.9,0])
			cylinder(r = 0.1, h = 2.2);

			translate([18.5,5.9,0])
			cylinder(r = 0.1, h = 2.2);

			translate([18.5,3.5,0])
			cylinder(r = 0.1, h = 2.2);

		}
		*/
	}
}

module top(){
	for(i=[-2:2]){
		translate([0,20.0*i,0])
		slot();
	}
}

module holder(){
	bottom();

	translate([0,0,34])
	top();

	translate([0,-49,2])
	end();

	translate([0,49,2])
	end();

	translate([-22,0,2])
	side();

	translate([22,0,2])
	side();
}

holder();
//end();

//side();