/***********************************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)
*	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*	Authors: Before 2022 Ozan Nurettin Süel (sicherheitsschmiede) Team / Since 2022 - Ozan Nurettin Süel (sicherheitsschmiede) 
*	Documentation [DE]: https://www.sicherheitsschmiede.de/docus/uim-core/datatypes/overview
************************************************************************************************/
module uim.core.datatypes;

import uim.core;

unittest {
  writeln("-----  ", __MODULE__ , "\t  -----");
}

public {
  // import uim.core.datatypes.datetime;
  import uim.core.datatypes.boolean;
  import uim.core.datatypes.datetime;
  import uim.core.datatypes.floating;
  import uim.core.datatypes.general;
  import uim.core.datatypes.integral;
  import uim.core.datatypes.json;
  import uim.core.datatypes.string_;
  import uim.core.datatypes.uuid; 
}


T rotate(T)(T value, T[] values, bool directionRight = true) {
  if (values.length > 0)
  foreach(index, val; values) {
    if (val == value) {
      return directionRight
        ? (index == values.length-1 
          ? values[0]
          : values[index+1]
         )
        : (index == 0 
          ? values[$-1] 
          : values[index-1]
         );
    }
  }
  return value;
}
unittest {
  assert(1.rotate([2,3,1,4,5]) == 4);
}

