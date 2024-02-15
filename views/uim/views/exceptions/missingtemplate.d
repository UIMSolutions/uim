module uim.views.exceptions;

import uim.views;

@safe:

// Used when a template file cannot be found.
class MissingTemplateException : DViewException {
  mixin(TProperty!("string", "templateName"));

  mixin(TProperty!("string", "fileName"));

  // The path list that template could not be found in
  mixin(TProperty!("string[]", "paths"));

  protected string templateType = "Template";

  this(string newFileName, string[] checkedPaths = [], int code = 0, Throwable previousException = null) {
    filename(newFileName);
    templateName(null);
    paths(checkedPaths);

    super(this.formatMessage(), code, previousException);
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
