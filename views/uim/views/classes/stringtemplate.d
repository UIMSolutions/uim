module uim.views.classes.stringtemplate;

import uim.views;

@safe:

/**
 * Provides an interface for registering and inserting
 * content into simple logic-less string templates.
 *
 * Used by several helpers to provide simple flexible templates
 * for generating HTML and other content.
 */
class DStringTemplate {
    mixin TConfigurable!();

    this() {
        this.initialize;
    }

    this(string newName) {
        this();
        this.name(newName);
    }

    this(IData[string] initData) {
        this.initialize(initData);
    }

    bool initialize(IData[string] initData = null) {
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

    // Contains the list of compiled templates
    protected string[] _compiledTemplates;

    /**
     * Registers a list of templates by name
     *
     * ### Example:
     *
     * ```
     * mytemplater.add([
     *  "link": "<a href="{{url}}">{{title}}</a>"
     *  "button": "<button>{{text}}</button>"
     * ]);
     * ```
     */
    void add(STRINGAA newTemplates) {
        //TODO updateConfiguration(newTemplates);
        _compiledTemplates = newTemplates.keys;
    }

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

    // Compile templates into a more efficient printf() compatible format.
    protected void _compileAllTemplates() {
        // TODO _compileTemplates(configuration.keys);
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

    /**
     * Load a config file containing templates.
     *
     * Template files should define a `configData` variable containing
     * all the templates to load. Loaded templates will be merged with existing
     * templates.
     * /
    void load(string fileName) {
        if (fileName.isEmpty) {
            throw new UimException("String template filename cannot be an empty string");
        }

        auto myloader = new DPhpConfig();
        auto mytemplates = myloader.read(fileName);
        this.add(mytemplates);
    } */
    
    // Remove the named template.
    void remove(string templateName) {
        //TODO configuration.remove(templateName);
        _compiledTemplates.remove(templateName);
    }

    // Format a template string with data
    string format(string templateName, IData[string] insertData) {
        auto myData = insertData.dup;
        
        // TODO if (!_compiledtemplates.isSet(templateName)) {
        // TODO     throw new DInvalidArgumentException("Cannot find template named `%s`.".format(templateName));
        // TODO }
        // TODO [mytemplate, myplaceholders] = _compiledtemplates[templateName];
        string myTemplate; // TODO  = _compiledtemplates[templateName];
        string[] myplaceholders;
        
        IData[] templateVars;
        if (myData.isSet("templateVars")) {
            // TODO templateVars = myData["templateVars"];
            myData.remove("templateVars");
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
     * in `StringTemplate.my_compactAttributes` and its value is one of:
     *
     * - "1" (string)
     * - 1 (integer)
     * - true (boolean)
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
     * Params:
     * IData[string]|null options Array of options.
     * @param string[] myexclude Array of options to be excluded, the options here will not be part of the return.
     */
    string formatAttributes(IData[string] options, string[] excludes) {
        bool[string] newExcludes;
        excludes.each!(ex => newExcludes[ex] = true);
        return formatAttributes(options, newExcludes);
    }

    string formatAttributes(IData[string] options, bool[string] excludes = null) {
        string myinsertBefore = " ";
        auto updatedOptions = options.update(["escape": BooleanData(true)]);

        auto myExcludes = excludes.update(["escape": true, "idPrefix": true, "templateVars": true, "fieldName": true]);
        bool escape = updatedOptions["escape"].toBoolean;

        string[] attributes = updatedOptions.byKeyValue
            .filter!(kv => !myExcludes.hasKey(kv.key))
            .map!(kv => _formatAttribute(kv.key, kv.value, escape))
            .array;

        string result = strip(attributes.join(" "));
        return result ? myinsertBefore ~ result : "";
    }

    /**
     * Formats an individual attribute, and returns the string value of the composed attribute.
     * Works with minimized attributes that have the same value as their name such as "disabled" and "checked"
     * Params:
     * @param IData aValue The value of the attribute to create.
     * @param bool myescape Define if the value must be escaped
     */
    protected string _formatAttribute(string attributeKey, IData data, bool shouldEscape = true) {
        /*    if (isArray(myvalue)) {
            myvalue = join(" ", myvalue);
        }
        if (isNumeric(attributeKey)) {
            return "myvalue=\"myvalue\"";
        } */

        // mytruthy = [1, "1", true, "true", aKey];
        bool isMinimized; 
        // isMinimized = isSet(_compactAttributes[aKey]);
        // TODO if (!preg_match("/\A(\w|[.-])+\z/", aKey)) {
        //    aKey = htmlAttribEscape(aKey);
        // }
        
        if (isMinimized && ["1", "true", attributeKey].has(data.toString)) {
            return attributeKey~"=\"" ~attributeKey~ "\"";
        }
        // TODO if (myisMinimized) {
        //     return "";
        // }

        return attributeKey ~ "=\"" ~ (shouldEscape ? htmlAttribEscape(data.toString): data.toString) ~ "\"";
    }
    
    // TODO
    /**
     * Adds a class DAnd returns a unique list either in array or space separated
     * Params:
     * IData myinput The array or string to add the class to
     * @param string[]|string|false|null mynewClass the new class or classes to add
     * @param string myuseIndex if you are inputting an array with an element other than default of "class".
     * /
    string[] addClass(
        IData myinput,
        string[]|false|null mynewClass,
        string myuseIndex = "class"
    ) {
        // NOOP
        if (mynewClass.isEmpty) {
            return myinput;
        }
        if (myinput.isArray) {
            myclass = Hash.get(myinput, myuseIndex, []);
        } else {
            myclass = myinput;
            myinput = [];
        }
        // Convert and sanitise the inputs
        if (!myclass.isArray) {
            myClass = myclass.isString && !myclass.isEmpty
                ? myclass.split(" ")
                : null;

        }
        if (mynewClass.isString) {
            string[] mynewClass = mynewClass.split(" ");
        }
        auto myclass = array_unique(chain(myclass, mynewClass));
        return Hash.insert(myinput, myuseIndex, myclass);
    } */
}
