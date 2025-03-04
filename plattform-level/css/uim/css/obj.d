module uim.css.obj;

import uim.css;
@safe:

class DCSSObj {
	this() { _init; }	 
	protected void _init() {}

	override string toString() {
		return null;
	}
}
auto CSSOBJ() { return new DCSSObj(); }

unittest {
	// TODO
}
