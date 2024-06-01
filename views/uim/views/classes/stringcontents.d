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
            "allowfullscreen": true.toJson,
            "async": true.toJson,
            "autofocus": true.toJson,
            "autoload": true.toJson,
            "autoplay": true.toJson,
            "checked": true.toJson,
            "compact": true.toJson,
            "controls": true.toJson,
            "declare": true.toJson,
            "default": true.toJson,
            "defaultchecked": true.toJson,
            "defaultmuted": true.toJson,
            "defaultselected": true.toJson,
            "defer": true.toJson,
            "disabled": true.toJson,
            "enabled": true.toJson,
            "formnovalidate": true.toJson,
            "hidden": true.toJson,
            "indeterminate": true.toJson,
            "inert": true.toJson,
            "ismap": true.toJson,
            "itemscope": true.toJson,
            "loop": true.toJson,
            "multiple": true.toJson,
            "muted": true.toJson,
            "nohref": true.toJson,
            "noresize": true.toJson,
            "noshade": true.toJson,
            "novalidate": true.toJson,
            "nowrap": true.toJson,
            "open": true.toJson,
            "pauseonexit": true.toJson,
            "readonly": true.toJson,
            "required": true.toJson,
            "reversed": true.toJson,
            "scoped": true.toJson,
            "seamless": true.toJson,
            "selected": true.toJson,
            "sortable": true.toJson,
            "truespeed": true.toJson,
            "typemustmatch": true.toJson,
            "visible": true.toJson,
        ];

        return true;
    }

    mixin(TProperty!("string", "name"));

    // List of attributes that can be made compact.
    protected bool[string] _compactAttributes;

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
    void add(STRINGAA newTemplates) {
        // TODO add(newTemplates.toJsonString);
    }

    void add(Json[string] newTemplates) {
        configuration.update(newTemplates);
        _compiledTemplates = newTemplates.keys;
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
            // TODO throw new UimException("String template filename cannot be an empty string");
        }

        /* 
        auto myloader = new DPhpConfig();
        auto mytemplates = myloader.read(fileName);
        add(mytemplates); */
    } 
    
    // Remove the named template.
    bool remove(string templateName) {
        configuration.remove(templateName);
        _compiledTemplates.remove(templateName);
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
        string templateValue; // TODO  = get(templateName);
        // TODO if (templateValue.isNull) {
        // TODO    throw new DInvalidArgumentException("String template `%s` is not valid.".format(templateName));
        // TODO}

        // TODO assert(templateValue.isString,
        // TODO     "Template for `%s` must be of type `string`, but is `%s`".format(templateName, templateValue)
        // TODO );

        templateValue = templateValue.replace("%", "%%");

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
        // TODO [configuration, _compiledtemplates] = array_pop(configurationStack);
    } 


    // Format a template string with data
    string format(string templateName, Json[string] insertData) {
        auto dataToInsert = insertData.dup;
        
        // TODO if (!_compiledtemplates.hasKey(templateName)) {
        // TODO     throw new DInvalidArgumentException("Cannot find template named `%s`.".format(templateName));
        // TODO }
        // TODO [mytemplate, myplaceholders] = _compiledtemplates[templateName];
        string myTemplate; // TODO  = _compiledtemplates[templateName];
        
        string[] myplaceholders;
        Json templateVars;
        if (dataToInsert.hasKey("templateVars")) {
            templateVars = dataToInsert["templateVars"];
            dataToInsert.remove("templateVars");
        }
        
        string[] myreplace;
        //TODO myplaceholders.each!((placeholder) {
        //TODO     auto myreplacement = templateVars.get(placeholder);
        //TODO     myreplace ~= myreplacement.isArray
        //TODO         ? myreplacement.join("")
        //TODO         : "";
        //TODO });

        // TODO return mytemplate.format(myreplace); 
        return null;
    }

    /**
     * Returns a space-delimited string with items of the options array. If a key
     * of options array happens to be one of those listed
     * in `StringContents._compactAttributes` and its value is one of:
     *
     * - "1" (string)
     * - "true" (string)
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
        excludedKeys.each!(ex => excludedOptions[ex] = true);
        return formatAttributes(options, excludedOptions);
    }

    string formatAttributes(Json[string] options, bool[string] excludedOptions = null) {
        string insertBefore = " ";
        Json[string] mergedOptions = options.merge(["escape": true.toJson]);

        bool[string] mergedExcludedOptions = excludedOptions.merge(["escape": true.toJson, "idPrefix": true.toJson, "templateVars": true.toJson, "fieldName": true]);
        bool useEscape = mergedOptions["escape"].to!bool;

        string[] attributes = mergedOptions.byKeyValue
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
            ? attributeData.toStringArray.join(" ")
            : attributeData.toString;

        if (attributeKey.isNumeric) {
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
    string[] addClassnameToList(string[] classnames, string newClassname) {
        string[] newClassnames = !newClassname.isEmpty ? newClassname.split(" ") : null;
        return addClassnameToList(classnames, newClassnames); 
    } 

    string[] addClassnameToList(string[] classnames, string[] newClassnames) {
        return newClassnames.isEmpty
? classnames : uniq(chain(classnames, newClassnames)).array; 
    
}
