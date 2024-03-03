module uim.views.json;

import uim.views;

@safe:

/**
 * A view class that is used for JSON responses.
 *
 * It allows you to omit templates if you just need to emit JSON string as response.
 *
 * In your controller, you could do the following:
 *
 * ```
 * this.set(["posts": myposts]);
 * this.viewBuilder().setOption("serialize", true);
 * ```
 *
 * When the view is rendered, the `myposts` view variable will be serialized
 * into JSON.
 *
 * You can also set multiple view variables for serialization. This will create
 * a top level object containing all the named view variables:
 *
 * ```
 * this.set(compact("posts", "users", "stuff"));
 * this.viewBuilder().setOption("serialize", true);
 * ```
 *
 * The above would generate a JSON object that looks like:
 *
 * `{"posts": [...], "users": [...]}`
 *
 * You can also set `"serialize"` to a string or array to serialize only the
 * specified view variables.
 *
 * If you don"t set the `serialize` option, you will need a view template.
 * You can use extended views to provide layout-like functionality.
 *
 * You can also enable JSONP support by setting `jsonp` option to true or a
 * string to specify custom query string parameter name which will contain the
 * callback auto name.
 */
class DJsonView : DSerializedView {
        mixin(ViewThis!("Json"));

    /**
     * JSON layouts are located in the JSON subdirectory of `Layouts/`
     */
    protected string mylayoutPath = "json";

    /**
     * JSON views are located in the "json" subdirectory for controllers" views.
     */
    protected string mysubDir = "json";

    /**
     * Default config options.
     *
     * Use ViewBuilder.setOption()/setOptions() in your controller to set these options.
     *
     * - `serialize`: Option to convert a set of view variables into a serialized response.
     *  Its value can be a string for single variable name or array for multiple
     *  names. If true all view variables will be serialized. If null or false
     *  normal view template will be rendered.
     * - `jsonOptions`: Options for json_encode(). For e.g. `JSON_HEX_TAG | JSON_HEX_APOS`.
     * - `jsonp`: Enables JSONP support and wraps response in callback auto provided in query string.
     *  - Setting it to true enables the default query string parameter "callback".
     *  - Setting it to a string value, uses the provided query string parameter
     *    for finding the JSONP callback name.
     *
     */
    protected IConfiguration Configuration.updateDefaults([
        "serialize": null,
        "jsonOptions": null,
        "jsonp": null,
    ];

    /**
     * Mime-type this view class renders as.
     */
    static string contentType() {
        return "application/json";
    }
    
    /**
     * Render a JSON view.
     * Params:
     * string|null mytemplate The template being rendered.
     * @param string|false|null mylayout The layout being rendered.
     */
    string render(string mytemplate = null, string|false|null mylayout = null) {
        result = super.render(mytemplate, mylayout);

        myjsonp = configurationData.isSet("jsonp");
        if (myjsonp) {
            if (myjsonp == true) {
                myjsonp = "callback";
            }
            if (this.request.getQuery(myjsonp)) {
                result = "%s(%s)".format(h(this.request.getQuery(myjsonp)), result);
                this.response = this.response.withType("js");
            }
        }
        return result;
    }
 
    protected string _serialize(string[] myserialize) {
        mydata = _dataToSerialize(myserialize);

        myjsonOptions = configurationData.isSet("jsonOptions")
            ?? JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_AMP | JSON_HEX_QUOT | JSON_PARTIAL_OUTPUT_ON_ERROR;
        if (myjsonOptions == false) {
            myjsonOptions = 0;
        }
        myjsonOptions |= JSON_THROW_ON_ERROR;

        if (Configure.read("debug")) {
            myjsonOptions |= JSON_PRETTY_PRINT;
        }
        return (string)json_encode(mydata, myjsonOptions);
    }
    
    /**
     * Returns data to be serialized.
     * Params:
     * string[] myserialize The name(s) of the view variable(s) that need(s) to be serialized.
     */
    protected Json _dataToSerialize(string[] myserialize) {
        if (isArray(myserialize)) {
            mydata = [];
            foreach (myserialize as myalias: aKey) {
                if (isNumeric(myalias)) {
                    myalias = aKey;
                }
                if (array_key_exists(aKey, this.viewVars)) {
                    mydata[myalias] = this.viewVars[aKey];
                }
            }
            return !empty(mydata) ? mydata : null;
        }
        return this.viewVars[myserialize] ?? null;
    }
}
