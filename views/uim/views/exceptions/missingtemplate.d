module uim.views.exceptions.missingtemplate;

import uim.views;

@safe:

// Used when a template file cannot be found.
class DMissingTemplateException : DViewException {
  mixin(ExceptionThis!("MissingTemplate"));

  override bool initialize(IData[string] configData = null) {
		if (!super.initialize(configData)) { return false; }

    templateType("Template");

    return true;
  }

  mixin(TProperty!("string", "templateName"));

  mixin(TProperty!("string", "fileName"));

  // The path list that template could not be found in
  mixin(TProperty!("string[]", "paths"));

  mixin(TProperty!("string", "templateType"));

  this(string newFileName, string[] checkedPaths = [], int errorCode = 0, Throwable previousException = null) {
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
  override Json[string] attributes() {
    return super.attributes().update([
      "file": Json(fileName),
      "paths": Json(paths),
    ]);
  }
}
