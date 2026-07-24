// Print-process presets. Wrap a board render to set stem supports + fit
// tolerances for a given process, then compose the board inside:
//
//   sla_print() superlyra_default("dsa", sculpt=true, stem="box_cherry");
//   sls_print() lily58_default("dsa");
//
// They only set KeyV2's global stem special variables; the board modules no
// longer touch those, so the board inherits whatever the wrapper sets. Omit the
// wrapper entirely for stock FDM (KeyV2's default tines + 0.35/0.2 slop).

// SLS (nylon powder bed): self-supporting, so no in-model stem tines; a
// nylon-friendly fit slop.
module sls_print(stem_slop = 0.15) {
  $stem_support_type = "disable";
  $stem_slop = stem_slop;
  children();
}

// SLA (resin): dimensionally sharp; no in-model tines (the slicer adds the real
// supports), and a tight fit. Tune the two slops to your resin + switches --
// 0 matches KeyV2's built-in resin() values; the defaults here are a cautious
// starting point to test-fit from.
//   stem_slop       : outer post size / Box-housing clearance
//   stem_inner_slop : + cross grip on the switch stem (main retention knob)
module sla_print(stem_slop = 0.08, stem_inner_slop = 0.08) {
  $stem_support_type = "disable";
  $stem_slop = stem_slop;
  $stem_inner_slop = stem_inner_slop;
  children();
}
