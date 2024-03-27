/***********************************************************************************
*	Copyright: ©2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.keypairs.keypair;

import uim.oop;

@safe:
class DOPKeypair {
	this() {
	}
	this(DOOPObject aKey) { this().key(aKey); }
	this(DOOPObject aKey, DOOPObject aValue) { this().key(aKey).value(aValue); }

	DOOPObject _key;
	auto key() { return _key; }
	O key(this O)(DOOPObject newKey) { _key = newKey; return cast(DO)this; }
	version(test_uim_oop) { unittest {
		/// TODO
	}}


	DOOPObject _value;
	auto value() { return _value; }
	O value(this O)(DOOPObject newValue) { _value = newValue; return cast(DO)this; }
	version(test_uim_oop) { unittest {
		/// TODO
	}}
}
auto OPKeypair() { return new DOPKeypair; }
auto OPKeypair(DOOPObject aKey) { return new DOPKeypair(aKey); }
auto OPKeypair(DOOPObject aKey, DOOPObject aValue) { return new DOPKeypair(aKey, aValue); }

version(test_uim_oop) { unittest { /// TODO 
}}
