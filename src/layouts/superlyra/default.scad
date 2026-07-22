include <../layout.scad>

// =====================================================================
// SuperLyra -- Malevolti (https://github.com/Malevolti/SuperLyra)
// A unibody split ergo with a center numpad.
//
// Physical layout (from the build photo):
//   * LEFT hand:  7 cols x 5 rows; bottom row = 6x 1u + a 2u spacebar   (35 keys)
//   * RIGHT hand: 7 cols x 5 rows; bottom row = a 2u spacebar + 6x 1u   (35 keys)
//   * CENTER:     4 cols x 5 rows numpad                                (20 keys)
//   => 90 keycaps total (88x 1u + 2x 2u spacebars). The bottom row runs
//   8u wide (6x 1u + the 2u space), extending 1u toward the center.
//
// Legends: a Mac-style layout with symbol modifiers (⌘ ⌥ ⌃ ⇧ ⇥ ⇪ ↩ ⌫ ⌦),
// QWERTY, and a dedicated arrow cluster at the right hand's bottom-right.
// The extra inner columns have no canonical home, so those got sensible picks.
//
// KeyV2 lays caps on a flat grid for preview/plating only; column
// stagger / tenting are not modeled and don't affect the printed caps.
// =====================================================================

// ---- Legends -------------------------------------------------------
// A cell is a string (one centered legend) OR a [lower, upper] pair,
// which renders as two stacked legends (base char + shifted symbol).

// LEFT hand, 7 cols (C1 outer/pinky -> C7 inner) x 5 rows.
// C1: esc, Tab, Caps, Shift, (blank).  C2: ~, [, ] (symbol column).
// Alphas + numbers live in C3-C7 (shifted one column right). NOTE: the old
// left "6" fell off the end of the shifted number row and is currently dropped.
sl_left = [
  ["esc", ["1","!"], ["2","@"], ["3","#"], ["4","$"], ["5","%"], ["6","^"]],
  ["⇥",   ["`","~"], "Q", "W", "E", "R", "T"],
  ["⇪",   ["[","{"], "A", "S", "D", "F", "G"],
  ["⇧",   ["]","}"],        "Z", "X", "C", "V", "B"],   // NOTE: C2 here (R4) is an open blank
  ["prtscr", "menu", "fn", "⌃", "⌥", "⌘", ""]          // C1 blank; fn/ctrl/opt/cmd/menu; 2u space
];

// RIGHT hand, 7 cols (C1 inner -> C7 outer/pinky) x 5 rows.
// Arrow cluster bottom-right: ↑ at R4C6, ← ↓ → across R5. Right Shift at R4C7.
sl_right = [
  [["7","&"], ["8","*"], ["9","("], ["0",")"], ["-","_"], ["=","+"], "⌫"],
  ["Y", "U", "I", "O", "P", ["\\","|"], "⌦"],    // C6: backslash; C7: fwd delete
  ["H", "J", "K", "L", [";",":"], ["'","\""], "↩"],
  ["N", "M", [",","<"], [".",">"], ["/","?"], "↑", "⇧"],  // C6 up-arrow; C7 right shift
  ["", "⌘", "⌥", "⌃", "←", "↓", "→"]             // 2u space; cmd/opt/ctrl; arrow row
];

// CENTER numpad, 4 cols x 5 rows (Mac-style: clear top-left, return).
sl_numpad = [
  ["⌧", "◀", "▶", "/"],
  ["7", "8", "9", "*"],
  ["4", "5", "6", "-"],
  ["1", "2", "3", "+"],
  ["⌦", "0", ".", "↩"]
];

// ---- Physical grid -------------------------------------------------
// Per row: 7 left | gap | 4 numpad | gap | 7 right. Negative = spacer.
// Rows 0-3 are all 1u; the bottom row swaps in the two 2u spacebars.
// Rows 0-3: 7 left | gap | 4 numpad | gap | 7 right = 20 cols.
// Row 4 (bottom): the two 2u spaces fill where the gaps would be, so there
// are no gap spacers -- 7 left | 4 numpad | 7 right = 18 cols.
sl_row_top = [1,1,1,1,1,1,1, -1, 1,1,1,1, -1, 1,1,1,1,1,1,1];
sl_row_bot = [1,1,1,1,1,1,2,     1,1,1,1,     2,1,1,1,1,1,1];

// Legends assembled to match each row's shape (gap slots use "").
sl_legends = [
  concat(sl_left[0], [""], sl_numpad[0], [""], sl_right[0]),
  concat(sl_left[1], [""], sl_numpad[1], [""], sl_right[1]),
  concat(sl_left[2], [""], sl_numpad[2], [""], sl_right[2]),
  concat(sl_left[3], [""], sl_numpad[3], [""], sl_right[3]),
  concat(sl_left[4],       sl_numpad[4],       sl_right[4])   // no gaps on bottom row
];

// Apply one legend cell. String -> single centered legend; [lower, upper]
// pair -> two stacked legends (base + shifted symbol).
module sl_main_key(spec) {
  if (is_list(spec)) {
    legend(spec[0], [0,  0.8], $font_size * 0.8)
      legend(spec[1], [0, -0.8], $font_size * 0.8)
        key();
  } else {
    legend(spec) key();
  }
}

// profile     : "dsa"/"g20" (uniform) or a sculpted profile "oem"/"cherry"/"sa"/etc.
// sculpt      : false -> flat row-3 everywhere (uniform). true -> row-sculpt: the
//               top four rows map to profile rows 1-4 (number/QWERTY/home/bottom-
//               alpha) and the bottom row is pinned to `bottom_row`.
// bottom_row  : profile row for the bottom row's SHAPE/TILT when sculpting.
//               Default 4 gives a gentle forward tilt (matching the row above);
//               leaving it on the offset would hit profile row 5's steep tilt.
// bottom_raise: mm added to the bottom row's height when sculpting. Profile row
//               4 is ~2 mm shorter than the tall outer rows, so the default 2
//               lifts the bottom row to sit level in the bowl (a Cherry-style
//               tall, forward-tilted bottom row). Set 0 to leave it at row-4 height.
// legend_size : legend font size (mm). Default 4.
// The two 2u spacebars come from the width-2 cells; layout() gives them a
// stabilizer automatically. Legends on them are blank.
module superlyra_default(profile = "dsa", sculpt = false, legend_size = 4, bottom_row = 4, bottom_raise = 2, sls = false) {
  $font_size = legend_size;
  // sls: true -> disable stem supports (SLS powder bed self-supports) + nylon slop.
  $stem_support_type = sls ? "disable" : $stem_support_type;
  $stem_slop         = sls ? 0.15      : $stem_slop;

  // Top four rows (number / QWERTY / home / bottom-alpha). Sculpting maps them
  // to profile rows 1-4.
  layout(
    [sl_row_top, sl_row_top, sl_row_top, sl_row_top],
    profile,
    row_override = sculpt ? undef : 3,
    row_sculpting_offset = sculpt ? 1 : 0,
    column_sculpt_profile = "disable"
  ) sl_main_key(sl_legends[$row][$column]);

  // Bottom row (mods + the two 2u spaces), placed at y=-4. Pinned to bottom_row
  // for tilt, and raised by bottom_raise mm so its height fits the bowl instead
  // of sinking below the row above.
  translate_u(0, -4) layout(
    [sl_row_bot],
    profile,
    row_override = sculpt ? bottom_row : 3,
    column_sculpt_profile = "disable"
  ) {
    $total_depth = $total_depth + (sculpt ? bottom_raise : 0);
    sl_main_key(sl_legends[4][$column]);
  }
}
