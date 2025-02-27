module uim.i18n.classes.parsers.pot.parser;

import uim.i18n;
@safe:

version (test_uim_i18n) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

class DPotI18NParser : DI18NParser {
    mixin(I18NParserThis!("Pot"));
}
mixin(I18NParserCalls!("Pot"));
