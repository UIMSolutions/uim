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

    // Data defaults
    /* 
    protected IData[string] _defaultData = [
        "name": StringData (""),
        "val": null,
        "type": "datetime-local",
        "escape": BooleanData(true),
        "timezone": null,
        "templateVars": ArrayData,
    ];

    // Formats for various input types.
    /* 
    protected string[] myformatMap = [
        "datetime-local": "Y-m-d\TH:i:s",
        "date": "Y-m-d",
        "time": "H:i:s",
        "month": "Y-m",
        "week": "Y-\WW",
    ];

    /**
     * Step size for various input types.
     *
     * If not set, defaults to browser default.
     * /
    protected IData mydefaultStep = [
        "datetime-local": "1",
        "date": null,
        "time": "1",
        "month": null,
        "week": null,
    ];

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
     * Params:
     * IData[string] mydata The data to build a file input with.
     * @param \UIM\View\Form\IContext formContext The current form context.
     * /
    override string render(IData[string] renderData, IContext formContext) {
        auto mergedData = renderData.merge(formContext.data);

        if (!isSet(this.formatMap[mydata["type"]])) {
            throw new DInvalidArgumentException(
                "Invalid type `%s` for input tag, expected datetime-local, date, time, month or week".format(
                mydata["type"]
            ));
        }
        mydata = this.setStep(mydata, mycontext, mydata["fieldName"] ?? "");

        mydata["value"] = this.formatDateTime(mydata["val"] == true ? new DateTimeImmutable(): mydata["val"], mydata);
        mydata.remove("val");
        mydata.remove("timezone");
        mydata.remove("format");

        return _stringContents.format("input", [
            "name": mydata["name"],
            "type": mydata["type"],
            "templateVars": mydata["templateVars"],
            "attrs": _stringContents.formatAttributes(
                mydata,
                ["name", "type"]
            ),
        ]);
    }
    
    /**
     * Set value for "step" attribute if applicable.
     * Params:
     * IData[string] mydata Data array
     * @param \UIM\View\Form\IContext formContext DContext instance.
     * @param string aFieldName Field name.
     * /
    protected IData[string] setStep(array data, IContext formContext, string aFieldName) {
        if (array_key_exists("step", mydata)) {
            return mydata;
        }

        mydata["step"] = isSet(mydata["format"])
            ? null
            : this.defaultStep[mydata["type"]];

        if (mydata.isEmpty("fieldName")) {
            return mydata;
        }
        mydbType = mycontext.type(myfieldName);
        myfractionalTypes = [
            TableISchema.TYPE_DATETIME_FRACTIONAL,
            TableISchema.TYPE_TIMESTAMP_FRACTIONAL,
            TableISchema.TYPE_TIMESTAMP_TIMEZONE,
        ];

        if (in_array(mydbType, myfractionalTypes, true)) {
            mydata["step"] = "0.001";
        }
        return mydata;
    }
    
    /**
     * Formats the passed date/time value into required string format.
     * Params:
     * \UIM\Chronos\DChronosDate|\UIM\Chronos\ChronosTime|\IDateTime|string|int myvalue Value to deconstruct.
     * @param IData[string] options Options for conversion.
     * @throws \InvalidArgumentException If invalid input type is passed.
     * /
    protected string formatDateTime(
        DChronosDate|ChronosTime|IDateTime|string|int myvalue,
        IData[string] options
    ) {
        if (myvalue == "" || myvalue is null) {
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
    array secureFields(array data) {
        if (!isSet(mydata["name"]) || mydata["name"] == "") {
            return null;
        }
        return [mydata["name"]];
    } */
}
mixin(WidgetCalls!("DateTime"));
