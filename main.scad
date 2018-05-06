// UP Core Extension Case
// Developed by: Michael McCool
// Copyright 2018 Michael McCpp;
// License: CC BY 3.0. See LICENSE.md
include <tols.scad>
include <smooth_model.scad>
//include <smooth_make.scad>
include <bolt_params.scad>
use <bolts.scad>

core_x = 65;
core_y = 55;
core_z = 2;
core_r = 3;
core_s = 0.2;
core_sm = 2*sm_base;

case_p = 3.66; // recess from top lip

case_x = 75.85;
case_y = 72;
case_z = 22.45;
case_h = 9.5;
case_r = 7;
case_lt = 1.3;
case_lh = 1.25;
case_t = 4.2;

case_sm = 4*sm_base;

bolt_x = 58;
bolt_y = 49;
bolt_ox = 8.7;
bolt_oy = 7.62;

standoff_h = 5.5;
standoff_r = (4/2)/cos(30);

module rcube(x,y,z,r,sm) {
  hull() {
    translate([-x/2,-y/2,0])
      cylinder(r=r,h=z,$fn=sm);
    translate([ x/2,-y/2,0])
      cylinder(r=r,h=z,$fn=sm);
    translate([-x/2, y/2,0])
      cylinder(r=r,h=z,$fn=sm);
    translate([ x/2, y/2,0])
      cylinder(r=r,h=z,$fn=sm);
  }
}

module standoff(r=standoff_r,h=standoff_h) {
  color([0.9,0.9,0.9,1])
  cylinder(r=r,h=h,$fn=6);
}
module standoffs() {
  translate([-case_x/2+bolt_ox,-case_y/2+bolt_oy,case_z-case_p])
    standoff();
  translate([bolt_x-case_x/2+bolt_ox,-case_y/2+bolt_oy,case_z-case_p])
    standoff();
  translate([-case_x/2+bolt_ox,bolt_y-case_y/2+bolt_oy,case_z-case_p])
    standoff();
  translate([bolt_x-case_x/2+bolt_ox,bolt_y-case_y/2+bolt_oy,case_z-case_p])
    standoff();
}

// model of base case (not for printing...)
module case() {
  color([0.5,0.5,0.5,1])
  difference() {
    rcube(case_x-2*case_r,case_y-2*case_r,case_z,case_r,case_sm);
    translate([0,0,case_h])
      rcube(case_x-2*case_r,case_y-2*case_r,case_z,case_r-case_t,case_sm);
    difference() {
      translate([0,0,case_z-case_lh])
        rcube(case_x-2*case_r,case_y-2*case_r,case_z,case_r-case_lt,case_sm);
      translate([0,0,case_z-case_lh])
        rcube(case_x-2*case_r,case_y-2*case_r,case_z,case_r-case_t+case_lt,case_sm);
    }
  }
}

module core() {
  color([0,0.5,0,1])
    translate([0,core_y/2-case_y/2+case_t+core_s,case_z-case_p-core_z])
      rcube(core_x-2*core_r,core_y-2*core_r,core_z,core_r,core_sm);
}

module assembly() {
  case();
  core();
  standoffs();
}

assembly();

// 3d printing

// laser cutting (export as DXF, then import to inkscape and convert to PDF)
//shelf_plate();

