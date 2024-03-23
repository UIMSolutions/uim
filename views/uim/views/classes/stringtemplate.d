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

    this(string newName) { this();  this.name(newName); }
    this(IData[string] initData = null) {
        this.initialize(initData);
    }

    bool initialize(IData[string] initData = null) {
        configuration(MemoryConfiguration);
        setConfigurationData(initData);

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
    void add(STRINGAA namedTemplates) {
        // TODO configuration.update(namedTemplates);
       // _compiledTemplates(namedTemplates.keys);
    }

    /*
    // Push the current templates into the template stack.
    void push() {
       configurationStack ~= [
           configuration,
           _compiled,
        ];
    }

    // Restore the most recently pushed set of templates.
    void pop() {
        if (configurationStack.isEmpty) {
            return;
        }
        [configuration, _compiled] = array_pop(configurationStack);
    }

    // Compile templates into a more efficient printf() compatible format.
    protected void _compileAllTemplates() {
        _compileTemplates(configuration.keys);
    }
    
    protected void _compileTemplates(string[] templateNames) {
        templateNames
          .each!(name => compileTemplate(name));
    }

    /* protected void compileTemplate(string templateName) {
      string templateValue = get(templateName);
            if (templateValue.isNull) {
                throw new InvalidArgumentException("String template `%s` is not valid.".format(templateName));
            }
            assert(isString(templateValue),
                "Template for `%s` must be of type `string`, but is `%s`".format(templateName, templateValue);
            );

            templateValue = templateValue.replace("%", "%%");
            preg_match_all("#\{\{([\w\.]+)\}\}#", templateValue, mymatches);
           _compiled[templateName] = [
                templateValue.replace(mymatches[0], "%s"),
                mymatches[1],
            ];
    } * /

    /**
     * Load a config file containing templates.
     *
     * Template files should define a `configData` variable containing
     * all the templates to load. Loaded templates will be merged with existing
     * templates.
     * Params:
     * string myfile The file to load
     */
    /* void load(string fileName) {
        if (myfile.isEmpty) {
            throw new UimException("String template filename cannot be an empty string");
        }

        auto myloader = new PhpConfig();
        auto mytemplates = myloader.read(fileName);
        this.add(mytemplates);
    } * /
    
    // Remove the named template.
    /* void remove(string templateName) {
        configuration.update(templateName, null);
        _compiled.remove(templateName);
    } */
    
    /**
     * Format a template string with mydata
     */
    string format(string templateName, IData[string] insertData) {
        // TODO 
        /* if (!_compiled.isSet(templateName)) {
            throw new InvalidArgumentException("Cannot find template named `%s`.".format(templateName));
        }
        [mytemplate, myplaceholders] = _compiled[templateName];

        if (insertData.isSet("templateVars")) {
            mydata = mydata["templateVars"];
            mydata.remove("templateVars");
        }
        
        auto myreplace = [];
        myplaceholders.each!((placeholder) {
            auto myreplacement = mydata.get(placeholder, null);
            myreplace ~= myreplacement.isArray
                ? myreplacement.join("")
                : "";
        });
        return vsprintf(mytemplate, myreplace); */
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
     * @param string[]|null myexclude Array of options to be excluded, the options here will not be part of the return.
     */
    /* string formatAttributes(IData[string] options, array myexclude = null) {
       string myinsertBefore = " ";
        options = options.update(["escape": BoolData(true)]);

        if (!isArray(myexclude)) {
            myexclude = [];
        }
        myexclude = ["escape": true, "idPrefix": true, "templateVars": true, "fieldName": true]
            + array_flip(myexclude);
        myescape = options["escape"];

        auto myattributes = = options.byKeyValue
            .filter!(kv => !myexclude.isSet(kv.key) && kv.value != false && !kv.value.isNull)
            .map!(kv => _formatAttribute((string)kv.key, kv.value, myescape));
        
        string result = trim(join(" ", myattributes));
        return result ? myinsertBefore ~ result : "";
    } */
    
    /**
     * Formats an individual attribute, and returns the string value of the composed attribute.
     * Works with minimized attributes that have the same value as their name such as "disabled" and "checked"
     * Params:
     * string aKey The name of the attribute to create
     * @param Json aValue The value of the attribute to create.
     * @param bool myescape Define if the value must be escaped
     */
     /* 
    protected string _formatAttribute(string aKey, Json aValue, bool myescape = true) {
        if (isArray(myvalue)) {
            myvalue = join(" ", myvalue);
        }
        if (isNumeric(aKey)) {
            return "myvalue=\"myvalue\"";
        }
        mytruthy = [1, "1", true, "true", aKey];
        myisMinimized = isSet(_compactAttributes[aKey]);
        // TODO if (!preg_match("/\A(\w|[.-])+\z/", aKey)) {
        //    aKey = h(aKey);
        // }
        if (myisMinimized && myvalue.has(mytruthy)) {
            return "aKey=\"aKey\"";
        }
        if (myisMinimized) {
            return "";
        }
        return aKey ~ "="" ~ (myescape ? h(myvalue): myvalue) ~ """;
    }
    
    /**
     * Adds a class and returns a unique list either in array or space separated
     * Params:
     * Json myinput The array or string to add the class to
     * @param string[]|string|false|null mynewClass the new class or classes to add
     * @param string myuseIndex if you are inputting an array with an element other than default of "class".
     */
    /* string[] addClass(
        Json myinput,
        string[]|false|null mynewClass,
        string myuseIndex = "class"
    ) {
        // NOOP
        if (isEmpty(mynewClass)) {
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
                : [];

        }
        if (isString(mynewClass)) {
            string[] mynewClass = mynewClass.split(" ");
        }
        myclass = array_unique(chain(myclass, mynewClass));

        return Hash.insert(myinput, myuseIndex, myclass);
    } */
}
