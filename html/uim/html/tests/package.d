/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.html.tests;

import uim.html;
@safe:

void testH5Obj(DH5Obj obj, string tag, bool single = false) {
  assert(obj, tag~" object is null");
  assert(obj == (single ? `<%s>`.format(tag) : `<%s></%s>`.format(tag, tag)), tag~" has wrong work base string");
  
  // Test classes

  assert(H5Obj.attributes(["a": "b"]).attributes == ["a": "b"]); 
}

void testH5ObjAttributes(DH5Obj obj, string tag, string[] attributes, bool single = false) {
}

template TestH5Double(string h5, string tag, bool showRendering = false) {
  const char[] TestH5Double = `
  assert(`~h5~`("content") == "<`~tag~`>content</`~tag~`>");

  assert(`~h5~`(["a", "b"]) == "<`~tag~` class=\"a b\"></`~tag~`>");
  assert(`~h5~`(["a", "b"], "content") == "<`~tag~` class=\"a b\">content</`~tag~`>");
  assert(`~h5~`(["a", "b"], ["x":"y"]) == "<`~tag~` class=\"a b\" x=\"y\"></`~tag~`>");
  assert(`~h5~`(["a", "b"], ["x":"y"], "content") == "<`~tag~` class=\"a b\" x=\"y\">content</`~tag~`>");
  assert(`~h5~`(["x":"y"]) == "<`~tag~` x=\"y\"></`~tag~`>");
  assert(`~h5~`(["x":"y"], "content") == "<`~tag~` x=\"y\">content</`~tag~`>");

  assert(`~h5~`("x", ["a", "b"]) == "<`~tag~` id=\"x\" class=\"a b\"></`~tag~`>");
  assert(`~h5~`("x", ["a", "b"], "content") == "<`~tag~` id=\"x\" class=\"a b\">content</`~tag~`>");
  assert(`~h5~`("x", ["a", "b"], ["x":"y"]) == "<`~tag~` id=\"x\" class=\"a b\" x=\"y\"></`~tag~`>");
  assert(`~h5~`("x", ["a", "b"], ["x":"y"], "content") == "<`~tag~` id=\"x\" class=\"a b\" x=\"y\">content</`~tag~`>");
  assert(`~h5~`("x", ["x":"y"]) == "<`~tag~` id=\"x\" x=\"y\"></`~tag~`>");
  assert(`~h5~`("x", ["x":"y"], "content") == "<`~tag~` id=\"x\" x=\"y\">content</`~tag~`>");

  assert(`~h5~`(H5Div, H5Div) == "<`~tag~`><div></div><div></div></`~tag~`>", "In `~tag~`: Test classes 01");
  assert(`~h5~`(["a", "b"], H5Div, H5Div) == "<`~tag~` class=\"a b\"><div></div><div></div></`~tag~`>", "In `~tag~`: Test classes 01");
  assert(`~h5~`(["a", "b"], ["x":"y"], H5Div, H5Div) == "<`~tag~` class=\"a b\" x=\"y\"><div></div><div></div></`~tag~`>", "In `~tag~`: Test classes 01");
  assert(`~h5~`(["x":"y"], H5Div, H5Div) == "<`~tag~` x=\"y\"><div></div><div></div></`~tag~`>", "In `~tag~`: Test classes 01");
  assert(`~h5~`("x", ["a", "b"], H5Div, H5Div) == "<`~tag~` id=\"x\" class=\"a b\"><div></div><div></div></`~tag~`>", "In `~tag~`: Test classes 01");
  assert(`~h5~`("x", ["a", "b"], ["x":"y"], H5Div, H5Div) == "<`~tag~` id=\"x\" class=\"a b\" x=\"y\"><div></div><div></div></`~tag~`>", "In `~tag~`: Test classes 01");
  assert(`~h5~`("x", ["x":"y"], H5Div, H5Div) == "<`~tag~` id=\"x\" x=\"y\"><div></div><div></div></`~tag~`>", "In `~tag~`: Test classes 01");

  assert(`~h5~`([H5Div, H5Div]) == "<`~tag~`><div></div><div></div></`~tag~`>", "In `~tag~`: Test classes 01");
  assert(`~h5~`(["a", "b"], [H5Div, H5Div]) == "<`~tag~` class=\"a b\"><div></div><div></div></`~tag~`>", "In `~tag~`: Test classes 01");
  assert(`~h5~`(["a", "b"], ["x":"y"], [H5Div, H5Div]) == "<`~tag~` class=\"a b\" x=\"y\"><div></div><div></div></`~tag~`>", "In `~tag~`: Test classes 01");
  assert(`~h5~`(["x":"y"], [H5Div, H5Div]) == "<`~tag~` x=\"y\"><div></div><div></div></`~tag~`>", "In `~tag~`: Test classes 01");
  assert(`~h5~`("x", ["a", "b"], [H5Div, H5Div]) == "<`~tag~` id=\"x\" class=\"a b\"><div></div><div></div></`~tag~`>", "In `~tag~`: Test classes 01");
  assert(`~h5~`("x", ["a", "b"], ["x":"y"], [H5Div, H5Div]) == "<`~tag~` id=\"x\" class=\"a b\" x=\"y\"><div></div><div></div></`~tag~`>", "In `~tag~`: Test classes 01");
  assert(`~h5~`("x", ["x":"y"], [H5Div, H5Div]) == "<`~tag~` id=\"x\" x=\"y\"><div></div><div></div></`~tag~`>", "In `~tag~`: Test classes 01");
  `;
} 

