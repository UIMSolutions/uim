/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.logging.factories.factory;

import uim.logging;

@safe:

class DLogFormatterFactory : DFactory!DLogFormatter {
}
auto LogFormatterFactory() { return DLogFormatterFactory.factory; }

