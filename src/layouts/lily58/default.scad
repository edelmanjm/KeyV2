include <../layout.scad>

// =====================================================================
// Lily58 -- a 58-key column-staggered split ergo (no numpad).
//
// Physical layout, per half: 6-col x 4-row main grid + 1 inner extra key
// (the [ / ], on the bottom row) + 4 thumb keys.  29 keys/half, 58 total.
//
// Legends transcribed from the reference photo: QWERTY, number row with
// shifted symbols, ESC/TAB/CTRL/SHIFT down the left outer column. Thumb
// keys are blank (solid colored caps in the photo).
//
// KeyV2 lays caps on a flat grid for preview/plating only; the column
// stagger, thumb fan, and rotation are not modeled.
// =====================================================================

// ---- Legends -------------------------------------------------------
// A cell is a string (one centered legend) OR a [lower, upper] pair
// (base char + shifted symbol, rendered stacked).

// LEFT half: 4 rows x 7 cols. C1 = outer mod column, C2-C6 = alphas,
// C7 = the inner extra key ("" on the upper rows means no key there).
ly_left = [
  ["ESC",   ["1","!"], ["2","@"], ["3","#"], ["4","$"], ["5","%"], ""],
  ["TAB",   "Q", "W", "E", "R", "T", ""],
  ["CTRL",  "A", "S", "D", "F", "G", ""],
  ["SHIFT", "Z", "X", "C", "V", "B", ["[","{"]]
];

// RIGHT half: 4 rows x 7 cols. C1 = inner extra key (bottom row only),
// C2-C6 = alphas, C7 = outer column.
// NOTE: the right outer column's row-2 and row-4 legends weren't legible
// in the photo -- left blank (see the (?) markers).
ly_right = [
  ["",         ["6","^"], ["7","&"], ["8","*"], ["9","("], ["0",")"], ["`","~"]],
  ["",         "Y", "U", "I", "O", "P", ""],                    // (?) C7 outer
  ["",         "H", "J", "K", "L", [";",":"], ["'","\""]],
  [["]","}"],  "N", "M", [",","<"], [".",">"], ["/","?"], ""]   // (?) C7 outer
];

// ---- Physical grid -------------------------------------------------
// Per row: 7 left | center gap | 7 right. Negative = spacer.
// Rows 0-2: the inner extra columns (left C7, right C1) are gaps.
// Row 3: those become the [ and ] keys.
ly_row_top   = [1,1,1,1,1,1,-1, -1, -1,1,1,1,1,1,1];
ly_row_bot   = [1,1,1,1,1,1, 1, -1,  1,1,1,1,1,1,1];
ly_main_rows = [ly_row_top, ly_row_top, ly_row_top, ly_row_bot];

// 4 thumb keys per half (blank), placed below toward the center. The
// innermost thumb on each hand is 1.5u (the Lily58's rotated outer thumb).
ly_thumb_row = [-3, 1,1,1,1.5, -1, 1.5,1,1,1];

ly_main_legends = [
  concat(ly_left[0], [""], ly_right[0]),
  concat(ly_left[1], [""], ly_right[1]),
  concat(ly_left[2], [""], ly_right[2]),
  concat(ly_left[3], [""], ly_right[3])
];

// Apply one legend cell. String -> single centered legend; [lower, upper]
// pair -> two stacked legends (base + shifted symbol).
module ly_main_key(spec) {
  if ($ly_blank) {
    key();                              // blank cap, no legend
  } else if (is_list(spec)) {
    legend(spec[0], [0,  0.8], $font_size * 0.8)
      legend(spec[1], [0, -0.8], $font_size * 0.8)
        key();
  } else if (len(spec) > 1) {
    // multi-letter words (ESC, TAB, CTRL, SHIFT...) shrink to fit the 1u cap;
    // longer words scale down further so they all sit under one line.
    legend(spec, [0, 0], $font_size * min(0.8, 3.0 / len(spec))) key();
  } else {
    legend(spec) key();
  }
}

// profile     : "dsa"/"g20" (uniform) or a sculpted profile ("oem"/"cherry"/"sa").
// sculpt      : false -> flat row-3 everywhere. true -> row-sculpt the 4 main rows
//               to profile rows 1-4; thumbs are pinned to thumb_row.
// thumb_row   : profile row for the thumb keys when sculpting (default 3 = flat).
// legend_size : legend font size (mm).
// font        : legend font family (must be installed / fontconfig-visible), e.g.
//               "Routed Gothic", "National Park", "Inter". Default is KeyV2's.
module lily58_default(profile = "dsa", sculpt = false, legend_size = 4, thumb_row = 3, font = "DejaVu Sans Mono", sls = false, legends = true) {
  $font_size = legend_size;
  $font = font;
  $ly_blank = !legends;   // blank caps (no legends) when legends=false
  // sls: true -> disable stem supports (SLS powder bed self-supports) + nylon slop.
  $stem_support_type = sls ? "disable" : $stem_support_type;
  $stem_slop         = sls ? 0.15      : $stem_slop;

  // Main grid, rows 0-3 (number / QWERTY / home / bottom-alpha + the [ ] extras).
  layout(
    ly_main_rows,
    profile,
    row_override = sculpt ? undef : 3,
    row_sculpting_offset = sculpt ? 1 : 0,
    column_sculpt_profile = "disable"
  ) ly_main_key(ly_main_legends[$row][$column]);

  // Thumb keys at y=-4 (blank), pinned so they don't grab the steep row-5 tilt.
  translate_u(0, -4) layout(
    [ly_thumb_row],
    profile,
    row_override = sculpt ? thumb_row : 3,
    column_sculpt_profile = "disable"
  ) key();
}
