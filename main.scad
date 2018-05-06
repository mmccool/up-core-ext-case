// UP Core Extension Case
// Developed by: Michael McCool
// Copyright 2018 Michael McCpp;
// License: CC BY 3.0. See LICENSE.md
include <tols.scad>
include <smooth_model.scad>
//include <smooth_make.scad>
include <bolt_params.scad>
use <bolts.scad>

case_x = 75.85;
case_y = 72;
case_z = 22.45;
case_r = 5;
case_sm = 4*sm_base;

module rcube(x,y,z,r,sm) {
  hull() {
    translate([-x/2+r,-y/2+r,0])
      cylinder(r=r,h=z,$fn=sm);
    translate([ x/2-r,-y/2+r,0])
      cylinder(r=r,h=z,$fn=sm);
    translate([-x/2+r, y/2-r,0])
      cylinder(r=r,h=z,$fn=sm);
    translate([ x/2-r, y/2-r,0])
      cylinder(r=r,h=z,$fn=sm);
  }
}

// model of base case (not for printing...)
module case() {
  difference() {
    rcube(case_x,case_y,case_z,case_r,case_sm);
  }
}

module assembly() {
  case();
}

assembly();

// 3d printing

// laser cutting (export as DXF, then import to inkscape and convert to PDF)
//shelf_plate();

