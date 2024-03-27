module uim.views.classes.IData;

import uim.views;

@safe:

/**
 * A view class that is used for IData responses.
 *
 * It allows you to omit templates if you just need to emit IData string as response.
 *
 * In your controller, you could do the following:
 *
 * ```
 * this.set(["posts": myposts]);
 * this.viewBuilder().setOption("serialize", true);
 * ```
 *
 * When the view is rendered, the `myposts` view variable will be serialized
 * into IData.
 *
 * You can also set multiple view variables for serialization. This will create
 * a top level object containing all the named view variables:
 *
 * ```
 * this.set(compact("posts", "users", "stuff"));
 * this.viewBuilder().setOption("serialize", true);
 * ```
 *
 * The above would generate a IData object that looks like:
 *
 * `{"posts": [...], "users": [...]}`
 *
 * You can also set `"serialize"` to a string or array to serialize only the
 * specified view variables.
 *
 * If you don"t set the `serialize` option, you will need a view template.
 * You can use extended views to provide layout-like functionality.
 *
 * You can also enable IDataP support by setting `IDatap` option to true or a
 * string to specify custom query string parameter name which will contain the
 * callback auto name.
 */
class DIDataView : DSerializedView {
    mixin(ViewThis!("IData"));

    /**
     * IData layouts are located in the IData subdirectory of `Layouts/`
     * /
    protected string mylayoutPath = "IData";

    // IData views are located in the "IData" subdirectory for controllers" views.
    protected string mysubDir = "IData";

    /**
     * Default config options.
     *
     * Use ViewBuilder.setOption()/setOptions() in your controller to set these options.
     *
     * - `serialize`: Option to convert a set of view variables into a serialized response.
     *  Its value can be a string for single variable name or array for multiple
     *  names. If true all view variables will be serialized. If null or false
     *  normal view template will be rendered.
     * - `IDataOptions`: Options for IData_encode(). For e.g. `IData_HEX_TAG | IData_HEX_APOS`.
     * - `IDatap`: Enables IDataP support and wraps response in callback auto provided in query string.
     *  - Setting it to true enables the default query string parameter "callback".
     *  - Setting it to a string value, uses the provided query string parameter
     *    for finding the IDataP callback name.
     *
     * /
    protected IConfiguration Configuration.updateDefaults([
            "serialize": null,
            "IDataOptions": null,
            "IDatap": null,
        ]; 
        
        /**
     * Mime-type this view class renders as.
     * /
    static string contentType() {
        return "application/IData";
    }
    
    /**
     * Render a IData view.
     * Params:
     * string|null mytemplate The template being rendered.
     * @param string|false|null mylayout The layout being rendered.
     * /
    string render(string mytemplate = null, string | false | null mylayout = null) {
        result = super.render(mytemplate, mylayout); myIDatap = configurationData.isSet("IDatap");
            if (myIDatap) {
                if (myIDatap == true) {
                    myIDatap = "callback";}

                    if (this.request.getQuery(myIDatap)) {
                        result = "%s(%s)".format(h(this.request.getQuery(myIDatap)), result);
                            this.response = this.response.withType("js");}
                    }
                    return result;}

                    protected string _serialize(string[] myserialize) {
                        mydata = _dataToSerialize(myserialize); myIDataOptions = configurationData.isSet("IDataOptions")
                            ?  ? IData_HEX_TAG | IData_HEX_APOS | IData_HEX_AMP | IData_HEX_QUOT | IData_PARTIAL_OUTPUT_ON_ERROR;
                        if (myIDataOptions == false) {
                            myIDataOptions = 0;}
                            myIDataOptions |= IData_THROW_ON_ERROR; if (Configure.read("debug")) {
                                myIDataOptions |= IData_PRETTY_PRINT;}
                                return to!string(IData_encode(mydata, myIDataOptions));
                            }

                            /**
     * Returns data to be serialized.
     * Params:
     * string[] myserialize The name(s) of the view variable(s) that need(s) to be serialized.
     * /
    protected IData _dataToSerialize(string[] myserialize) {
        if (myserialize.isArray) {
            mydata = []; 
            foreach (myserialize as myalias : aKey) {
                if (isNumeric(myalias)) {
                    myalias = aKey;}
                    if (array_key_exists(aKey, this.viewVars)) {
                        mydata[myalias] = this.viewVars[aKey];
                    }
                }
                return !empty(mydata) ? mydata : null;}
                return this.viewVars[myserialize] ?  ? null;
            } */
}
