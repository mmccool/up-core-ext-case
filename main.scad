// UP Core Extension Case
// Developed by: Michael McCool
// Copyright 2018 Michael McCpp;
// License: CC BY 3.0. See LICENSE.md
include <tols.scad>
//include <smooth_model.scad>
include <smooth_make.scad>
include <bolt_params.scad>
use <bolts.scad>

sleeve_tol = 0.2;

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

camera_x = 39;
camera_y = 39;
camera_cx = 16;
camera_cy = 16;
camera_ch = 10.5;
camera_cr = 1;
camera_bx = 28;
camera_by = 28;
camera_br = m2_hole_radius; // M2
camera_nr = m2_nut_radius + 0.2;
camera_rr = 2;
camera_sx = 20;
camera_sy = 20;
camera_sr = 5/2;
camera_h = 12.5;
camera_r = 14/2;
camera_ie = 1;
camera_ir = m2_hole_radius;
camera_inr = m2_nut_radius + 0.2;
camera_tol = 0.2;
camera_sm = 4*sm_base;

sleeve_u = 3;
sleeve_n = 6;
sleeve_z = (sleeve_u+1)*sleeve_n;
sleeve_sm = 4*sm_base;
top_taper = 0.5;
insert_e = tol;
insert_wr = 3;
insert_wh = 1;


case_sbr = m2_5_hole_radius + 0.1;
case_shr = 4.4/2+0.2;
case_st = 1;
case_sth = 1.3;

// 16 neopixel ring
ring_r = 31.7/2 - tol;
ring_R = 44.5/2 + tol;
//ring_h = 6.7 + tol;
ring_h = 3.25 + tol;
ring_sm = 4*sm_base;

insert_sh = 4;

module ring(r=ring_r,R=ring_R,h=ring_h,sm=ring_sm,r_tol=0,h_tol=0) {
  difference() {
    cylinder(r=R+r_tol,h=h+h_tol,$fn=sm);
    translate([0,0,-1]) cylinder(r=r-r_tol,h=h+h_tol+2,$fn=sm);
  }
}

// 8 neopixel stick
stick_x = 51.10 + tol;
stick_y = 3.23 + tol;
stick_z = 10.22 + tol;
stick_s = 25.3; // hole separation
stick_r = 2.7/2; // hole radius in stick
stick_br = 2/2; // bolt radius (for mounting hole, self-threading)
stick_e = 2; // hole inset
stick_d = 5;
stick_wr = 5/2; // wiring relief radius
stick_we = 3; // wiring inset
stick_sm = 4*sm_base;
stick_inverted = false;

module stick(x=stick_x,y=stick_y,z=stick_z,x_tol=0,y_tol=0,z_tol=0) {
  difference() {
    translate([-x/2-x_tol,-y_tol,-z_tol]) 
      cube([x+2*x_tol,y+2*y_tol,z+2*z_tol]);
    if (stick_inverted) {
      translate([-stick_s/2,-1,stick_z-stick_e])
        rotate([-90,0,0])
          cylinder(r=stick_r,h=stick_y+2,$fn=stick_sm);
      translate([ stick_s/2,-1,stick_z-stick_e])
        rotate([-90,0,0])
          cylinder(r=stick_r,h=stick_y+2,$fn=stick_sm);
    } else {
      translate([-stick_s/2,-1,stick_e])
        rotate([-90,0,0])
          cylinder(r=stick_r,h=stick_y+2,$fn=stick_sm);
      translate([ stick_s/2,-1,stick_e])
        rotate([-90,0,0])
          cylinder(r=stick_r,h=stick_y+2,$fn=stick_sm);
    }
  }
}

