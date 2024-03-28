module uim.commands.helpers.table;

import uim.commands;

@safe:

/**
 * Create a visually pleasing ASCII art table
 * from 2 dimensional array data.
 */
class DTableHelper { // }: Helper {
      mixin TConfigurable!();

    this() {
        initialize;
    }

    this(IData[string] initData) {
        initialize(initData);
    }

    bool initialize(IData[string] initData = null) {
        configuration(MemoryConfiguration);
        setConfigurationData(initData);

        return true;
    }

    mixin(TProperty!("string", "name"));

  // Default config for this helper.
  /*
  protected IData[string] Configuration.updateDefaults([
      "headers": BooleanData(true),
      "rowSeparator": BooleanData(false),
      "headerStyle": "info",
    ]);

  /**
     * Calculate the column widths
     * @param array rows The rows on which the columns width will be calculated on.
     * /
  protected int[string] _calculateWidths(arrayrows) {
    auto results;
    rows.each!((line) {
      line.values.byKeyValue
        .each!((kv) {
          auto columnWidth = _cellWidth(to!string(kv.value)); if (columnWidth >= results.get(kv.key, 0)) {
            results[kv.key] = columnWidth;}
          });});
          return results;
        }

      // Get the width of a cell exclusive of style tags.
      protected size_t _cellWidth(string maxText) {
        if (maxText.isEmpty) {
          return 0;
        }
        if (!maxText.has("<") && !maxText.has(">")) {
          return mb_strwidth(maxText);
        }
        styles = _io.styles();
        tags = styles.keys.join("|",);
        maxText = to!string(preg_replace("#</?(?:" ~ tags ~ ")>#", "", maxText));

        return mb_strwidth(maxText);
      }

      /**
     * Output a row separator.
     * @param array<int> columnWidths The widths of each column to output.
     * /
      protected void _rowSeparator(int[] columnWidths) {
        string outputResult = columnWidths
          .map!(width => "+" ~ str_repeat("-", width + 2))
          .join;

        outputResult ~= "+";
        _io.
        out (outputResult);
      }

      /**
     * Output a row.
     * Params:
     * array row The row to output.
     * @param ] optionsToPass Options to be passed.
     * /
      protected void _render(arrayrow, int[] columnWidths, array optionsToPass = []) {
        if (count(row) == 0) {
          return;
        }

        string outputResult = "";
        foreach (index : value; row.values) {
          string column = to!string(value);
          pad = columnWidths[index] - _cellWidth(column);
          if (!optionsToPass["style"].isEmpty) {
            column = _addStyle(column, optionsToPass["style"]);
          }
          if (column != "" && preg_match("#(.*)<text-right>.+</text-right>(.*)#", column, matches)) {
            if ( matches[1] != "" || ! matches[2].isEmpty) {
              throw new UnexpectedValueException(
                "You cannot include text before or after the text-right tag.");
            }
            column = column.replace(["<text-right>", "</text-right>"], "");
            outputResult ~= "| " ~ str_repeat(" ", pad) ~ column ~ " ";
          } else {
            outputResult ~= "| " ~ column ~ str_repeat(" ", pad) ~ " ";
          }
        }
        outputResult ~= "|";
        _io.
        out (outputResult);
      }

      /**
     * Output a table.
     *
     * Data will be output based on the order of the values
     * in the array. The keys will not be used to align data.
     * Params:
     * array commandArguments The data to render out.
     * /
      void output(array commandArguments) {
        if (commandArguments.isEmpty) {
          return;
        }
        _io.setStyle("text-right", ["text": null]);

        configData = this.configuration.data;
        widths = _calculateWidths(commandArguments);

        _rowSeparator( widths);
        if (configData("headers"] == true) {
            _render(array_shift(commandArguments), widths, ["style": configData("headerStyle"]]);
              _rowSeparator( widths); }
              if (commandArguments.isEmpty) {
                return; }
                commandArguments.each!((line) {
                  _render(line, widths); if (configData("rowSeparator"] == true) {
                      _rowSeparator( widths); }
                    }
                    if (configData("rowSeparator"] != true) {
                        _rowSeparator( widths); }
                      }

                      /**
     * Add style tags
     * Params:
     * string textForSurround The text to be surrounded
     * @param string astyle The style to be applied
     * /
                      protected string _addStyle(string textForSurround, string astyle) {
                        return "<" ~ style ~ ">" ~ textForSurround ~ "</" ~ style ~ ">";
                      } */
}
