/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.views.interfaces.view;import uim.views;@safe:interface IView : INamed {    string currentType();     string[] blockNames();     // Turns on or off UIM"s conventional mode of applying layout files.    IView enableAutoLayout(bool enable = true);        // Turns off UIM"s conventional mode of applying layout files.    IView disableAutoLayout(); }