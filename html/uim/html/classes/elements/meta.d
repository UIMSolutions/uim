module uim.html.classes.elements.meta;

import uim.html;
@safe:

@safe:
class DH5Meta : DH5Obj {
	mixin(H5This!("meta", null, null, true));
}
mixin(H5Short!("Meta"));

version(test_uim_html) { unittest {
  assert(H5Meta == "<meta>");
}}

string toString(DH5Meta[] metas) {
	return metas.map!(meta => meta.toString).join;
}
version(test_uim_html) { unittest {
    // assert([H5Meta, H5Meta].toString == "<meta><meta>");
}}

DH5Meta[] H5Metas(string[string][] metas...) { return H5Metas(metas.dup); }
DH5Meta[] H5Metas(string[string][] metas) { 
	DH5Meta[] results;
	foreach(meta; metas) results ~= H5Meta(meta);
	return results; }
version(test_uim_html) { unittest {
	/// TODO
}}
