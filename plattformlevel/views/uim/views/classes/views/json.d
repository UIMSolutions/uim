/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.views.classes.views.json;

import uim.views;
@safe:

version (test_uim_views) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}


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

        /**
     * Default config options.
     *
     * Use ViewBuilder.setOption()/setOptions() in your controller to set these options.
     *
     * - `serialize`: Option to convert a set of view variables into a serialized response.
     * Its value can be a string for single variable name or array for multiple
     * names. If true all view variables will be serialized. If null or false
     * normal view template will be rendered.
     * - `JsonOptions`: Options for Json_encode(). For e.g. `Json_HEX_TAG | Json_HEX_APOS`.
     * - `Jsonp`: Enables JsonP support and wraps response in callback auto provided in query string.
     * - Setting it to true enables the default query string parameter "callback".
     * - Setting it to a string value, uses the provided query string parameter
     *   for finding the JsonP callback name.
     *
     */
        configuration
            .setDefault("serialize", Json(null))
            .setDefault("JsonOptions", Json(null))
            .setDefault("Jsonp", Json(null));

        return true;
    }

    // Json layouts are located in the Json subdirectory of `Layouts/`
    protected string _layoutPath = "Json";

    // Json views are located in the "Json" subdirectory for controllers" views.
    protected string _subDir = "Json";

    // Mime-type this view class renders as.
    static string contentType() {
        return "application/Json";
    }

    // Render a Json view.
    /* override string render(string templateText = null, string /* false | null  *  layoutName = null) {
        auto result = super.render(templateText, layoutName);
        if (string myJsonp = configuration.getString("Jsonp")) {
            // TODO ?? 
            /* if (myJsonp == true) {
                myJsonp = "callback";
            } */

            /* if (_request.getQuery(myJsonp)) {
                result = "%s(%s)".format(h(_request.getQuery(myJsonp)), result);
                _response = _response.withType("js");
            } * 
        }
        return result;
    } */

    /* override protected string _serialize(string[] myserialize) {
        /* auto mydata = _dataToSerialize(myserialize);
        auto dataOptions = configuration.get("JsonOptions",
            Json_HEX_TAG | Json_HEX_APOS | Json_HEX_AMP | Json_HEX_QUOT | Json_PARTIAL_OUTPUT_ON_ERROR);
        if (dataOptions == false) {
            dataOptions = 0;
        }
        dataOptions |= Json_THROW_ON_ERROR;
        if (configuration.hasKey("debug")) {
            dataOptions |= Json_PRETTY_PRINT;
        }
        return to!string(Json_encode(mydata, dataOptions)); * /
        return null; 
    } */

    // Returns data to be serialized.
    protected Json _dataToSerialize(string[] serializeVariables) {
        /* if (serializeVariables.isArray) {
            auto mydata = null;
            serializeVariables.byKeyValue.each!((aliasKey) {
                if (isNumeric(aliasKey.key)) {
                    aliasKey.key = aliasKey.value;
                }
                if (hasKey(aliasKey.value, this.viewVars)) {
                    mydata[aliasKey.key] = this
                        .viewVars[aliasKey.value];
                }
            });
            return !mydata.isEmpty ? mydata : null;
        } */
        /*  return viewVars.get(serializeVariables, null); */
        return Json(null);
    }
}
