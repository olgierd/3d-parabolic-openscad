// de SQ3SWF 2020

$fn=100;

r = 300;            // dish radius, mm
f_d = 0.6;          // focal to diameter ratio

ch = 25;            // center hole radius, mm
thick = 0.8;        // thickness

step = 1;           // surface accuracy, mm
split = 4;          // split into x parts

mark_focal = 1;     // draws a sphere in focal point
                    // set to 0 when generating STL

///////////////////////////////////////////////

f = f_d*2*r;    // focal length
a = 1/(4*f);    // parabola coefficient
depth = a*r*r;  // dish depth

rotate_extrude(angle=360/split) {
    v = [for (x = ch; x<=r; x=x+step) [ x, a*x*x ] ];
    w = [for (x = r; x>=ch; x=x-step) [ x, a*x*x-thick ] ];
    polygon(concat(v,w));
}

if(mark_focal == 1) {
    translate([0,0,f]) color("red") sphere(d=10);
}

echo("Focal (mm)", f);
echo("Depth (mm)", depth);
echo("F/d", f_d);
echo("a", a);
