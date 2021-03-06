// building Lego bricks - rdavis.bacs@gmail.com
// measurements taken from: 
//   http://www.robertcailliau.eu/Lego/Dimensions/zMeasurements-en.xhtml
// all copyrights and designs are property of their respective owners.

TOLERANCE = 0.1;

KNOB_TOP_DIAMETER = 4.8;
KNOB_BOTTOM_DIAMETER = 6.5137;
BEAM_BOTTOM_CYLINDER_DIAMETER = 3.0;

HORIZONTAL_KNOB_SEPARATION = 8.0;
HALF_HORIZONTAL_KNOB_SEPARATION = HORIZONTAL_KNOB_SEPARATION/2;

BRICK_STANDARD_HEIGHT = 9.6;
PLATE_STANDARD_HEIGHT = BRICK_STANDARD_HEIGHT/3;

WALL_THICKNESS = 1.2;

FINE = 40;

function radius(diameter) = diameter / 2;

function knob_top_radius() = radius(KNOB_TOP_DIAMETER);


module knob_top() {
 	height = 1.8;
 	radius = knob_top_radius();
  	cylinder(h = height, r = radius, $fn=FINE);
}

module knob_bottom(height=BRICK_STANDARD_HEIGHT) {
	knob_bottom_exterior_radius = radius(KNOB_BOTTOM_DIAMETER);
	knob_bottom_interior_radius = knob_top_radius() + TOLERANCE;
  	difference() {
    	cylinder(h=height, r=knob_bottom_exterior_radius);
    	cylinder(h=height, r=knob_bottom_interior_radius, $fn=FINE);
  	}
}

module beam_bottom_cylinder(height=BRICK_STANDARD_HEIGHT) {
	radius = radius(BEAM_BOTTOM_CYLINDER_DIAMETER);
  	cylinder(h=height, r=radius);
}

module walls(width, depth, height=BRICK_STANDARD_HEIGHT) {
	double_wall_thickness = WALL_THICKNESS * 2;

	outer_cube_dimensions = [width, depth, height];
	inner_cube_dimensions = [width-double_wall_thickness, depth-double_wall_thickness, height-WALL_THICKNESS];

  	difference() {
    	cube(outer_cube_dimensions);
    	translate([WALL_THICKNESS, WALL_THICKNESS, 0])
    	cube(inner_cube_dimensions);
	}
}

function offset_for_top_knobs(index) = (index*2-1) * HALF_HORIZONTAL_KNOB_SEPARATION;

module place_top_knobs(cols, rows, height) {

	for (j = [1:rows]) {
		for (i = [1:cols]) {
			assign (offset_x = offset_for_top_knobs(i), offset_y = offset_for_top_knobs(j))
			{
				translate([offset_x, offset_y, height])
					knob_top();
			}
		}
	}
}

module place_bottom_knobs(cols, rows, height) {
	if ((cols > 1) && (rows > 1)) {
		for (j = [1:rows-1]) {
			for (i = [1:cols-1]) {
				translate([HORIZONTAL_KNOB_SEPARATION*i, HORIZONTAL_KNOB_SEPARATION*j, 0])
					knob_bottom(height);
			}
		}
	}	
}

module create_walls(cols, rows, height) {
	double_tolerance = 2 * TOLERANCE;

	width = cols*HORIZONTAL_KNOB_SEPARATION - double_tolerance;
  	depth = rows*HORIZONTAL_KNOB_SEPARATION - double_tolerance;
  
  	walls(width, depth, height);
}

module place_beam_bottom_cilynder_horizontally (cols, height) {
	rows = 1;
	if (cols > 1) {
		for (i = [1:cols-1]) {
        	translate([HORIZONTAL_KNOB_SEPARATION*i, HORIZONTAL_KNOB_SEPARATION/2, 0])
        		beam_bottom_cylinder(height);
		}
  	}
}

module place_beam_bottom_cilynder_vertically (rows, height) {
	cols = 1;
	if (rows > 1) {
		for (j = [1:rows-1]) {
      		translate([HORIZONTAL_KNOB_SEPARATION/2, HORIZONTAL_KNOB_SEPARATION*j, 0])
      			beam_bottom_cylinder(height);
    	}
  	}
}

module build_brick(cols, rows, height) {

	create_walls(cols, rows, height);

  	place_top_knobs(cols, rows, height);

	place_beam_bottom_cilynder_horizontally(cols, height);

	place_beam_bottom_cilynder_vertically (rows, height);
	
	place_bottom_knobs(cols, rows, height);
}

module beam(cols) {
  build_brick(cols, 1, BRICK_STANDARD_HEIGHT);
}

module brick(cols) {
  build_brick(cols, 2, BRICK_STANDARD_HEIGHT);
}

module plate(cols, rows) {
  build_brick(cols, rows, PLATE_STANDARD_HEIGHT);
}

module create_lego_pieces() {
	brick(2);

	translate([-20, 0, 0])
		plate(1,1);

	translate([-20, 10, 0])
		beam(1);

	translate([20, 0, 0])
		brick(4);

	translate([0, 20, 0])
		beam(5);

	translate([0, 30, 0])
		plate(2, 2);

	translate([0, -70, 0])
		plate(10, 8);

	translate([-10, 0, 0])
		plate(1, 10);

	translate([-40, -40, 0])
		plate(3, 5);
}

create_lego_pieces();