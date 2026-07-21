include <../layout.scad>

// =====================================================================
// Mountain Breeze (modified build) -- Afternoon Labs
// https://github.com/afternoonlabs/MountainBreeze
//
// Physical layout, per the owner's build:
//   * 6x4 main alpha/number cluster on EACH hand   (24 keys/hand)
//   * 3-key bottom row on EACH hand                 ( 3 keys/hand)
//   * one 2u thumb on EACH hand                     ( 1 key /hand)
//   * a 4x3 cluster on the RIGHT hand only          (12 keys)
//   => 68 keycaps total: 66x 1u + 2x 2u.
//
// As with every board here, KeyV2 lays caps on a flat grid for
// preview/plating only -- it does NOT model the column stagger, tenting,
// or thumb splay. That has no effect on the printed caps.
// =====================================================================

// ---------------------------------------------------------------------
// CONFIG: right-hand cluster legends. Uncomment exactly ONE line.
// Numpad and arrows are the SAME twelve 1u caps -- only legends differ.
mb_cluster_mode = "arrows";     // arrow keys + the symbols  - = ` [ ] \
// mb_cluster_mode = "numpad";  // numeric keypad
// ---------------------------------------------------------------------

// The two cluster legend sets (4 rows x 3 columns each).
mb_cluster_arrows = [
  [["+","="], "*", "▲"],   // left +/=, center *, right volume up
  [["-","_"], "/", "▼"],   // left -/_, center /, right volume down
  ["\\",      "↑", "⇪"],   // center ↑, right caps (moved into the blank spot)
  ["←",       "↓", "→"]
];
mb_cluster_numpad = [
  ["7", "8", "9"],
  ["4", "5", "6"],
  ["1", "2", "3"],
  ["0", ".", "="]
];
mb_cluster = (mb_cluster_mode == "numpad") ? mb_cluster_numpad : mb_cluster_arrows;

// Main grid, both hands, plus the right cluster. Widths are in units; a
// negative number is a spacer, not a key:
//   idx 0-5   left main (6 cols)
//   idx 6     gap between hands
//   idx 7-12  right main (6 cols)
//   idx 13    gap before the right cluster
//   idx 14-16 right 4x3 cluster
// The thumb cluster (bottom-row keys + the two 2u thumbs) is placed directly
// in the module, not via this grid, so it can use its own profile row and
// height when sculpting (see the module).
mb_main_row  = [1, 1, 1, 1, 1, 1, -1, 1, 1, 1, 1, 1, 1, -0.5, 1, 1, 1];
mb_main_rows = [mb_main_row, mb_main_row, mb_main_row, mb_main_row];  // rows 0-3

// Legends, transcribed from the product photo. A few are best-guesses where the
// photo is unclear -- edit the ones marked (?) below.
// A cell is a string (one centered legend) OR a [lower, upper] pair, which
// renders as two stacked legends -- used here for number + shifted symbol.
mb_left_main = [                       // 4 rows x 6 cols (outer mod column first)
  ["esc",   ["1","!"], ["2","@"], ["3","#"], ["4","$"], ["5","%"]],
  [["`","~"], "Q", "W", "E", "R", "T"],  // grave/tilde (was Tab)
  ["⇥",       "A", "S", "D", "F", "G"],  // Tab (was Ctrl)
  ["⇧",       "Z", "X", "C", "V", "B"]   // Shift
];
mb_right_main = [                      // 4 rows x 6 cols (inner column last)
  [["6","^"], ["7","&"], ["8","*"], ["9","("], ["0",")"], ["[","{"]],
  ["Y", "U", "I", "O", "P", ["]","}"]],
  ["H", "J", "K", "L", [";",":"], ["'","\""]],
  ["N", "M", [",","<"], [".",">"], ["/","?"], "⇧"]
];
// The "Windows"/Super key glyph. text() can only show glyphs the active font
// contains, and the same font is used for the whole board -- so a Tux penguin
// needs a MONOCHROME emoji font installed and set globally (color-emoji fonts
// won't extrude, and it would restyle the letters too). "Super" always renders.
mb_win = "⌘";          // Command/Super symbol
// mb_win = "Super";   // plain text label
// mb_win = "⊞";       // squared-plus: compact Windows-style glyph (font-dependent)
// mb_win = "🐧";      // Tux: only with a mono emoji font selected globally

// Bottom-row (thumb) clusters. Left: Option / Control / Super. Right: Backspace
// / Delete / fn.
mb_left_bottom  = ["⌥", "⌃", mb_win];   // Alt(Option) / Control / Super
mb_right_bottom = ["⌫", "⌦", "fn"];     // Backspace / Delete / fn
mb_left_thumb   = "";        // space left blank, per request
mb_right_thumb  = "↩";       // Enter / Return

