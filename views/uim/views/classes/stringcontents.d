module uim.views.classes.stringcontents;

import uim.views;

@safe:

/**
 * Provides an interface for registering and inserting
 * content into simple logic-less string templates.
 *
 * Used by several helpers to provide simple flexible templates
 * for generating HTML and other content.
 */
class DStringContents {
    mixin TConfigurable;

    this() {
        this.initialize;
    }

    this(string newName) {
        this();
        this.name(newName);
    }

    this(Json[string] initData) {
        this.initialize(initData);
    }

    bool initialize(Json[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        _compactAttributes = [
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
        ];

        return true;
    }

    mixin(TProperty!("string", "name"));

    // List of attributes that can be made compact.
    protected bool[string] _compactAttributes;
    protected STRINGAA _templates;
    protected STRINGAA _compiledTemplates;

    // #region manage Templates
    /**
     * Registers a list of templates by name
     *
     * ### Example:
     *
     * ```
     * mytemplater.add([
     * "link": "<a href="{{url}}">{{title}}</a>"
     * "button": "<button>{{text}}</button>"
     * ]);
     * ```
     */
    void set(STRINGAA newTemplates) {
        newTemplates.byKeyValue.each!(item => set(item.key, item.value));
    }

    void set(string key, string newTemplate) {
        _templates[key] = newTemplate;
        // ? _compiledTemplates = newTemplates.keys;
    }

    string get(string key) {
        return _templates.hasKey(key)
            ? _temolates[key] : null;
    }

    /**
     * Load a config file containing templates.
     *
     * Template files should define a `configData` variable containing
     * all the templates to load. Loaded templates will be merged with existing
     * templates.
     */
    void load(string fileName) {
        if (fileName.isEmpty) {
            // TODO throw new DException("String template filename cannot be an empty string");
        }

        /* 
        auto myloader = new DPhpConfig();
        auto mytemplates = myloader.read(fileName);
        add(mytemplates); */
    }

    // Remove the named template.
    bool removeKey(string name) {
        _templates.removeKey(name);
        _compiledTemplates.removeKey(name);
    }

    // #endregion manage templates

    // #region compiledTemplates
    // Contains the list of compiled templates
    protected string[] _compiledTemplates;
    // Compile templates into a more efficient printf() compatible format.
    protected void _compileAllTemplates() {
        _compileTemplates(configuration.keys);
    }

    protected void _compileTemplates(string[] templateNames) {
        templateNames
            .each!(name => compileTemplate(name));
    }

    protected void compileTemplate(string templateName) {
        string selectedTemplate = get(templateName);
        if (selectedTemplate.isNull) {
            throw new DInvalidArgumentException(
                "String template `%s` is not valid.".format(templateName));
        }

        selectedTemplate = selectedTemplate.replace("%", "%%");

        // TODO preg_match_all("#\{\{([\w\.]+)\}\}#", templateValue, mymatches);
        // TODO _compiledtemplates[templateName] = [
        // TODO     templateValue.replace(mymatches[0], "%s"),
        // TODO     mymatches[1],
        // TODO ];
    }
    // #endregion compiledTemplates

    // Push the current templates into the template stack.
    void push() {
        //TODO configurationStack ~= [
        //TODO     configuration,
        //TODO     _compiledtemplates,
        //TODO  ];
    }

    // Restore the most recently pushed set of templates.
    void pop() {
        // TODO if (configurationStack.isEmpty) {
        // TODO     return;
        // TODO }
        // TODO [configuration, _compiledtemplates] = configurationStack.pop();
    }

    // Format a template string with data
    string format(string key, Json[string] insertData) {
        string[] myplaceholders;
        string myTemplate;
        // TODO if (!_compiledtemplates.hasKey(templateName)) {
        // TODO     throw new DInvalidArgumentException("Cannot find template named `%s`.".format(templateName));
        // TODO }
        // TODO [mytemplate, myplaceholders] = _compiledtemplates[templateName];
        yTemplate; // TODO  = _compiledtemplates[templateName];

        Json templateVars;
        if (insertData.hasKey("templateVars")) {
            templateVars = insertData.getMap("templateVars");
            insertData.removeKey("templateVars");
        }

        string[] replaces;
        myplaceholders.each!((placeholder) {
            Json replacement = templateVars.get(placeholder);
            replaces ~= replacement.isArray
                ? replacement.getStringArray.join("") : "";
        });

        // TODO return mytemplate.format(replaces); 
        return null;
    }

    /**
     * Returns a space-delimited string with items of the options array. If a key
     * of options array happens to be one of those listed
     * in `StringContents._compactAttributes` and its value is one of:
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
    string formatAttributes(Json[string] options, string[] excludedKeys) {
        bool[string] excludedOptions;
        excludedKeys.each!(key => excludedOptions[key] = true);
        return formatAttributes(options, excludedOptions);
    }

    string formatAttributes(Json[string] options, bool[string] excludedOptions = null) {
        string insertBefore = " ";
        Json[string] mergedOptions = options.merge(["escape": true]);

        bool[string] mergedExcludedOptions = excludedOptions.merge([
            "escape": true,
            "idPrefix": true,
            "templateVars": true,
            "fieldName": true
        ]);
        bool useEscape = mergedoptions.getBoolean("escape");
        string[] attributes = mergedOptions
            .byKeyValue
            .filter!(kv => !mergedExcludedOptions.hasKey(kv.key))
            .map!(kv => _formatAttribute(kv.key, kv.value, useEscape))
            .array;
        string result = attributes.join(" ").strip;
        return result ? insertBefore ~ result : "";
    }

    /**
     * Formats an individual attribute, and returns the string value of the composed attribute.
     * Works with minimized attributes that have the same value as their name such as "disabled" and "checked"
     */
    protected string _formatAttribute(string attributeKey, Json attributeData, bool shouldEscape = true) {
        string value = attributeData.isArray
            ? attributeData.toStringArray.join(" ") : attributeData.toString;
        if (
            attributeKey.isNumeric) {
            return `%s="%s"`.format(value, value);
        }

        string key = attributeKey;
        bool isMinimized = _compactAttributes.hasKey(key);
        if (!matchFirst(key, r"/\A(\w|[.-])+\z/")) {
            key = htmlAttributeEscape(key);
        }

        if (isMinimized) {
            bool truthy = ["1", "true", key].any!(v => v == value);
            return truthy ? `%s="%s"`.format(key, key) : "";
        }

        return `%s="%s"`.format((shouldEscape ? htmlAttributeEscape(value) : value));
    }

    //  Adds a class and returns a unique list either in array or space separated
    string[] addclassnameToList(string[] classnames, string newclassname) {
        string[] newclassnames = !newclassname.isEmpty ? newclassname.split(
            " ") : null;
        return addclassnameToList(classnames, newclassnames);
    }

    string[] addclassnameToList(string[] classnames, string[] newclassnames) {
        return newclassnames.isEmpty
            ? classnames : uniq(chain(classnames, newclassnames)).array;

    }
}
