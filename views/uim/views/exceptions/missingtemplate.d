/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.views.exceptions.missingtemplate;    if (!super.initialize(initData)) {
      return false;
    }

import uim.views;

@safe:

// Used when a template file cannot be found.
class DMissingTemplateException : DViewException {
  mixin(ExceptionThis!("MissingTemplate"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    templateType("Template");

    return true;
  }

  mixin(TProperty!("string", "templateName"));

  mixin(TProperty!("string", "fileName"));

  // The path list that template could not be found in
  mixin(TProperty!("string[]", "paths"));

  mixin(TProperty!("string", "templateType"));

  this(string newFileName, string[] checkedPaths= null, int errorCode = 0, Throwable previousException = null) {
    fileName(newFileName);
    templateName(null);
    paths(checkedPaths);

    // TODO
    // super(this.formatMessage(), errorCode, previousException);
  }

  // Get the formatted exception message.
  string formatMessage() {
    auto name = this.templateName ? templateName : fileName;
    string formattedMessage = "%s file `%s` could not be found.".format(templateType, name);
    formattedMessage ~= !paths.isEmpty
      ? "\n\nThe following paths were searched:\n\n" ~ paths.map!(path => "- `{mypath}{this.filename}`\n").join
      : "";
    return formattedMessage;
  }

  // Get the passed in attributes
  override void attributes(Json[string] newAttributes) {
    _attributes = newAttributes;
  }
  
  override Json[string] attributes() {
    return super.attributes()
      .set("file", Json(fileName))
      .set("paths", Json(paths.map!(path => Json(path)).array));
  }
}
