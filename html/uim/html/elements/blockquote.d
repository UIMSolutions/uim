module uim.html.elements.blockquote;

@safe:
import uim.html;

// Wrapper for the blockquote tag - indicates that the enclosed text is an extended quotation
class DH5Blockquote : DH5Obj {
	mixin(H5This!"blockquote");

  // Cite = A URL that designates a source document or message for the information quoted. 
  // This attribute is intended to point to information explaining the context or the reference for the quote.
  mixin(MyAttribute!("cite"));
  version(test_uim_html) { unittest {
    assert(H5Blockquote.cite("/server/somewhere").cite == "/server/somewhere");
    assert(H5Blockquote.cite("/server/somewhere") == `<blockquote cite="/server/somewhere"></blockquote>`);
  }}
}
mixin(H5Short!"Blockquote");

version(test_uim_html) { unittest {
  testH5Obj(H5Blockquote, "blockquote");
}}
