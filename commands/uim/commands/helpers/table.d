module uim.commands.helpers.table;

import uim.commands;

@safe:

/**
 * Create a visually pleasing ASCII art table
 * from 2 dimensional array data.
 */
class DTableHelper : UIMObject { // }: Helper {
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }
    configuration.mergeDefaults([
      "headers": true.toJson,
      "rowSeparator": false.toJson,
      "headerStyle": Json("info")
    ]);

    return true;
  }

  // Calculate the column widths
  protected int[string] _calculateWidths(Json[string] rows) {
    int[string] results;
    rows.each!((line) {
      line.values.byKeyValue
        .each!((kv) {
          auto columnWidth = _cellWidth(to!string(kv.value));
          if (columnWidth >= results.get(kv.key, 0)) {
            results[kv.key] = columnWidth;
          }
        });
    });
    return results;
  }

  // Get the width of a cell exclusive of style tags.
  protected size_t _cellWidth(string maxText) {
    if (maxText.isEmpty) {
      return 0;
    }
    if (!maxText.contains("<") && !maxText.contains(">")) {
      return mb_strwidth(maxText);
    }
    styles = _io.styles();
    tags = styles.keys.join("|",);
    maxText = to!string(preg_replace("#</?(?:" ~ tags ~ ")>#", "", maxText));

    return mb_strwidth(maxText);
  }

  // Output a row separator.
  protected void _rowSeparator(int[] columnWidths) {
    string outputResult = columnWidths
      .map!(width => "+" ~ str_repeat("-", width + 2))
      .join;

    outputResult ~= "+";
    _io.
    out (outputResult);
  }

  // Output a row.
  protected void _render(Json[string] rowOutput, int[] columnWidths, Json[string] optionsToPass = null) {
    if (count(row) == 0) {
      return;
    }

    string outputResult = "";
    foreach (index : value; row.values) {
      outputResult ~= _renderColumn(to!string(value), columnWidths[index], optionsToPass)
    }
    outputResult ~= "|";
    _io.
    out (outputResult);
  }

  protected void _renderColumn(string column, int columnWidth, Json[string] optionsToPass = null) {
    auto pad = columnWidth - _cellWidth(column);
    if (!optionsToPass.isEmpty("style")) {
      column = _addStyle(column, optionsToPass.get("style"));
    }
    if (column != "" && preg_match("#(.*)<text-right>.+</text-right>(.*)#", column, matches)) {
      if (matches[1] != "" || !matches[2].isEmpty) {
        throw new DUnexpectedValueException(
          "You cannot include text before or after the text-right tag.");
      }
      column = column.replace(["<text-right>", "</text-right>"], "");
      return "| " ~ str_repeat(" ", pad) ~ column ~ " ";
    } else {
      return "| " ~ column ~ str_repeat(" ", pad) ~ " ";
    }
  }

  /**
     * Output a table.
     *
     * Data will be output based on the order of the values
     * in the array. The keys will not be used to align data.
     */
  void output(Json[string] commandArguments) {
    if (commandArguments.isEmpty) {
      return;
    }
    _io.setStyle("text-right", ["text": Json(null)]);

    auto configData = configuration.data;
    auto widths = _calculateWidths(commandArguments);

    _rowSeparator(widths);
    if (configuration.hasKey("headers")) {
      _render(commandArguments.shift, widths, [
          "style": configuration.get("headerStyle")
        ]);
      _rowSeparator(widths);
    }
    if (commandArguments.isEmpty) {
      return;
    }
    commandArguments.each!((line) {
      _render(line, widths);
      if (configuration.hasKey("rowSeparator")) {
        _rowSeparator(widths);
      }
    });

    if (!configuration.hasKey("rowSeparator")) {
      _rowSeparator(widths);
    }
  }

  // Add style tags
  protected string _addStyle(string textForSurround, string styleToAppy) {
    return "<" ~ style ~ ">" ~ textForSurround ~ "</" ~ style ~ ">";
  }
}
