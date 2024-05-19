module uim.views.classes.views.json;

import uim.views;

@safe:

/**
 * A view class that is used for Json responses.
 *
 * It allows you to omit templates if you just need to emit Json string as response.
 *
 * In your controller, you could do the following:
 *
 * ```
 * set(["posts": myposts]);
 * viewBuilder().setOption("serialize", true);
 * ```
 *
 * When the view is rendered, the `myposts` view variable will be serialized
 * into Json.
 *
 * You can also set multiple view variables for serialization. This will create
 * a top level object containing all the named view variables:
 *
 * ```
 * set(compact("posts", "users", "stuff"));
 * viewBuilder().setOption("serialize", true);
 * ```
 *
 * The above would generate a Json object that looks like:
 *
 * `{"posts": [...], "users": [...]}`
 *
 * You can also set `"serialize"` to a string or array to serialize only the
 * specified view variables.
 *
 * If you don"t set the `serialize` option, you will need a view template.
 * You can use extended views to provide layout-like functionality.
 *
 * You can also enable JsonP support by setting `Jsonp` option to true or a
 * string to specify custom query string parameter name which will contain the
 * callback auto name.
 */
class DJsonView : DSerializedView {
    mixin(ViewThis!("Json"));

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }

    // Json layouts are located in the Json subdirectory of `Layouts/`
    protected string _layoutPath = "Json";

    // Json views are located in the "Json" subdirectory for controllers" views.
    protected string _subDir = "Json";

    /**
     * Default config options.
     *
     * Use ViewBuilder.setOption()/setOptions() in your controller to set these options.
     *
     * - `serialize`: Option to convert a set of view variables into a serialized response.
     *  Its value can be a string for single variable name or array for multiple
     *  names. If true all view variables will be serialized. If null or false
     *  normal view template will be rendered.
     * - `JsonOptions`: Options for Json_encode(). For e.g. `Json_HEX_TAG | Json_HEX_APOS`.
     * - `Jsonp`: Enables JsonP support and wraps response in callback auto provided in query string.
     *  - Setting it to true enables the default query string parameter "callback".
     *  - Setting it to a string value, uses the provided query string parameter
     *    for finding the JsonP callback name.
     *
     */
    configuration.updateDefaults([
            "serialize": Json(null),
            "JsonOptions": Json(null),
            "Jsonp": Json(null),
        ]; 
        
        /**
     * Mime-type this view class renders as.
     */
    static string contentType() {
        return "application/Json";
    }
    
    /**
     * Render a Json view.
     * Params:
     * string|null mytemplate The template being rendered.
     * @param string|false|null mylayout The layout being rendered.
     */
    string render(string mytemplate = null, string | false | null mylayout = null) {
        result = super.render(mytemplate, mylayout); myJsonp = configurationData.isSet("Jsonp");
            if (myJsonp) {
                if (myJsonp == true) {
                    myJsonp = "callback";}

                    if (this.request.getQuery(myJsonp)) {
                        result = "%s(%s)".format(h(this.request.getQuery(myJsonp)), result);
                            this.response = this.response.withType("js");}
                    }
                    return result;}

                    protected string _serialize(string[] myserialize) {
                        mydata = _dataToSerialize(myserialize); 
                        dataOptions = configurationData.ifNull("JsonOptions", 
                            Json_HEX_TAG | Json_HEX_APOS | Json_HEX_AMP | Json_HEX_QUOT | Json_PARTIAL_OUTPUT_ON_ERROR);
                        if (dataOptions == false) {
                            dataOptions = 0;}
                            dataOptions |= Json_THROW_ON_ERROR; if (configuration.get("debug")) {
                                dataOptions |= Json_PRETTY_PRINT;}
                                return to!string(Json_encode(mydata, dataOptions));
                            }

                            /**
     * Returns data to be serialized.
     * Params:
     * string[] myserialize The name(s) of the view variable(s) that need(s) to be serialized.
     */
    protected Json _dataToSerialize(string[] myserialize) {
        if (myserialize.isArray) {
            mydata = null; 
            foreach (aliasName : aKey, 
            myserialize.byKeyValue.each!((aliasKey) {
                if (isNumeric(aliasKey.key)) {
                    aliasKey.key = aliasKey.value;}
                    if (array_key_exists(aliasKey.value, this.viewVars)) {
                        mydata[aliasKey.key] = this.viewVars[aliasKey.value];
                    }
                }
            return !mydata.isEmpty ? mydata : null;
            }
        return viewVars.get(myserialize, null);
    }
}
