module uim.views.helpers.attribute;

import uim.views;

@safe:

version (test_uim_views) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

class AttributeHelper {
  /**
     * Returns a space-delimited string with items of the options array. If a key
     * of options array happens to be one of those listed
     * in `StringContents._boolAttributes` and its value is one of:
     *
     * - "1" /* (string) * /
     * - "true" /* (string) * /
     *
     * Then the value will be reset to be identical with key"s name.
     * If the value is not one of these 4, the parameter is not output.
     *
     * "escape" is a special option in that it controls the conversion of
     * attributes to their HTML-entity encoded equivalents. Set to false to disable HTML-encoding.
     *
     * If value for any option key is set to `null` or `false`, that option will be excluded from output.
     *
     * This method uses the "attribute" and "compactAttribute" templates. Each of
     * these templates uses the `name` and `value` variables. You can modify these
     * templates to change how attributes are formatted.
     */
  static bool boolAttribute(string name) {
    return [
        "allowfullscreen": true,
        "async": true,
        "autofocus": true,
        "autoload": true,
        "autoplay": true,
        "checked": true,
        "compact": true,
        "controls": true,
        "declare": true,
        "default": true,
        "defaultchecked": true,
        "defaultmuted": true,
        "defaultselected": true,
        "defer": true,
        "disabled": true,
        "enabled": true,
        "formnovalidate": true,
        "hidden": true,
        "indeterminate": true,
        "inert": true,
        "ismap": true,
        "itemscope": true,
        "loop": true,
        "multiple": true,
        "muted": true,
        "nohref": true,
        "noresize": true,
        "noshade": true,
        "novalidate": true,
        "nowrap": true,
        "open": true,
        "pauseonexit": true,
        "readonly": true,
        "required": true,
        "reversed": true,
        "scoped": true,
        "seamless": true,
        "selected": true,
        "sortable": true,
        "truespeed": true,
        "typemustmatch": true,
        "visible": true,
      ].hasKey(name);
  }

  static string formatAttributes(Json[string] options, string[] excludedKeys) {
    bool[string] excluded;
    excludedKeys.each!(key => excluded[key] = excludedKeys.has(key));
    return formatAttributes(options, excluded);
  }

   static string formatAttributes(Json[string] options, bool[string] excluded = null) {
    string insertBefore = " ";
    options
      .merge("escape", true);

    excluded
      .merge("escape", true)
      .merge("idPrefix", true)
      .merge("templateVars", true)
      .merge("fieldName", true);

    bool useEscape = options.getBoolean("escape");
    string[] attributes = options.byKeyValue
      .filter!(kv => !excluded.hasKey(kv.key))
      .map!(kv => AttributeHelper.formatAttribute(kv.key, kv.value, useEscape))
      .array;

    string result = attributes.join(" ").strip;
    return result ? insertBefore ~ result : "";
  }

  /**
     * Formats an individual attribute, and returns the string value of the composed attribute.
     * Works with minimized attributes that have the same value as their name such as "disabled" and "checked"
     */
  static string formatAttribute(string key, Json attributeData, bool shouldEscape = true) {
    string value = attributeData.isArray
      ? attributeData.toStringArray.join(" ") : attributeData.toString;
    return AttributeHelper.formatAttribute(key, value, shouldEscape);
  }

  static string formatAttribute(string key, string value, bool shouldEscape = true) {
    // TODO 
    /* if (
            attributeKey.isNumeric) {
            return `%s="%s"`.format(value, value);
        } */

    key = key.strip;
    bool isBoolAttributes = AttributeHelper.boolAttribute(key);
    /* if (!matchFirst(key, r"/\A(\w|[.-])+\z/")) {
            key = htmlAttributeEscape(key);
        }

        if (isBoolAttributes) {
            bool truthy = ["1", "true", key].any!(v => v == value);
            return truthy ? `%s="%s"`.format(key, key) : "";
        } */

    return `%s="%s"`.format(key, shouldEscape ? htmlAttributeEscape(value) : value);
  }
}
