// the point of this file is to be a sort of DSL for constructing keycaps.
// when you create a method chain you are just changing the parameters
// key.scad uses, it doesn't generate anything itself until the end. This
// lets it remain easy to use key.scad like before (except without key profiles)
// without having to rely on this file. Unfortunately that means setting tons of
// special variables, but that's a limitation of SCAD we have to work around

include <./includes.scad>


// Keycaps for a board. Press F5 to preview, F6 to render.
$fn = 128; // preview resolution; bump to 64+ before F6 for a smooth render.
$inset_legend_depth = 0.5; // engraved-legend depth in mm (stock default 0.2).

// sls_print(stem_slop=0.50, stem_inner_slop=0.1)
sla_print(stem_slop=1.00, stem_inner_slop=0.08, wall=4)

// Wrap a board in a print-process preset (from src/print_profiles.scad):
//   sla_print(stem_slop, stem_inner_slop)  -- resin; tune the slops, test-fit ONE cap
//   sls_print(stem_slop)                   -- nylon SLS
//   (no wrapper)                           -- stock FDM tines + slop
// Tuning: print `dsa_row(3) box_cherry() key();` inside the wrapper, adjust, repeat.

// lily58_default("dsa", font="National Park:style=Bold", stem="box_cherry");

// superlyra_default("cherry", sculpt=true, font="Inter:style=Bold", legend_size=3.5);
// superlyra_default("dsa", sculpt=true, font="Inter:style=Bold", legend_size=3.5, stem="box_cherry");

// Tom Hightower
// mountain_breeze_default("dsa", sculpt=false, legends=false);
// Xinyuan Zhao
// mountain_breeze_default("dsa", sculpt=false, font="Inter");
// Jonathan Edelman
// mountain_breeze_default("cherry", sculpt=true, thumb_raise=1.5, font="Inter");
mountain_breeze_default("dsa", sculpt=true, thumb_raise=1.5, font="SF Pro Text");  // SF Pro must be installed locally


// mountain_breeze_default("dsa", sculpt=true, thumb_raise=1.5, font="National Park", symbols=false);
// kiwi36_default("dsa");