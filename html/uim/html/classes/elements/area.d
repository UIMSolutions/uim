module uim.html.classes.elements.area;

@safe:
import uim.html;

/**
 * The <area> tag defines an area inside an image-map (an image-map is an image with clickable areas).

The <area> element is always nested inside a <map> tag.

Note: The usemap attribute in the <img> tag is associated with the <map> element's name attribute, and creates a relationship between the image and the map.
*/
class DH5Area : DH5Obj {
	mixin(H5This!"area");

	// Attribute alt - A text string alternative to display on browsers that do not display images.
	mixin(MyAttribute!"alt");

	// Attribute coords - The coords attribute details the coordinates of the shape attribute in size, shape, and placement of an <area>.
	mixin(MyAttribute!"coords");

	// Attribute download - causes the browser to treat the linked URL as a download
	mixin(MyAttribute!"download");

	// Attribute href - The URL that the hyperlink points to
	mixin(MyAttribute!"href");

	// Attribute hreflang - Hints at the human language of the linked URL
	mixin(MyAttribute!"hreflang");

	// Attribute ping - A space-separated list of URLs. 
	// When the link is followed, the browser will send POST requests with the body PING to the URLs. Typically for tracking.
	mixin(MyAttribute!"ping");

	// Attribute reffererpolicy - How much of the referrer to send when following the link.
	// Valid values: no-referrer, no-referrer-when-downgrade, origin, origin-when-cross-origin, same-origin, strict-origin, strict-origin-when-cross-origin, unsafe-url
	mixin(MyAttribute!"referrerpolicy");

	// Attribute rel - The relationship of the linked URL as space-separated link types.
	mixin(MyAttribute!"rel");

	// Attribute shape - The shape of the associated hot spot.
	mixin(MyAttribute!"shape");

	// Attribute target - Where to display the linked URL, as the name for a browsing context (a tab, window, or <iframe>) 
	mixin(MyAttribute!"target"); // Valid values: _self, _blank, _parent, _top
}
mixin(H5Short!"Area");

version(test_uim_html) { unittest {
	testH5Obj(H5Area, "area");
	assert(H5Area == `<area></area>`);

	mixin(TestH5DoubleAttributes!("H5Area", "area", [
		"alt", "coords", "download", "href", "hreflang", "ping", "referrerpolicy", "rel", "shape", "target"
	]));
}}



