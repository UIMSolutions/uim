/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.mixins.properties.expandable;

mixin(Version!"test_uim_oop");

import uim.oop;
@safe:

// Mixin for expandable string datatypes
template XString(string name) {
  const char[] XString = "
  string _"~name~";
  @safe auto "~name~"() { return _"~name~"; }

  O "~name~"(this O)(string[] addValues...) { this."~name~"(addValues); return cast(O)this; }
  O "~name~"(this O)(string[] addValues) { _"~name~" ~= addValues.join(); return cast(O)this; }

  O clear"~name.capitalize~"(this O)() { _"~name~" = null; return cast(O)this; }  
  ";
}
version(test_uim_oop) { unittest {
  class DTest { mixin(XString!"a"); }
  assert((new DTest).a("x").a == "x");
  assert((new DTest).a("x").a("x").a == "xx");
  assert((new DTest).a("x", "x").a == "xx");
  assert((new DTest).a(["x", "x"]).a == "xx");
  assert((new DTest).a("x").clearA.a is null);
}}

// Mixin for expandable string array datatypes
template XStringArray(string name) {
  const char[] Name = name.capitalize;
  const char[] XStringArray = "
  string[] _"~name~";
  @safe auto "~name~"() { return _"~name~"; }

  O "~name~"(this O)(string[] values...) { this."~name~"(values); return cast(O)this; }
  O "~name~"(this O)(string[] values) { _"~name~" ~= values; return cast(O)this; }
  
  O remove"~Name~"(this O)(string[] values...) { this.remove"~Name~"(values); return cast(O)this; }  
  O remove"~Name~"(this O)(string[] values) {
    foreach(value; values) _"~name~" = _"~name~".sub(value); return cast(O)this; }  
  
  O clear"~Name~"(this O)() { _"~name~" = null; return cast(O)this; }  
  ";
}
version(test_uim_oop) { unittest {
  class DTest { mixin(XStringArray!"a"); }
  assert((new DTest).a("x").a == ["x"]);
  assert((new DTest).a("x").a("x").a == ["x", "x"]);
  assert((new DTest).a("x", "x").a == ["x", "x"]);
  assert((new DTest).a("x").clearA.a == null);
  assert((new DTest).a(["a", "b", "c"]).a == ["a", "b", "c"]);
   assert((new DTest).a(["a", "b", "c"]).removeA("x").a == ["a", "b", "c"]);
  assert((new DTest).a(["a", "b", "c", "a"]).a == ["a", "b", "c", "a"]); 
  assert((new DTest).a(["a", "b", "c", "a"]).removeA("a").a == ["b", "c", "a"]);
  assert((new DTest).a(["a", "b", "c", "a"]).removeA(["a"]).a == ["b", "c", "a"]); 
  //assert((new DTest).a(["a", "b", "c"]).removeA(["a"], true).a == ["b", "c"]);
}}

// Mixin for expandable string associative array datatypes
template XStringAA(string name) {
  const char[] Name = name.capitalize;
  const char[] XStringAA = "
  STRINGAA _"~name~";
  @safe auto "~name~"() { return _"~name~"; }
  @safe auto "~name~"(string key) { return _"~name~".get(key, ``); }

  O "~name~"(this O)(string key, string value) { _"~name~"[key] = value; return cast(O)this; }
  O "~name~"(this O)(string[string] addValues) { foreach(kv; addValues.byKeyValue) _"~name~"[kv.key] = kv.value; return cast(O)this; }
  
  O remove"~Name~"(this O)(string[] values...) { removeKey(values); return cast(O)this; }  
  O remove"~Name~"(this O)(string[] values) { foreach(value; values) _name = _"~name~".removeKey(value); return cast(O)this; }  
  
  O clear"~Name~"(this O)() { _"~name~" = null; return cast(O)this; }  
  ";
}
version(test_uim_oop) { unittest {
  class DTest { mixin(XStringAA!"a"); }
  assert((new DTest).a(["a": "x"]).a == ["a": "x"]);
  assert((new DTest).a("a", "x").a == ["a": "x"]);
  assert((new DTest).a("a", "x").clearA.a == null);
}}

