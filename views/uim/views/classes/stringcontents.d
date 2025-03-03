/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.views.classes.stringcontents;

import uim.views;
@safe:

version (test_uim_views) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
} 


/**
 * Provides an interface for registering and inserting
 * content into simple logic-less string templates.
 *
 * Used by several helpers to provide simple flexible templates
 * for generating HTML and other content.
 */
class DStringContents : UIMObject {
    this() {
        super();
    }

    this(Json[string] initData) {
        super(initData);
    }

    this(string newName, Json[string] initData = null) {
        super(newName, initData);
    }

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        

        return true;
    }

    // List of attributes that can be made compact.
    protected bool[string] _boolAttributes;
    protected STRINGAA _templates;

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
    void set(string[string] newTemplates) {
        newTemplates.byKeyValue.each!(item => set(item.key, item.value));
    }

    void set(string key, string newTemplate) {
        _templates[key] = newTemplate;
        // ? _compiledTemplates = newTemplates.keys;
    }

    string get(string key) {
        /* return _templates.hasKey(key)
            ? _temolates[key] : null; */
        return null;
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
            // TODO throw new UIMException("String template filename cannot be an empty string");
        }

        /* 
        auto myloader = new DPhpConfig();
        auto mytemplates = myloader.read(fileName);
        add(mytemplates); */
    }

    // Remove the named template.
    bool removeKey(string name) {
        _templates.removeKey(name);
        // _compiledTemplates.remove(_compiledTemplates.indexOf(name)); 
        return false;
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
            /* throw new DInvalidArgumentException(
                "String template `%s` is not valid.".format(templateName)); */
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
        // yTemplate; // TODO = _compiledtemplates[templateName];

        Json[string] templateVars;
        if (insertData.hasKey("templateVars")) {
            templateVars = insertData.shift("templateVars").getMap;
        }

        string[] replaces;
        /* myplaceholders.each!((placeholder) {
            Json replacement = templateVars.get(placeholder);
            replaces ~= replacement.isArray
                ? replacement.getStrings.join("") : "";
        }); */

        // TODO return mytemplate.format(replaces); 
        return null;
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
