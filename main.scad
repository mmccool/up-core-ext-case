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
core_z = 2.54;
core_r = 3;
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

// model of base case (not for printing...)
module case() {
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
  translate([0,0,case_h-case_p-core_z])
    rcube(core_x-2*core_r,core_y-2*core_r,core_z,core_r,core_sm);
}

module assembly() {
  case();
  //core();
}

assembly();

// 3d printing

// laser cutting (export as DXF, then import to inkscape and convert to PDF)
//shelf_plate();

