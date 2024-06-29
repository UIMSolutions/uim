module uim.html.classes.elements.mixins;



template H5Test(string classname, string tag) {
	const char[] H5Test = `
// assert(`~classname~`, "<`~tag~`></`~tag~`>"));`;
//
//// assert(`~classname~`.id("newID") == "<`~tag~` id=\"newID\"></`~tag~`>");
//// assert(`~classname~`.id("newID").classes(["classA", "classB"]) == "<`~tag~` id=\"newID\" class=\"classA classB\"></`~tag~`>");
//// assert(`~classname~`.id("newID").classes("classA", "classB") == "<`~tag~` id=\"newID\" class=\"classA classB\"></`~tag~`>");
//// assert(`~classname~`.id("newID").classes("classA", "classB").attributes(["a":"b"]) == "<`~tag~` id=\"newID\" class=\"classA classB\" a=\"b\"></`~tag~`>");
//// assert(`~classname~`.id("newID").classes("classA", "classB").attributes(["a":"b"]).content("content") == "<`~tag~` id=\"newID\" class=\"classA classB\" a=\"b\">content</`~tag~`>");
//// assert(`~classname~`.id("newID").attributes(["a":"b"]) == "<`~tag~` id=\"newID\" a=\"b\"></`~tag~`>");
//// assert(`~classname~`.id("newID").attributes(["a":"b"]).content("content") == "<`~tag~` id=\"newID\" a=\"b\">content</`~tag~`>");
//
//// assert(`~classname~`("someContent") == "<`~tag~`>someContent</`~tag~`>");
//// assert(`~classname~`(H5DIV("a"), H5DIV("b")) == "<`~tag~`><div id=\"a\"></div><div id=\"b\"></div></`~tag~`>");
//
//// assert(`~classname~`("newID", ["classA", "classB"]) == "<`~tag~` id=\"newID\" class=\"classA classB\"></`~tag~`>");
//// assert(`~classname~`("newID", ["classA", "classB"], "someContent") == "<`~tag~` id=\"newID\" class=\"classA classB\">someContent</`~tag~`>");
//// assert(`~classname~`("newID", ["classA", "classB"], H5DIV("a"), H5DIV("b")) == "<`~tag~` id=\"newID\" class=\"classA classB\"><div id=\"a\"></div><div id=\"b\"></div></`~tag~`>");
//
//// assert(`~classname~`("newID", ["a":"b", "c":"d"]) == "<`~tag~` id=\"newID\" a=\"b\" c=\"d\"></`~tag~`>");
//// assert(`~classname~`("newID", ["a":"b", "c":"d"], "someContent") == "<`~tag~` id=\"newID\" a=\"b\" c=\"d\">someContent</`~tag~`>");
//// assert(`~classname~`("newID", ["a":"b", "c":"d"], H5DIV("a"), H5DIV("b")) == "<`~tag~` id=\"newID\" a=\"b\" c=\"d\"><div id=\"a\"></div><div id=\"b\"></div></`~tag~`>");
//
//// assert(`~classname~`("newID", ["classA", "classB"], ["a":"b", "c":"d"]) == "<`~tag~` id=\"newID\" class=\"classA classB\" a=\"b\" c=\"d\"></`~tag~`>");
//// assert(`~classname~`("newID", ["classA", "classB"], ["a":"b", "c":"d"], "someContent") == "<`~tag~` id=\"newID\" class=\"classA classB\" a=\"b\" c=\"d\">someContent</`~tag~`>");
//// assert(`~classname~`("newID", ["classA", "classB"], ["a":"b", "c":"d"], H5DIV("a"), H5DIV("b")) == "<`~tag~` id=\"newID\" class=\"classA classB\" a=\"b\" c=\"d\"><div id=\"a\"></div><div id=\"b\"></div></`~tag~`>");
//
//// assert(`~classname~`(["classA", "classB"]) == "<`~tag~` class=\"classA classB\"></`~tag~`>");
//// assert(`~classname~`(["classA", "classB"], "someContent") == "<`~tag~` class=\"classA classB\">someContent</`~tag~`>");
//// assert(`~classname~`(["classA", "classB"], H5DIV("a"), H5DIV("b")) == "<`~tag~` class=\"classA classB\"><div id=\"a\"></div><div id=\"b\"></div></`~tag~`>");
//
//// assert(`~classname~`(["classA", "classB"], ["a":"b", "c":"d"]) == "<`~tag~` class=\"classA classB\" a=\"b\" c=\"d\"></`~tag~`>");
//// assert(`~classname~`(["classA", "classB"], ["a":"b", "c":"d"], "someContent") == "<`~tag~` class=\"classA classB\" a=\"b\" c=\"d\">someContent</`~tag~`>");
//// assert(`~classname~`(["classA", "classB"], ["a":"b", "c":"d"], H5DIV("a"), H5DIV("b")) == "<`~tag~` class=\"classA classB\" a=\"b\" c=\"d\"><div id=\"a\"></div><div id=\"b\"></div></`~tag~`>");
//
//// assert(`~classname~`(["a":"b", "c":"d"]) == "<`~tag~` a=\"b\" c=\"d\"></`~tag~`>");
//// assert(`~classname~`(["a":"b", "c":"d"], "someContent") == "<`~tag~` a=\"b\" c=\"d\">someContent</`~tag~`>");
//// assert(`~classname~`(["a":"b", "c":"d"], H5DIV("a"), H5DIV("b")) == "<`~tag~` a=\"b\" c=\"d\"><div id=\"a\"></div><div id=\"b\"></div></`~tag~`>");
//
//auto h5 = `~classname~`;
//assert(H5.id("newID") == "<`~tag~` id=\"newID\"></`~tag~`>");
//assert(H5.id("newID").classes(["classA", "classB"]) == "<`~tag~` id=\"newID\" class=\"classA classB\"></`~tag~`>");
//assert(H5.id("newID").classes("classA", "classB") == "<`~tag~` id=\"newID\" class=\"classA classB\"></`~tag~`>");
//assert(H5.id("newID").classes("classA", "classB").attributes(["a":"b"]) == "<`~tag~` id=\"newID\" class=\"classA classB\" a=\"b\"></`~tag~`>");
//assert(H5.id("newID").classes("classA", "classB").attributes(["a":"b"]).content("content") == "<`~tag~` id=\"newID\" class=\"classA classB\" a=\"b\">content</`~tag~`>");
//
//// assert(cast(D`~classname~`)`~classname~`);
//// assert(cast(D`~classname~`)`~classname~`.id("newID"));
//// assert(cast(D`~classname~`)`~classname~`.classes("classA", "classB"));
//	`;
//	pragma(msg, H5Test);
}
