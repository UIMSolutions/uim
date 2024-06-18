module uim.html.classes.elements.dd;

import uim.html;
@safe:

/* Dd-Elemente enthalten eine Beschreibung eines zu beschreibenden Ausdrucks in einer Beschreibungsliste (Dd = description list data) */
class DH5Dd : DH5Obj {
	mixin(H5This!"dd");
}
mixin(H5Short!"Dd");

version(test_uim_html) { unittest {
  testH5Obj(H5Dd, "dd");
}}