template TestH5DoubleClasses(string h5, string tag, bool showRendering = false) {
  const char[] TestH5DoubleClasses = `
    `~(showRendering ? `writeln(`~h5~`(["a", "b"]));` : ``)~` 
    assert(`~h5~`(["a", "b"]).classes == ["a", "b"], "In `~tag~`: Test classes 01"); 
    assert(`~h5~`(["a", "b"]) == "<`~tag~` class=\"a b\"></`~tag~`>", "In `~tag~`: Test classes 1"); 
    
    assert(`~h5~`()(["a", "b"]).classes == ["a", "b"], "In `~tag~`: Error classes 2"); 
    assert(`~h5~`()(["a", "b"]) == "<`~tag~` class=\"a b\"></`~tag~`>", "In `~tag~`: Error classes 3"); 

    // Set classes
    assert(`~h5~`(["a", "b"]).classes(["c", "d"]).classes == ["c", "d"], "In `~tag~`: Test classes 011"); 
    assert(`~h5~`(["a", "b"]).classes("c", "d").classes == ["c", "d"], "In `~tag~`: Test classes 012"); 

    // Adding classes
    // Using opCall
    assert(`~h5~`()(["a", "b"])(["c", "d"]).classes == ["a", "b", "c", "d"], "In `~tag~`: Error classes 4"); 
    assert(`~h5~`()(["a", "b"])(["c", "d"]) == "<`~tag~` class=\"a b c d\"></`~tag~`>", "In `~tag~`: Error classes 5"); 
    
    // Using addClasses
    assert(`~h5~`()(["a", "b"]).addClasses(["c", "d"]).classes == ["a", "b", "c", "d"], "In `~tag~`: Error classes 41"); 
    assert(`~h5~`()(["a", "b"]).addClasses(["c", "d"]) == "<`~tag~` class=\"a b c d\"></`~tag~`>", "In `~tag~`: Error classes 51"); 
    
    // Using addClasses
    // assert(`~h5~`().addClasses(["a", "b"]).addClasses(["c", "d"]).classes == ["a", "b", "c", "d"], "In `~tag~`: Error classes 411"); 
    // assert(`~h5~`().addClasses(["a", "b"]).addClasses(["c", "d"]) == "<`~tag~` class=\"a b c d\"></`~tag~`>", "In `~tag~`: Error classes 511"); 
    // Using addClasses (with variadic)
    // assert(`~h5~`().addClasses("a", "b").addClasses("c", "d").classes == ["a", "b", "c", "d"], "In `~tag~`: Error classes 411"); 
    // assert(`~h5~`().addClasses("a", "b").addClasses("c", "d") == "<`~tag~` class=\"a b c d\"></`~tag~`>", "In `~tag~`: Error classes 511"); 

    // Classes should be unique
    // assert(`~h5~`()(["a", "b"])(["a", "d"]).classes == ["a", "b", "d"], "In `~tag~`: Error classes 42"); 
    // assert(`~h5~`()(["a", "b"])(["a", "d"]) == "<`~tag~` class=\"a b d\"></`~tag~`>", "In `~tag~`: Error classes 52"); 

    // assert(`~h5~`.classes(["a", "b"]).classes == ["a", "b"], "In `~tag~`: Error classes 6"); 
    // assert(`~h5~`.classes(["a", "b"]) == "<`~tag~` class=\"a b\"></`~tag~`>", "In `~tag~`: Error classes 7"); 

    // assert(`~h5~`.classes(["b", "a"]).classes == ["a", "b"], "In `~tag~`: Error classes 8"); 
    // assert(`~h5~`.classes(["b", "a"]) == "<`~tag~` class=\"a b\"></`~tag~`>", "In `~tag~`: Error classes 9"); 

    // assert(`~h5~`.classes("a", "b").classes == ["a", "b"], "In `~tag~`: Error classes 10"); 
    // assert(`~h5~`.classes("a", "b") == "<`~tag~` class=\"a b\"></`~tag~`>", "In `~tag~`: Error classes 11"); 

    // assert(`~h5~`.classes("b", "a").classes == ["a", "b"], "In `~tag~`: Error classes 12"); 
    // assert(`~h5~`.classes("b", "a") == "<`~tag~` class=\"a b\"></`~tag~`>", "In `~tag~`: Error classes 13");
  `;
} 

