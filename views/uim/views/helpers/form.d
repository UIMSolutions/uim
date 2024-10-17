/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.views.helpers.form;

import uim.views;

@safe:
unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
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
    protected string[] _supportedValueSources = ["context", "data", "query"];

    // The default sources.
    protected string[] _valueSources = ["data", "context"];

    // Grouped input types.
    protected string[] _groupedInputTypes = ["radio", "multicheckbox"];

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        /*         _typeMap
            .set("string", "text")
            .set("text", "textarea")
            .set("uuid", "string")
            .set("datetime", "datetime")
            .set("datetimefractional", "datetime")
            .set("timestamp", "datetime")
            .set("timestampfractional", "datetime")
            .set("timestamptimezone", "datetime")
            .set("date", "date")
            .set("time", "time")
            .set("year", "year")
            .set("boolean", "checkbox")
            .set("float", "number")
            .set("integer", "number")
            .set("tinyinteger", "number")
            .set("smallinteger", "number")
            .set("decimal", "number")
            .set("binary", "file");
 */

        _defaultWidgets
            .set("button", ["Button"])
            .set("checkbox", ["Checkbox"])
            .set("file", ["File"])
            .set("label", ["Label"])
            .set("nestingLabel", ["NestingLabel"])
            .set("multicheckbox", ["MultiCheckbox", "nestingLabel"])
            .set("radio", ["Radio", "nestingLabel"])
            .set("select", ["SelectBox"])
            .set("textarea", ["Textarea"])
            .set("datetime", ["DateTime", "select"])
            .set("year", ["Year", "select"])
            .set("_default", ["Basic"]);

        configuration
            .setDefault("idPrefix", Json(null))
            .setDefault("errorClass", "form-error") // .setDefault("typeMap", typeMap)
            .setDefault("templates", createMap!(string, Json)) // set HTML5 validation message to custom required/empty messages
            .setDefault("autoSetCustomValidity", true);

        /* auto mylocator = null; 
        Json[] mywidgets = _defaultWidgets; */
        if (configuration.hasKey("locator")) {
            // mylocator = configuration.shift("locator");
        }

        if (configuration.hasKey("widgets")) {
            if (configuration.isString("widgets")) {
                configuration.set("widgets", configuration.get("widgets").toArray);
            }
            // mywidgets = configuration.shift("widgets").toArray ~ mywidgets;
        }
        if (configuration.hasKey("groupedInputTypes")) {
            _groupedInputTypes = configuration.shift("groupedInputTypes").toStringArray;
        }

        return true;
    }
    /**
     * Constant used internally to skip the securing process,
     * and neither add the field to the hash or to the unlocked fields.
     */
    const string SECURE_SKIP = "skip"; // Defines the type of form being created. Set by FormHelper.create().
    string _requestType = null; // DContext for the current form.
    protected IContext _context = null; /**
     * The action attribute value of the last created form.
     * Used to make form/request specific hashes for form tampering protection.
     */
    protected string _lastAction = "";

    // Default widgets
    protected Json[string] _defaultWidgets;

    // Locator for input widgets.
    protected DWidgetLocator _locator;

    // DContext factory.
    protected DContextFactory _contextFactory = null;
    // Other helpers used by FormHelper
    protected string[] myhelpers = ["Url", "Html"];

    // Form protector
    protected DFormProtector _formProtector = null;

    /*     this(IView myview, Json[string] configData = null) {
/*     super(myview, configData);

    if (!mylocator) {
        mylocator = new WidgetLocator(this.templater(), _view, mywidgets);
    }
    setWidgetLocator(mylocator);
    _idPrefix = configuration.getString("idPrefix");
} */

    // Get the widget locator currently used by the helper.
    DWidgetLocator getWidgetLocator() {
        return _locator;
    }

    /**
     * Set the widget locator the helper will use.
     * Params:
     * \UIM\View\Widget\WidgetLocator myinstance The locator instance to set.
     */
    void setWidgetLocator(DWidgetLocator myinstance) {
        _locator = myinstance;
    }

    // Set the context factory the helper will use.
    DContextFactory contextFactory(DContextFactory factory = null, Json[string] contexts = null) {
        /* if (factory.isNull) {
            return _contextFactory ? _contextFactory : DContextFactory.createWithDefaults(contexts);
        }
        _contextFactory = factory;
        return _contextFactory; */
        return null;
    }

    /**
     * Returns an HTML form element.
     *
     * ### Options:
     *
     * - `type` Form method defaults to autodetecting based on the form context. If
     * the form context"s isCreate() method returns false, a PUT request will be done.
     * - `method` Set the form"s method attribute explicitly.
     * - `url` The URL the form submits to. Can be a string or a URL array.
     * - `encoding` Set the accept-charset encoding for the form. Defaults to `configuration.get("App.encoding")`
     * - `enctype` Set the form encoding explicitly. By default `type: file` will set `enctype`
     * to `multipart/form-data`.
     * - `templates` The templates you want to use for this form. Any templates will be merged on top of
     * the already loaded templates. This option can either be a filename in /config that contains
     * the templates you want to load, or an array of templates to use.
     * - `context` Additional options for the context class. For example the EntityContext accepts a "table"
     * option that allows you to set the specific Table class the form should be based on.
     * - `idPrefix` Prefix for generated ID attributes.
     * - `valueSources` The sources that values should be read from. See FormHelper.setValueSources()
     * - `templateVars` Provide template variables for the formStart template.
     */
    string create(Json formContext = null, Json[string] options = null) {
        /* string myappend = "";

        if (cast(IContext) formContext) {
            context(formContext);
        } else {
            if (options.isEmpty("context")) {
                options.set("context", Json(null));
            }
            options.set("context.entity", formContext);
            formContext = _getContext(options.shift("context"));
        }
        myisCreate = formContext.isCreate();

        options
            .merge("type", myisCreate ? "post" : "put")
            .merge("url", Json(null))
            .merge("encoding", configuration.get("App.encoding").lower)
            .merge("templates", Json(null))
            .merge("idPrefix", Json(null))
            .merge("valueSources", Json(null));

        if (options.hasKey("valueSources")) {
            setValueSources(options.shift("valueSources"));
        }
        if (options.hasKey("idPrefix")) {
            _idPrefix = options.get("idPrefix");
        }
        mytemplater = this.templater();

        if (options.hasKey("templates")) {
            mytemplater.push();
            methodName = isString(options.get("templates")) ? "load" : "add";
            // TODO mytemplater.{methodName}(options.get("templates"));
        }
        options.removeKey("templates");

        if (!options.hasKey("url")) {
            myurl = _view.getRequest().getRequestTarget();
            myaction = null;
        } else {
            myurl = _formUrl(formContext, options);
            myaction = _url.build(myurl);
        }
        lastAction(myurl);
        options.removeKey("ur", "idPrefix");

        myhtmlAttributes = null;
        switch (options.get("type").lower) {
        case "get":
            myhtmlAttributes.get("method", "get");
            break;
            // Set enctype for form
        case "file":
            myhtmlAttributes.get("enctype", "multipart/form-data");
            options.set("type", myisCreate ? "post" : "put");
            // Move on
        case "put":
            // Move on
        case "delete":
            // Set patch method
        case "patch":
            myappend ~= hidden("_method", [
                    "name": "_method",
                    "value": options.getString("type").upper,
                    "secure": SECURE_SKIP,
                ]);
            // Default to post method
        default:
            myhtmlAttributes.get("method", "post");
        }
        if (options.hasKey("method")) {
            myhtmlAttributes.set("method", options.getString("method").lower);
        }
        if (options.hasKey("enctype")) {
            myhtmlAttributes.set("enctype", options.getString("enctype").lower);
        }
        _requestType = options.getString("type").lower;

        if (options.hasKey("encoding")) {
            myhtmlAttributes.set("accept-, set", options.get("encoding"));
        }
        options.removeKey("type", "encoding");

        myhtmlAttributes += options;

        if (_, requestType != "get") {
            myformTokenData = _view.getRequest().getAttribute("formTokenData");
            if (!myformTokenData.isNull) {
                _formProtector = this.createFormProtector(myformTokenData);
            }
            myappend ~= _csrfField();
        }
        if (!myappend.isEmpty) {
            myappend = mytemplater.format("hiddenBlock", ["content": myappend]);
        }
        myactionAttr = mytemplater.formatAttributes(createMap!(string, Json)
                .set("action", myaction)
                .set("escape", false));

        return _formatTemplate("formStart", createMap!(string, Json)
                .set("attrs", mytemplater.formatAttributes(myhtmlAttributes) ~ myactionAttr)
                .set("templateVars", options.getArray("templateVars"))) ~ myappend;
     */
        return null;
    }

    // Create the URL for a form based on the options.
    protected string[] _formUrl(IContext formContext, Json[string] options = null) {
        /* auto request = _view.getRequest();

        if (options.isNull("url")) {
            return request.getRequestTarget();
        }
        if (
            options.isString("url") ||
            (options.isArray("url") && options.hasKey("url._name"))
            ) {
            return options.get("url");
        }

        return options.get("url")
            .merge("plugin", _view.pluginName)
            .merge("controller", request.getParam("controller"))
            .merge("action", request.getParam("action")); */
        return null;
    }

    // Correctly store the last created form action URL.
    protected void lastAction(string[] myurl = null) {
        /* auto myaction = Router.url(myurl, true);
        auto myQuery = parse_url(myaction, D_URL_QUERY);
        myQuery = myQuery ? "?" ~ myQuery : ""; */

        /* auto mypath = parse_url(myaction, D_URL_PATH) ?: "";
       _lastAction = mypath ~ myQuery; */
    }

    /**
     * Return a CSRF input if the request data is present.
     * Used to secure forms in conjunction with CsrfMiddleware.
     */
    protected string _csrfField() {
        /* auto request = _view.getRequest();
        auto csrfToken = request.getAttribute("csrfToken");
        if (!csrfToken) {
            return null;
        }
        return _hidden("_csrfToken", createMap!(string, Json)
                .set("value", csrfToken)
                .set("secure", SECURE_SKIP)); */
        return null;
    }

    /**
     * Closes an HTML form, cleans up values set by FormHelper.create(), and writes hidden
     * input fields where appropriate.
     *
     * Resets some parts of the state, shared among multiple FormHelper.create() calls, to defaults.
     * Params:
     * Json[string] secureAttributes Secure attributes which will be passed as HTML attributes
     * into the hidden input elements generated for the Security Component.
     */
    string end(Json[string] secureAttributes = null) {
        /* string result = "";

        if (_requestType != "get" && !_view.getRequest().getAttribute("formTokenData").isNull) {
            result ~= this.secure([], secureAttributes);
        }
        result ~= formatTemplate("formEnd", []);

        templater().pop();
        _requestType = null;
        _context = null;
        _valueSources = ["data", "context"];
        _idPrefix = configurationData.hasKey("idPrefix");
        _formProtector = null;

        return result; */
        return null;
    }

    /**
     * Generates a hidden field with a security hash based on the fields used in
     * the form.
     *
     * If secureAttributes is set, these HTML attributes will be merged into
     * the hidden input tags generated for the Security Component. This is
     * especially useful to set HTML5 attributes like "form".
     */
    string secure(Json[string] fieldNames = null, Json[string] secureAttributes = null) {
        if (!_formProtector) {
            return null;
        }
        /* fieldNames.byKeyValue.each!(fieldName)
            if (isInteger(fieldName)) {
                fieldName = myvalue;
                myvalue = null;
            }
            _formProtector.addField(fieldName, true, myvalue);
        } */
        auto mydebugSecurity = configuration.getBoolean("debug");
        /* if (secureAttributes.hasKey("debugSecurity")) {
            mydebugSecurity = mydebugSecurity && secureAttributes["debugSecurity"];
            secureAttributes.removeKey("debugSecurity");
        } */

        /* secureAttributes.set("secure", SECURE_SKIP);
        auto mytokenData = _formProtector.buildTokenData(
           _lastAction,
           _getFormProtectorSessionId()
       ); */
        /* mytokenFields = array_merge(secureAttributes, [
            "value": mytokenData["fields"],
        ]);
        result = hidden("_Token.fields", mytokenFields); */
        /* mytokenUnlocked = array_merge(secureAttributes, [
            "value": mytokenData["unlocked"],
        ]); */
        /* result ~= hidden("_Token.unlocked", mytokenUnlocked); */
        if (mydebugSecurity) {
            /* mytokenDebug = array_merge(secureAttributes, [
                "value": mytokenData["debug"],
            ]);
            result ~= hidden("_Token.debug", mytokenDebug); */
        }
        /* return _formatTemplate("hiddenBlock", ["content": result]); */
        // return string;
        return null;
    }

    /**
     * Get Session id for FormProtector
     * Must be the same as in FormProtectionComponent
     */
    protected string _getFormProtectorSessionId() {
        // return _view.getRequest().getSession().id();
        return null;
    }

    /**
     * Add to the list of fields that are currently unlocked.
     *
     * Unlocked fields are not included in the form protection field hash.
     */
    void unlockField(string fieldName) {
        getFormProtector().unlockField(fieldName);
    }

    // Create FormProtector instance.
    protected DFormProtector createFormProtector(Json[string] tokenData) {
        /* auto mysession = _view.getRequest().getSession();
        mysession.start();

        return new DFormProtector(tokenData); */
        return null;
    }

    // Get form protector instance.
    DFormProtector getFormProtector() {
        /* if (_formProtector.isNull) {
            throw new UIMException(
                "`FormProtector` instance has not been created. Ensure you have loaded the `FormProtectionComponent`" ~
                    " in your controller and called `FormHelper.create()` before calling `FormHelper.unlockField()`."
            );
        }
        return _formProtector; */
        return null;
    }

    // Returns true if there is an error for the given field, otherwise false
    bool isFieldError(string fieldName) {
        return _getContext().hasError(fieldName);
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
     * string fieldName A field name, like "modelname.fieldname"
     */
    string error(string fieldName, string[] text = null, Json[string] options = null) {
        /* if (fieldName.endsWith("._ids")) {
            fieldName = subString(fieldName, 0, -5);
        }
        options.merge("escape", true);
        auto formContext = _getContext();
        if (!formContext.hasError(fieldName)) {
            return null;
        }

        auto myerror = formContext.error(fieldName);
        if (text.isArray) {
            mytmp = null;
            foreach (key, exception; myerror) {
                if (text.hasKey(key)) {
                    mytmp ~= text[key];
                } else if (mytextm.hasKey(ye)) {
                    mytmp ~= text[exception];
                } else {
                    mytmp ~= exception;
                }
            }
            text = mytmp;
        }
        if (text !is null) {
            myerror = text;
        }
        if (options.hasKey("escape")) {
            Json myerror = htmlAttributeEscape(myerror);
            options.removeKey("escape");
        }
        if (isArray(myerror)) {
            if (count(myerror) > 1) {
                myerrorText = null;
                foreach (error; myerror) {
                    myerrorText ~= formatTemplate("errorItem", ["text": error]);
                }
                myerror = formatTemplate("errorList", [
                        "content": myerrorText.join,
                    ]);
            } else {
                myerror = myerror.pop();
            }
        }
        return _formatTemplate("error", createMap!(string, Json)
                .set("content", myerror)
                .set("id", _domId(fieldName) ~ "-error")); */
        return null;
    }

    /**
     * Returns a formatted LABEL element for HTML forms.
     *
     * Will automatically generate a `for` attribute if one is not provided.
     *
     * ### Options
     *
     * - `for` - Set the for attribute, if its not defined the for attribute
     * will be generated from the fieldName parameter using
     * FormHelper._domId().
     * - `escape` - Set to `false` to turn off escaping of label text.
     * Defaults to `true`.
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
     * "for": "post-publish"
     * ]);
     * <label for="post-publish">Publish</label>
     * ```
     *
     * Nesting an input tag:
     *
     * ```
     * writeln(this.Form.label("published", "Publish", [
     * "for": "published",
     * "input": this.text("published"),
     * ]);
     * <label for="post-publish">Publish <input type="text" name="published"></label>
     * ```
     * If you want to nest inputs in the labels, you will need to modify the default templates.
     */
    string label(string fieldName, string text = null, Json[string] htmlAttributes = null) {
        /* if (text.isNull) {
            text = fieldName;
            if (text.endsWith("._ids")) {
                text = subString(text, 0, -5);
            }
            if (text.contains(".")) {
                string[] fieldNameElements = text.split(".");
                text = fieldNameElements.pop();
            }
            if (text.endsWith("_id")) {
                text = subString(text, 0, -3);
            }
            text = __(text.underscore.humanize);
        }
        if (htmlAttributes.hasKey("for")) {
            mylabelFor = htmlAttributes["for"];
            htmlAttributes.removeKey("for");
        } else {
            mylabelFor = _domId(fieldName);
        }

        auto attributes = htmlAttributes
            .set("for", mylabelFor)
            .set("text", text);
        if (htmlAttributes.hasKey("input")) {
            if (isArray(htmlAttributes["input"])) {
                attributes = htmlAttributes["input"] + attributes;
            }
            return _widget("nestingLabel", attributes);
        }
        return _widget("label", attributes); */
        return null;
    }

    /**
     * Generate a set of controls for `fieldNames`. If fieldNames is empty the fields
     * of current model will be used.
     *
     * You can customize individual controls through `fieldNames`.
     * ```
     * this.Form.allControls([
     * "name": ["label": "custom label"]
     * ]);
     * ```
     *
     * You can exclude fields by specifying them as `false`:
     *
     * ```
     * this.Form.allControls(["title": false]);
     * ```
     *
     * In the above example, no field would be generated for the title field.
     * Params:
     * array fieldNames An array of customizations for the fields that will be
     * generated. This array allows you to set custom types, labels, or other options.
     */
    string allControls(Json[string] fieldNames = null, Json[string] options = null) {
        /* auto mycontext = _getContext();
        auto mymodelFields = mycontext.fieldNames();
        auto fieldNames = array_merge(mymodelFields, fieldNames);

        return _controls(fieldNames, options); */
        return null;
    }

    /**
     * Generate a set of controls for `fieldNames` wrapped in a fieldset element.
     *
     * You can customize individual controls through `fieldNames`.
     * ```
     * this.Form.controls([
     * "name": ["label": "custom label"],
     * "email"
     * ]);
     * ```
     * Params:
     * array fieldNames An array of the fields to generate. This array allows
     * you to set custom types, labels, or other options.
     */
    string controls(Json[string] fieldNames, Json[string] options = null) {
        /* string result = "";
        foreach (views, myopts; fieldNames) {
            if (myopts == false) {
                continue;
            }
            result ~= this.control(views, /* (array) * / myopts);
        }
        return _fieldset(result, options); */
        return null;
    }

    /**
     * Wrap a set of inputs in a fieldset
     * Params:
     * string fieldNames the form inputs to wrap in a fieldset
     *
     * - `legend` Set to false to disable the legend for the generated input set. Or supply a string
     *  to customize the legend text.
     */
    string fieldset(string fieldNames = "", Json[string] options = null) {
        /* bool isLegend = options.getBoolean("legend", true);
        // `fieldset` Set to false to disable the fieldset. 
        auto fieldNameset = options.getBoolean("fieldset", true);
        auto mycontext = _getContext();
        auto result = fieldNames;

        if (myleisLegendend) {
            auto myisCreate = mycontext.isCreate();
            auto mymodelName = Inflector.singularize(_view.getRequest()
                    .getParam("controller")).humanize;

            isLegend = !myisCreate
                ? __d("uim", "Edit {0}", mymodelName) : __d("uim", "New {0}", mymodelName);
        }
        if (fieldNameset == true) {
            if (isLegend) {
                result = formatTemplate("legend", ["text": isLegend]) ~ result;
            }
            fieldNamesetParams = ["content": result, "attrs": ""];
            if (fieldNameset.isArray && !fieldNameset.isEmpty) {
                fieldNamesetParams["attrs"] = this.templater().formatAttributes(fieldNameset);
            }
            result = formatTemplate("fieldset", fieldNamesetParams);
        }
        return result; */
        return null;
    }

    /**
     * Generates a form control element complete with label and wrapper div.
     *
     * ### Options
     *
     * See each field type method for more information. Any options that are part of
     * attributes or options for the different **type** methods can be included in `options` for control().
     * Additionally, any unknown keys that are not in the list below, or part of the selected type"s options
     * will be treated as a regular HTML attribute for the generated input.
     *
     * - `type` - Force the type of widget you want. e.g. `type: "select"`
     * - `label` - Either a string label, or an array of options for the label. See FormHelper.label().
     * - `options` - For widgets that take options e.g. radio, select.
     * - `error` - Control the error message that is produced. Set to `false` to disable any kind of error reporting
     * (field error and error messages).
     * - `empty` - String or boolean to enable empty select box options.
     * - `nestedInput` - Used with checkbox and radio inputs. Set to false to render inputs outside of label
     * elements. Can be set to true on any input to force the input inside the label. If you
     * enable this option for radio buttons you will also need to modify the default `radioWrapper` template.
     * - `templates` - The templates you want to use for this input. Any templates will be merged on top of
     * the already loaded templates. This option can either be a filename in /config that contains
     * the templates you want to load, or an array of templates to use.
     * - `options` - Either `false` to disable label around nestedWidgets e.g. radio, multicheckbox or an array
     * of attributes for the label tag. `selected` will be added to any classes e.g. `class: "myclass"` where
     * widget is checked
     */
    string control(string fieldName, Json[string] options = null) {
        /* options
            .merge("type", Json(null))
            .merge("label", Json(null))
            .merge("error", Json(null))
            .merge("required", Json(null))
            .merge("options", Json(null))
            .merge("templates", Json.emptyArray)
            .merge("templateVars", Json.emptyArray)
            .merge("options", true);

        options = _parseOptions(fieldName, options);
        options.set("id", _domId(fieldName));

        auto mytemplater = this.templater();
        auto mynewTemplates = options.get("templates");

        if (mynewTemplates) {
            mytemplater.push();
            mytemplateMethod = isString(options.getString("templates") ? "load" : "add");
            // mytemplater.{mytemplateMethod}(options.getString("templates"));
        }
        options.removeKey("templates");

        // Hidden inputs don"t need aria.
        // Multiple checkboxes can"t have aria generated for them at this layer.
        if (options.getString("type") != "hidden" && (options.getString("type") != "select" && !options.hasKey(
                "multiple"))) {
            bool isFieldError = isFieldError(fieldName);
            options
                .update("aria-required", options.getBoolean("required") ? "true" : null)
                .update("aria-invalid", isFieldError ? "true" : null);

            // Don"t include aria-describedby unless we have a good chance of
            // having error message show up.
            if (
                mytemplater.getString("error").contains("{{id}}") &&
                mytemplater.getString("inputContainerError").contains("{{error}}")
                ) {
                options.update("aria-describedby", isFieldError ? _domId.getString(
                        fieldName) ~ "-error" : null);
            }
            if (options.hasKey("placeholder") && options.get("label") == false) {
                options.update("aria-label", options.get("placeholder"));
            }
        }

        auto myerror = null;
        auto myerrorSuffix = "";
        if (options.getString("type") != "hidden" && options.get("error") == true) {
            myError = options.isArray("error")
                ? error(fieldName, options.get("error"), options.get("error")) : error(fieldName, options.get(
                        "error"));

            myerrorSuffix = myerror.isEmpty ? "" : "Error";
            options.removeKey("error");
        }
        auto mylabel = options.shift("label");
        auto myoptions = options.shift("options");

        bool isNestedInput = options.getString("type") == "checkbox";
        isNestedInput = options.getBoolean("nestedInput", isNestedInput);
        options.removeKey("nestedInput");

        if (
            isNestedInput == true
            && options.getString("type") == "checkbox"
            && !hasKey("hiddenField", options)
            && mylabel == true
            ) {
            options.get("hiddenField", "_split");
        }

        string myinput = _getInput(fieldName, options ~ ["options": myoptions]);
        if (options.getString("type") == "hidden" || options.getString("type") == "submit") {
            if (mynewTemplates) {
                mytemplater.pop();
            }
            return myinput;
        }

        auto mylabel = _getLabel(fieldName, compact("input", "label", "error", "nestedInput").merge(
                options));

        auto result = isNestedInput
            ? _groupTemplate(compact("label", "error", "options")) : _groupTemplate(
                compact("input", "label", "error", "options"));

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
        return result; */
        return null;
    }

    // Generates an group template element
    protected string _groupTemplate(Json[string] options = null) {
        /* string groupTemplate = options.getString("options.type") ~ "FormGroup";
        if (!this.templater().get(groupTemplate)) {
            groupTemplate = "formGroup";
        }
        return _formatTemplate(groupTemplate, [
                "input": options.get("input"),
                "label": options.get("label"),
                "error": options.get("error"),
                "templateVars": options.get("options.templateVars"),
            ]); */
        return null;
    }

    /**
     * Generates an input container template
     * Params:
     * Json[string] options The options for input container template
     */
    protected string _inputContainerTemplate(Json[string] options = null) {
        /* myinputContainerTemplate = options.getString(
            "options.type") ~ "Container" ~ options.getString("errorSuffix");
        if (!this.templater().get(myinputContainerTemplate)) {
            myinputContainerTemplate = "inputContainer" ~ options.getString("errorSuffix");
        }
        return _formatTemplate(myinputContainerTemplate, [
                "content": options.get("content"),
                "error": options.get("error"),
                "label": options.getString("label", ""),
                "required": options.get("options.required") ? " " ~ this.templater()
                .get("requiredClass"): "",
                "type": options.get("options.type"),
                "templateVars": options.get("options.templateVars", null),
            ]); */
        return null;
    }

    /**
     * Generates an input element
     * Params:
     * string fieldName the field name
     */
    protected string[] _getInput(string fieldName, Json[string] options = null) {
        auto mylabel = options.shift("options");

        switch (options.getString("type").lower) {
        case "select":
        case "radio":
        case "multicheckbox":
            auto myopts = options.shift("options");
            if (myopts.isNull) {
                myopts = null;
            }

            /* return _{options.get("type")}(fieldName, myopts, options.set("label", mylabel)); */
            return null;
        case "input":
            /*  throw new DInvalidArgumentException(
                "Invalid type `input` used for field `%s`.".format(fieldName
            )); */

        default:
            return null;
            /* return _{options.get("type")}(fieldName, options); */
        }
    }

    // Generates input options array
    protected Json[string] _parseOptions(string fieldName, Json[string] options = null) {
        auto myneedsMagicType = false;
        if (options.isEmpty("type")) {
            myneedsMagicType = true;
            options.set("type", _inputType(fieldName, options));
        }
        return _magicOptions(fieldName, options, myneedsMagicType);
    }

    /**
     * Returns the input type that was guessed for the provided fieldName,
     * based on the internal type it is associated too, its name and the
     * variables that can be found in the view template
     * Params:
     * string fieldName the name of the field to guess a type for
     */
    protected string _inputType(string fieldName, Json[string] options = null) {
        auto mycontext = _getContext();

        if (mycontext.isPrimaryKey(fieldName)) {
            return "hidden";
        }
        if (fieldName.endsWith("_id")) {
            return "select";
        }
        auto mytype = "text";
        auto internalType = mycontext.type(fieldName);
        auto mymap = configuration.get("typeMap");
        /* if (internalType !is null && mymap.hasKey(internalType)) {
            mytype = mymap[internalType];
        } */
        // auto fieldName = fieldName.split(".").slice(, -1)[0];

        /*  return match (true) {
            options.hasKey("checked"): "checkbox",
            options.hasKey("options"): "select",
            isIn(fieldName, ["passwd", "password"], true): "password",
            isIn(fieldName, ["tel", "telephone", "phone"], true): "tel",
            fieldName == "email": "email",
            options.hasKey("rows") || options.hasKey("cols") : "textarea",
            fieldName == "year": "year",
            default: mytype,
        }; */
        return null;
    }

    /**
     * Selects the variable containing the options for a select field if present,
     * and sets the value to the "options" key in the options array.
     */
    protected Json[string] _optionsOptions(string fieldName, Json[string] options = null) {
        /* if (options.hasKey("options")) {
            return options;
        }

        auto internalType = _getContext().type(fieldName);
        if (internalType && internalType.startsWith("enum-")) {
            mydbType = TypeFactory.build(internalType);
            if (cast(EnumType) mydbType) {
                if (options.getString("type") != "radio") {
                    options.set("type", "select");
                }
                options.set("options", this.enumOptions(mydbType.getEnumclassname()));
                return options;
            }
        }
        mypluralize = true;
        if (fieldName.endsWith("._ids")) {
            fieldName = subString(fieldName, 0, -5);
            mypluralize = false;
        } else if (fieldName.endsWith("_id")) {
            fieldName = subString(fieldName, 0, -3);
        }
        fieldName = fieldName.split(".").slice(-1)[0];

        myvarName = Inflector.variable(
            mypluralize ? Inflector.pluralize(fieldName) : fieldName
        );
        myvarOptions = _view.get(myvarName);
        if (!is_iterable(myvarOptions)) {
            return options;
        }
        if (options.hasKey("type") != "radio") {
            options.set("type", "select");
        }
        options.set("options", myvarOptions);

        return options; */
        return null;
    }

    /**
     * Get map of enum value: label for select/radio options.
     * Params:
     * class-string<\BackedEnum> myenumClass Enum class name.
     */
    // TODO protected array<int|string, string> enumOptions(string enumclassname) {
    /* assert(isSubclass_of(enumclassname, BackedEnum.classname));

        myvalues = null;
        /** @var \BackedEnum mycase * /
        foreach (mycase; enumclassname.cases()) {
            myhasLabel = cast(IEnumLabel)mycase || hasMethod(mycase, "label");
            myvalues[mycase.value] = myhasLabel ? mycase.label(): mycase.name;
        }
        return myvalues;
    } */

    // Magically set option type and corresponding options
    protected Json[string] _magicOptions(string fieldName, Json[string] options, bool allowOverride) {
        /* options.merge("templateVars", Json.emptyArray);

        options = setRequiredAndCustomValidity(fieldName, options);
        auto mytypesWithOptions = ["text", "number", "radio", "select"];
        auto mymagicOptions = (isIn(options.get("type"), ["radio", "select"], true) || allowOverride);
        if (mymagicOptions && isIn(options.get("type"), mytypesWithOptions, true)) {
            options = _optionsOptions(fieldName, options);
        }
        if (allowOverride && fieldName.endsWith("._ids")) {
            options.set("type", "select");
            if (!options.hasKey("multiple") || options.getString("multiple") != "checkbox") {
                options.set("multiple", true);
            }
        }
        return options; */
        return null;
    }

    /**
     * Set required attribute and custom validity JS.
     * Params:
     * string fieldName The name of the field to generate options for.
     */
    protected Json[string] setRequiredAndCustomValidity(string fieldName, Json[string] options = null) {
        /* mycontext = _getContext();

        if (!options.hasKey("required") && options.getString("type") != "hidden") {
            options.set("required", mycontext.isRequired(fieldName));
        }
        mymessage = mycontext.getRequiredMessage(fieldName);
        mymessage = htmlAttributeEscape(mymessage);

        if (options.hasKey("required") && mymessage) {
            options.set("templateVars.customValidityMessage", mymessage);

            if (configuration.hasKey("autoSetCustomValidity")) {
                options.set("data-validity-message", mymessage);
                options.set("oninvalid",
                    "setCustomValidity(\"\"); " ~
                        "if (!this.value) setCustomValidity(this.dataset.validityMessage)");
                options.set("oninput", "setCustomValidity(\"\")");
            }
        }
        return options; */
        return null;
    }

    // Generate label for input
    protected string _getLabel(string fieldName, Json[string] options = null) {
        /* if (options.getString("type") == "hidden") {
            return null;
        }

        auto mylabel = options.get("label", null);
        if (!mylabel && options.getString("type") == "checkbox") {
            return options.get("input");
        }

        return mylabel
            ? _inputLabel(fieldName, mylabel, options) : null; */
        return null;
    }

    // Extracts a single option from an options array.
    protected Json _extractOption(string optionName, Json[string] optionsToExtract, Json defaultValue = Json(
            null)) {
        /* return hasKey(optionName, optionsToExtract)
            ? optionsToExtract[optionName] : defaultValue; */
        return Json(null);
    }

    /**
     * Generate a label for an input() call.
     *
     * options can contain a hash of id overrides. These overrides will be
     * used instead of the generated values if present.
     */
    protected string _inputLabel(string fieldName, string labelText = null,
        STRINGAA labelAttributes = null, Json[string] options = null) {
        /* options
            .merge("id", Json(null))
            .merge("input", Json(null))
            .merge("nestedInput", false)
            .merge("templateVars", Json.emptyArray);

        STRINGAA labelAttributes = ["templateVars": options.get("templateVars")];
        if (isArray(options)) {
            string labelText = null;
            if (options.hasKey("text")) {
                labelText = options.shift("text").getString;
            }
            labelAttributes = updateKey(labelAttributes, labelAttributes);
        } else {
            labelText = options;
        }
        labelAttributes.set("for", options.get("id"));
        if (isIn(options.get("type"), _groupedInputTypes, true)) {
            labelAttributes.set("for", false);
        }
        if (options.hasKey("nestedInput")) {
            labelAttributes.set("input", options.get("input"));
        }
        if (options.hasKey("escape")) {
            labelAttributes.set("escape", options.getBoolean("escape"));
        }
        return _label(fieldName, labelText, labelAttributes); */
        return null;
    }

    /**
     * Creates a checkbox input widget.
     *
     * ### Options:
     *
     * - `value` - the value of the checkbox
     * - `checked` - boolean indicate that this checkbox is checked.
     * - `hiddenField` - boolean|string. Set to false to disable a hidden input from
     *  being generated. Passing a string will define the hidden input value.
     * - `disabled` - create a disabled input.
     * - `default` - Set the default value for the checkbox. This allows you to start checkboxes
     *  as checked, without having to check the POST data. A matching POST data value, will overwrite
     *  the default value.
     * Params:
     * string fieldName Name of a field, like this "modelname.fieldname"
     */
    string[] checkbox(string fieldName, Json[string] options = null) {
        options
            .merge("hiddenField", true)
            .merge("value", 1);

        // Work around value=>val translations.
        auto myvalue = options.shift("value");
        options = _initInputField(fieldName, options);
        options.set("value", myvalue);

        string outputText = "";
        /* if (options.hasKey("hiddenField") && isScalar(options.get("hiddenField"))) {
            myhiddenOptions = createMap!(string, Json)
                .set("name", options.getString)
                .set("value", options.getString("hiddenField") != "_split"
                        ? options.getString("hiddenField") : "0")
                .set("form", options.get("form", null))
                .set("secure", false);

            if (!options.isNull("disabled")) {
                myhiddenOptions.set("disabled", "disabled");
            }
            outputText = hidden(fieldName, myhiddenOptions);
        } */
        /* if (options.getString("hiddenField") == "_split") {
            options.removeKey("hiddenField", "type");

            return ["hidden": outputText, "input": widget("checkbox", options)];
        } */
        options.removeKeys("hiddenField", "type");

        // return outputText ~ widget("checkbox", options);
        return null;
    }

    /**
     * Creates a set of radio widgets.
     *
     * ### Attributes:
     *
     * - `value` - Indicates the value when this radio button is checked.
     * - `label` - Either `false` to disable label around the widget or an array of attributes for
     *  the label tag. `selected` will be added to any classes e.g. `"class": "myclass"` where widget
     *  is checked
     * - `hiddenField` - boolean|string. Set to false to not include a hidden input with a value of "".
     *  Can also be a string to set the value of the hidden input. This is useful for creating
     *  radio sets that are non-continuous.
     * - `disabled` - Set to `true` or `disabled` to disable all the radio buttons. Use an array of
     * values to disable specific radio buttons.
     * - `empty` - Set to `true` to create an input with the value "" as the first option. When `true`
     * the radio label will be "empty". Set this option to a string to control the label value.
     */
    string radio(string fieldName, Json[string] radioOptions = null, Json[string] attributes = null) {
        /* attributes.set("options", radioOptions);
        attributes.set("idPrefix", _idPrefix);

        auto generatedHiddenId = false;
        if (!attributes.hasKey("id")) {
            attributes.set("id", true);
            generatedHiddenId = true;
        }
        attributes = _initInputField(fieldName, attributes);

        auto hiddenField = attributes.get("hiddenField", true);
        attributes.removeKey("hiddenField");

        auto myhidden = "";
        if (hiddenField == true && isScalar(hiddenField)) {
            myhidden = hidden(fieldName, [
                    "value": hiddenField == true ? "": to!string(hiddenField),
                    "form": attributes["form"].ifNull(null),
                    "name": attributes.getString,
                    "id": attributes["id"],
                ]);
        }
        if (generatedHiddenId) {
            removeKey(attributes["id"]);
        }
        string myradio = widget("radio", attributes);
        return myhidden ~ myradio; */
        return null;
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
     */
    string __call(string methodName, Json[string] params) {
        /* if (isEmpty(params)) {
            throw new UIMException(
                "Missing field name for `FormHelper.%s`.".format(methodName));
        }
        // options = params[1] ? params[1] : [];
        options.set("type", options.get("type", methodName));
        options = _initInputField(params[0], options);

        return _widget(options.get("type"), options); */
        return null;
    }

    /**
     * Creates a textarea widget.
     *
     * ### Options:
     *
     * - `escape` - Whether the contents of the textarea should be escaped. Defaults to true.
     * Params:
     * string fieldName Name of a field, in the form "modelname.fieldname"
     */
    string textarea(string fieldName, Json[string] options = null) {
        /* options = _initInputField(fieldName, options);
        options.removeKey("type");

        return _widget("textarea", options); */
        return null;
    }

    // Creates a hidden input field.
    string hidden(string fieldName, Json[string] htmlAttributes = null) {
        htmlAttributes
            .merge("required", false)
            .merge("secure", true);
        auto mysecure = htmlAttributes.shift("secure");

        /*
        htmlAttributes = _initInputField(fieldName, array_merge(
                htmlAttributes,
                ["secure": SECURE_SKIP]
        ));

        if (mysecure == true && _formProtector) {
            _formProtector.addField(
                options.get("name"),
                true,
                options.hasKey("val") ? "0" : options.getString("val")
            );
        }
        options.set("type", "hidden");

        return _widget("hidden", options); */
        return null;
    }

    /**
     * Creates file input widget.
     * Name of a field in the form "modelname.fieldname"
     */
    string file(string fieldName, Json[string] options = null) {
        options.merge("secure", true);
        /* options = _initInputField(fieldName, options);
        options.removeKey("type");
        return _widget("file", options); */
        return null;
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
     * string title The button"s caption. Not automatically HTML encoded
     */
    string button(string title, Json[string] options = null) {
        options
            .set("type", "submit")
            .set("escapeTitle", true)
            .set("escape", true)
            .set("secure", false)
            .set("confirm", Json(null))
            .set("text", title);

        /*  auto confirmMessage = options.get("confirm");
        options.removeKey("confirm");
        if (confirmMessage) {
            myconfirm = _confirm("return true;", "return false;");
            options.set("data-confirm-message", confirmMessage);
            options.set("onclick", this.templater().format("confirmJs", [
                        "confirmMessage": htmlAttributeEscape(confirmMessage),
                        "confirm": myconfirm,
                    ]));
        }
        return _widget("button", options); */
        return null;
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
     * HTTP/1.1 DELETE (or others) request. Defaults to "post".
     * - `form` - Array with any option that FormHelper.create() can take
     * - Other options is the same of button method.
     * - `confirm` - Confirm message to show. Form execution will only continue if confirmed then.
     */
    string postButton(string caption, string[] myurl, Json[string] options = null) {
        /* auto myformOptions = ["url": myurl];
        if (options.hasKey("method")) {
            myformOptions.set("type", options.shift("method"));
        }
        if (options.hasKey("form") && options.isArray("form")) {
            myformOptions = options.shift("form") + myformOptions;
        }
        result = create(null, myformOptions);
        if (options.hasKey("data") && options.isArray("data")) {
            foreach (aKey, myvalue; Hash.flatten(options.get("data"))) {
                result ~= hidden(aKey, ["value": myvalue]);
            }
            options.removeKey("data");
        }
        result ~= button(caption, options)
            ~ end();

        return result; */
        return null;
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
     * HTTP/1.1 DELETE request. Defaults to "post".
     * - `confirm` - Confirm message to show. Form execution will only continue if confirmed then.
     * - `block` - Set to true to append form to view block "postLink" or provide
     * custom block name.
     * - Other options are the same of HtmlHelper.link() method.
     * - The option `onclick` will be replaced.
     */
    string postLink(string title, string[] myurl = null, Json[string] options = null) {
        // options = options.addKeys(["block", "confirm"]);

        /* string requestMethod = options.hasKey("method")
            ? options.shift("method").getString.upper
            : "POST";

        auto confirmMessage = options.shift("confirm");
 */
        /* auto myformName = uniqid("post_", true).replace(".", "");
        auto myformOptions = createMap!(string, Json)
            .set("name", myformName)
            .set("style", "display:none;")
            .set("method", "post");

        if (options.hasKey("target")) {
            myformOptions.set("target", options.shift("target"));
        } */
        /* auto mytemplater = this.templater();
        auto myrestoreAction = _lastAction;
        lastAction(myurl);
        auto myrestoreFormProtector = _formProtector;

        auto myaction = mytemplater.formatAttributes(
            createMap!(string, Json)
                .set("action", _url.build(myurl))
                .set("escape", false));

        auto result = formatTemplate("formStart", createMap!(string, Json)
                .set("attrs", mytemplater.formatAttributes(myformOptions) ~ myaction));
        result ~= hidden("_method", createMap!(string, Json)
                .set("value", requestMethod)
                .set("secure", SECURE_SKIP));

        auto myformTokenData = _view.getRequest().getAttribute("formTokenData");
        if (myformTokenData !is null) {
            _formProtector = this.createFormProtector(myformTokenData);
        }

        auto fieldNames = null;
        if (options.hasKey("data") && options.isArray("data")) {
            /* Hash.flatten(options.get("data")).each!((kv) {
                fieldNames[kv.key] = kv.value;
                result ~= hidden(kv.key, [
                        "value": kv.value,
                        "secure": SECURE_SKIP
                    ]);
            }); * /
            options.removeKey("data");
        }
        result ~= this.secure(fieldNames);
        // result ~= formatTemplate("formEnd", []);

        _lastAction = myrestoreAction;
        _formProtector = myrestoreFormProtector;

        if (options.hasKey("block")) {
            if (options.isEmpty("block")) {
                options.set("block", __FUNCTION__);
            }
            _view.append(options.get("block"), result);
            result = "";
        }
        options.removeKey("block");

        string myurl = "#";
        string myonClick = "document." ~ myformName ~ ".submit();";
        if (confirmMessage) {
            myonClick = _confirm(myonClick, "");
            myonClick = myonClick ~ "event.returnValue = false; return false;";
            myonClick = this.templater().format("confirmJs", [
                    "confirmMessage": htmlAttributeEscape(confirmMessage),
                    "formName": myformName,
                    "confirm": myonClick,
                ]);
            options.set("data-confirm-message", confirmMessage);
        } else {
            myonClick ~= " event.returnValue = false; return false;";
        }
        options.set("onclick", myonClick);

        result ~= _html.link(title, myurl, options);
        return result; */
        return null;
    }

    /**
     * Creates a submit button element. This method will generate `<input>` elements that
     * can be used to submit, and reset forms by using options. image submits can be created by supplying an
     * image path for caption.
     *
     * ### Options
     *
     * - `type` - Set to "reset" for reset inputs. Defaults to "submit"
     * - `templateVars` - Additional template variables for the input element and its container.
     * - Other attributes will be assigned to the input element.
     * Params:
     * string caption The label appearing on the button OR if string contains :// or the
     * extension .jpg, .jpe, .jpeg, .gif, .png use an image if the extension
     * exists, AND the first character is /, image is relative to webroot,
     * OR if the first character is not /, image is relative to webroot/img.
     */
    string submit(string caption = null, Json[string] options = null) {
        /* caption = caption.ifEmpty(`__d("uim", "Submit")`);
        options
            .merge("type", "submit")
            .merge("secure", false)
            .merge("templateVars", Json.emptyArray); */

        /* if (options.hasKey("name") && _formProtector) {
            _formProtector.addField(options.getString(options.get("secure")));
        } */
        options.removeKey("secure");

        bool isUrl = caption.contains(": //");
        bool isImage = false; // preg_match("/\.(jpg|jpe|jpeg|gif|png|ico)my/", caption);

        string mytype = options.shift("type").getString;

        if (isUrl || isImage) {
            mytype = "image";

            if (_formProtector) {
                auto myunlockFields = ["x", "y"];
                if (options.hasKey("name")) {
                    myunlockFields = [
                        options.getString("name") ~ "_x",
                        options.getString("name") ~ "_y",
                    ];
                }
                myunlockFields.each!(myignore => unlockField(myignore));
            }
        }
        /* if (isUrl) {
            options.set("src", caption);
        } else if (isImage) {
            myUrl = caption[0] != "/"
                ? _url.webroot(configuration.getString(
                        "App.imageBaseUrl") ~ caption) : _url.webroot(trim(caption, "/"));

            myUrl = _url.assetTimestamp(myUrl);
            options.set("src", myUrl);
        } else {
            options.set("value", caption);
        } */

        /* auto myinput = formatTemplate("inputSubmit", createMap!(string, Json)
                .set("type", mytype)
                .set("attrs", this.templater().formatAttributes(options))
                .set("templateVars", options.get("templateVars")));

        return _formatTemplate("submitContainer", createMap!(string, Json)
                .set("content", myinput)
                .set("templateVars", options.get("templateVars"))); */
        return null;
    }

    /**
     * Returns a formatted SELECT element.
     *
     * ### Attributes:
     *
     * - `multiple` - show a multiple select box. If set to "checkbox" multiple checkboxes will be
     * created instead.
     * - `empty` - If true, the empty select option is shown. If a string,
     * that string is displayed as the empty element.
     * - `escape` - If true contents of options will be HTML entity encoded. Defaults to true.
     * - `val` The selected value of the input.
     * - `disabled` - Control the disabled attribute. When creating a select box, set to true to disable the
     * select box. Set to an array to disable specific option elements.
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
     *   "fred": [
     *       2: "fred",
     *       3: "fred jr."
     *   ]
     * ];
     * this.Form.select("Model.field", options);
     * ```
     *
     * If you have multiple options that need to have the same value attribute, you can
     * use an array of arrays to express this:
     *
     * ```
     * options = [
     *   ["text": "United states", "value": "USA"],
     *   ["text": "USA", "value": "USA"],
     * ];
     * ```
     */
    string select(string fieldName, Json[string] options = null, Json[string] attributes = null) {
        attributes
            .merge("disabled", Json(null))
            .merge("escape", true)
            .merge("hiddenField", true)
            .merge("multiple", Json(null))
            .merge("secure", true)
            .merge("empty", Json(null));

        /* if (attributes["empty"].isNull && attributes["multiple"] != "checkbox") {
            myrequired = _getContext().isRequired(fieldName);
            attributes.set("empty", myrequired.isNull ? false : !myrequired);
        }
        if (attributes.getString("multiple") == "checkbox") {
            attributes.removeKey("multiple", "empty");

            return _multiCheckbox(fieldName, options, attributes);
        }
        attributes.removeKey("label"); */

        // Secure the field if there are options, or it"s a multi select.
        // Single selects with no options don"t submit, but multiselects do.
        /* if (
            attributes.hasKey("secure") &&
            options.isEmpty &&
            attributes.isAllEmpty("empty", "multiple")
            ) {
            attributes.set("secure", false);
        }
        attributes = _initInputField(fieldName, attributes);
        attributes.set("options", options);

        myhidden = "";
        if (attributes["multiple"] && attributes["hiddenField"]) {
            myhiddenAttributes
                .merge("name", attributes.getString)
                .merge("value", "")
                .merge("form", attributes.get("form"))
                .merge("secure", false);
            myhidden = hidden(fieldName, myhiddenAttributes);
        }
        attributes.removeKey("hiddenField", "type");

        return myhidden ~ widget("select", attributes); */
        return null;
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
     * You can also set disabled to a list of values you want to disable when creating checkboxes.
     * - `hiddenField` - Set to false to remove the hidden field that ensures a value
     * is always submitted.
     * - `label` - Either `false` to disable label around the widget or an array of attributes for
     * the label tag. `selected` will be added to any classes e.g. `"class": "myclass"` where
     * widget is checked
     *
     * Can be used in place of a select box with the multiple attribute.
     */
    string multiCheckbox(string fieldName, Json[string] options, Json[string] htmlAttributes = null) {
        htmlAttributes
            .merge("disabled", Json(null))
            .merge("escape", true)
            .merge("hiddenField", true)
            .merge("secure", true);

        /* generatedHiddenId = false;
        if (!htmlAttributes.hasKey("id")) {
            htmlAttributes.set("id", true);
            generatedHiddenId = true;
        }
        htmlAttributes = _initInputField(fieldName, htmlAttributes);
        htmlAttributes.set("options", options);
        htmlAttributes.set("idPrefix", _idPrefix); */

        /* auto myhidden = "";
        if (htmlAttributes.hasKey("hiddenField")) {
            myhiddenAttributes
                .merge("name", htmlAttributes.getString("name"))
                .merge("value", "")
                .merge("secure", false)
                .merge("disabled", htmlAttributes.getString("disabled") == "disabled")
                .merge("id", htmlAttributes["id"]);

            myhidden = hidden(fieldName, myhiddenAttributes);
        }
        htmlAttributes.removeKey("hiddenField");

        if (generatedHiddenId) {
            htmlAttributes.removeKey("id");
        }
        return myhidden ~ widget("multicheckbox", htmlAttributes); */
        return null;
    }

    /**
     * Returns a SELECT element for years
     *
     * ### Attributes:
     *
     * - `empty` - If true, the empty select option is shown. If a string,
     * that string is displayed as the empty element.
     * - `order` - DOrdering of year values in select options.
     * Possible values "asc", "desc". Default "desc"
     * - `value` The selected value of the input.
     * - `max` The max year to appear in the select element.
     * - `min` The min year to appear in the select element.
     */
    string year(string fieldName, Json[string] options = null) {
        /* options.merge("empty", true);
        options = _initInputField(fieldName, options);
        options.removeKey("type");

        return _widget("year", options); */
        return null;
    }

    // Generate an input tag with type "month".
    string month(string fieldName, Json[string] options = null) {
        options.merge("value", Json(null));

        /* options = _initInputField(fieldName, options);
        options.set("type", "month");

        return _widget("datetime", options); */
        return null;
    }

    /**
     * Generate an input tag with type "datetime-local".
     *
     * ### Options:
     *
     * - `value` | `default` The default value to be used by the input.
     * If set to `true` current datetime will be used.
     */
    string dateTime(string fieldName, Json[string] options = null) {
        options.merge("value", Json(null));
        /* options = _initInputField(fieldName, options);
        options
            .set("type", "datetime-local")
            .set("fieldName", fieldName);

        return _widget("datetime", options); */
        return null;
    }

    // Generate an input tag with type "time".
    string time(string fieldName, Json[string] options = null) {
        options.merge(["value": Json(null)]);
        /*  auto fieldOptions = _initInputField(fieldName, options);
        fieldOptions.set("type", "time");

        return _widget("datetime", fieldOptions); */
        return null;
    }

    // Generate an input tag with type "date".
    string date(string fieldName, Json[string] options = null) {
        /* options.merge("value", Json(null));
        auto fieldOptions = _initInputField(fieldName, options);
        fieldOptions.set("type", "date");

        return _widget("datetime", fieldOptions); */
        return null;

    }

    /**
     * Sets field defaults and adds field to form security input hash.
     * Will also add the error class if the field contains validation errors.
     *
     * ### Options
     *
     * - `secure` - boolean whether the field should be added to the security fields.
     * Disabling the field using the `disabled` option, will also omit the field from being
     * part of the hashed key.
     * - `default` - Json - The value to use if there is no value in the form"s context.
     * - `disabled` - Json - Either a boolean indicating disabled state, or the string in
     * a numerically indexed value.
     * - `id` - Json - If `true` it will be auto generated based on field name.
     *
     * This method will convert a numerically indexed "disabled" into an associative
     * array value. FormHelper"s internals expect associative options.
     *
     * The output of this bool is a more complete set of input attributes that
     * can be passed to a form widget to generate the actual input.
     */
    protected Json[string] _initInputField(string fieldName, Json[string] options = null) {
        options
            .merge("fieldName", fieldName) /* .merge("secure", _view.getRequest().getAttribute("formTokenData").isNull ? false : true) */
            ;

        /* auto mycontext = _getContext();

        options.update("id", _domId(fieldName));
        if (!options.hasKey("name")) {
            myendsWithBrackets = "";
            if (fieldName.endsWith("[]")) {
                fieldName = subString(fieldName, 0, -2);
                myendsWithBrackets = "[]";
            }
            string[] pathParts = fieldName.split(".");
            myfirst = pathParts.shift();
            options.set("name", myfirst ~ (!pathParts.isEmpty ? "[" ~ pathParts.join(".") ~ "]" : "") ~ myendsWithBrackets);
        }
        if (options.hasKey("value") && !options.hasKey("val")) {
            options.set("val", options.shift("value"));
        }
        if (!options.hasKey("val")) {
            myvalOptions = createMap!(string, Json)
                .set("default", options.get("default"))
                .set("schemaDefault", options.get("schemaDefault", true));

            options.set("val", getSourceValue(fieldName, myvalOptions));
        }
        options.merge("val", options.shift("default"));
        options.removeKey("value");

        if (cast(BackedEnum) options.get("val")) {
            options.set("val", options.get("val").value);
        }
        if (mycontext.hasError(fieldName)) {
            options = addClass(options, configuration.get("errorClass"));
        }

        bool isDisabled = _isDisabled(options);
        if (isDisabled) {
            options.set("secure", SECURE_SKIP);
        }
        return options; */
        return null;
    }

    // Determine if a field is disabled.
    protected bool _isDisabled(Json[string] options = null) {
        /*         if (!options.hasKey("disabled")) {
            return false;
        }
        if (options.get("disabled").isScalar) {
            return options.getString("disabled") == "disabled";
        }
        if (!options.hasKey("options")) {
            return false;
        }
 */
        if (options.isArray("options")) {
            // Simple list options
            /* auto myfirst = options.get([
                "options", options.get("options").keys[0]
            ]);
            if (myfirst.isScalar) {
                return options.get("options").diff(options.get("disabled")) == null;
            } */
            // Complex option types
            // if (myfirst.isArray) {
            /* mydisabled = filterValues(
                    options.get("options"),
                    fn (index): isIn(index["value"], options.get("disabled"), true)
               ); */

            // return count(mydisabled) > 0;
            // }
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
     */
    void addContextProvider(string contextType /* , callable mycheck */ ) {
        // this.contextFactory().addProvider(contextType, null  /* mycheck */ );
    }

    /**
     * Get the context instance for the current form set.
     *
     * If there is no active form null will be returned.
     * Params:
     * \UIM\View\Form\IContext|null formContext Either the new context when setting, or null to get.
     */
    IContext context(IContext formContext = null) {
        if (cast(IContext) formContext) {
            _context = formContext;
        }
        return _getContext();
    }

    /**
     * Find the matching context provider for the data.
     *
     * If no type can be matched a NullContext will be returned.
     */
    protected IContext _getContext(Json mydata = null) {
        /* if (_context !is null && mydata.isEmpty) {
            return _context;
        }
        mydata.merge("entity", Json(null)); */

        /* return _context = this.contextFactory()
            .get(_view.getRequest(), mydata); */
        return null;
    }

    /**
     * Add a new widget to FormHelper.
     * Allows you to add or replace widget instances with custom code.
     */
    void addWidget(string name, /* IWidget| */ string[] myspec) {
        // _locator.add([name: myspec]);
    }

    /**
     * Render a named widget.
     *
     * This is a lower level method. For built-in widgets, you should be using
     * methods like `text`, `hidden`, and `radio`. If you are using additional
     * widgets you should use this method render the widget without the label
     * or wrapping div.
     */
    string widget(string name, Json[string] options = null) {
        Json mysecure = null;
        if (options.hasKey("secure")) {
            mysecure = options.shift("secure");
        }

        auto namedWidget = _locator.get(name);
        string result = namedWidget.render(options, context());
        /* if (
            !_formProtector.isMull &&
            options.hasKey("name") &&
            !mysecure.isNull &&
            mysecure != SECURE_SKIP
            ) {
            namedWidget.secureFields(options)
                .each!(fieldName => _formProtector.addField(fieldName, mysecure));
        } */
        return result;
    }

    /**
     * Restores the default values built into FormHelper.
     *
     * This method will not reset any templates set in custom widgets.
     */
    void resetTemplates() {
        // setTemplates(_defaultconfiguration.get("templates"));
    }

    // Event listeners.
    override IEvent[] implementedEvents() {
        return null;
    }

    /**
     * Gets the value sources.
     * Returns a list, but at least one item, of valid sources, such as: `"context"`, `"data"` and `"query"`.
     */
    string[] getValueSources() {
        return _valueSources;
    }

    // Validate value sources.
    protected void validateValueSources(Json[string] sourceIds) {
        /* auto mydiff = array_diff(mysources, _supportedValueSources);

        if (mydiff) {
            mydiff.each!(&myx => myx = "`myx`");
            _supportedValueSources.each!(&myx => myx = "`myx`");
            throw new DInvalidArgumentException(
                "Invalid value source(s): %s. Valid values are: %s."
                    .format(mydiff.join(", "), _supportedValueSources.join(", "))
            );
        } */
    }

    /**
     * Sets the value sources.
     *
     * You need to supply one or more valid sources, as a list of strings.
     * DOrder sets priority.
     */
    // void setValueSources(string mysources) {
    void setValueSources(string[] mysources) {
        /* mysources = (array)mysources; */

        /*         this.validateValueSources(mysources);
        _valueSources = mysources;
 */
    }

    // Gets a single field value from the sources available.
    Json getSourceValue(string fieldName, Json[string] options = null) {
        auto myvalueMap = createMap!(string, Json)
            .set("data", "getData")
            .set("query", "getQuery");

        foreach (myvaluesSource; getValueSources()) {
            if (myvaluesSource == "context") {
                auto contextValue = _getContext().val(fieldName, options);
                if (!contextValue.isNull) {
                    return contextValue;
                }
            }
            if (myvalueMap.hasKey(myvaluesSource)) {
                auto methodName = myvalueMap[myvaluesSource];
                /* myvalue = _view.getRequest().{methodName}(fieldName);
                if (myvalue !is null) {
                    return myvalue;
                } */
            }
        }
        return Json(null);
    }
}

IForm getForm(string classname) {
    return null;
}
