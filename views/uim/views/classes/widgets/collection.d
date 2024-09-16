/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.views.classes.widgets.collection;import uim.views;@safe:// An object Collection for Widget.class DWidgetCollection : DCollection!DWidget {}auto WidgetCollection() { // Singleton  return new DWidgetCollection;}