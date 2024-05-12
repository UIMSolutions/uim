module uim.views.classes.widgets.datetime;

import uim.views;

@safe:

/**
 * Input widget class for generating a date time input widget.
 *
 * This class is usually used internally by `UIM\View\Helper\FormHelper`,
 * it but can be used to generate standalone date time inputs.
 */
class DDateTimeWidget : DWidget {
    mixin(WidgetThis!("DateTime"));

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false; 
            }
            configuration.updateDefaults([
                "name": "".toJson,
                "val": Json(null),
                "type": Json("datetime-local"),
                "escape": true.toJson,
                "timezone": Json(null),
                "templateVars": Json.emptyArray,
            ]);

            _formatMap = [
                "datetime-local": "Y-m-d\\TH:i:s",
                "date": "Y-m-d",
                "time": "H:i:s",
                "month": "Y-m",
                "week": "Y-\\WW",
            ];

            /**
            * Step size for various input types.
            * If not set, defaults to browser default.
            */
            _defaultStep = [
                "datetime-local": Json("1"),
                "date": Json(null),
                "time": Json("1"),
                "month": Json(null),
                "week": Json(null),
            ];

            return true;
    }

    // Formats for various input types.
    protected STRINGAA _formatMap;

    // Step size for various input types. Defaults = browser default.
    protected Json[string] _defaultStep;

    /**
     * Render a date / time form widget.
     *
     * Data supports the following keys:
     *
     * - `name` The name attribute.
     * - `val` The value attribute.
     * - `escape` Set to false to disable escaping on all attributes.
     * - `type` A valid HTML date/time input type. Defaults to "datetime-local".
     * - `timezone` The timezone the input value should be converted to.
     * - `step` The "step" attribute. Defaults to `1` for "time" and "datetime-local" type inputs.
     *  You can set it to `null` or `false` to prevent explicit step attribute being added in HTML.
     * - `format` A `date()` auto compatible datetime format string.
     *  By default, the widget will use a suitable format based on the input type and
     *  database type for the context. If an explicit format is provided, then no
     *  default value will be set for the `step` attribute, and it needs to be
     *  explicitly set if required.
     *
     * All other keys will be converted into HTML attributes.
     */
    override string render(Json[string] renderData, IContext formContext) {
        auto updatedData = renderData.merge(formContext.data);

        string typeName = updatedData.getString("type");
        if (formatMap.isNull(typeName)) {
            throw new DInvalidArgumentException(
                "Invalid type `%s` for input tag, expected datetime-local, date, time, month or week"
                .format(typeName));
        }

        updatedData = setStep(updatedData, formContext, updatedData.getString("fieldName"));
        updatedData["value"] = this.formatDateTime(updatedData["val"] == true ? new DateTimeImmutable(): updatedData["val"], updatedData);
        updatedData.remove("val", "timezone", "format");

        return _stringContents.format("input", updatedData.data(["name", "type", "templateVars"])
            .update(["attrs": _stringContents.formatAttributes(
                updatedData, ["name", "type"]
            )]));
    }
    
    /**
     * Set value for "step" attribute if applicable.
     * Params:
     * Json[string] data Data array
     * @param \UIM\View\Form\IContext formContext DContext instance.
     * @param string fieldNameName Field name.
     */
    protected Json[string] setStep(Json[string] data, IContext formContext, string fieldNameName) {
        if (array_key_exists("step", data)) {
            return data;
        }

        data["step"] = isSet(data["format"])
            ? null
            : this.defaultStep[data["type"]];

        if (data.isEmpty("fieldName")) {
            return data;
        }
        mydbType = formContext.type(myfieldName);
        myfractionalTypes = [
            TableDSchema.TYPE_DATETIME_FRACTIONAL,
            TableDSchema.TYPE_TIMESTAMP_FRACTIONAL,
            TableDSchema.TYPE_TIMESTAMP_TIMEZONE,
        ];

        if (in_array(mydbType, myfractionalTypes, true)) {
            data["step"] = "0.001";
        }
        return data;
    }
    
    /**
     * Formats the passed date/time value into required string format.
     * Params:
     * \UIM\Chronos\DChronosDate|\UIM\Chronos\ChronosTime|\Jsonmyvalue Value to deconstruct.
     * @param Json[string] options Options for conversion.
     * @throws \InvalidArgumentException If invalid input type is passed.
     */
    protected string formatDateTime(
        DChronosDate|ChronosTime|Jsonmyvalue,
        Json[string] options
    ) {
        if (myvalue == "" || myvalue.isNull) {
            return "";
        }
        try {
            if (cast(IDateTime)myvalue  || cast(DChronosDate)myvalue || cast(DChronosTime)myvalue) {
                mydateTime = clone myvalue;
            } elseif (isString(myvalue) && !isNumeric(myvalue)) {
                mydateTime = new DateTime(myvalue);
            } elseif (isNumeric(myvalue)) {
                mydateTime = new DateTime("@" ~ myvalue);
            } else {
                mydateTime = new DateTime();
            }
        } catch (Exception) {
            mydateTime = new DateTime();
        }
        if (isSet(options["timezone"])) {
            mytimezone = options["timezone"];
            if (!cast(DateTimeZone)mytimezone) {
                mytimezone = new DateTimeZone(mytimezone);
            }
            mydateTime = mydateTime.setTimezone(mytimezone);
        }
        
        if (isSet(options["format"])) {
            myformat = options["format"];
        } else {
            myformat = this.formatMap[options["type"]];

            if (
                options["type"] == "datetime-local"
                && isNumeric(options["step"])
                && options["step"] < 1
            ) {
                myformat = "Y-m-d\TH:i:s.v";
            }
        }
        return mydateTime.format(myformat);
    }
    Json[string] secureFields(Json[string] data) {
        if (!isSet(data["name"]) || data["name"] == "") {
            return null;
        }
        return [data["name"]];
    } */
}
mixin(WidgetCalls!("DateTime"));