module rcube(x,y,z,r,sm,tt=top_taper) {
  hull() {
    translate([-x/2,-y/2,z-tt-eps])
      cylinder(r1=r,r2=r-tt,h=tt+eps,$fn=sm);
    translate([ x/2,-y/2,z-tt-eps])
      cylinder(r1=r,r2=r-tt,h=tt+eps,$fn=sm);
    translate([-x/2, y/2,z-tt-eps])
      cylinder(r1=r,r2=r-tt,h=tt+eps,$fn=sm);
    translate([ x/2, y/2,z-tt-eps])
      cylinder(r1=r,r2=r-tt,h=tt+eps,$fn=sm);
  }
  hull() {
    translate([-x/2,-y/2,0])
      cylinder(r=r,h=z-tt,$fn=sm);
    translate([ x/2,-y/2,0])
      cylinder(r=r,h=z-tt,$fn=sm);
    translate([-x/2, y/2,0])
      cylinder(r=r,h=z-tt,$fn=sm);
    translate([ x/2, y/2,0])
      cylinder(r=r,h=z-tt,$fn=sm);
  }
}

module standoff(r=standoff_r,h=standoff_h) {
  color([0.9,0.9,0.9,1])
  difference() {
    cylinder(r=r,h=h,$fn=6);
    translate([0,0,-tol])
      cylinder(r=m2_5_thread_radius,h=h+2*tol,$fn=10);
  }
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
    rcube(case_x-2*case_r,case_y-2*case_r,case_z,case_r,case_sm,0);
    translate([0,0,case_h])
      rcube(case_x-2*case_r,case_y-2*case_r,case_z,case_r-case_t,case_sm,0);
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

insert_x = case_x-2*case_t-2*sleeve_tol;
insert_y = case_y-2*case_t-2*sleeve_tol;
module insert() {
  color([0.5,0,0,1])
  translate([0,0,case_z+standoff_h-case_p]) {
    difference() {
      rcube(case_x-2*case_r,case_y-2*case_r,sleeve_z-sleeve_u-standoff_h+case_p-insert_e,case_r-case_t-sleeve_tol,case_sm);
      // cutout for ring
      translate([0,0,sleeve_z-sleeve_u-ring_h-standoff_h+case_p]) ring(r_tol=tol);
      // wiring holes for ring
      for (i=[0:15]) {
        rotate((i-0.5)*360/16) 
          translate([ring_R-2,0,sleeve_z-sleeve_u-ring_h-standoff_h+case_p-10]) 
            cylinder(r=1,h=20,$fn=4*sm_base);
      }
      // cutout for sticks
      hull() {
        translate([0,insert_y/2-stick_y,-standoff_h+case_p+sleeve_z-sleeve_u-stick_z-tol]) 
          stick(x_tol=10,y_tol=tol,z_tol=tol);
        translate([0,insert_y/2+tol,-standoff_h+case_p+sleeve_z-sleeve_u-stick_z-tol]) 
          stick(x_tol=10,y_tol=tol,z_tol=stick_y);
      }
      hull() {
        translate([0,-insert_y/2,-standoff_h+case_p+sleeve_z-sleeve_u-stick_z-tol]) 
          stick(x_tol=10,y_tol=tol,z_tol=tol);
        translate([0,-insert_y/2-stick_y-tol,-standoff_h+case_p+sleeve_z-sleeve_u-stick_z-tol]) 
          stick(x_tol=10,y_tol=tol,z_tol=stick_y);
      }
      hull() {
        translate([insert_x/2,0,-standoff_h+case_p+sleeve_z-sleeve_u-stick_z-tol]) 
          rotate(90) 
            stick(x_tol=10,y_tol=tol,z_tol=tol);
        translate([insert_x/2+stick_y+tol,0,-standoff_h+case_p+sleeve_z-sleeve_u-stick_z-tol]) 
          rotate(90) 
            stick(x_tol=10,y_tol=tol,z_tol=stick_y);
      }
      hull() {
        translate([-insert_x/2+stick_y,0,-standoff_h+case_p+sleeve_z-sleeve_u-stick_z-tol]) 
          rotate(90) 
            stick(x_tol=10,y_tol=tol,z_tol=tol);
        translate([-insert_x/2-tol,0,-standoff_h+case_p+sleeve_z-sleeve_u-stick_z-tol]) 
          rotate(90) 
            stick(x_tol=10,y_tol=tol,z_tol=stick_y);
      }
      // mounting holes for sticks, non-inverted
      translate([-stick_s/2,insert_y/2-stick_y+1,
                 -standoff_h+case_p+sleeve_z-sleeve_u-stick_z-tol+stick_e]) 
        rotate([90,0,0]) cylinder(r=stick_br,h=stick_d+1,$fn=stick_sm);
      translate([ stick_s/2,insert_y/2-stick_y+1,
                 -standoff_h+case_p+sleeve_z-sleeve_u-stick_z-tol+stick_e]) 
        rotate([90,0,0]) cylinder(r=stick_br,h=stick_d+1,$fn=stick_sm);

      translate([-stick_s/2,-insert_y/2+stick_y-1,
                 -standoff_h+case_p+sleeve_z-sleeve_u-stick_z-tol+stick_e]) 
        rotate([-90,0,0]) cylinder(r=stick_br,h=stick_d+1,$fn=stick_sm);
      translate([ stick_s/2,-insert_y/2+stick_y-1,
                 -standoff_h+case_p+sleeve_z-sleeve_u-stick_z-tol+stick_e]) 
        rotate([-90,0,0]) cylinder(r=stick_br,h=stick_d+1,$fn=stick_sm);

      translate([insert_x/2-stick_y+1,-stick_s/2,
                 -standoff_h+case_p+sleeve_z-sleeve_u-stick_z-tol+stick_e])
        rotate([0,-90,0]) cylinder(r=stick_br,h=stick_d+1,$fn=stick_sm);
      translate([insert_x/2-stick_y+1, stick_s/2,
                 -standoff_h+case_p+sleeve_z-sleeve_u-stick_z-tol+stick_e])
        rotate([0,-90,0]) cylinder(r=stick_br,h=stick_d+1,$fn=stick_sm);

      translate([-insert_x/2+stick_y-1,-stick_s/2,
                 -standoff_h+case_p+sleeve_z-sleeve_u-stick_z-tol+stick_e]) 
        rotate([0,90,0]) cylinder(r=stick_br,h=stick_d+1,$fn=stick_sm);
      translate([-insert_x/2+stick_y-1, stick_s/2,
                 -standoff_h+case_p+sleeve_z-sleeve_u-stick_z-tol+stick_e]) 
        rotate([0,90,0]) cylinder(r=stick_br,h=stick_d+1,$fn=stick_sm);
      // mounting holes for sticks, inverted
      translate([-stick_s/2,insert_y/2-stick_y+1,
                 -standoff_h+case_p+sleeve_z-sleeve_u-stick_z-tol+stick_z-stick_e]) 
        rotate([90,0,0]) cylinder(r=stick_br,h=stick_d+1,$fn=stick_sm);
      translate([ stick_s/2,insert_y/2-stick_y+1,
                 -standoff_h+case_p+sleeve_z-sleeve_u-stick_z-tol+stick_z-stick_e]) 
        rotate([90,0,0]) cylinder(r=stick_br,h=stick_d+1,$fn=stick_sm);

      translate([-stick_s/2,-insert_y/2+stick_y-1,
                 -standoff_h+case_p+sleeve_z-sleeve_u-stick_z-tol+stick_z-stick_e]) 
        rotate([-90,0,0]) cylinder(r=stick_br,h=stick_d+1,$fn=stick_sm);
      translate([ stick_s/2,-insert_y/2+stick_y-1,
                 -standoff_h+case_p+sleeve_z-sleeve_u-stick_z-tol+stick_z-stick_e]) 
        rotate([-90,0,0]) cylinder(r=stick_br,h=stick_d+1,$fn=stick_sm);

      translate([insert_x/2-stick_y+1,-stick_s/2,
                 -standoff_h+case_p+sleeve_z-sleeve_u-stick_z-tol+stick_z-stick_e])
        rotate([0,-90,0]) cylinder(r=stick_br,h=stick_d+1,$fn=stick_sm);
      translate([insert_x/2-stick_y+1, stick_s/2,
                 -standoff_h+case_p+sleeve_z-sleeve_u-stick_z-tol+stick_z-stick_e])
        rotate([0,-90,0]) cylinder(r=stick_br,h=stick_d+1,$fn=stick_sm);

      translate([-insert_x/2+stick_y-1,-stick_s/2,
                 -standoff_h+case_p+sleeve_z-sleeve_u-stick_z-tol+stick_z-stick_e]) 
        rotate([0,90,0]) cylinder(r=stick_br,h=stick_d+1,$fn=stick_sm);
      translate([-insert_x/2+stick_y-1, stick_s/2,
                 -standoff_h+case_p+sleeve_z-sleeve_u-stick_z-tol+stick_z-stick_e]) 
        rotate([0,90,0]) cylinder(r=stick_br,h=stick_d+1,$fn=stick_sm);
      // wiring access holes for sticks
      translate([-insert_x/2+stick_y, stick_x/2-stick_wr,
                 -standoff_h+case_p+sleeve_z-sleeve_u-stick_z-tol]) {
        cylinder(r=stick_wr,h=sleeve_z,$fn=stick_sm);
        hull() {
          sphere(r=stick_wr,$fn=stick_sm);
          translate([5,0,-5]) sphere(r=stick_wr,$fn=stick_sm);
        }
      }
      translate([-insert_x/2+stick_y,-stick_x/2+stick_wr,
                 -standoff_h+case_p+sleeve_z-sleeve_u-stick_z-tol]) {
        cylinder(r=stick_wr,h=sleeve_z,$fn=stick_sm);
        hull() {
          sphere(r=stick_wr,$fn=stick_sm);
          translate([5,0,-5]) sphere(r=stick_wr,$fn=stick_sm);
        }
      }

      translate([insert_x/2-stick_y, stick_x/2-stick_wr,
                 -standoff_h+case_p+sleeve_z-sleeve_u-stick_z-tol]) {
        cylinder(r=stick_wr,h=sleeve_z,$fn=stick_sm);
        hull() {
          sphere(r=stick_wr,$fn=stick_sm);
          translate([-5,0,-5]) sphere(r=stick_wr,$fn=stick_sm);
        }
      }
      translate([insert_x/2-stick_y,-stick_x/2+stick_wr,
                 -standoff_h+case_p+sleeve_z-sleeve_u-stick_z-tol]) {
        cylinder(r=stick_wr,h=sleeve_z,$fn=stick_sm);
        hull() {
          sphere(r=stick_wr,$fn=stick_sm);
          translate([-5,0,-5]) sphere(r=stick_wr,$fn=stick_sm);
        }
      }

      translate([ stick_x/2-stick_wr,-insert_y/2+stick_y,
                 -standoff_h+case_p+sleeve_z-sleeve_u-stick_z-tol]) {
        cylinder(r=stick_wr,h=sleeve_z,$fn=stick_sm);
        hull() {
          sphere(r=stick_wr,$fn=stick_sm);
          translate([0,5,-5]) sphere(r=stick_wr,$fn=stick_sm);
        }
      }
      translate([-stick_x/2+stick_wr,-insert_y/2+stick_y,
                 -standoff_h+case_p+sleeve_z-sleeve_u-stick_z-tol]) {
        cylinder(r=stick_wr,h=sleeve_z,$fn=stick_sm);
        hull() {
          sphere(r=stick_wr,$fn=stick_sm);
          translate([0,5,-5]) sphere(r=stick_wr,$fn=stick_sm);
        }
      }

      translate([ stick_x/2-stick_wr,insert_y/2-stick_y,
                 -standoff_h+case_p+sleeve_z-sleeve_u-stick_z-tol]) {
        cylinder(r=stick_wr,h=sleeve_z,$fn=stick_sm);
        hull() {
          sphere(r=stick_wr,$fn=stick_sm);
          translate([0,-5,-5]) sphere(r=stick_wr,$fn=stick_sm);
        }
      }
      translate([-stick_x/2+stick_wr,insert_y/2-stick_y,
                 -standoff_h+case_p+sleeve_z-sleeve_u-stick_z-tol]) {
        cylinder(r=stick_wr,h=sleeve_z,$fn=stick_sm);
        hull() {
          sphere(r=stick_wr,$fn=stick_sm);
          translate([0,-5,-5]) sphere(r=stick_wr,$fn=stick_sm);
        }
      }
      // cutout for camera
      translate([0,0,sleeve_z-sleeve_u-camera_ch])
        rcube(camera_cx,camera_cy,camera_ch+5,camera_cr,case_sm);
      // cutouts for "side bumps"
      hull() {
        translate([-camera_sx/2,0,sleeve_z-sleeve_u-camera_ch])
          cylinder(r=camera_sr,h=camera_ch+5,$fn=camera_sm);
        translate([ camera_sx/2,0,sleeve_z-sleeve_u-camera_ch])
          cylinder(r=camera_sr,h=camera_ch+5,$fn=camera_sm);
      }
      hull() {
        translate([0,-camera_sy/2,sleeve_z-sleeve_u-camera_ch])
          cylinder(r=camera_sr,h=camera_ch+5,$fn=camera_sm);
        translate([0, camera_sy/2,sleeve_z-sleeve_u-camera_ch])
          cylinder(r=camera_sr,h=camera_ch+5,$fn=camera_sm);
      }
      hull() {
        translate([-camera_sx/2-2*camera_br,0,sleeve_z-sleeve_u-camera_ch])
          cylinder(r=camera_sr,h=0.3*camera_ch,$fn=camera_sm);
        translate([ camera_sx/2+2*camera_br,0,sleeve_z-sleeve_u-camera_ch])
          cylinder(r=camera_sr,h=0.3*camera_ch,$fn=camera_sm);
      }
      hull() {
        translate([0,-camera_sy/2-2*camera_br,sleeve_z-sleeve_u-camera_ch])
          cylinder(r=camera_sr,h=0.3*camera_ch,$fn=camera_sm);
        translate([0, camera_sy/2+2*camera_br,sleeve_z-sleeve_u-camera_ch])
          cylinder(r=camera_sr,h=0.3*camera_ch,$fn=camera_sm);
      }
      // cutout for camera mounting bolts
      translate([-camera_bx/2,-camera_by/2,sleeve_z-sleeve_u-camera_ch])
        cylinder(r=camera_br,h=camera_ch+5,$fn=camera_sm);
      translate([ camera_bx/2,-camera_by/2,sleeve_z-sleeve_u-camera_ch])
        cylinder(r=camera_br,h=camera_ch+5,$fn=camera_sm);
      translate([-camera_bx/2, camera_by/2,sleeve_z-sleeve_u-camera_ch])
        cylinder(r=camera_br,h=camera_ch+5,$fn=camera_sm);
      translate([ camera_bx/2, camera_by/2,sleeve_z-sleeve_u-camera_ch])
        cylinder(r=camera_br,h=camera_ch+5,$fn=camera_sm);
      // camera insert mounting holes
      translate([-camera_x/2+camera_ie,-camera_y/2+camera_ie,sleeve_z-sleeve_u-camera_ch])
        cylinder(r=camera_ir,h=camera_ch+5,$fn=camera_sm);
      translate([ camera_x/2-camera_ie,-camera_y/2+camera_ie,sleeve_z-sleeve_u-camera_ch])
        cylinder(r=camera_ir,h=camera_ch+5,$fn=camera_sm);
      translate([-camera_x/2+camera_ie, camera_y/2-camera_ie,sleeve_z-sleeve_u-camera_ch])
        cylinder(r=camera_ir,h=camera_ch+5,$fn=camera_sm);
      translate([ camera_x/2-camera_ie, camera_y/2-camera_ie,sleeve_z-sleeve_u-camera_ch])
        cylinder(r=camera_ir,h=camera_ch+5,$fn=camera_sm);
      // camera insert mounting holes (nuts)
      translate([-camera_x/2+camera_ie,-camera_y/2+camera_ie,sleeve_z-sleeve_u-camera_ch+insert_sh+2])
        cylinder(r=camera_inr,h=camera_ch+5,$fn=6);
      translate([ camera_x/2-camera_ie,-camera_y/2+camera_ie,sleeve_z-sleeve_u-camera_ch+insert_sh+2])
        cylinder(r=camera_inr,h=camera_ch+5,$fn=6);
      translate([-camera_x/2+camera_ie, camera_y/2-camera_ie,sleeve_z-sleeve_u-camera_ch+insert_sh+2])
        cylinder(r=camera_inr,h=camera_ch+5,$fn=6);
      translate([ camera_x/2-camera_ie, camera_y/2-camera_ie,sleeve_z-sleeve_u-camera_ch+insert_sh+2])
        cylinder(r=camera_inr,h=camera_ch+5,$fn=6);
      // recesses for camera pcb backside clearances (any rotation)
      hull() {
        translate([-camera_bx/2+camera_nr+2*camera_br,-camera_by/2,sleeve_z-sleeve_u-camera_ch])
          cylinder(r=1.3*camera_br,h=0.3*camera_ch,$fn=camera_sm);
        translate([ camera_bx/2-camera_nr-2*camera_br,-camera_by/2,sleeve_z-sleeve_u-camera_ch])
          cylinder(r=1.3*camera_br,h=0.3*camera_ch,$fn=camera_sm);
      }
      hull() {
        translate([-camera_bx/2+camera_nr+2*camera_br, camera_by/2,sleeve_z-sleeve_u-camera_ch])
          cylinder(r=1.3*camera_br,h=0.3*camera_ch,$fn=camera_sm);
        translate([ camera_bx/2-camera_nr-2*camera_br, camera_by/2,sleeve_z-sleeve_u-camera_ch])
          cylinder(r=1.3*camera_br,h=0.3*camera_ch,$fn=camera_sm);
      }
      hull() {
        translate([-camera_bx/2,-camera_by/2+camera_nr+2*camera_br,sleeve_z-sleeve_u-camera_ch])
          cylinder(r=1.3*camera_br,h=0.3*camera_ch,$fn=camera_sm);
        translate([-camera_bx/2, camera_by/2-camera_nr-2*camera_br,sleeve_z-sleeve_u-camera_ch])
          cylinder(r=1.3*camera_br,h=0.3*camera_ch,$fn=camera_sm);
      }
      hull() {
        translate([ camera_bx/2,-camera_by/2+camera_nr+2*camera_br,sleeve_z-sleeve_u-camera_ch])
          cylinder(r=1.3*camera_br,h=0.3*camera_ch,$fn=camera_sm);
        translate([ camera_bx/2, camera_by/2-camera_nr-2*camera_br,sleeve_z-sleeve_u-camera_ch])
          cylinder(r=1.3*camera_br,h=0.3*camera_ch,$fn=camera_sm);
      }
      // cutout for camera mounting nuts
      translate([0,0,5]) {
        translate([-camera_bx/2,-camera_by/2,sleeve_z-sleeve_u-camera_ch-4])
          rotate(15) cylinder(r=camera_nr,h=camera_ch+5,$fn=6);
        translate([ camera_bx/2,-camera_by/2,sleeve_z-sleeve_u-camera_ch-4])
          rotate(-15) cylinder(r=camera_nr,h=camera_ch+5,$fn=6);
        translate([-camera_bx/2, camera_by/2,sleeve_z-sleeve_u-camera_ch-4])
          rotate(-15) cylinder(r=camera_nr,h=camera_ch+5,$fn=6);
        translate([ camera_bx/2, camera_by/2,sleeve_z-sleeve_u-camera_ch-4])
          rotate(15) cylinder(r=camera_nr,h=camera_ch+5,$fn=6);
      }
      // cutout for camera pcb
      translate([0,0,-5]) {
        hull() {
          rcube(camera_x,camera_y,sleeve_z-sleeve_u-camera_ch+5+tol,camera_rr,case_sm,0);
          translate([0,0,0]) rcube(camera_x+3,camera_y+10,insert_wh+8+tol,camera_rr+insert_wr,case_sm,0);
        }
      }
      // cable clearances
      rotate([0,90,0])
        hull() {
          translate([-4,-10,-case_x]) 
            cylinder(r=5,h=2*case_x,$fn=case_sm);
          translate([-4,10,-case_x]) 
            cylinder(r=5,h=2*case_x,$fn=case_sm);
          translate([0,-10,-case_x]) 
            cylinder(r=5,h=2*case_x,$fn=case_sm);
          translate([0,10,-case_x]) 
            cylinder(r=5,h=2*case_x,$fn=case_sm);
        }
      rotate(90) rotate([0,90,0])
        hull() {
          translate([-4,-10,-case_x]) 
            cylinder(r=5,h=2*case_x,$fn=case_sm);
          translate([-4,10,-case_x]) 
            cylinder(r=5,h=2*case_x,$fn=case_sm);
          translate([0,-10,-case_x]) 
            cylinder(r=5,h=2*case_x,$fn=case_sm);
          translate([0,10,-case_x]) 
            cylinder(r=5,h=2*case_x,$fn=case_sm);
        }
      // holes for case mounting bolts
      translate([-case_x/2+bolt_ox,-case_y/2+bolt_oy,-5])
        cylinder(r=case_sbr,h=sleeve_z+10,$fn=sleeve_sm);
      translate([bolt_x-case_x/2+bolt_ox,-case_y/2+bolt_oy,-5])
        cylinder(r=case_sbr,h=sleeve_z+10,$fn=sleeve_sm);
      translate([-case_x/2+bolt_ox,bolt_y-case_y/2+bolt_oy,-5])
        cylinder(r=case_sbr,h=sleeve_z+10,$fn=sleeve_sm);
      translate([bolt_x-case_x/2+bolt_ox,bolt_y-case_y/2+bolt_oy,-5])
        cylinder(r=case_sbr,h=sleeve_z+10,$fn=sleeve_sm);
      // holes for case mounting bolt caps (tapered)
      translate([-case_x/2+bolt_ox,-case_y/2+bolt_oy,case_st])
        cylinder(r1=case_sbr,r2=case_shr,h=case_sth+tol,$fn=sleeve_sm);
      translate([bolt_x-case_x/2+bolt_ox,-case_y/2+bolt_oy,case_st])
        cylinder(r1=case_sbr,r2=case_shr,h=case_sth+tol,$fn=sleeve_sm);
      translate([-case_x/2+bolt_ox,bolt_y-case_y/2+bolt_oy,case_st])
        cylinder(r1=case_sbr,r2=case_shr,h=case_sth+tol,$fn=sleeve_sm);
      translate([bolt_x-case_x/2+bolt_ox,bolt_y-case_y/2+bolt_oy,case_st])
        cylinder(r1=case_sbr,r2=case_shr,h=case_sth+tol,$fn=sleeve_sm);
      // access holes for case mounting bolts
      hull() {
        translate([-case_x/2+bolt_ox,-case_y/2+bolt_oy,case_st+case_sth])
          cylinder(r=case_shr,h=sleeve_z+10,$fn=sleeve_sm);
        translate([-case_x/2+bolt_ox,-10-case_y/2+bolt_oy,case_st+case_sth])
          cylinder(r=case_shr,h=sleeve_z+10,$fn=sleeve_sm);
      }
      hull() {
        translate([bolt_x-case_x/2+bolt_ox,-case_y/2+bolt_oy,case_st+case_sth])
          cylinder(r=case_shr,h=sleeve_z+10,$fn=sleeve_sm);
        translate([bolt_x-case_x/2+bolt_ox,-10-case_y/2+bolt_oy,case_st+case_sth])
          cylinder(r=case_shr,h=sleeve_z+10,$fn=sleeve_sm);
      }
      hull() {
        translate([-case_x/2+bolt_ox,bolt_y-case_y/2+bolt_oy,case_st+case_sth])
          cylinder(r=case_shr,h=sleeve_z+10,$fn=sleeve_sm);
        translate([-10-case_x/2+bolt_ox,bolt_y-case_y/2+bolt_oy,case_st+case_sth])
          cylinder(r=case_shr,h=sleeve_z+10,$fn=sleeve_sm);
      }
      hull() {
        translate([bolt_x-case_x/2+bolt_ox,bolt_y-case_y/2+bolt_oy,case_st+case_sth])
          cylinder(r=case_shr,h=sleeve_z+10,$fn=sleeve_sm);
        translate([10+bolt_x-case_x/2+bolt_ox,bolt_y-case_y/2+bolt_oy,case_st+case_sth])
          cylinder(r=case_shr,h=sleeve_z+10,$fn=sleeve_sm);
      }
      // MCU clearance
      hull() {
        translate([-case_x/2+bolt_ox,case_y/2-bolt_oy,-5])
          cylinder(r=case_sbr,h=10,$fn=sleeve_sm);
        translate([-case_x/2+bolt_ox,case_y/2-bolt_oy,-5+10])
          sphere(r=case_sbr,$fn=sleeve_sm);
        translate([bolt_x-case_x/2+bolt_ox,case_y/2-bolt_oy,-5])
          cylinder(r=case_sbr,h=10,$fn=sleeve_sm);
        translate([bolt_x-case_x/2+bolt_ox,case_y/2-bolt_oy,-5+10])
          sphere(r=case_sbr,$fn=sleeve_sm);
        translate([-case_x/2+bolt_ox,case_y/2-bolt_oy-4,-5])
          cylinder(r=case_sbr,h=10,$fn=sleeve_sm);
        translate([-case_x/2+bolt_ox,case_y/2-bolt_oy-4,-5+12])
          sphere(r=case_sbr,$fn=sleeve_sm);
        translate([bolt_x-case_x/2+bolt_ox,case_y/2-bolt_oy-4,-5])
          cylinder(r=case_sbr,h=10,$fn=sleeve_sm);
        translate([bolt_x-case_x/2+bolt_ox,case_y/2-bolt_oy-4,-5+12])
          sphere(r=case_sbr,$fn=sleeve_sm);
      }
    }
  }
}

module sleeve() {
  color([1,1,1,1])
  difference() {
    translate([0,0,case_z])
      rcube(case_x-2*case_r,case_y-2*case_r,sleeve_z,case_r,case_sm);
    // insert
    translate([0,0,case_z-sleeve_u])
      rcube(case_x-2*case_r,case_y-2*case_r,sleeve_z,case_r-case_t,case_sm,0);
    // hole for camera lens
    cylinder(r=camera_r + camera_tol,h=case_z+sleeve_z+5,$fn=camera_sm);
  }
}

module assembly() {
  //translate([0,0,-tol]) case();
  //core();
  //translate([0,0,-2*tol]) standoffs();
  //sleeve();
  translate([0,0,-tol]) insert();
  translate([0,0,case_z+sleeve_z-sleeve_u-ring_h]) ring();
  //translate([0,insert_y/2-stick_y,case_z+sleeve_z-sleeve_u-stick_z-tol]) stick();
  //translate([0,-insert_y/2,case_z+sleeve_z-sleeve_u-stick_z-tol]) stick();
  //translate([insert_x/2,0,case_z+sleeve_z-sleeve_u-stick_z-tol]) rotate(90) stick();
  //translate([-insert_x/2+stick_y,0,case_z+sleeve_z-sleeve_u-stick_z-tol]) rotate(90) stick();
}

module cutaway() {
  difference() {
    assembly();
    translate([0,0,-2])
      cube([200,200,200]);
    translate([-bolt_x/2-200,-200,-2])
      cube([200,200,200]);
  }
}

assembly();
//cutaway();

// 3d printing
//insert();
//sleeve();

// laser cutting (export as DXF, then import to inkscape and convert to PDF)
//shelf_plate();

