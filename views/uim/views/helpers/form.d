module uim.views.helpers.form;

import uim.views;

@safe:

/**
 * Form helper library.
 *
 * Automatic generation of HTML FORMs from given data.
 *
 * @method string text(string fieldNameName, Json[string] options  = null) Creates input of type text.
 * @method string number(string fieldNameName, Json[string] options  = null) Creates input of type number.
 * @method string email(string fieldNameName, Json[string] options  = null) Creates input of type email.
 * @method string password(string fieldNameName, Json[string] options  = null) Creates input of type password.
 * @method string search(string fieldNameName, Json[string] options  = null) Creates input of type search.
 * @property \UIM\View\Helper\HtmlHelper myHtml
 * @property \UIM\View\Helper\UrlHelper myUrl
 */
class DFormHelper : DHelper {
    mixin(HelperThis!("Form"));
    mixin TIdGenerator;
    mixin TStringContents;

    /**
     * The supported sources that can be used to populate input values.
     *
     * `context` - Corresponds to `IContext` instances.
     * `data` - Corresponds to request data (POST/PUT).
     * `query` - Corresponds to request"s query string.
     */
    protected string[] mysupportedValueSources = ["context", "data", "query"];

    // The default sources.
    protected string[] _valueSources = ["data", "context"];

    /**
     * Grouped input types.
     */
    protected string[] _groupedInputTypes = ["radio", "multicheckbox"];

