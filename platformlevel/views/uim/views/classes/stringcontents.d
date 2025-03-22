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

    // #region templates
    // Registers a list of templates by name
    protected STRINGAA _templates;    
    DStringContents templates(Json[string] newTemplates) {
        newTemplates.each!((key, value) => template_(key, value.getString));
      return this;
    }
    
    DStringContents templates(string[string] newTemplates) {
        newTemplates.each!((key, value) => template_(key, value));
      return this;
    }

    DStringContents template_(string key, Json newTemplate) {
        _templates.set(key, newTemplate.getString);
        // ? _compiledTemplates = newTemplates.keys;
      return this;
    }

  DStringContents template_(string key, string newTemplate) {
        _templates.set(key, newTemplate);
        // ? _compiledTemplates = newTemplates.keys;
      return this;
    }

    string template_(string key) {
        return _templates.get(key, null);
    }
    // #endregion templates

    // Load a config file containing templates.
    DStringContents load(string fileName) {
        if (fileName.isEmpty || !fileName.exists) {
            return this;
        }

        // TODO
        /* auto mytemplates = myloader.read(fileName);
        add(mytemplates); */
          
      return this;
    }

    // #region remove
    // Remove the named template.
    DStringContents removeTemplates(string[] names...) {
      removeTemplates(names.dup);
      return this;
    }

  DStringContents removeTemplates(string[] names) {
        names.each!(name => _templates.removeKey(name));
      return this;
    }

    DStringContents removeTemplate(string name) {
        _templates.removeKey(name);
        // TODO _compiledTemplates.remove(_compiledTemplates.indexOf(name)); 
      return this;
    }
    // #endregion remove
    // #endregion templates

    // #region compiledTemplates
    // Contains the list of compiled templates
    protected string[string] _compiledTemplates;
  bool hasCompiledTemplate(string name) {
    return _compiledTemplates.hasKey(name);
  }

    // #region compile Template
    // Compile templates into a more efficient printf() compatible format.
    protected DStringContents compileAllTemplates() {
        compileTemplates(_templates.keys);
      return this;
    }

    protected DStringContents _compileTemplates(string[] names) {
        names
            .each!(name => compileTemplate(name));
      return this;
    }

    protected DStringContents compileTemplate(string templateName) {
      if (!hasTemplate(name)) return this;
        string selectedTemplate = template_(templateName);
        selectedTemplate = selectedTemplate.replace("%", "%%");

        // TODO preg_match_all("#\{\{([\w\.]+)\}\}#", selectedTemplate, mymatches);
        // TODO _compiledtemplates[templateName] = [
        // TODO     templateValue.replace(mymatches[0], "%s"),
        // TODO     mymatches[1],
        // TODO ];

      return this;
    }
    // #endregion compile Template
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
        myplaceholders.each!((placeholder) {
            Json replacement = templateVars.get(placeholder);
            /* replaces ~= replacement.isArray
                ? replacement.getStrings.join("") : "";*/
        }); 

        // TODO return mytemplate.format(replaces); 
        return null;
    }

    // #region addclassnameToList
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
    // #endregion addclassnameToList
}
