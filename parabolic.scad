// de SQ3SWF 2020

$fn=100;

r = 200;            // dish radius, mm
f_d = 0.6;          // focal to diameter ratio

ch = 11;            // center hole radius, mm
thick = 0.8;        // thickness

step = 1;           // surface accuracy, mm
split = 4;          // split into x parts

h_pos=[15,110,194]; // position of the holes
h_dia=3.5;          // hole diameter         
h_edge_dist=4;      // distance from center of the hole to edge

mark_focal = 0;     // draws a sphere in focal point
                    // set to 0 when generating STL                    

cl_rim = 1;         // clip rim
cl_clear = 0.1;     // clip pin clearance gap
cl_hei = 4;         // clip pin height

///////////////////////////////////////////////

f = f_d*2*r;    // focal length
a = 1/(4*f);    // parabola coefficient

echo("Focal (mm)", f);
echo("Depth (mm)", a*r*r);
echo("F/d", f_d);
echo("a", a);

module dish() {
    rotate_extrude(angle=360/split) {
        v = [for (x = ch; x<=r; x=x+step) [ x, a*x*x ] ];
        w = [for (x = r; x>=ch; x=x-step) [ x, a*x*x-thick ] ];
        polygon(concat(v,w));
    }
}

module conn_holes(edge_dist, pos, dia) {
    for(dist = h_pos, side=[0,1]) {
        rotate([0,0,360/split*side])
        translate([dist,-(2*side-1)*h_edge_dist,a*dist*dist])
        rotate([0,atan2(-2*a*dist,1),0])
        cylinder(d=h_dia, h=2*thick, center=true);
    }
}

module dish_holes() {
    difference() {
        dish();
        conn_holes();
    }
}



if(mark_focal == 1) {
    translate([0,0,f]) color("red") sphere(d=10);
}

//dish_holes();

////////////////////////////////// clip(s)

module clip() {
    hull() {
        for(x=[-1,1]) {
            translate([h_edge_dist*x, 0, 0])
            cylinder(d=h_dia+cl_rim*2, h=1);
        }
    }

    for(x=[-1,1]) {
        translate([h_edge_dist*x, 0, 0])
        cylinder(d=h_dia-cl_clear*2, h=cl_hei);
    }

}

//clip();

module pin() {
    difference() {
        hull() {
            cylinder(d=h_dia, h=0.01);

            for(x=[-1,1])
                translate([x/3,0,3])
            cylinder(d=h_dia, h=0.01);
            translate([0,0,6])
            cylinder(d=h_dia, h=0.01);
        }
        
        
    }
}

pin();