// Assemble the main-block legends to match its shape.
//   Main rows 0-3: 6 left main | gap | 6 right main | gap | 3 cluster = 17
// (Bottom-row and thumb legends are applied per key in the module.)
mb_main_legends = [
  concat(mb_left_main[0], [""], mb_right_main[0], [""], mb_cluster[0]),
  concat(mb_left_main[1], [""], mb_right_main[1], [""], mb_cluster[1]),
  concat(mb_left_main[2], [""], mb_right_main[2], [""], mb_cluster[2]),
  concat(mb_left_main[3], [""], mb_right_main[3], [""], mb_cluster[3])
];

// Apply one main-block legend cell. String -> a single centered legend;
// [lower, upper] pair -> two stacked legends (number + shifted symbol). The
// position/size numbers are fudge constants -- nudge them if it looks off.
module mb_main_key(spec) {
  if (is_list(spec)) {
    legend(spec[0], [0,  0.8], $font_size * 0.8)    // lower: number
      legend(spec[1], [0, -0.8], $font_size * 0.8)  // upper: shifted symbol
        key();
  } else {
    legend(spec) key();
  }
}

// profile   : "dsa"/"g20" (uniform) or a sculpted MX profile: "oem","cherry",
//             "dcs","sa","mt3".
// sculpt    : false -> every cap uses the flat row-3 shape (correct for uniform
//             profiles; the board's tenting/stagger comes from the case).
//             true  -> row-sculpt the main block: number row -> profile row 1,
//             top-alpha -> 2, home -> 3, bottom-alpha -> 4. Use with a sculpted
//             `profile`. Column side-cant stays off either way.
// thumb_row : profile row for the thumb clusters + 2u thumbs. The thumbs have no
//             natural sculpt row, so they're pinned here (default 3 = home, a
//             neutral shape) rather than inheriting the steep row-5 tilt.
// thumb_raise : extra height (mm) added to the thumb-cluster caps. When sculpting,
//             the bottom alpha row sits on the taller profile row 4, so the flat
//             row-3 thumbs read as lower; bump this (~1-2 mm) to lift them level
//             or slightly proud. 0 = leave at the profile's natural row height.
// column_sculpt : per-column side-tilt applied to the MAIN block. "disable" (flat,
//             default), or "2hands"/"1hand"/"cresting_wave". Anything other than
//             "disable" also turns on $double_sculpted so the tops meet cleanly.
//             Best paired with a spherical profile (dsa/sa/mt3). Thumbs stay flat.
// legend_size : legend font size (mm). Default 3.6 for small, Apple-Magic-Keyboard
//             -ish lettering; KeyV2's stock default is a chunky 6. Stacked symbol
//             pairs are drawn at 0.8x this.
module mountain_breeze_default(profile = "dsa", sculpt = false, thumb_row = 3, thumb_raise = 0, column_sculpt = "disable", legend_size = 3.6) {
  $double_sculpted = (column_sculpt != "disable");
  $font_size = legend_size;   // smaller lettering than the stock default of 6

  // Main 6x4 blocks (both hands) + the right cluster, rows 0-3. Legends are
  // applied per key from mb_main_legends via $row/$column, so a cell can be a
  // single string or a stacked [lower, upper] pair (see mb_main_key).
  layout(
    mb_main_rows,
    profile,
    row_override = sculpt ? undef : 3,   // uniform: pin row 3; sculpt: use offset
    row_sculpting_offset = sculpt ? 1 : 0,
    column_sculpt_profile = column_sculpt
  ) mb_main_key(mb_main_legends[$row][$column]);

  // --- Thumb cluster, placed directly at y=-4 -----------------------------
  // Pinned to thumb_row and lifted by thumb_raise mm. x-positions match the
  // old bottom-row array [-1,1,1,1,-5,1,1,1]: left keys at 1.5/2.5/3.5, right
  // at 9.5/10.5/11.5, and the 2u thumbs inboard at 5 and 8.
  mb_bottom_1u = [
    [1.5, mb_left_bottom[0]],  [2.5,  mb_left_bottom[1]],  [3.5,  mb_left_bottom[2]],
    [9.5, mb_right_bottom[0]], [10.5, mb_right_bottom[1]], [11.5, mb_right_bottom[2]]
  ];
  for (k = mb_bottom_1u) {
    translate_u(k[0], -4) key_profile(profile, thumb_row) legend(k[1]) cherry() {
      $total_depth = $total_depth + thumb_raise;
      if ($children) children(); else key();
    }
  }

  // The two 2u thumbs: 2u caps with stabilizer support, inboard of each hand.
  mb_thumbs = [[5, mb_left_thumb], [8, mb_right_thumb]];
  for (t = mb_thumbs) {
    translate_u(t[0], -4) key_profile(profile, thumb_row) u(2) stabilized() legend(t[1]) cherry() {
      $total_depth = $total_depth + thumb_raise;
      if ($children) children(); else key();
    }
  }
}
