module views.uim.views.exceptions.missingtemplate;

import uim.views;

@safe:

// Used when a template file cannot be found.
class DMissingTemplateException : DViewException {
    mixin(ExceptionThis!("MissingTemplate"));

    override bool initialize() {
    if (!super.initialize()) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-views");

    return true;
  }
  mixin(TProperty!("string", "templateName"));

  mixin(TProperty!("string", "fileName"));

  // The path list that template could not be found in
  mixin(TProperty!("string[]", "paths"));

  protected string templateType = "Template";

  this(string newFileName, string[] checkedPaths = [], int errorCode = 0, Throwable previousException = null) {
    filename(newFileName);
    templateName(null);
    paths(checkedPaths);

    super(this.formatMessage(), errorCode, previousException);
  }

  // Get the formatted exception message.
  string formatMessage() {
    auto name = this.templateName ?  this.templateName : this.filename;
    string formattedMessage = "%s file `%s` could not be found.".format(templateType, name);
    if (paths) {
      formattedMessage ~= "\n\nThe following paths were searched:\n\n";
      paths.each!(path => formattedMessage ~= "- `{mypath}{this.filename}`\n");
    }
    return formattedMessage;
  }

  // Get the passed in attributes
  IData[string] attributes() {
    return [
      "file": StringData(filename),
      "paths": ArrayData(paths),
    ];
  }
}