template TestH5DoubleAttributes(string h5, string tag, string[] attributes, bool showRendering = false) {
  const char[] TestH5DoubleAttributes = 
    (showRendering ? attributes.map!(a => `writeln(`~h5~`.`~a~`("aValue"));`).join : "")~
    attributes.map!(a => `// assert(`~h5~`.`~a~`("aValue").`~a~` == "aValue", "Tag `~tag~`: No setting attribute `~a~`");`).join ~
    attributes.map!(a => `// assert(`~h5~`.`~a~`("aValue") == "<`~tag~` `~a.toLower~`=\"aValue\"></`~tag~`>", "Tag `~tag~`: Wrong rendering with attribute `~a~`");`).join;
}

template TestH5SingleAttributes(string h5, string tag, string[] attributes, bool showRendering = false) {
  const char[] TestH5SingleAttributes = 
    (showRendering ? attributes.map!(a => `writeln(`~h5~`.`~a~`("aValue"));`).join : "")~
    attributes.map!(a => `// assert(`~h5~`.`~a~`("aValue").`~a~` == "aValue", "Tag `~tag~`: No setting attribute `~a~`");`).join ~
    attributes.map!(a => `// assert(`~h5~`.`~a~`("aValue") == "<`~tag~` `~a.toLower~`=\"aValue\">", "Tag `~tag~`: Wrong rendering with attribute `~a~`");`).join;
}

//  
// 

/*   // Global HTML attributes  
  O accesskey(this O)(string value) { if (value.length > 0) attributes.set("accesskey", value); return cast(O)this; }
  O contenteditable(this O)(bool value) { if (value) attributes.set("contenteditable", "true"); return cast(O)this; }
  O contextmenu(this O)(string value) { if (value.length > 0) attributes.set("contextmenu", value); return cast(O)this; }
  O dir(this O)(string value) { if (value.length > 0) attributes.set("dir", value); return cast(O)this; }
  O draggable(this O)(bool value) { if (value) attributes.set("draggable", "true"); return cast(O)this; }
  O dropzone(this O)(string value) { if (value.length > 0) attributes.set("dropzone", value); return cast(O)this; }
  O hidden(this O)(bool value) { if (value) attributes.set("hidden", "true"); return cast(O)this; }
  O lang(this O)(string value) { if (value.length > 0) attributes.set("lang", value); return cast(O)this; }
  O spellcheck(this O)(bool value) { if (value) attributes.set("spellcheck", "true"); return cast(O)this; }
  O style(this O)(string value) { if (value.length > 0) attributes.set("style", value); return cast(O)this; }
  O tabindex(this O)(string value) { if (value.length > 0) attributes.set("tabindex", value); return cast(O)this; }
  O title(this O)(string value) { if (value.length > 0) attributes.set("title", value); return cast(O)this; }
  O translate(this O)(bool value) { if (value) attributes.set("translate", "true"); return cast(O)this; } */