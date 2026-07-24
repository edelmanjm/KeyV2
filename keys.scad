// the point of this file is to be a sort of DSL for constructing keycaps.
// when you create a method chain you are just changing the parameters
// key.scad uses, it doesn't generate anything itself until the end. This
// lets it remain easy to use key.scad like before (except without key profiles)
// without having to rely on this file. Unfortunately that means setting tons of
// special variables, but that's a limitation of SCAD we have to work around

include <./includes.scad>


// Keycaps for a board. Press F5 to preview, F6 to render.
$fn = 32; // preview resolution; bump to 64+ before F6 for a smooth render.



// lily58_default("dsa", font="National Park:style=Regular", stem="box_cherry", sls=true);

// superlyra_default("cherry", sculpt=true, font="Inter:style=Light", legend_size=3.5, sls=true);
superlyra_default("dsa", sculpt=true, font="Inter:style=Light", legend_size=3.5, stem="box_cherry", sls=true);

// Tom Hightower
// mountain_breeze_default("dsa", sculpt=false, legends=false);
// Xinyuan Zhao
// mountain_breeze_default("dsa", sculpt=false, font="Inter");
// Jonathan Edelman
// mountain_breeze_default("cherry", sculpt=true, thumb_raise=1.5, font="Inter");
// mountain_breeze_default("dsa", sculpt=true, thumb_raise=1.5, font="Inter");


// mountain_breeze_default("dsa", sculpt=true, thumb_raise=1.5, font="National Park", symbols=false);
// kiwi36_default("dsa");