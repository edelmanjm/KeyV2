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

// Legends are written as plain words ("tab", "vol+", "cmd"). With symbols=true
// each word that has an entry in mb_glyphs (below the tables) is drawn as that
// glyph; with symbols=false the word itself is engraved. Anything not in the
// map -- letters, digits, "esc", "fn", the arrows -- is drawn as written.

// ---------------------------------------------------------------------
// CONFIG: right-hand cluster legends. Uncomment exactly ONE line.
// Numpad and arrows are the SAME twelve 1u caps -- only legends differ.
mb_cluster_mode = "arrows";     // arrow keys + the symbols  - = ` [ ] \
// mb_cluster_mode = "numpad";  // numeric keypad
// ---------------------------------------------------------------------

// The two cluster legend sets (4 rows x 3 columns each).
mb_cluster_arrows = [
  [["+","="], "*", "vol+"],   // left +/=, center *, right volume up
  [["-","_"], "/", "vol-"],   // left -/_, center /, right volume down
  [["\\","|"], "↑", "out"],   // left \/|, center ↑, right ZMK output toggle (USB <-> Bluetooth)
  ["←",       "↓", "→"]
];
mb_cluster_numpad = [
  ["7", "8", "9"],
  ["4", "5", "6"],
  ["1", "2", "3"],
  ["0", ".", "enter"]   // Enter in the numpad's bottom-right slot
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

// Legends, transcribed from the product photo. A cell is a string (one centered
// legend) OR a [lower, upper] pair -> two stacked legends (number + shift symbol).
mb_left_main = [                       // 4 rows x 6 cols (outer mod column first)
  ["esc",   ["1","!"], ["2","@"], ["3","#"], ["4","$"], ["5","%"]],
  [["`","~"], "Q", "W", "E", "R", "T"],  // grave/tilde (was Tab)
  ["tab",     "A", "S", "D", "F", "G"],  // Tab (was Ctrl)
  ["shift",   "Z", "X", "C", "V", "B"]   // Shift
];
mb_right_main = [                      // 4 rows x 6 cols (inner column last)
  [["6","^"], ["7","&"], ["8","*"], ["9","("], ["0",")"], ["[","{"]],
  ["Y", "U", "I", "O", "P", ["]","}"]],
  ["H", "J", "K", "L", [";",":"], ["'","\""]],
  ["N", "M", [",","<"], [".",">"], ["/","?"], "shift"]
];
mb_win = "cmd";   // Super/Command key in the left bottom-row cluster

// Bottom-row (thumb) clusters. Left: Option / Control / Super. Right: Backspace
// / Delete / fn.
mb_left_bottom  = ["alt", "ctrl", mb_win];   // Alt(Option) / Control / Super
mb_right_bottom = ["enter", "fn", ["fn", "lock"]];   // Return / fn / fn-toggle (fn with a padlock above)
mb_left_thumb   = "bksp";     // Backspace
mb_right_thumb  = "";       // space left blank, per request

// Front (side) legends: the layer-1 function of each key, engraved on the
// front face of the cap. Same shapes as the top-legend tables; "" = none. A
// cell may also be a [left, right] pair -> two legends side by side (used for
// the Bluetooth keys: logo + modifier).
mb_left_front = [                      // 4 rows x 6 cols
  ["",          "",         "",         "",         "",         ""],
  [["bt","›"],  "bri-",     "bri+",     "mute",     "vol-",     "vol+"],      // ` = next BT profile
  [["bt","‹"],  ["bt","1"], ["bt","2"], ["bt","3"], ["bt","4"], ["bt","5"]],  // tab = previous BT profile, A-G = select profile 1-5
  ["btclr",     "",         "",         "",         "",         ""]           // shift = clear BT profile (caps is on the right shift)
];
mb_right_front = [                     // 4 rows x 6 cols
  ["",      "",     "",    "",     "",     ""],
  ["PrtSc", "mctl", "rwd", "play", "ffwd", "pwr"],   // print screen, mission control, rewind, play/pause, fast-forward, power (on ])
  ["",      "",     "",    "",     "",     ""],
  ["", "", "", "", "", "caps"]   // caps lock on the front of right shift
];
// Right cluster front legends: the numpad (7-8-9 on top, 0 . = at the bottom)
// when the top legends are the arrow set; nothing when the numpad is already
// on top.
mb_cluster_front = (mb_cluster_mode == "numpad") ? [["","",""], ["","",""], ["","",""], ["","",""]] : mb_cluster_numpad;
mb_left_bottom_front  = ["", "", ""];
mb_right_bottom_front = ["", "", ""];
mb_left_thumb_front   = "del";   // Delete
mb_right_thumb_front  = "";

// Assemble the main-block legends to match its shape.
//   Main rows 0-3: 6 left main | gap | 6 right main | gap | 3 cluster = 17
// (Bottom-row and thumb legends are applied per key in the module.)
mb_main_legends = [
  concat(mb_left_main[0], [""], mb_right_main[0], [""], mb_cluster[0]),
  concat(mb_left_main[1], [""], mb_right_main[1], [""], mb_cluster[1]),
  concat(mb_left_main[2], [""], mb_right_main[2], [""], mb_cluster[2]),
  concat(mb_left_main[3], [""], mb_right_main[3], [""], mb_cluster[3])
];
mb_main_front = [
  concat(mb_left_front[0], [""], mb_right_front[0], [""], mb_cluster_front[0]),
  concat(mb_left_front[1], [""], mb_right_front[1], [""], mb_cluster_front[1]),
  concat(mb_left_front[2], [""], mb_right_front[2], [""], mb_cluster_front[2]),
  concat(mb_left_front[3], [""], mb_right_front[3], [""], mb_cluster_front[3])
];

// Word -> glyph map for symbols=true. Plain Unicode glyphs (Mac modifiers,
// arrows) draw from $mb_symbol_font; SF Symbols -- Apple's own keycap glyphs,
// which live in SF Pro at private-use codepoints U+100000+ -- always draw from
// SF Pro, so glyph mode needs it installed locally (developer.apple.com/fonts;
// not redistributable). The arrows map to themselves so they still route to the
// symbol font. Words with no entry are engraved as written in both modes.
// An entry may name a third item, the font to draw that glyph from; this is
// how the Bluetooth logo comes in, since SF Symbols omits it (trademark) and
// no installed font has it as plain Unicode. Any Nerd Font carries it.
mb_sf_font = "SF Pro Text";
mb_bt_font = "JetBrainsMono Nerd Font";
mb_glyphs = [
  ["cmd",   "⌘"], ["alt",   "⌥"], ["ctrl",  "⌃"], ["shift", "⇧"], ["caps", "⇪"],
  ["bksp",  "⌫"], ["del",   "⌦"],
  ["←","←"], ["↑","↑"], ["↓","↓"], ["→","→"],
  ["tab",   chr(0x100142)],   // arrow.right.to.line (SF Pro has no plain ⇥)
  ["enter", chr(0x100147)],   // return              (SF Pro has no plain ↩)
  ["bri-",  chr(0x1001AC)],   // sun.min.fill
  ["bri+",  chr(0x1001AE)],   // sun.max.fill
  ["vol+",  chr(0x1002A9)],   // speaker.wave.3.fill
  ["vol-",  chr(0x1002A5)],   // speaker.wave.1.fill
  ["mute",  chr(0x1002A3)],   // speaker.slash.fill
  ["PrtSc", chr(0x1003BC)],   // camera.viewfinder (0x10031F camera.fill is bolder)
  ["mctl",  chr(0x1001F4)],   // rectangle.3.group (Mission Control)
  ["rwd",   chr(0x100289)],   // backward  (0x10028A backward.fill is heavier)
  ["play",  chr(0x100287)],   // playpause (0x100288 playpause.fill)
  ["ffwd",  chr(0x10028B)],   // forward   (0x10028C forward.fill)
  ["lock",  chr(0x1003A0)],   // lock (outline; 0x1003A1 lock.fill)
  ["out",   chr(0x10014C)],   // arrow.triangle.2.circlepath -- ZMK output toggle
  ["pwr",   "⏻"],             // Unicode U+23FB in SF Pro: same stroke as the SF power symbol (0x1001A8) but cap-height sized, not 1.45x
  ["bt",    chr(0xF00AF), mb_bt_font],   // Nerd Font md-bluetooth (logo)
  ["btclr", chr(0xF00B2), mb_bt_font]    // Nerd Font md-bluetooth_off (slashed logo) = clear profile
];
function mb_entry(w)    = let(m = [for (p = mb_glyphs) if (p[0] == w) p]) len(m) > 0 ? m[0] : undef;
function mb_glyph(w)    = let(e = mb_entry(w)) is_undef(e) ? undef : e[1];
// Icon-font glyphs (SF Symbols at U+100000+, Nerd Font at U+F0000+) vs. plain Unicode.
function mb_is_icon(g)  = is_string(g) && len(g) > 0 && ord(g[0]) >= 983040;
// What gets engraved: "" when blank, the word in text mode, else its glyph if it has one.
function mb_disp(s)     = $mb_blank ? "" : (($mb_text || is_undef(mb_glyph(s))) ? s : mb_glyph(s));
function mb_font_for(s) = let(e = mb_entry(s))
                          ($mb_text || is_undef(e)) ? $font
                          : (len(e) > 2 ? e[2] : (mb_is_icon(e[1]) ? mb_sf_font : $mb_symbol_font));
// Size factor: icon glyphs get icon_scale; multi-character words shrink to 0.8x.
function mb_scale_for(s) = let(d = mb_disp(s)) mb_is_icon(d) ? $mb_icon_scale : (len(d) > 1 ? 0.8 : 1);
function mb_size_for(s)       = $font_size * mb_scale_for(s);
function mb_front_size_for(s) = $mb_front_size * mb_scale_for(s);

// Wrap children in a front-face legend (or a side-by-side pair) when `spec` is
// non-empty and front legends are enabled; otherwise pass them through
// untouched. Same glyph/word/blank handling and engraving depth as the top.
module mb_front(spec) {
  if (!$mb_front || is_undef(spec) || spec == "") children();
  else if (is_list(spec))                                    // [left, right] side by side
    front_legend(mb_disp(spec[0]), [-0.6, 0], mb_front_size_for(spec[0]), mb_font_for(spec[0]))
      front_legend(mb_disp(spec[1]), [0.6, 0], mb_front_size_for(spec[1]), mb_font_for(spec[1]))
        children();
  else if (mb_disp(spec) == "") children();
  else front_legend(mb_disp(spec), [0, 0], mb_front_size_for(spec), mb_font_for(spec)) children();
}

// Wrap children in the top-face legend(s) for one cell. String -> single
// centered legend (glyph or word per the mode, in the right font);
// [lower, upper] pair -> two stacked at 0.8x (number + shifted symbol, or
// "fn" + a padlock). Blank mode passes through untouched.
function mb_pair_size(s) = $font_size * 0.8 * (mb_is_icon(mb_disp(s)) ? $mb_icon_scale : 1);
module mb_top(spec) {
  if ($mb_blank || is_undef(spec) || spec == "") children();
  else if (is_list(spec))
    legend(mb_disp(spec[0]), [0,  0.8], mb_pair_size(spec[0]), mb_font_for(spec[0]))   // lower
      legend(mb_disp(spec[1]), [0, -0.8], mb_pair_size(spec[1]), mb_font_for(spec[1]))  // upper
        children();
  else legend(mb_disp(spec), [0, 0], mb_size_for(spec), mb_font_for(spec)) children();
}

// One main-block key: top legend cell + matching front cell (see mb_front).
module mb_main_key(spec, front = "") {
  $stem_type = $mb_stem;                            // override layout()'s hardcoded cherry()
  mb_front(front) mb_top(spec) key();
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
// font        : main text font. undef (default) keeps KeyV2's stock font; else a
//             named family (must be installed), e.g. "SF Pro Text", "Inter".
// symbol_font : font for the plain-Unicode glyphs in mb_glyphs (⌘⌥⌃⇧⇪⌫⌦ and the
//             arrows). Defaults to the main `font`; for a text-only font
//             (National Park) set e.g. "DejaVu Sans Mono". The SF Symbols in
//             mb_glyphs always come from SF Pro, and the two Bluetooth glyphs
//             from a Nerd Font (mb_bt_font), regardless.
// symbols     : true (default) -> words with an entry in mb_glyphs are drawn as
//             that glyph. false -> the words themselves are engraved, all in the
//             main font, so neither a symbol font nor SF Pro is needed.
// legends     : true (default) -> render legends. false -> blank caps (no legends).
// front_legends : true (default) -> also engrave the layer-1 legends (mb_*_front)
//             on the front face of each cap. false -> top legends only. Always
//             off when legends=false.
// front_legend_size : font size (mm) for the front legends. Default = legend_size,
//             so a glyph shared between faces (⌫ on top, ⌦ on the front of the
//             same thumb) prints at one size. Multi-character words shrink 0.8x.
// icon_scale  : icon-glyph size relative to the legend size (default 0.88), tuned
//             so the icons sit visually level with the letters while fitting the
//             short front face.
module mountain_breeze_default(profile = "dsa", sculpt = false, thumb_row = 3, thumb_raise = 0, column_sculpt = "disable", legend_size = 3.6, font = undef, symbol_font = undef, symbols = true, legends = true, front_legends = true, front_legend_size = undef, icon_scale = 0.8, stem = "cherry") {
  $double_sculpted = (column_sculpt != "disable");
  $font_size = legend_size;   // smaller lettering than the stock default of 6
  $font = is_undef(font) ? $font : font;                  // undef = keep KeyV2's stock font
  $mb_symbol_font = is_undef(symbol_font) ? $font : symbol_font;
  $mb_text = !symbols;        // text-label mode when symbols=false
  $mb_blank = !legends;       // blank caps (no legends) when legends=false
  $mb_front = legends && front_legends;   // front-face (layer-1) legends
  $mb_front_size = is_undef(front_legend_size) ? legend_size : front_legend_size;
  $mb_icon_scale = icon_scale;            // SF Symbol size vs. letters
  $mb_stem = stem;            // "cherry" or "box_cherry" (Kailh Box)

  // Main 6x4 blocks (both hands) + the right cluster, rows 0-3. Legends are
  // applied per key from mb_main_legends via $row/$column, so a cell can be a
  // single string or a stacked [lower, upper] pair (see mb_main_key).
  layout(
    mb_main_rows,
    profile,
    row_override = sculpt ? undef : 3,   // uniform: pin row 3; sculpt: use offset
    row_sculpting_offset = sculpt ? 1 : 0,
    column_sculpt_profile = column_sculpt
  ) mb_main_key(mb_main_legends[$row][$column], mb_main_front[$row][$column]);

  // --- Thumb cluster, placed directly at y=-4 -----------------------------
  // Pinned to thumb_row and lifted by thumb_raise mm. x-positions match the
  // old bottom-row array [-1,1,1,1,-5,1,1,1]: left keys at 1.5/2.5/3.5, right
  // at 9.5/10.5/11.5, and the 2u thumbs inboard at 5 and 8.
  // Each entry: [x, top legend, front legend].
  mb_bottom_1u = [
    [1.5, mb_left_bottom[0],  mb_left_bottom_front[0]],  [2.5,  mb_left_bottom[1],  mb_left_bottom_front[1]],  [3.5,  mb_left_bottom[2],  mb_left_bottom_front[2]],
    [9.5, mb_right_bottom[0], mb_right_bottom_front[0]], [10.5, mb_right_bottom[1], mb_right_bottom_front[1]], [11.5, mb_right_bottom[2], mb_right_bottom_front[2]]
  ];
  for (k = mb_bottom_1u) {
    translate_u(k[0], -4) key_profile(profile, thumb_row) mb_front(k[2]) mb_top(k[1]) cherry() {
      $total_depth = $total_depth + thumb_raise;
      $stem_type = $mb_stem;
      if ($children) children(); else key();
    }
  }

  // The two 2u thumbs: 2u caps with stabilizer support, inboard of each hand.
  mb_thumbs = [[5, mb_left_thumb, mb_left_thumb_front], [8, mb_right_thumb, mb_right_thumb_front]];
  for (t = mb_thumbs) {
    translate_u(t[0], -4) key_profile(profile, thumb_row) u(2) stabilized() mb_front(t[2]) mb_top(t[1]) cherry() {
      $total_depth = $total_depth + thumb_raise;
      $stem_type = $mb_stem;
      if ($children) children(); else key();
    }
  }
}
