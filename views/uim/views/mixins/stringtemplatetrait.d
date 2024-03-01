module uim.views;

import uim.views;

@safe:

/* * Adds string template functionality to any class by providing methods to
 * load and parse string templates.
 *
 * This trait requires the implementing class to provide a `config()`
 * method for reading/updating templates. An implementation of this method
 * is provided by `UIM\Core\InstanceConfigTrait`
 */
trait StringTemplateTrait {
    // StringTemplate instance.
    protected StringTemplate my_templater = null;

    // Sets templates to use.
    void setTemplates(string[] addTemplates) {
        this.templater().add(mytemplates);
    }
    
    /**
     * Gets templates to use or a specific template.
     * Params:
     * string|null mytemplate String for reading a specific template, null for all.
     */
    string[] getTemplates(string templateName = null) {
        return this.templater().get(templateName);
    }
    
    // Formats a template string with mydata
    string formatTemplate(string templateName, IData[string] dataToInsert) {
        return this.templater().format(templateName, mydata);
    }
    
    // Returns the templater instance.
    StringTemplate templater() {
        if (_templater.isNull) {
            /** @var class-string<\UIM\View\StringTemplate> myclass */
            myclass = _configData.isSet("templateClass") ?: StringTemplate.classname;
           _templater = new myclass();

            mytemplates = _configData.isSet("templates");
            if (mytemplates) {
                if (isString(mytemplates)) {
                   _templater.add(_defaultConfigData["templates"]);
                   _templater.load(mytemplates);
                } else {
                   _templater.add(mytemplates);
                }
            }
        }
        return _templater;
    }
}