    /** 
    override bool initialize(Json[string] initData = null) {
        if (super.initialize(initData)) {
            configuration.updateDefaults([
                "idPrefix": Json(null),
                "errorClass": Json("form-error"),
                "typeMap": MapData([
                    "string": "text",
                    "text": "textarea",
                    "uuid": "string",
                    "datetime": "datetime",
                    "datetimefractional": "datetime",
                    "timestamp": "datetime",
                    "timestampfractional": "datetime",
                    "timestamptimezone": "datetime",
                    "date": "date",
                    "time": "time",
                    "year": "year",
                    "boolean": "checkbox",
                    "float": "number",
                    "integer": "number",
                    "tinyinteger": "number",
                    "smallinteger": "number",
                    "decimal": "number",
                    "binary": "file",

                

            ]),
            "templates" : MapData([
                // Used for button elements in button().
                "button": `<button{{attrs}}>{{text}}</button>`, // Used for checkboxes in checkbox() and multiCheckbox().
                "checkbox": `<input type="checkbox" name="{{name}}" value="{{value}} "{{attrs}}>`, // Input group wrapper for checkboxes created via control().
                "checkboxFormGroup": `{{label}}`, // Wrapper container for checkboxes.
                "checkboxWrapper": `<div class="checkbox">{{label}}</div>`, // Error message wrapper elements.
                "error": `<div class=" error - message" id="{{id}}">{{content}}</div>`, // Container for error items.
                "errorList": `<ul>{{content}}</ul>`, // Error item wrapper.
                "errorItem": `<li>{{text}}</li>`, // File input used by file().
                "file": `<input type=" file" name="{{name}}" {{attrs}}>`, // Fieldset element used by allControls().
                "fieldset": `<fieldset{{attrs}}>{{content}}</fieldset>`, // Open tag used by create().
                "formStart": `<form{{attrs}}>`, // Close tag used by end().
                "formEnd": `</form>`, // General grouping container for control(). Defines input/label ordering.
                "formGroup": `{{label}}{{input}}`, // Wrapper content used to hide other content.
                "hiddenBlock": `<div style="d isplay: none; ">{{content}}</div>`, // Generic input element.
                "input": `<input type="{{type}}" name="{{name}}"{{attrs}}>`, // Submit input element.
                "inputSubmit": `<input type="{{type}}"{{attrs}}>`, // Container element used by control().
                "inputContainer": `<div class="input{{type}} {{required}}">{{content}}</div>`, // Container element used by control() when a field has an error.
                "inputContainerError": `<div class="input{{type}} {{required}} error">{{content}}{{error}}</div>`, // Label element when inputs are not nested inside the label.
                "label": `<label{{attrs}}>{{text}}</label>`, // Label element used for radio and multi-checkbox inputs.
                "nestingLabel": `{{hidden}}<label{{attrs}}>{{input}}{{text}}</label>`, // Legends created by allControls()
                "legend": `<legend>{{text}}</legend>`, // Multi-Checkbox input set title element.
                "multicheckboxTitle": `<legend>{{text}}</legend>`, // Multi-Checkbox wrapping container.
                "multicheckboxWrapper": `<fieldset{{attrs}}>{{content}}</fieldset>`, // Option element used in select pickers.
                "option": `<option value="{{value}} {{attrs}}>{{text}}</option>`, // Option group element used in select pickers.
                "optgroup": `<optgroup label="{{label}}"{{attrs}}>{{content}}</optgroup>`, // Select element,
                "select": `<select name="{{name}}"{{attrs}}>{{content}}</select>`, // Multi-select element,
                "selectMultiple": `<select name="{{name}}[]" multiple=" multiple"{{attrs}}>{{content}}</select>`, // Radio input element,
                "radio": `<input type=" radio" name="{{name}}" value="{{value}}"{{attrs}}>`, // Wrapping container for radio input/label,
                "radioWrapper": `{{label}}`, // Textarea input element,
                "textarea": `<textarea name="{{name}}"{{attrs}}>{{value}}</textarea>`, // Container for submit buttons.
                "submitContainer": `<div class=" submit">{{content}}</div>`, // Confirm javascript template for postLink()
                "confirmJs": `{{confirm}}`, // selected class
                "selectedClass": `selected`, // required class
                "requiredClass": `required`,
            ]), // set HTML5 validation message to custom required/empty messages
                "autoSetCustomValidity" : Json(true),]);
            return true;
        }
        /**
     * Constant used internally to skip the securing process,
     * and neither add the field to the hash or to the unlocked fields.
     * /
        const string SECURE_SKIP = "skip"; // Defines the type of form being created. Set by FormHelper.create().
        string _requestType = null; // DContext for the current form.
        protected IContext _context = null; /**
     * The action attribute value of the last created form.
     * Used to make form/request specific hashes for form tampering protection.
     * /
        protected string _lastAction = ""; /* 
    // Other helpers used by FormHelper
    // TODO protected Json[string] myhelpers = ["Url", "Html"];

    // Default config for the helper.
    

    /**
     * Default widgets
     *
     * @var array<string, string[]>
     * /
    // TODO protected Json[string] _defaultWidgets = [
        "button": ["Button"],
        "checkbox": ["Checkbox"],
        "file": ["File"],
        "label": ["Label"],
        "nestingLabel": ["NestingLabel"],
        "multicheckbox": ["MultiCheckbox", "nestingLabel"],
        "radio": ["Radio", "nestingLabel"],
        "select": ["SelectBox"],
        "textarea": ["Textarea"],
        "datetime": ["DateTime", "select"],
        "year": ["Year", "select"],
        "_default": ["Basic"],
    ];


    // Locator for input widgets.
    protected DWidgetLocator _locator;


    // DContext factory.
    protected DContextFactory _contextFactory = null;




    /**
     * Form protector
     *
     * @var \UIM\Form\FormProtector|null
     * /
    protected DFormProtector myformProtector = null;

    /**
     * Construct the widgets and binds the default context providers
     * Params:
     * \UIM\View\View myview The View this helper is being attached to.
     * @param Json[string] configData Configuration settings for the helper.
     * /
    this(IView myview, Json[string] configData = null) {
        mylocator = null;
        mywidgets = _defaultWidgets;
        if (isSet(configuration.get("locator"])) {
            mylocator = configuration.get("locator"];
            configuration.remove("locator");
        }
        if (isSet(configuration.get("widgets"])) {
            if (isString(configuration.get("widgets"])) {
                configuration.get("widgets"] = (array)configuration.get("widgets"];
            }
            mywidgets = configuration.get("widgets"] + mywidgets;
            configuration.remove("widgets");
        }
        if (isSet(configuration.get("groupedInputTypes"])) {
           _groupedInputTypes = configuration.get("groupedInputTypes"];
            configuration.remove("groupedInputTypes");
        }
        super(myview, configData);

        if (!mylocator) {
            mylocator = new WidgetLocator(this.templater(), _View, mywidgets);
        }
        this.setWidgetLocator(mylocator);
       _idPrefix = configurationData.isSet("idPrefix");
    }
    
    /**
     * Get the widget locator currently used by the helper.
     * /
    WidgetLocator getWidgetLocator() {
        return _locator;
    }
    
    /**
     * Set the widget locator the helper will use.
     * Params:
     * \UIM\View\Widget\WidgetLocator myinstance The locator instance to set.
     * /
    void setWidgetLocator(WidgetLocator myinstance) {
       _locator = myinstance;
    }
    
    /**
     * Set the context factory the helper will use.
     * Params:
     * \UIM\View\Form\ContextFactory|null myinstance The context factory instance to set.
     * @param array mycontexts An array of context providers.
     * /
    DContextFactory contextFactory(?ContextFactory myinstance = null, Json[string] mycontexts = []) {
        if (myinstance.isNull) {
            return _contextFactory ??= DContextFactory.createWithDefaults(mycontexts);
        }
       _contextFactory = myinstance;

        return _contextFactory;
    }
    
    /**
     * Returns an HTML form element.
     *
     * ### Options:
     *
     * - `type` Form method defaults to autodetecting based on the form context. If
     *  the form context"s isCreate() method returns false, a PUT request will be done.
     * - `method` Set the form"s method attribute explicitly.
     * - `url` The URL the form submits to. Can be a string or a URL array.
     * - `encoding` Set the accept-charset encoding for the form. Defaults to `Configuration.read("App.encoding")`
     * - `enctype` Set the form encoding explicitly. By default `type: file` will set `enctype`
     *  to `multipart/form-data`.
     * - `templates` The templates you want to use for this form. Any templates will be merged on top of
     *  the already loaded templates. This option can either be a filename in /config that contains
     *  the templates you want to load, or an array of templates to use.
     * - `context` Additional options for the context class. For example the EntityContext accepts a "table"
     *  option that allows you to set the specific Table class the form should be based on.
     * - `idPrefix` Prefix for generated ID attributes.
     * - `valueSources` The sources that values should be read from. See FormHelper.setValueSources()
     * - `templateVars` Provide template variables for the formStart template.
     * Params:
     * Json formContext The context for which the form is being defined.
     *  Can be a IContext instance, ORM entity, ORM resultset, or an
     *  array of meta data. You can use `null` to make a context-less form.
     * @param Json[string] options An array of html attributes and options.
     * /
    string create(Json formContext = null, Json[string] options  = null) {
        myappend = "";

        if (cast(IContext)formContext) {
            this.context(formContext);
        } else {
            if (options.isEmpty("context")) {
                options["context"] = null;
            }
            options["context"]["entity"] = formContext;
            formContext = _getContext(options["context"]);
            unset(options["context"]);
        }
        myisCreate = formContext.isCreate();

        options = options.update[
            "type": myisCreate ? "post" : "put",
            "url": null,
            "encoding": Configuration.read("App.encoding").toLower,
            "templates": null,
            "idPrefix": null,
            "valueSources": null,
        ];

        if (isSet(options["valueSources"])) {
            this.setValueSources(options["valueSources"]);
            unset(options["valueSources"]);
        }
        if (options["idPrefix"] !isNull) {
           _idPrefix = options["idPrefix"];
        }
        mytemplater = this.templater();

        if (!empty(options["templates"])) {
            mytemplater.push();
            mymethod = isString(options["templates"]) ? "load" : "add";
            mytemplater.{mymethod}(options["templates"]);
        }
        unset(options["templates"]);

        if (options["url"] == false) {
            myurl = _View.getRequest().getRequestTarget();
            myaction = null;
        } else {
            myurl = _formUrl(formContext, options);
            myaction = this.Url.build(myurl);
        }
       _lastAction(myurl);
        unset(options["url"], options["idPrefix"]);

        myhtmlAttributes = null;
        switch (options["type"].toLower) {
            case "get":
                myhtmlAttributes["method"] = "get";
                break;
            // Set enctype for form
            case "file":
                myhtmlAttributes["enctype"] = "multipart/form-data";
                options["type"] = myisCreate ? "post" : "put";
            // Move on
            case "put":
            // Move on
            case "delete":
            // Set patch method
            case "patch":
                myappend ~= this.hidden("_method", [
                    "name": "_method",
                    "value": strtoupper(options["type"]),
                    "secure": SECURE_SKIP,
                ]);
            // Default to post method
            default:
                myhtmlAttributes["method"] = "post";
        }
        if (isSet(options["method"])) {
            myhtmlAttributes["method"] = options.getString("method").toLower;
        }
        if (isSet(options["enctype"])) {
            myhtmlAttributes["enctype"] = options.getString("enctype").toLower;
        }
        this.requestType = options["type"].toLower;

        if (!empty(options["encoding"])) {
            myhtmlAttributes["accept-charset"] = options["encoding"];
        }
        unset(options["type"], options["encoding"]);

        myhtmlAttributes += options;

        if (this.requestType != "get") {
            myformTokenData = _View.getRequest().getAttribute("formTokenData");
            if (myformTokenData !isNull) {
                this.formProtector = this.createFormProtector(myformTokenData);
            }
            myappend ~= _csrfField();
        }
        if (!empty(myappend)) {
            myappend = mytemplater.format("hiddenBlock", ["content": myappend]);
        }
        myactionAttr = mytemplater.formatAttributes(["action": myaction, "escape": Json(false)]);

        return _formatTemplate("formStart", [
            "attrs": mytemplater.formatAttributes(myhtmlAttributes) ~ myactionAttr,
            "templateVars": options["templateVars"] ?? [],
        ]) ~ myappend;
    }
    
    /**
     * Create the URL for a form based on the options.
     * Params:
     * \UIM\View\Form\IContext formContext The context object to use.
     * @param Json[string] options An array of options from create()
     * /
    protected string[] _formUrl(IContext formContext, Json[string] options) {
        auto myrequest = _View.getRequest();

        if (options.isNull("url")) {
            return myrequest.getRequestTarget();
        }
        if (
            options.isString("url") ||
            (options.isArray("url") &&
            isSet(options["url"]["_name"]))
        ) {
            return options["url"];
        }
        myactionDefaults = [
            "plugin": _View.pluginName,
            "controller": myrequest.getParam("controller"),
            "action": myrequest.getParam("action"),
        ];

        return (array)options["url"] + myactionDefaults;
    }
    
    /**
     * Correctly store the last created form action URL.
     * Params:
     * string[] myurl The URL of the last form.
     * /
    protected void _lastAction(string[] myurl = null) {   myaction = Router.url(myurl, true);
        myquery = parse_url(myaction, D_URL_QUERY);
        myquery = myquery ? "?" ~ myquery : "";

        mypath = parse_url(myaction, D_URL_PATH) ?: "";
       _lastAction = mypath ~ myquery;
    }
    
    /**
     * Return a CSRF input if the request data is present.
     * Used to secure forms in conjunction with CsrfMiddleware.
     * /
    protected string _csrfField() {
        myrequest = _View.getRequest();

        mycsrfToken = myrequest.getAttribute("csrfToken");
        if (!mycsrfToken) {
            return "";
        }
        return _hidden("_csrfToken", [
            "value": mycsrfToken,
            "secure": SECURE_SKIP,
        ]);
    }
    
    /**
     * Closes an HTML form, cleans up values set by FormHelper.create(), and writes hidden
     * input fields where appropriate.
     *
     * Resets some parts of the state, shared among multiple FormHelper.create() calls, to defaults.
     * Params:
     * Json[string] mysecureAttributes Secure attributes which will be passed as HTML attributes
     *  into the hidden input elements generated for the Security Component.
     * /
    string end(Json[string] mysecureAttributes = []) {
        result = "";

        if (this.requestType != "get" && _View.getRequest().getAttribute("formTokenData") !isNull) {
            result ~= this.secure([], mysecureAttributes);
        }
        result ~= this.formatTemplate("formEnd", []);

        this.templater().pop();
        this.requestType = null;
       _context = null;
       _valueSources = ["data", "context"];
       _idPrefix = configurationData.isSet("idPrefix");
        this.formProtector = null;

        return result;
    }
    
    /**
     * Generates a hidden field with a security hash based on the fields used in
     * the form.
     *
     * If mysecureAttributes is set, these HTML attributes will be merged into
     * the hidden input tags generated for the Security Component. This is
     * especially useful to set HTML5 attributes like "form".
     * Params:
     * array myfields If set specifies the list of fields to be added to
     *   FormProtector for generating the hash.
     * @param Json[string] mysecureAttributes will be passed as HTML attributes into the hidden
     *   input elements generated for the Security Component.
     * /
    string secure(Json[string] myfields = [], Json[string] mysecureAttributes = []) {
        if (!this.formProtector) {
            return "";
        }
        foreach (myfields as myfield: myvalue) {
            if (isInt(myfield)) {
                myfield = myvalue;
                myvalue = null;
            }
            this.formProtector.addField(myfield, true, myvalue);
        }
        mydebugSecurity = (bool)Configuration.read("debug");
        if (isSet(mysecureAttributes["debugSecurity"])) {
            mydebugSecurity = mydebugSecurity && mysecureAttributes["debugSecurity"];
            unset(mysecureAttributes["debugSecurity"]);
        }
        mysecureAttributes["secure"] = SECURE_SKIP;

        mytokenData = this.formProtector.buildTokenData(
           _lastAction,
           _getFormProtectorSessionId()
        );
        mytokenFields = array_merge(mysecureAttributes, [
            "value": mytokenData["fields"],
        ]);
        result = this.hidden("_Token.fields", mytokenFields);
        mytokenUnlocked = array_merge(mysecureAttributes, [
            "value": mytokenData["unlocked"],
        ]);
        result ~= this.hidden("_Token.unlocked", mytokenUnlocked);
        if (mydebugSecurity) {
            mytokenDebug = array_merge(mysecureAttributes, [
                "value": mytokenData["debug"],
            ]);
            result ~= this.hidden("_Token.debug", mytokenDebug);
        }
        return _formatTemplate("hiddenBlock", ["content": result]);
    }
    
    /**
     * Get Session id for FormProtector
     * Must be the same as in FormProtectionComponent
     * /
    protected string _getFormProtectorSessionId() {
        return _View.getRequest().getSession().id();
    }
    
    /**
     * Add to the list of fields that are currently unlocked.
     *
     * Unlocked fields are not included in the form protection field hash.
     * /
    void unlockField(string fieldName) {
        this.getFormProtector().unlockField(fieldName);
    }
    
    /**
     * Create FormProtector instance.
     * Params:
     * Json[string] myformTokenData Token data.
     * /
    protected DFormProtector createFormProtector(Json[string] myformTokenData) {
        auto mysession = _View.getRequest().getSession();
        mysession.start();

        return new DFormProtector(
            myformTokenData
        );
    }
    
    // Get form protector instance.
    FormProtector getFormProtector() {
        if (this.formProtector.isNull) {
            throw new UimException(
                "`FormProtector` instance has not been created. Ensure you have loaded the `FormProtectionComponent`"
                ~ " in your controller and called `FormHelper.create()` before calling `FormHelper.unlockField()`."
            );
        }
        return _formProtector;
    }
    
    /**
     * Returns true if there is an error for the given field, otherwise false
     * Params:
     * string myfield This should be "modelname.fieldname"
     * /
    bool isFieldError(string myfield) {
        return _getContext().hasError(myfield);
    }
    
    /**
     * Returns a formatted error message for given form field, "" if no errors.
     *
     * Uses the `error`, `errorList` and `errorItem` templates. The `errorList` and
     * `errorItem` templates are used to format multiple error messages per field.
     *
     * ### Options:
     *
     * - `escape` boolean - Whether to html escape the contents of the error.
     * Params:
     * string myfield A field name, like "modelname.fieldname"
     * @param string[] mytext Error message as string or array of messages. If an array,
     *  it should be a hash of key names: messages.
     * @param Json[string] options See above.
     * /
    string error(string myfield, string[] mytext = null, Json[string] options  = null) {
        if (myfield.endsWith("._ids")) {
            myfield = substr(myfield, 0, -5);
        }
        options = options.update["escape": Json(true)];

        formContext = _getContext();
        if (!formContext.hasError(myfield)) {
            return "";
        }
        myerror = formContext.error(myfield);

        if (mytext.isArray) {
            mytmp = null;
            foreach (myerror as myKey: mye) {
                if (isSet(mytext[myKey])) {
                    mytmp ~= mytext[myKey];
                } elseif (isSet(mytext[mye])) {
                    mytmp ~= mytext[mye];
                } else {
                    mytmp ~= mye;
                }
            }
            mytext = mytmp;
        }
        if (mytext !isNull) {
            myerror = mytext;
        }
        if (options["escape"]) {
            myerror = htmlAttribEscape(myerror);
            options.remove("escape");
        }
        if (isArray(myerror)) {
            if (count(myerror) > 1) {
                myerrorText = null;
                foreach (myerror as myerr) {
                    myerrorText ~= this.formatTemplate("errorItem", ["text": myerr]);
                }
                myerror = this.formatTemplate("errorList", [
                    "content": join("", myerrorText),
                ]);
            } else {
                myerror = array_pop(myerror);
            }
        }
        return _formatTemplate("error", [
            "content": myerror,
            "id": _domId(myfield) ~ "-error",
        ]);
    }
    
    /**
     * Returns a formatted LABEL element for HTML forms.
     *
     * Will automatically generate a `for` attribute if one is not provided.
     *
     * ### Options
     *
     * - `for` - Set the for attribute, if its not defined the for attribute
     *  will be generated from the fieldName parameter using
     *  FormHelper._domId().
     * - `escape` - Set to `false` to turn off escaping of label text.
     *  Defaults to `true`.
     *
     * Examples:
     *
     * The text and for attribute are generated off of the fieldname
     *
     * ```
     * writeln(this.Form.label("published");
     * <label for="PostPublished">Published</label>
     * ```
     *
     * Custom text:
     *
     * ```
     * writeln(this.Form.label("published", "Publish");
     * <label for="published">Publish</label>
     * ```
     *
     * Custom attributes:
     *
     * ```
     * writeln(this.Form.label("published", "Publish", [
     *  "for": "post-publish"
     * ]);
     * <label for="post-publish">Publish</label>
     * ```
     *
     * Nesting an input tag:
     *
     * ```
     * writeln(this.Form.label("published", "Publish", [
     *  "for": "published",
     *  "input": this.text("published"),
     * ]);
     * <label for="post-publish">Publish <input type="text" name="published"></label>
     * ```
     *
     * If you want to nest inputs in the labels, you will need to modify the default templates.
     * Params:
     * string fieldNameName This should be "modelname.fieldname"
     * @param string|null mytext Text that will appear in the label field. If
     *  mytext is left undefined the text will be inflected from the
     *  fieldName.
     * @param Json[string] options An array of HTML attributes.
     * /
    string label(string fieldNameName, string mytext = null, Json[string] options  = null) {
        if (mytext.isNull) {
            mytext = fieldName;
            if (mytext.endsWith("._ids")) {
                mytext = substr(mytext, 0, -5);
            }
            if (mytext.has(".")) {
                string[] myfieldElements = mytext.split(".");
                mytext = array_pop(myfieldElements);
            }
            if (mytext.endsWith("_id")) {
                mytext = substr(mytext, 0, -3);
            }
            mytext = __(Inflector.humanize(Inflector.underscore(mytext)));
        }
        if (isSet(options["for"])) {
            mylabelFor = options["for"];
            unset(options["for"]);
        } else {
            mylabelFor = _domId(fieldName);
        }
        myattrs = options ~ [
            "for": mylabelFor,
            "text": mytext,
        ];
        if (isSet(options["input"])) {
            if (isArray(options["input"])) {
                myattrs = options["input"] + myattrs;
            }
            return _widget("nestingLabel", myattrs);
        }
        return _widget("label", myattrs);
    }
    
    /**
     * Generate a set of controls for `myfields`. If myfields is empty the fields
     * of current model will be used.
     *
     * You can customize individual controls through `myfields`.
     * ```
     * this.Form.allControls([
     *  "name": ["label": "custom label"]
     * ]);
     * ```
     *
     * You can exclude fields by specifying them as `false`:
     *
     * ```
     * this.Form.allControls(["title": Json(false)]);
     * ```
     *
     * In the above example, no field would be generated for the title field.
     * Params:
     * array myfields An array of customizations for the fields that will be
     *  generated. This array allows you to set custom types, labels, or other options.
     * @param Json[string] options Options array. Valid keys are:
     *
     * - `fieldset` Set to false to disable the fieldset. You can also pass an array of params to be
     *   applied as HTML attributes to the fieldset tag. If you pass an empty array, the fieldset will
     *   be enabled
     * - `legend` Set to false to disable the legend for the generated control set. Or supply a string
     *   to customize the legend text.
     * /
    string allControls(Json[string] myfields = [], Json[string] options  = null) {
        mycontext = _getContext();

        mymodelFields = mycontext.fieldNames();

        myfields = array_merge(
            Hash.normalize(mymodelFields),
            Hash.normalize(myfields)
        );

        return _controls(myfields, options);
    }
    
    /**
     * Generate a set of controls for `myfields` wrapped in a fieldset element.
     *
     * You can customize individual controls through `myfields`.
     * ```
     * this.Form.controls([
     *  "name": ["label": "custom label"],
     *  "email"
     * ]);
     * ```
     * Params:
     * array myfields An array of the fields to generate. This array allows
     *  you to set custom types, labels, or other options.
     * @param Json[string] options Options array. Valid keys are:
     *
     * - `fieldset` Set to false to disable the fieldset. You can also pass an
     *   array of params to be applied as HTML attributes to the fieldset tag.
     *   If you pass an empty array, the fieldset will be enabled.
     * - `legend` Set to false to disable the legend for the generated input set.
     *   Or supply a string to customize the legend text.
     * /
    string controls(Json[string] myfields, Json[string] options  = null) {
        myfields = Hash.normalize(myfields);

        result = "";
        foreach (myfields as views: myopts) {
            if (myopts == false) {
                continue;
            }
            result ~= this.control(views, (array)myopts);
        }
        return _fieldset(result, options);
    }
    
    /**
     * Wrap a set of inputs in a fieldset
     * Params:
     * string myfields the form inputs to wrap in a fieldset
     * @param Json[string] options Options array. Valid keys are:
     *
     * - `fieldset` Set to false to disable the fieldset. You can also pass an array of params to be
     *   applied as HTML attributes to the fieldset tag. If you pass an empty array, the fieldset will
     *   be enabled
     * - `legend` Set to false to disable the legend for the generated input set. Or supply a string
     *   to customize the legend text.
     * /
    string fieldset(string myfields = "", Json[string] options  = null) {
        auto mylegend = options["legend"] ?? true;
        auto myfieldset = options["fieldset"] ?? true;
        auto mycontext = _getContext();
        auto result = myfields;

        if (mylegend == true) {
            myisCreate = mycontext.isCreate();
            mymodelName = Inflector.humanize(
                Inflector.singularize(_View.getRequest().getParam("controller"))
            );

            mylegend = !myisCreate
                ? __d("uim", "Edit {0}", mymodelName)
                : __d("uim", "New {0}", mymodelName);
        }
        if (myfieldset != false) {
            if (mylegend) {
                result = this.formatTemplate("legend", ["text": mylegend]) ~ result;
            }
            myfieldsetParams = ["content": result, "attrs": ""];
            if (isArray(myfieldset) && !empty(myfieldset)) {
                myfieldsetParams["attrs"] = this.templater().formatAttributes(myfieldset);
            }
            result = this.formatTemplate("fieldset", myfieldsetParams);
        }
        return result;
    }
    
    /**
     * Generates a form control element complete with label and wrapper div.
     *
     * ### Options
     *
     * See each field type method for more information. Any options that are part of
     * myattributes or options for the different **type** methods can be included in `options` for control().
     * Additionally, any unknown keys that are not in the list below, or part of the selected type"s options
     * will be treated as a regular HTML attribute for the generated input.
     *
     * - `type` - Force the type of widget you want. e.g. `type: "select"`
     * - `label` - Either a string label, or an array of options for the label. See FormHelper.label().
     * - `options` - For widgets that take options e.g. radio, select.
     * - `error` - Control the error message that is produced. Set to `false` to disable any kind of error reporting
     *  (field error and error messages).
     * - `empty` - String or boolean to enable empty select box options.
     * - `nestedInput` - Used with checkbox and radio inputs. Set to false to render inputs outside of label
     *  elements. Can be set to true on any input to force the input inside the label. If you
     *  enable this option for radio buttons you will also need to modify the default `radioWrapper` template.
     * - `templates` - The templates you want to use for this input. Any templates will be merged on top of
     *  the already loaded templates. This option can either be a filename in /config that contains
     *  the templates you want to load, or an array of templates to use.
     * - `labelOptions` - Either `false` to disable label around nestedWidgets e.g. radio, multicheckbox or an array
     *  of attributes for the label tag. `selected` will be added to any classes e.g. `class: "myclass"` where
     *  widget is checked
     * Params:
     * string fieldNameName This should be "modelname.fieldname"
     * @param Json[string] options Each type of input takes different options.
     * /
    string control(string fieldNameName, Json[string] options  = null) {
        options = options.update[
            "type": null,
            "label": null,
            "error": null,
            "required": null,
            "options": null,
            "templates": Json.emptyArray,
            "templateVars": Json.emptyArray,
            "labelOptions": Json(true),
        ];
        options = _parseOptions(fieldName, options);
        options = options.update["id": _domId(fieldName)];

        mytemplater = this.templater();
        mynewTemplates = options["templates"];

        if (mynewTemplates) {
            mytemplater.push();
            mytemplateMethod = isString(options["templates"]) ? "load" : "add";
            mytemplater.{mytemplateMethod}(options["templates"]);
        }
        unset(options["templates"]);

        // Hidden inputs don"t need aria.
        // Multiple checkboxes can"t have aria generated for them at this layer.
        if (options["type"] != "hidden" && (options["type"] != "select" && !options.isSet("multiple"))) {
            myisFieldError = this.isFieldError(fieldName);
            options = options.update[
                "aria-required": options["required"] ? "true" : null,
                "aria-invalid": myisFieldError ? "true" : null,
            ];
            // Don"t include aria-describedby unless we have a good chance of
            // having error message show up.
            if (
                mytemplater.get("error").has("{{id}}") &&
                mytemplater.get("inputContainerError").has("{{error}}")
            ) {
                options = options.update[
                   "aria-describedby": myisFieldError ? _domId(fieldName) ~ "-error" : null,
                ];
            }
            if (isSet(options["placeholder"]) && options["label"] == false) {
                options = options.update[
                    "aria-label": options["placeholder"],
                ];
            }
        }
        myerror = null;
        myerrorSuffix = "";
        if (options["type"] != "hidden" && options["error"] != false) {
            if (isArray(options["error"])) {
                myerror = this.error(fieldName, options["error"], options["error"]);
            } else {
                myerror = this.error(fieldName, options["error"]);
            }
            myerrorSuffix = empty(myerror) ? "" : "Error";
            unset(options["error"]);
        }
        mylabel = options["label"];
        unset(options["label"]);

        mylabelOptions = options["labelOptions"];
        unset(options["labelOptions"]);

        mynestedInput = false;
        if (options["type"] == "checkbox") {
            mynestedInput = true;
        }
        mynestedInput = options["nestedInput"] ?? mynestedInput;
        unset(options["nestedInput"]);

        if (
            mynestedInput == true
            && options["type"] == "checkbox"
            && !array_key_exists("hiddenField", options)
            && mylabel != false
        ) {
            options["hiddenField"] = "_split";
        }

        string myinput = _getInput(fieldName, options ~ ["labelOptions": mylabelOptions]);
        if (options["type"] == "hidden" || options["type"] == "submit") {
            if (mynewTemplates) {
                mytemplater.pop();
            }
            return myinput;
        }
        mylabel = _getLabel(fieldName, compact("input", "label", "error", "nestedInput") + options);
        
        result = mynestedInput
            ? _groupTemplate(compact("label", "error", "options"))
            : _groupTemplate(compact("input", "label", "error", "options"));

        result = _inputContainerTemplate([
            "content": result,
            "error": myerror,
            "errorSuffix": myerrorSuffix,
            "label": mylabel,
            "options": options,
        ]);

        if (mynewTemplates) {
            mytemplater.pop();
        }
        return result;
    }
    
    // Generates an group template element
    protected string _groupTemplate(Json[string] options) {
        string mygroupTemplate = options["options"]["type"] ~ "FormGroup";
        if (!this.templater().get(mygroupTemplate)) {
            mygroupTemplate = "formGroup";
        }
        return _formatTemplate(mygroupTemplate, [
            "input": options["input"] ?? [],
            "label": options["label"],
            "error": options["error"],
            "templateVars": options["options"]["templateVars"] ?? [],
        ]);
    }
    
    /**
     * Generates an input container template
     * Params:
     * Json[string] options The options for input container template
     * /
    protected string _inputContainerTemplate(Json[string] options) {
        myinputContainerTemplate = options["options"]["type"] ~ "Container" ~ options["errorSuffix"];
        if (!this.templater().get(myinputContainerTemplate)) {
            myinputContainerTemplate = "inputContainer" ~ options["errorSuffix"];
        }
        return _formatTemplate(myinputContainerTemplate, [
            "content": options["content"],
            "error": options["error"],
            "label": options["label"] ?? "",
            "required": options["options"]["required"] ? " " ~ this.templater().get("requiredClass") : "",
            "type": options["options"]["type"],
            "templateVars": options["options"].get("templateVars", null),
        ]);
    }
    
    /**
     * Generates an input element
     * Params:
     * string fieldNameName the field name
     * @param Json[string] options The options for the input element
     * /
    protected string[] _getInput(string fieldNameName, Json[string] options) {
        mylabel = options["labelOptions"];
        options.remove("labelOptions");

        switch (options.getString("type").toLower) {
            case "select":
            case "radio":
            case "multicheckbox":
                myopts = options["options"];
                if (myopts.isNull) {
                    myopts = null;
                }
                unset(options["options"]);

                return _{options["type"]}(fieldName, myopts, options ~ ["label": mylabel]);
            case "input":
                throw new DInvalidArgumentException(
                    "Invalid type `input` used for field `%s`.".format(fieldName
                ));

            default:
                return _{options["type"]}(fieldName, options);
        }
    }
    
    /**
     * Generates input options array
     * Params:
     * string fieldNameName The name of the field to parse options for.
     * @param Json[string] options Options list.
     * /
    protected Json[string] _parseOptions(string fieldNameName, Json[string] options) {
        myneedsMagicType = false;
        if (options.isEmpty("type")) {
            myneedsMagicType = true;
            options["type"] = _inputType(fieldName, options);
        }
        return _magicOptions(fieldName, options, myneedsMagicType);
    }
    
    /**
     * Returns the input type that was guessed for the provided fieldName,
     * based on the internal type it is associated too, its name and the
     * variables that can be found in the view template
     * Params:
     * string fieldNameName the name of the field to guess a type for
     * @param Json[string] options the options passed to the input method
     * /
    protected string _inputType(string fieldNameName, Json[string] options) {
        mycontext = _getContext();

        if (mycontext.isPrimaryKey(fieldName)) {
            return "hidden";
        }
        if (fieldName.endsWith("_id")) {
            return "select";
        }
        mytype = "text";
        myinternalType = mycontext.type(fieldName);
        mymap = configuration.get("typeMap"];
        if (myinternalType !isNull && isSet(mymap[myinternalType])) {
            mytype = mymap[myinternalType];
        }
        auto fieldName = array_slice(fieldName.split("."), -1)[0];

        return match (true) {
            isSet(options["checked"]): "checkbox",
            isSet(options["options"]): "select",
            in_array(fieldName, ["passwd", "password"], true): "password",
            in_array(fieldName, ["tel", "telephone", "phone"], true): "tel",
            fieldName == "email": "email",
            isSet(options["rows"]) || isSet(options["cols"]): "textarea",
            fieldName == "year": "year",
            default: mytype,
        };
    }
    
    /**
     * Selects the variable containing the options for a select field if present,
     * and sets the value to the "options" key in the options array.
     * Params:
     * string fieldNameName The name of the field to find options for.
     * @param Json[string] options Options list.
     * /
    protected Json[string] _optionsOptions(string fieldNameName, Json[string] options) {
        if (isSet(options["options"])) {
            return options;
        }
        myinternalType = _getContext().type(fieldName);
        if (myinternalType && myinternalType.startsWith("enum-")) {
            mydbType = TypeFactory.build(myinternalType);
            if (cast8EnumType)mydbType) {
                if (options["type"] != "radio") {
                    options["type"] = "select";
                }
                options["options"] = this.enumOptions(mydbType.getEnumClassName());

                return options;
            }
        }
        mypluralize = true;
        if (fieldName.endsWith("._ids")) {
            fieldName = substr(fieldName, 0, -5);
            mypluralize = false;
        } elseif (fieldName.endsWith("_id")) {
            fieldName = substr(fieldName, 0, -3);
        }
        fieldName = array_slice(fieldName.split("."), -1)[0];

        myvarName = Inflector.variable(
            mypluralize ? Inflector.pluralize(fieldName): fieldName
        );
        myvarOptions = _View.get(myvarName);
        if (!is_iterable(myvarOptions)) {
            return options;
        }
        if (options["type"] != "radio") {
            options["type"] = "select";
        }
        options["options"] = myvarOptions;

        return options;
    }
    
    /**
     * Get map of enum value: label for select/radio options.
     * Params:
     * class-string<\BackedEnum> myenumClass Enum class name.
     * /
    // TODO protected array<int|string, string> enumOptions(string enumClassname) {
        assert(isSubclass_of(enumClassname, BackedEnum.classname));

        myvalues = null;
        /** @var \BackedEnum mycase * /
        foreach (mycase; enumClassname.cases()) {
            myhasLabel = cast(IEnumLabel)mycase || method_exists(mycase, "label");
            myvalues[mycase.value] = myhasLabel ? mycase.label(): mycase.name;
        }
        return myvalues;
    }
    
    /**
     * Magically set option type and corresponding options
     * Params:
     * string fieldNameName The name of the field to generate options for.
     * @param Json[string] options Options list.
     * @param bool myallowOverride Whether it is allowed for this method to
     * overwrite the "type" key in options.
     * /
    protected Json[string] _magicOptions(string fieldNameName, Json[string] options, bool myallowOverride) {
        options = options.update[
            "templateVars": Json.emptyArray,
        ];

        options = this.setRequiredAndCustomValidity(fieldName, options);

        mytypesWithOptions = ["text", "number", "radio", "select"];
        mymagicOptions = (in_array(options["type"], ["radio", "select"], true) || myallowOverride);
        if (mymagicOptions && in_array(options["type"], mytypesWithOptions, true)) {
            options = _optionsOptions(fieldName, options);
        }
        if (myallowOverride && fieldName.endsWith("._ids")) {
            options["type"] = "select";
            if (!isSet(options["multiple"]) || (options["multiple"] && options["multiple"] != "checkbox")) {
                options["multiple"] = true;
            }
        }
        return options;
    }
    
    /**
     * Set required attribute and custom validity JS.
     * Params:
     * string fieldNameName The name of the field to generate options for.
     * @param Json[string] options Options list.
     * /
    protected Json[string] setRequiredAndCustomValidity(string fieldNameName, Json[string] options) {
        mycontext = _getContext();

        if (!options["required"]) && options["type"] != "hidden") {
            options["required"] = mycontext.isRequired(fieldName);
        }
        mymessage = mycontext.getRequiredMessage(fieldName);
        mymessage = htmlAttribEscape(mymessage);

        if (options["required"] && mymessage) {
            options["templateVars"]["customValidityMessage"] = mymessage;

            if (configurationData.isSet("autoSetCustomValidity")) {
                options["data-validity-message"] = mymessage;
                options["oninvalid"] = "this.setCustomValidity(""); "
                    ~ "if (!this.value) this.setCustomValidity(this.dataset.validityMessage)";
                options["oninput"] = "this.setCustomValidity("")";
            }
        }
        return options;
    }
    
    /**
     * Generate label for input
     * Params:
     * string fieldNameName The name of the field to generate label for.
     * @param  options Options list.
     * @return string|false Generated label element or false.
     * /
    protected string _getLabel(string fieldNameName, Json[string] options) {
        if (options["type"] == "hidden") {
            return null;
        }
        
        auto mylabel = options.get("label", null);
        if (!mylabel && options["type"] == "checkbox") {
            return options["input"];
        }
        
        if (!mylabel) {
            return null;
        }
        return _inputLabel(fieldName, mylabel, options);
    }
    
    // Extracts a single option from an options array.
    protected Json _extractOption(string optionName, Json[string] optionsToExtract, Json defaultValue = Json(null)) {
        return array_key_exists(optionName, optionsToExtract)
            ? optionsToExtract[optionName]
            : defaultValue;
    }
    
    /**
     * Generate a label for an input() call.
     *
     * options can contain a hash of id overrides. These overrides will be
     * used instead of the generated values if present.
     * Params:
     * @param Json[string]|string|null mylabel Label text or array with label attributes.
     * /
    protected string _inputLabel(string fieldName, string labelText = null, STRINGAA labelAttributes = null, Json[string] labelOptions = null) {
        Json[string] options = options.update["id": null, "input": null, "nestedInput": Json(false), "templateVars": Json.emptyArray];
        STRINGAA mylabelAttributes = ["templateVars": labelOptions["templateVars"]];
        if (isArray(mylabel)) {
            mylabelText = null;
            if (isSet(mylabel["text"])) {
                mylabelText = mylabel["text"];
                unset(mylabel["text"]);
            }
            mylabelAttributes = update(mylabelAttributes, labelAttributes);
        } else {
            mylabelText = mylabel;
        }
        mylabelAttributes["for"] = labelOptions["id"];
        if (in_array(labelOptions["type"], _groupedInputTypes, true)) {
            mylabelAttributes["for"] = false;
        }
        if (labelOptions["nestedInput"]) {
            mylabelAttributes["input"] = labelOptions["input"];
        }
        if (labelOptions.isSet("escape")) {
            mylabelAttributes["escape"] = labelOptions["escape"];
        }
        return _label(fieldName, mylabelText, mylabelAttributes);
    }
    
    /**
     * Creates a checkbox input widget.
     *
     * ### Options:
     *
     * - `value` - the value of the checkbox
     * - `checked` - boolean indicate that this checkbox is checked.
     * - `hiddenField` - boolean|string. Set to false to disable a hidden input from
     *   being generated. Passing a string will define the hidden input value.
     * - `disabled` - create a disabled input.
     * - `default` - Set the default value for the checkbox. This allows you to start checkboxes
     *   as checked, without having to check the POST data. A matching POST data value, will overwrite
     *   the default value.
     * Params:
     * string fieldNameName Name of a field, like this "modelname.fieldname"
     * @param Json[string] options Array of HTML attributes.
     * /
    string[] checkbox(string fieldNameName, Json[string] options  = null) {
        options = options.update["hiddenField": Json(true), "value": 1];

        // Work around value=>val translations.
        myvalue = options["value"];
        unset(options["value"]);
        options = _initInputField(fieldName, options);
        options["value"] = myvalue;

        myoutput = "";
        if (options["hiddenField"] != false && isScalar(options["hiddenField"])) {
            myhiddenOptions = [
                "name": options["name"],
                "value": options["hiddenField"] != true
                    && options["hiddenField"] != "_split"
                    ? to!string(options["hiddenField"]) : "0",
                "form": options.get("form", null),
                "secure": Json(false),
            ];
            if (isSet(options["disabled"]) && options["disabled"]) {
                myhiddenOptions["disabled"] = "disabled";
            }
            myoutput = this.hidden(fieldName, myhiddenOptions);
        }
        if (options["hiddenField"] == "_split") {
            unset(options["hiddenField"], options["type"]);

            return ["hidden": myoutput, "input": this.widget("checkbox", options)];
        }
        unset(options["hiddenField"], options["type"]);

        return myoutput ~ this.widget("checkbox", options);
    }
    
    /**
     * Creates a set of radio widgets.
     *
     * ### Attributes:
     *
     * - `value` - Indicates the value when this radio button is checked.
     * - `label` - Either `false` to disable label around the widget or an array of attributes for
     *   the label tag. `selected` will be added to any classes e.g. `"class": "myclass"` where widget
     *   is checked
     * - `hiddenField` - boolean|string. Set to false to not include a hidden input with a value of "".
     *   Can also be a string to set the value of the hidden input. This is useful for creating
     *   radio sets that are non-continuous.
     * - `disabled` - Set to `true` or `disabled` to disable all the radio buttons. Use an array of
     *  values to disable specific radio buttons.
     * - `empty` - Set to `true` to create an input with the value "" as the first option. When `true`
     *  the radio label will be "empty". Set this option to a string to control the label value.
     * Params:
     * string fieldNameName Name of a field, like this "modelname.fieldname"
     * @param range options Radio button options array.
     * @param Json[string] myattributes Array of attributes.
     * /
    string radio(string fieldNameName, range options = [], Json[string] myattributes = []) {
        myattributes["options"] = options;
        myattributes["idPrefix"] = _idPrefix;

        mygeneratedHiddenId = false;
        if (!myattributes.isSet("id")) {
            myattributes["id"] = true;
            mygeneratedHiddenId = true;
        }
        myattributes = _initInputField(fieldName, myattributes);

        myhiddenField = myattributes["hiddenField"] ?? true;
        unset(myattributes["hiddenField"]);

        myhidden = "";
        if (myhiddenField != false && isScalar(myhiddenField)) {
            myhidden = this.hidden(fieldName, [
                "value": myhiddenField == true ? "" : to!string(myhiddenField),
                "form": myattributes["form"].ifNull(null),
                "name": myattributes["name"],
                "id": myattributes["id"],
            ]);
        }
        if (mygeneratedHiddenId) {
            unset(myattributes["id"]);
        }
        myradio = this.widget("radio", myattributes);

        return myhidden ~ myradio;
    }
    
    /**
     * Missing method handler - : various simple input types. Is used to create inputs
     * of various types. e.g. `this.Form.text();` will create `<input type="text">` while
     * `this.Form.range();` will create `<input type="range">`
     *
     * ### Usage
     *
     * ```
     * this.Form.search("User.query", ["value": "test"]);
     * ```
     *
     * Will make an input like:
     *
     * `<input type="search" id="UserQuery" name="User[query]" value="test">`
     *
     * The first argument to an input type should always be the fieldname, in `Model.field` format.
     * The second argument should always be an array of attributes for the input.
     * Params:
     * string mymethod Method name / input type to make.
     * @param array myparams Parameters for the method call
     * /
    string|int|false __call(string mymethod, Json[string] myparams) {
        if (isEmpty(myparams)) {
            throw new UimException(
                "Missing field name for `FormHelper.%s`.".format(mymethod));
        }
        options = myparams[1] ?? [];
        options["type"] = options["type"] ?? mymethod;
        options = _initInputField(myparams[0], options);

        return _widget(options["type"], options);
    }
    
    /**
     * Creates a textarea widget.
     *
     * ### Options:
     *
     * - `escape` - Whether the contents of the textarea should be escaped. Defaults to true.
     * Params:
     * string fieldNameName Name of a field, in the form "modelname.fieldname"
     * @param Json[string] options Array of HTML attributes, and special options above.
     * /
    string textarea(string fieldNameName, Json[string] options  = null) {
        options = _initInputField(fieldName, options);
        unset(options["type"]);

        return _widget("textarea", options);
    }
    
    /**
     * Creates a hidden input field.
     * Params:
     * string fieldNameName Name of a field, in the form of "modelname.fieldname"
     * @param Json[string] options Array of HTML attributes.
     * /
    string hidden(string fieldNameName, Json[string] options  = null) {
        options = options.update["required": Json(false), "secure": Json(true)];

        mysecure = options["secure"];
        unset(options["secure"]);

        options = _initInputField(fieldName, array_merge(
            options,
            ["secure": SECURE_SKIP]
        ));

        if (mysecure == true && this.formProtector) {
            this.formProtector.addField(
                options["name"],
                true,
                options["val"] == false ? "0" : to!string(options["val"])
            );
        }
        options["type"] = "hidden";

        return _widget("hidden", options);
    }
    
    /**
     * Creates file input widget.
     * Params:
     * string fieldNameName Name of a field, in the form "modelname.fieldname"
     * @param Json[string] options Array of HTML attributes.
     * @return string A generated file input.
     * /
    string file(string fieldNameName, Json[string] options  = null) {
        options = options.update["secure": Json(true)];
        options = _initInputField(fieldName, options);

        unset(options["type"]);

        return _widget("file", options);
    }
    
    /**
     * Creates a `<button>` tag.
     *
     * ### Options:
     *
     * - `type` - Value for "type" attribute of button. Defaults to "submit".
     * - `escapeTitle` - HTML entity encode the title of the button. Defaults to true.
     * - `escape` - HTML entity encode the attributes of button tag. Defaults to true.
     * - `confirm` - Confirm message to show. Form execution will only continue if confirmed then.
     * Params:
     * string mytitle The button"s caption. Not automatically HTML encoded
     * @param Json[string] options Array of options and HTML attributes.
     * /
    string button(string mytitle, Json[string] options  = null) {
        options = options.update[
            "type": "submit",
            "escapeTitle": Json(true),
            "escape": Json(true),
            "secure": Json(false),
            "confirm": null,
        ];
        options["text"] = mytitle;

        myconfirmMessage = options["confirm"];
        options.remove("confirm");
        if (myconfirmMessage) {
            myconfirm = _confirm("return true;", "return false;");
            options["data-confirm-message"] = myconfirmMessage;
            options["onclick"] = this.templater().format("confirmJs", [
                "confirmMessage": htmlAttribEscape(myconfirmMessage),
                "confirm": myconfirm,
            ]);
        }
        return _widget("button", options);
    }
    
    /**
     * Create a `<button>` tag with a surrounding `<form>` that submits via POST as default.
     *
     * This method creates a `<form>` element. So do not use this method in an already opened form.
     * Instead use FormHelper.submit() or FormHelper.button() to create buttons inside opened forms.
     *
     * ### Options:
     *
     * - `data` - Array with key/value to pass in input hidden
     * - `method` - Request method to use. Set to "delete" or others to simulate
     *  HTTP/1.1 DELETE (or others) request. Defaults to "post".
     * - `form` - Array with any option that FormHelper.create() can take
     * - Other options is the same of button method.
     * - `confirm` - Confirm message to show. Form execution will only continue if confirmed then.
     * Params:
     * string mytitle The button"s caption. Not automatically HTML encoded
     * @param string[] myurl URL as string or array
     * /
    string postButton(string mytitle, string[] myurl, Json[string] options  = null) {
        auto myformOptions = ["url": myurl];
        if (isSet(options["method"])) {
            myformOptions["type"] = options["method"];
            unset(options["method"]);
        }
        if (isSet(options["form"]) && isArray(options["form"])) {
            myformOptions = options["form"] + myformOptions;
            unset(options["form"]);
        }
        result = this.create(null, myformOptions);
        if (isSet(options["data"]) && isArray(options["data"])) {
            foreach (Hash.flatten(options["data"]) as aKey: myvalue) {
                result ~= this.hidden(aKey, ["value": myvalue]);
            }
            unset(options["data"]);
        }
        result ~= this.button(mytitle, options);
        result ~= this.end();

        return result;
    }
    
    /**
     * Creates an HTML link, but access the URL using the method you specify
     * (defaults to POST). Requires javascript to be enabled in browser.
     *
     * This method creates a `<form>` element. If you want to use this method inside of an
     * existing form, you must use the `block` option so that the new form is being set to
     * a view block that can be rendered outside of the main form.
     *
     * If all you are looking for is a button to submit your form, then you should use
     * `FormHelper.button()` or `FormHelper.submit()` instead.
     *
     * ### Options:
     *
     * - `data` - Array with key/value to pass in input hidden
     * - `method` - Request method to use. Set to "delete" to simulate
     *  HTTP/1.1 DELETE request. Defaults to "post".
     * - `confirm` - Confirm message to show. Form execution will only continue if confirmed then.
     * - `block` - Set to true to append form to view block "postLink" or provide
     *  custom block name.
     * - Other options are the same of HtmlHelper.link() method.
     * - The option `onclick` will be replaced.
     * Params:
     * string mytitle The content to be wrapped by <a> tags.
     * @param string[] myurl uim-relative URL or array of URL parameters, or
     *  external URL (starts with http://)
     * @param Json[string] options Array of HTML attributes.
     * /
    string postLink(string mytitle, string[] myurl = null, Json[string] options  = null) {
        options = options.update["block": null, "confirm": null];

        myrequestMethod = "POST";
        if (!empty(options["method"])) {
            myrequestMethod = options.getString("method").toUpper;
            unset(options["method"]);
        }
        myconfirmMessage = options["confirm"];
        unset(options["confirm"]);

        myformName = uniqid("post_", true).replace(".", "");
        myformOptions = [
            "name": myformName,
            "style": "display:none;",
            "method": "post",
        ];
        if (isSet(options["target"])) {
            myformOptions["target"] = options["target"];
            unset(options["target"]);
        }
        mytemplater = this.templater();

        myrestoreAction = _lastAction;
       _lastAction(myurl);
        myrestoreFormProtector = this.formProtector;

        myaction = mytemplater.formatAttributes([
            "action": this.Url.build(myurl),
            "escape": Json(false),
        ]);

        result = this.formatTemplate("formStart", [
            "attrs": mytemplater.formatAttributes(myformOptions) ~ myaction,
        ]);
        result ~= this.hidden("_method", [
            "value": myrequestMethod,
            "secure": SECURE_SKIP,
        ]);
        result ~= _csrfField();

        myformTokenData = _View.getRequest().getAttribute("formTokenData");
        if (myformTokenData !isNull) {
            this.formProtector = this.createFormProtector(myformTokenData);
        }
        
        auto myfields = null;
        if (isSet(options["data"]) && isArray(options["data"])) {
            Hash.flatten(options["data"]).each!((kv) {
                myfields[kv.key] = kv.value;
                result ~= this.hidden(kv.key, ["value": kv.value, "secure": SECURE_SKIP]);
            });
            unset(options["data"]);
        }
        result ~= this.secure(myfields);
        result ~= this.formatTemplate("formEnd", []);

       _lastAction = myrestoreAction;
        this.formProtector = myrestoreFormProtector;

        if (options["block"]) {
            if (options["block"] == true) {
                options["block"] = __FUNCTION__;
            }
           _View.append(options["block"], result);
            result = "";
        }
        unset(options["block"]);

        string myurl = "#";
        myonClick = "document." ~ myformName ~ ".submit();";
        if (myconfirmMessage) {
            myonClick = _confirm(myonClick, "");
            myonClick = myonClick ~ "event.returnValue = false; return false;";
            myonClick = this.templater().format("confirmJs", [
                "confirmMessage": htmlAttribEscape(myconfirmMessage),
                "formName": myformName,
                "confirm": myonClick,
            ]);
            options["data-confirm-message"] = myconfirmMessage;
        } else {
            myonClick ~= " event.returnValue = false; return false;";
        }
        options["onclick"] = myonClick;

        result ~= this.Html.link(mytitle, myurl, options);
        return result;
    }
    
    /**
     * Creates a submit button element. This method will generate `<input>` elements that
     * can be used to submit, and reset forms by using options. image submits can be created by supplying an
     * image path for mycaption.
     *
     * ### Options
     *
     * - `type` - Set to "reset" for reset inputs. Defaults to "submit"
     * - `templateVars` - Additional template variables for the input element and its container.
     * - Other attributes will be assigned to the input element.
     * Params:
     * string|null mycaption The label appearing on the button OR if string contains :// or the
     * extension .jpg, .jpe, .jpeg, .gif, .png use an image if the extension
     * exists, AND the first character is /, image is relative to webroot,
     * OR if the first character is not /, image is relative to webroot/img.
     * @param Json[string] options Array of options. See above.
     * /
    string submit(string mycaption = null, Json[string] options  = null) {
        mycaption ??= __d("uim", "Submit");
        options = options.update[
            "type": "submit",
            "secure": Json(false),
            "templateVars": Json.emptyArray,
        ];

        if (isSet(options["name"]) && this.formProtector) {
            this.formProtector.addField(
                options["name"],
                options["secure"]
            );
        }
        unset(options["secure"]);

        bool myisUrl = mycaption.has("://");
        bool myisImage = preg_match("/\.(jpg|jpe|jpeg|gif|png|ico)my/", mycaption);

        mytype = options["type"];
        unset(options["type"]);

        if (myisUrl || myisImage) {
            mytype = "image";

            if (this.formProtector) {
                myunlockFields = ["x", "y"];
                if (isSet(options["name"])) {
                    myunlockFields = [
                        options["name"] ~ "_x",
                        options["name"] ~ "_y",
                    ];
                }
                foreach (myunlockFields as myignore) {
                    this.unlockField(myignore);
                }
            }
        }
        if (myisUrl) {
            options["src"] = mycaption;
        } elseif (myisImage) {
            myUrl = mycaption[0] != "/" 
                ? this.Url.webroot(Configuration.read("App.imageBaseUrl") ~ mycaption)
                : this.Url.webroot(trim(mycaption, "/"));

            myurl = this.Url.assetTimestamp(myurl);
            options["src"] = myurl;
        } else {
            options["value"] = mycaption;
        }
        myinput = this.formatTemplate("inputSubmit", [
            "type": mytype,
            "attrs": this.templater().formatAttributes(options),
            "templateVars": options["templateVars"],
        ]);

        return _formatTemplate("submitContainer", [
            "content": myinput,
            "templateVars": options["templateVars"],
        ]);
    }
    
    /**
     * Returns a formatted SELECT element.
     *
     * ### Attributes:
     *
     * - `multiple` - show a multiple select box. If set to "checkbox" multiple checkboxes will be
     *  created instead.
     * - `empty` - If true, the empty select option is shown. If a string,
     *  that string is displayed as the empty element.
     * - `escape` - If true contents of options will be HTML entity encoded. Defaults to true.
     * - `val` The selected value of the input.
     * - `disabled` - Control the disabled attribute. When creating a select box, set to true to disable the
     *  select box. Set to an array to disable specific option elements.
     *
     * ### Using options
     *
     * A simple array will create normal options:
     *
     * ```
     * options = [1: "one", 2: "two"];
     * this.Form.select("Model.field", options));
     * ```
     *
     * While a nested options array will create optgroups with options inside them.
     * ```
     * options = [
     * 1: "bill",
     *    "fred": [
     *        2: "fred",
     *        3: "fred jr."
     *    ]
     * ];
     * this.Form.select("Model.field", options);
     * ```
     *
     * If you have multiple options that need to have the same value attribute, you can
     * use an array of arrays to express this:
     *
     * ```
     * options = [
     *    ["text": "United states", "value": "USA"],
     *    ["text": "USA", "value": "USA"],
     * ];
     * ```
     * Params:
     * string fieldNameName Name attribute of the SELECT
     * @param range options Array of the OPTION elements (as "value"=>"Text" pairs) to be used in the
     *  SELECT element
     * @param Json[string] myattributes The HTML attributes of the select element.
     * /
    string select(string fieldNameName, range options = [], Json[string] myattributes = []) {
        myattributes += [
            "disabled": null,
            "escape": Json(true),
            "hiddenField": Json(true),
            "multiple": null,
            "secure": Json(true),
            "empty": null,
        ];

        if (myattributes["empty"].isNull && myattributes["multiple"] != "checkbox") {
            myrequired = _getContext().isRequired(fieldName);
            myattributes["empty"] = myrequired.isNull ? false : !myrequired;
        }
        if (myattributes["multiple"] == "checkbox") {
            unset(myattributes["multiple"], myattributes["empty"]);

            return _multiCheckbox(fieldName, options, myattributes);
        }
        unset(myattributes["label"]);

        // Secure the field if there are options, or it"s a multi select.
        // Single selects with no options don"t submit, but multiselects do.
        if (
            myattributes["secure"] &&
            empty(options) &&
            empty(myattributes["empty"]) &&
            empty(myattributes["multiple"])
        ) {
            myattributes["secure"] = false;
        }
        myattributes = _initInputField(fieldName, myattributes);
        myattributes["options"] = options;

        myhidden = "";
        if (myattributes["multiple"] && myattributes["hiddenField"]) {
            myhiddenAttributes = [
                "name": myattributes["name"],
                "value": "",
                "form": myattributes["form"] ?? null,
                "secure": Json(false),
            ];
            myhidden = this.hidden(fieldName, myhiddenAttributes);
        }
        unset(myattributes["hiddenField"], myattributes["type"]);

        return myhidden ~ this.widget("select", myattributes);
    }
    
    /**
     * Creates a set of checkboxes out of options.
     *
     * ### Options
     *
     * - `escape` - If true contents of options will be HTML entity encoded. Defaults to true.
     * - `val` The selected value of the input.
     * - `class` - When using multiple = checkbox the class name to apply to the divs. Defaults to "checkbox".
     * - `disabled` - Control the disabled attribute. When creating checkboxes, `true` will disable all checkboxes.
     *  You can also set disabled to a list of values you want to disable when creating checkboxes.
     * - `hiddenField` - Set to false to remove the hidden field that ensures a value
     *  is always submitted.
     * - `label` - Either `false` to disable label around the widget or an array of attributes for
     *  the label tag. `selected` will be added to any classes e.g. `"class": "myclass"` where
     *  widget is checked
     *
     * Can be used in place of a select box with the multiple attribute.
     * Params:
     * string fieldNameName Name attribute of the SELECT
     * @param range options Array of the OPTION elements
     *  (as "value"=>"Text" pairs) to be used in the checkboxes element.
     * @param Json[string] myattributes The HTML attributes of the select element.
     * /
    string multiCheckbox(string fieldNameName, range options, Json[string] myattributes = []) {
        myattributes += [
            "disabled": null,
            "escape": Json(true),
            "hiddenField": Json(true),
            "secure": Json(true),
        ];

        mygeneratedHiddenId = false;
        if (!myattributes.isSet("id")) {
            myattributes["id"] = true;
            mygeneratedHiddenId = true;
        }
        myattributes = _initInputField(fieldName, myattributes);
        myattributes["options"] = options;
        myattributes["idPrefix"] = _idPrefix;

        myhidden = "";
        if (myattributes["hiddenField"]) {
            myhiddenAttributes = [
                "name": myattributes["name"],
                "value": "",
                "secure": Json(false),
                "disabled": myattributes["disabled"] == true || myattributes["disabled"] == "disabled",
                "id": myattributes["id"],
            ];
            myhidden = this.hidden(fieldName, myhiddenAttributes);
        }
        unset(myattributes["hiddenField"]);

        if (mygeneratedHiddenId) {
            unset(myattributes["id"]);
        }
        return myhidden ~ this.widget("multicheckbox", myattributes);
    }
    
    /**
     * Returns a SELECT element for years
     *
     * ### Attributes:
     *
     * - `empty` - If true, the empty select option is shown. If a string,
     *  that string is displayed as the empty element.
     * - `order` - DOrdering of year values in select options.
     *  Possible values "asc", "desc". Default "desc"
     * - `value` The selected value of the input.
     * - `max` The max year to appear in the select element.
     * - `min` The min year to appear in the select element.
     * Params:
     * string fieldNameName The field name.
     * @param Json[string] options Options & attributes for the select elements.
     * /
    string year(string fieldNameName, Json[string] options  = null) {
        auto options = options.update[
            "empty": Json(true),
        ];
        options = _initInputField(fieldName, options);
        unset(options["type"]);

        return _widget("year", options);
    }
    
    /**
     * Generate an input tag with type "month".
     *
     * ### Options:
     *
     * See dateTime() options.
     * Params:
     * string fieldNameName The field name.
     * @param Json[string] options Array of options or HTML attributes.
     * /
    string month(string fieldNameName, Json[string] options  = null) {
        options = options.update[
            "value": null,
        ];

        options = _initInputField(fieldName, options);
        options["type"] = "month";

        return _widget("datetime", options);
    }
    
    /**
     * Generate an input tag with type "datetime-local".
     *
     * ### Options:
     *
     * - `value` | `default` The default value to be used by the input.
     *  If set to `true` current datetime will be used.
     * Params:
     * string fieldNameName The field name.
     * @param Json[string] options Array of options or HTML attributes.
     * /
    string dateTime(string fieldNameName, Json[string] options  = null) {
        options = options.update[
            "value": null,
        ];
        options = _initInputField(fieldName, options);
        options["type"] = "datetime-local";
        options["fieldName"] = fieldName;

        return _widget("datetime", options);
    }
    
    /**
     * Generate an input tag with type "time".
     *
     * ### Options:
     *
     * See dateTime() options.
     * Params:
     * string fieldNameName The field name.
     * @param Json[string] options Array of options or HTML attributes.
     * /
    string time(string fieldNameName, Json[string] options  = null) {
        options = options.update[
            "value": null,
        ];
        options = _initInputField(fieldName, options);
        options["type"] = "time";

        return _widget("datetime", options);
    }
    
    /**
     * Generate an input tag with type "date".
     *
     * ### Options:
     *
     * See dateTime() options.
     * Params:
     * string fieldNameName The field name.
     * @param Json[string] options Array of options or HTML attributes.
     * /
    string date(string fieldNameName, Json[string] options  = null) {
        options = options.update[
            "value": null,
        ];

        options = _initInputField(fieldName, options);
        options["type"] = "date";

        return _widget("datetime", options);
    }
    
    /**
     * Sets field defaults and adds field to form security input hash.
     * Will also add the error class if the field contains validation errors.
     *
     * ### Options
     *
     * - `secure` - boolean whether the field should be added to the security fields.
     *  Disabling the field using the `disabled` option, will also omit the field from being
     *  part of the hashed key.
     * - `default` - Json - The value to use if there is no value in the form"s context.
     * - `disabled` - Json - Either a boolean indicating disabled state, or the string in
     *  a numerically indexed value.
     * - `id` - Json - If `true` it will be auto generated based on field name.
     *
     * This method will convert a numerically indexed "disabled" into an associative
     * array value. FormHelper"s internals expect associative options.
     *
     * The output of this bool is a more complete set of input attributes that
     * can be passed to a form widget to generate the actual input.
     * Params:
     * string myfield Name of the field to initialize options for.
     * @param Json[string]|string[] options Array of options to append options into.
     * /
    protected Json[string] _initInputField(string myfield, Json[string] options  = null) {
        options = options.update["fieldName": myfield];

        if (!options.isSet("secure")) {
            options["secure"] = _View.getRequest().getAttribute("formTokenData").isNull ? false : true;
        }
        mycontext = _getContext();

        if (isSet(options["id"]) && options["id"] == true) {
            options["id"] = _domId(myfield);
        }
        if (!options["name"])) {
            myendsWithBrackets = "";
            if (myfield.endsWith("[]")) {
                myfield = substr(myfield, 0, -2);
                myendsWithBrackets = "[]";
            }
            string[] pathParts = myfield.split(".");
            myfirst = array_shift(pathParts);
            options["name"] = myfirst ~ (!empty(pathParts) ? "[" ~ join("][", pathParts) ~ "]" : "") ~ myendsWithBrackets;
        }
        if (isSet(options["value"]) && !options.isSet("val")) {
            options["val"] = options["value"];
            unset(options["value"]);
        }
        if (!options.isSet("val")) {
            myvalOptions = [
                "default": options["default"] ?? null,
                "schemaDefault": options.get("schemaDefault", true),
            ];
            options["val"] = this.getSourceValue(myfield, myvalOptions);
        }
        if (!options.isSet("val") && isSet(options["default"])) {
            options["val"] = options["default"];
        }
        unset(options["value"], options["default"]);

        if (cast(BackedEnum)options["val"]) {
            options["val"] = options["val"].value;
        }
        if (mycontext.hasError(myfield)) {
            options = this.addClass(options, configuration.get("errorClass"]);
        }
        myisDisabled = _isDisabled(options);
        if (myisDisabled) {
            options["secure"] = self.SECURE_SKIP;
        }
        return options;
    }
    
    /**
     * Determine if a field is disabled.
     * Params:
     * Json[string] options The option set.
     * /
    protected bool _isDisabled(Json[string] options) {
        if (!options.isSet("disabled")) {
            return false;
        }
        if (isScalar(options["disabled"])) {
            return options["disabled"] == true || options["disabled"] == "disabled";
        }
        if (!ons.isSet("options")) {
            return false;
        }
        if (options["options"].isArray) {
            // Simple list options
            myfirst = options["options"][options["options"].keys[0]];
            if (isScalar(myfirst)) {
                return array_diff(options["options"], options["disabled"]) == null;
            }
            // Complex option types
            if (isArray(myfirst)) {
                mydisabled = array_filter(
                    options["options"],
                    fn (myi): in_array(myi["value"], options["disabled"], true)
                );

                return count(mydisabled) > 0;
            }
        }
        return false;
    }
    
    /**
     * Add a new context type.
     *
     * Form context types allow FormHelper to interact with
     * data providers that come from outside UIM. For example
     * if you wanted to use an alternative ORM like Doctrine you could
     * create and connect a new context class to allow FormHelper to
     * read metadata from doctrine.
     * Params:
     * string mytype The type of context. This key
     *  can be used to overwrite existing providers.
     * @param callable mycheck A callable that returns an object
     *  when the form context is the correct type.
     * /
    void addContextProvider(string mytype, callable mycheck) {
        this.contextFactory().addProvider(mytype, mycheck);
    }
    
    /**
     * Get the context instance for the current form set.
     *
     * If there is no active form null will be returned.
     * Params:
     * \UIM\View\Form\IContext|null formContext Either the new context when setting, or null to get.
     * @return \UIM\View\Form\IContext The context for the form.
     * /
    IContext context(?IContext formContext = null) {
        if (cast(IContext)formContext) {
           _context = formContext;
        }
        return _getContext();
    }
    
    /**
     * Find the matching context provider for the data.
     *
     * If no type can be matched a NullContext will be returned.
     * Params:
     * Json mydata The data to get a context provider for.
     * /
    protected IContext _getContext(Json mydata = []) {
        if (isSet(_context) && empty(mydata)) {
            return _context;
        }
        mydata += ["entity": null];

        return _context = this.contextFactory()
            .get(_View.getRequest(), mydata);
    }
    
    /**
     * Add a new widget to FormHelper.
     *
     * Allows you to add or replace widget instances with custom code.
     * Params:
     * string views The name of the widget. e.g. "text".
     * @param \UIM\View\Widget\IWidget|string[] myspec Either a string class
     *  name or an object implementing the IWidget.
     * /
    void addWidget(string views, IWidget|string[] myspec) {
       _locator.add([views: myspec]);
    }
    
    /**
     * Render a named widget.
     *
     * This is a lower level method. For built-in widgets, you should be using
     * methods like `text`, `hidden`, and `radio`. If you are using additional
     * widgets you should use this method render the widget without the label
     * or wrapping div.
     * Params:
     * string widgetname The name of the widget. e.g. "text".
     * @param Json[string] data The data to render.
     * /
    string widget(string widgetname, Json[string] data = []) {
        mysecure = null;
        if (isSet(mydata["secure"])) {
            mysecure = mydata["secure"];
            unset(mydata["secure"]);
        }
        mywidget = _locator.get(widgetname);
        result = mywidget.render(mydata, this.context());
        if (
            this.formProtector !isNull &&
            isSet(mydata["name"]) &&
            mysecure !isNull &&
            mysecure != self.SECURE_SKIP
        ) {
            foreach (mywidget.secureFields(mydata) as myfield) {
                this.formProtector.addField(myfield, mysecure);
            }
        }
        return result;
    }
    
    /**
     * Restores the default values built into FormHelper.
     *
     * This method will not reset any templates set in custom widgets.
     * /
    void resetTemplates() {
        this.setTemplates(_defaultconfiguration.get("templates"]);
    }
    
    /**
     * Event listeners.
     * /
    IEvent[] implementedEvents() {
        return null;
    }
    
    /**
     * Gets the value sources.
     * Returns a list, but at least one item, of valid sources, such as: `"context"`, `"data"` and `"query"`.
     * /
    string[] getValueSources() {
        return _valueSources;
    }
    
    /**
     * Validate value sources.
     * Params:
     * string[] mysources A list of strings identifying a source.
     * @throws \InvalidArgumentException If sources list contains invalid value.
     * /
    protected void validateValueSources(Json[string] mysources) {
        mydiff = array_diff(mysources, this.supportedValueSources);

        if (mydiff) {
            array_walk(mydiff, fn (&myx): myx = "`myx`");
            array_walk(this.supportedValueSources, fn (&myx): myx = "`myx`");
            throw new DInvalidArgumentException(
                "Invalid value source(s): %s. Valid values are: %s."
                .format(join(", ", mydiff), join(", ", this.supportedValueSources)
            ));
        }
    }
    
    /**
     * Sets the value sources.
     *
     * You need to supply one or more valid sources, as a list of strings.
     * DOrder sets priority.
     *
     * @param string[]|string mysources A string or a list of strings identifying a source.
     * /
    void setValueSources(string[] mysources) {
        mysources = (array)mysources;

        this.validateValueSources(mysources);
       _valueSources = mysources;
    }
    
    // Gets a single field value from the sources available.
    Json getSourceValue(string fieldName, Json[string] options  = null) {
        auto myvalueMap = [
            "data": "getData",
            "query": "getQuery",
        ];
        foreach (myvaluesSource; this.getValueSources()) {
            if (myvaluesSource == "context") {
                auto contextValue = _getContext().val(fieldName, options);
                if (!contextValue.isNull) {
                    return contextValue;
                }
            }
            if (isSet(myvalueMap[myvaluesSource])) {
                mymethod = myvalueMap[myvaluesSource];
                myvalue = _View.getRequest().{mymethod}(fieldName);
                if (myvalue !isNull) {
                    return myvalue;
                }
            }
        }
        return null;
    } */
}
