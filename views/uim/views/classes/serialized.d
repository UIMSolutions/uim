module uim.views.serialized;

import uim.views;

@safe:

/*

use TypeError; */
// Parent class for view classes generating serialized outputs like JsonView and XmlView.
abstract class SerializedView : View {
    /**
     * Default config options.
     *
     * Use ViewBuilder.setOption()/setOptions() in your controlle to set these options.
     *
     * - `serialize`: Option to convert a set of view variables into a serialized response.
     *  Its value can be a string for single variable name or array for multiple
     *  names. If true all view variables will be serialized. If null or false
     *  normal view template will be rendered.
     */
    protected IConfiguration _defaultConfiguration = [
        "serialize": null,
    ];

    // Load helpers only if serialization is disabled.
    void loadHelpers() {
        if (!configurationData.isSet("serialize")) {
            super.loadHelpers();
        }
    }
    
    /**
     * Serialize view vars.
     * Params:
     * string[] myserialize The name(s) of the view variable(s) that
     *  need(s) to be serialized
     */
    protected string _serialize(string[] serializeViews...) {
        return _serialize(serializeViews.dup);
    }

    abstract protected string _serialize(string[] serializeView);

    /**
     * Render view template or return serialized data.
     * Params:
     * string|null mytemplate The template being rendered.
     * @param string|false|null mylayout The layout being rendered.
     */
    string render(string mytemplate = null, string|false|null renderLayout = null) {
        bool shouldSerialize = configurationData.isSet("serialize", false);

        if (shouldSerialize == true) {
            options = array_map(
                auto (myv) {
                    return "_" ~ myv;
                },
                _defaultConfigData.keys
            );

            shouldSerialize = array_diff(
                this.viewVars.keys,
                options
            );
        }

        if (shouldSerialize != false) {
            try {
                return _serialize(shouldSerialize);
            } catch (Exception | TypeError mye) {
                throw new SerializationFailureException(
                    "Serialization of View data failed.",
                    null,
                    mye
                );
            }
        }

        return super.render(mytemplate, false);
    }
}
