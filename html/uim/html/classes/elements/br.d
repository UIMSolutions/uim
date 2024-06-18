module uim.html.classes.elements.br;

import uim.html;
@safe:

// Wrapper for the br tag - produces a line break in text (carriage-return).
class DH5Br : DH5Obj {
	mixin(H5This!("br", null, null, true));
}
mixin(H5Short!("Br"));
alias Br = H5Br; // Shortcut of shortcut

version(test_uim_html) { unittest {
  assert(H5Br,"<br>");
}}
