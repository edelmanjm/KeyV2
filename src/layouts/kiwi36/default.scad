include <../layout.scad>

// Kiwi 36: a 3x5 + 3-thumb split ergonomic keyboard (36 keys total).
//
// This array describes ONE flat grid holding BOTH halves side by side.
// KeyV2 only lays keycaps out on a flat grid for previewing/plating -- it does
// NOT model the physical column-stagger or thumb-cluster splay of the real
// board. That's fine: the printed caps are identical either way; the stagger
// only affects where switches sit on your PCB, not the caps themselves.
//
// Numbers are key widths in units (1 = 1u). Negative numbers are gaps/spacers
// (used here to separate the two halves and to indent the thumb rows).
kiwi36_layout = [
  [1, 1, 1, 1, 1, -1, 1, 1, 1, 1, 1],  // top row    (5 left | gap | 5 right)
  [1, 1, 1, 1, 1, -1, 1, 1, 1, 1, 1],  // home row
  [1, 1, 1, 1, 1, -1, 1, 1, 1, 1, 1],  // bottom row
  // Thumbs: two 1u + one 1.5u per hand. The 1.5u is the inner (main) thumb on
  // each side, so they flank the centerline. Widths sum so the two 3-key groups
  // sit symmetric about the center; leading -1.5 and middle -1.0 are spacers.
  [-1.5, 1, 1, 1.5, -1.0, 1.5, 1, 1]  // thumbs (1u,1u,1.5u | gap | 1.5u,1u,1u)
];

// Optional legends. Must match the shape of kiwi36_layout (gap slots use "").
// Blank caps are the norm for boards like this, so legends are off by default.
// To use them, uncomment this array and the `legends=...` argument below.
/*
kiwi36_legends = [
  ["q", "w", "e", "r", "t", "", "y", "u", "i", "o",   "p"],
  ["a", "s", "d", "f", "g", "", "h", "j", "k", "l",   ";"],
  ["z", "x", "c", "v", "b", "", "n", "m", ",", ".",   "/"],
  ["",  "⇧", "⌫", "␣", "",  "␣", "⏎", "⎇"]
];
*/

// `profile` is a key profile like "dsa", "sa", "oem", "dcs", "g20".
// DSA (uniform -- every row the same shape) is recommended for split ergo
// boards, so that's the default. Pass another name to override.
// stem: "cherry" (default) or "box_cherry" for Kailh Box switches.
module kiwi36_default(profile = "dsa", sls = false, stem = "cherry") {
  // sls: true -> disable stem supports (SLS's powder bed is self-supporting) and
  // use a nylon-friendly stem slop. Default false keeps KeyV2's FDM tines/slop.
  $stem_support_type = sls ? "disable" : $stem_support_type;
  $stem_slop         = sls ? 0.15      : $stem_slop;
  $ki_stem = stem;
  layout(
    kiwi36_layout,
    profile,
    // legends = kiwi36_legends,   // uncomment together with the array above
    row_sculpting_offset = 1
  ) { $stem_type = $ki_stem; children(); }   // set stem past layout()'s hardcoded cherry()
}
