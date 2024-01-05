module uim.oop.obj;

import uim.oop;
@safe:

class DOOPObject {
	this() { _init; }
	protected void _init() {}
}
auto OOPObject() { return new DOOPObject; }

version(test_uim_oop) { unittest {
		/// TODO
	}}
