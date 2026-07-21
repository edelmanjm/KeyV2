// the point of this file is to be a sort of DSL for constructing keycaps.
// when you create a method chain you are just changing the parameters
// key.scad uses, it doesn't generate anything itself until the end. This
// lets it remain easy to use key.scad like before (except without key profiles)
// without having to rely on this file. Unfortunately that means setting tons of
// special variables, but that's a limitation of SCAD we have to work around

include <./includes.scad>


// Keycaps for a board. Press F5 to preview, F6 to render.
$fn = 32; // preview resolution; bump to 64+ before F6 for a smooth render.
mountain_breeze_default("dsa", sculpt=true, thumb_raise=1.5) key();
// kiwi36_default("dsa") key();

// --- other examples (uncomment to use) ---

// example key
/* layout = [
  [1, 1, 1, 1, 1],
  [1, 1, 1, 1, 1],
  [1, 1, 1, 1, 1],
  [1, 1, 1.5]
];
key(); */

// example row
/* for (x = [0:1:4]) {
  translate_u(0,-x) dcs_row(x) key();
} */

// example layout
/* preonic_default("dcs") key(); */
