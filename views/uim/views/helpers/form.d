module uim.views.helpers.form;

import uim.views;
@safe:

version (test_uim_views) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
} 

/**
 * Form helper library.
 *
 * Automatic generation of HTML FORMs from given data.
 *
 * @method string text(string fieldName, Json[string] options = null) Creates input of type text.
 * @method string number(string fieldName, Json[string] options = null) Creates input of type number.
 * @method string email(string fieldName, Json[string] options = null) Creates input of type email.
 * @method string password(string fieldName, Json[string] options = null) Creates input of type password.
 * @method string search(string fieldName, Json[string] options = null) Creates input of type search.
 * @property \UIM\View\Helper\HtmlHelper myHtml
 * @property \UIM\View\Helper\UrlHelper myUrl
 */
class FormHelper : DHelper {
  /* mixin TIdGenerator;
  mixin TStringContents; */

  /**
     * The supported sources that can be used to populate input values.
     *
     * `context` - Corresponds to `IContext` instances.
     * `data` - Corresponds to request data (POST/PUT).
     * `query` - Corresponds to request"s query string.
     */
  protected string[] _supportedValueSources = ["context", "data", "query"];

  // The default sources.
  protected string[] _valueSources = ["data", "context"];

  // Grouped input types.
  protected string[] _groupedInputTypes = ["radio", "multicheckbox"];
}