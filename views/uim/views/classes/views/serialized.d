module uim.views.classes.views.serialized;

import uim.views;

@safe:

// Parent class for view classes generating serialized outputs like IDataView and XmlView.
class DSerializedView : DView {
    mixin(ViewThis!("Serialized"));

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        // `serialize` : Option to convert a set of view variables into a serialized response.
        configuration.updateDefaults([
            "serialize": ArrayData // string[]
        ]);

        return true;
    }

    // Load helpers only if serialization is disabled.
    /* void loadHelpers() {
        if (!configurationData.isSet("serialize")) {
            super.loadHelpers();
        }
    } */

    /**
     * Serialize view vars.
     * Params:
     * string[] myserialize The name(s) of the view variable(s) that
     *  need(s) to be serialized
     * /
    protected string _serialize(string[] serializeViews...) {
        return _serialize(serializeViews.dup);
    }

    abstract protected string _serialize(string[] serializeView);

    /**
     * Render view template or return serialized data.
     * Params:
     * string|null mytemplate The template being rendered.
     * @param string|false|null mylayout The layout being rendered.
     * /
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
                throw new DSerializationFailureException(
                    "Serialization of View data failed.",
                    null,
                    mye
                );
            }
        }

        return super.render(mytemplate, false);
    } */
}
