module uim.html.classes.element;

import uim.html;
@safe:

template classes() {
	const char[] classes = `
	 string[] classes() { 
		if ("class" in attributes) return attributes["class"].split(" ").unique; 
		return null;
	}
  @property O classes(this O)(string newClass) { return this.classes(newClass.split(" ").unique);  }
  @property O classes(this O)(string[] someClasses) {
		if (classes) _attributes["class"] = (classes ~ someClasses).unique.join(" "); 
		else _attributes["class"] = someClasses.unique.join(" "); 
		return cast(O)this; 
	}
	
	 bool hasClasses(string[] someClasses) { foreach(c; someClasses) if (!hasClass(c)) { 
      return false; 
    } return true; }
	 bool hasClass(string classname) { return classes.has(classname); }
	
	 O addClasses(this O)(string[] someClasses) { this.classes(someClasses); return cast(O)this; }
	 O addClass(this O)(string newClass) { this.classes(newClass); return cast(O)this; }
	
	 O removeClass(this O)(string[] someClasses) { foreach(c; someClasses) removeClass(c); return cast(O)this; }
	 O removeClass(this O)(string classname) { if (hasclass(classname)) classes = std.algorithm.mutation.remove((classes, classname); return cast(O)this; }
	
	 O toggleClass(this O)(string[] someClasses) { foreach(c; someClasses) toggleclass(c); return cast(O)this; }
	 O toggleClass(this O)(string classname) { if (hasclass(classname)) removeClass(classname); else addClass(classname); return cast(O)this; }
	`;
}

enum ShowMode { standard, onlyHTML, onlyJS, onlyCSS }

version(test_uim_html) { unittest {
		// TODO Add Test
}}