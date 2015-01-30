// building Lego bricks - rdavis.bacs@gmail.com
// measurements taken from: 
//   http://www.robertcailliau.eu/Lego/Dimensions/zMeasurements-en.xhtml
// all copyrights and designs are property of their respective owners.

h_pitch = 8.0;   // horizontal unit
v_pitch = 9.6;   // vertical unit

TOLERANCE = 0.1;

KNOB_TOP_DIAMETER = 4.8;
KNOB_BOTTOM_DIAMETER = 6.5137;
BEAM_BOTTOM_CYLINDER_DIAMETER = 3.0;

WALL_THICKNESS = 1.2;

FINE = 40;

function radius(diameter) = diameter / 2;

function knob_top_radius() = radius(KNOB_TOP_DIAMETER);

module knob_top() {
 	height = 1.8;
 	radius = radius(KNOB_TOP_DIAMETER);
  	cylinder(h = height, r = radius, $fn=FINE);
}

module knob_bottom(height=v_pitch) {
	knob_bottom_exterior_radius = radius(KNOB_BOTTOM_DIAMETER);
	knob_bottom_interior_radius = knob_top_radius() + TOLERANCE;
  	difference() {
    	cylinder(h=height, r=knob_bottom_exterior_radius);
    	cylinder(h=height, r=knob_bottom_interior_radius, $fn=FINE);
  	}
}

module beam_bottom_cylinder(height=v_pitch) {
	radius = radius(BEAM_BOTTOM_CYLINDER_DIAMETER);
  	cylinder(h=height, r=radius);
}

module walls(w, d, height=v_pitch) {
  difference() {
    cube([w, d, height]);
    translate([WALL_THICKNESS, WALL_THICKNESS, 0])
    cube([w-2*WALL_THICKNESS, d-2*WALL_THICKNESS, height-WALL_THICKNESS]);
  }
}

module build_brick(col, row, height) {
  // builds a Lego brick based on the number of knobs
  width = col*h_pitch - 2*TOLERANCE;
  depth = row*h_pitch - 2*TOLERANCE;
  
  // build walls
  walls(width, depth, height);

  // place knobs
  for (j = [1:row]) {
    for (i = [1:col]) {
      translate([(2*i-1)*h_pitch/2, (2*j-1)*h_pitch/2, height])
      knob_top();
    }
  }

  // internal cylinders
  if (row == 1) {
    if (col > 1) {
      for (i = [1:col-1]) {
        translate([h_pitch*i, h_pitch/2, 0])
        beam_bottom_cylinder(height);
      }
    }
  } else if (col == 1) {
    for (j = [1:row-1]) {
      translate([h_pitch/2, h_pitch*j, 0])
      beam_bottom_cylinder(height);
    }

  } else {
    for (j = [1:row-1]) {
      for (i = [1:col-1]) {
        translate([h_pitch*i, h_pitch*j, 0])
        knob_bottom(height);
      }
    }
  }
}

module beam(k) {
  build_brick(k, 1, v_pitch);
}

module brick(k) {
  build_brick(k, 2, v_pitch);
}

module plate(col, row) {
  build_brick(col, row, v_pitch/3);
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