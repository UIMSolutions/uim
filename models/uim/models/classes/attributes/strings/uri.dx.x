module uim.models.classes.attributes.strings.uri;

/* any <- char <- string <- uri
Traits
is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
means.reference.URI */

import uim.models;

@safe:
class DUriAttribute : DStringAttribute {
  mixin(AttributeThis!("UriAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("uri");
    registerPath("uri");

    return true;
  }
}

mixin(AttributeCalls!("UriAttribute"));

///
unittest {
  auto attribute = new DUriAttribute;
  assert(attribute.name == "uri");
  assert(attribute.registerPath == "uri");

  DAttribute generalAttribute = attribute;
  assert(cast(DUriAttribute) generalAttribute);
  assert(cast(DStringAttribute) generalAttribute);
  assert(!cast(DIntegerAttribute) generalAttribute);

  // IData value = attribute.createValue();
  // assert(cast(DStringData) value);
}
