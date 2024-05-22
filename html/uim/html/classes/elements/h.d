module uim.html.classes.elements.h;

@safe:
import uim.html;

class DH5H1 : DH5Obj { 
	mixin(H5This!("h1"));
}
mixin(H5Short!"H1");

class DH5H2 : DH5Obj { 
	mixin(H5This!("h2"));
}
mixin(H5Short!"H2");

class DH5H3 : DH5Obj { 	
	mixin(H5This!("h3"));
}
mixin(H5Short!"H3");

class DH5H4 : DH5Obj { 
	mixin(H5This!("h4"));
}
mixin(H5Short!"H4");

class DH5H5 : DH5Obj { 
	mixin(H5This!("h5"));
}
mixin(H5Short!"H5");

class DH5H6 : DH5Obj { 	
	mixin(H5This!("h6"));
}
mixin(H5Short!"H6");

version(test_uim_html) { unittest {
	// TODO
	
}}