template XPropertyAA(string key, string value, string name) {
  const char[] Name = capitalize(name);
  const char[] datatype = value~`[`~key~`]`;

  const char[] XPropertyAA = `  `~datatype~` _`~name~`; 
  @safe auto `~name~`() { return _`~name~`; }
  @safe auto `~name~`(`~key~` key) { return _`~name~`[key]; }

  @safe auto `~name~`(this O)(`~key~`[] keys...) { return _`~name~`(keys); }
  @safe auto `~name~`(this O)(`~key~`[] keys) { return _`~name~`.select(keys); }

  O `~name~`(this O)(`~datatype~` values) { _`~name~` = _`~name~`.add(values); return cast(O)this; }

  O `~name~`Init(this O)(`~key~`[] keys, `~value~` value) { foreach(k; keys) _`~name~`[k] = value; return cast(O)this; }
  O `~name~`Add(this O)(`~datatype~` values) { _`~name~` = _`~name~`.add(values); return cast(O)this; }
  O `~name~`Sub(this O)(`~datatype~` values) { _`~name~` = _`~name~`.sub(values); return cast(O)this; }

  O remove`~Name~`(this O)(`~key~`[] keys...) { return _remove`~Name~`(keys); return cast(O)this; }
  O remove`~Name~`(this O)(`~key~`[] keys) { _`~name~` = _`~name~`.sub(keys); return cast(O)this; }

  O clear`~Name~`(this O)() { _`~name~` = _`~name~`.clear; return cast(O)this; }
`;
}
version(test_uim_oop) { unittest {
  class DTest { mixin(XPropertyAA!("int", "double", "a")); }
/*    assert((new DTest).a([1:1.0]).a[1] == 1.0);
   assert((new DTest).a([1:1.0]).a.hasKey(1));
   assert((new DTest).a([1:1.0]).a([2:3.0]).a.hasKey(2));
   assert(!(new DTest).a([1:1.0, 2:3.0]).aSub([2:3.0]).a.hasKey(2));
   assert((new DTest).aInit([1, 2], 1.0).a[1] == 1.0);
 */}}

template XPropertyArray(string datatype, string name) {
  const char[] Name = capitalize(name);
  const char[] XPropertyArray = `
  `~datatype~`[] _`~name~`; 
  @safe auto `~name~`() { return _`~name~`; }

  O `~name~`(this O)(`~datatype~`[] values...) { _`~name~` = _`~name~`.add(values); return cast(O)this; }
  O `~name~`(this O)(`~datatype~`[] values, bool unique = false) { _`~name~` = _`~name~`.add(values, unique); return cast(O)this; }
  
  O remove`~Name~`(this O)(`~datatype~`[] values...) { remove`~Name~`(values); return cast(O)this; }
  O remove`~Name~`(this O)(`~datatype~`[] values) { 
    foreach(value; values) if (value.index(_`~name~`) != -1) _`~name~`.removeKey(value.index(_`~name~`)); 
    return cast(O)this; }

  O clear`~Name~`(this O)() { _`~name~` = null; return cast(O)this; }
`;
}
version(test_uim_oop) { unittest {
  class DTest { mixin(XPropertyArray!("int", "a")); }
   assert((new DTest).a(0).a == [0]);
  assert((new DTest).a(0).a(1).a == [0, 1]);
  assert((new DTest).a(0, 1).a == [0, 1]);
  assert((new DTest).a(0).clearA.a == null);
  assert((new DTest).a([1, 2, 3]).a == [1, 2, 3]);
   // assert((new DTest).a([1, 2, 3]).removeA(4).a == [1, 2, 3]);
  /* assert((new DTest).a([1, 2, 3, 1]).a == [1, 2, 3, 1]); 
  assert((new DTest).a([1, 2, 3, 1]).removeA(1).a == [2, 3, 1]);
  assert((new DTest).a([1, 2, 3, 1]).removeA([1]).a == [2, 3, 1]);  */
   //assert((new DTest).a(["a", "b", "c"]).removeA(["a"], true).a == ["b", "c"]);
}}
