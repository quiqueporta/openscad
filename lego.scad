// building Lego bricks - rdavis.bacs@gmail.com
// measurements taken from: 
//   http://www.robertcailliau.eu/Lego/Dimensions/zMeasurements-en.xhtml
// all copyrights and designs are property of their respective owners.

TOLERANCE = 0.1;

KNOB_TOP_DIAMETER = 4.8;
KNOB_BOTTOM_DIAMETER = 6.5137;
BEAM_BOTTOM_CYLINDER_DIAMETER = 3.0;

HORIZONTAL_KNOB_SEPARATION = 8.0;

BRICK_STANDARD_HEIGHT = 9.6;

WALL_THICKNESS = 1.2;

FINE = 40;

function radius(diameter) = diameter / 2;

function knob_top_radius() = radius(KNOB_TOP_DIAMETER);

module knob_top() {
 	height = 1.8;
 	radius = radius(KNOB_TOP_DIAMETER);
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

	offset_x = WALL_THICKNESS;
	offset_y = WALL_THICKNESS;
	height = 0;
	offset = [offset_x, offset_y, height];

  	difference() {
    	cube(outer_cube_dimensions);
    	translate(offset)
    	cube(inner_cube_dimensions);
	}
}

module place_knobs(col, row, height) {
	for (j = [1:row]) {
		for (i = [1:col]) {
			translate([(2*i-1)*HORIZONTAL_KNOB_SEPARATION/2, (2*j-1)*HORIZONTAL_KNOB_SEPARATION/2, height])
			knob_top();
		}
	}
}

module build_brick(col, row, height) {

	double_tolerance = 2*TOLERANCE;

	width = col*HORIZONTAL_KNOB_SEPARATION - double_tolerance;
  	depth = row*HORIZONTAL_KNOB_SEPARATION - double_tolerance;
  
  	walls(width, depth, height);

  	place_knobs(col, row, height);

  // internal cylinders
  if (row == 1) {
    if (col > 1) {
      for (i = [1:col-1]) {
        translate([HORIZONTAL_KNOB_SEPARATION*i, HORIZONTAL_KNOB_SEPARATION/2, 0])
        beam_bottom_cylinder(height);
      }
    }
  } else if (col == 1) {
    for (j = [1:row-1]) {
      translate([HORIZONTAL_KNOB_SEPARATION/2, HORIZONTAL_KNOB_SEPARATION*j, 0])
      beam_bottom_cylinder(height);
    }

  } else {
    for (j = [1:row-1]) {
      for (i = [1:col-1]) {
        translate([HORIZONTAL_KNOB_SEPARATION*i, HORIZONTAL_KNOB_SEPARATION*j, 0])
        knob_bottom(height);
      }
    }
  }
}

module beam(k) {
  build_brick(k, 1, BRICK_STANDARD_HEIGHT);
}

module brick(k) {
  build_brick(k, 2, BRICK_STANDARD_HEIGHT);
}

module plate(col, row) {
  build_brick(col, row, BRICK_STANDARD_HEIGHT/3);
}


// let's build some parts!
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