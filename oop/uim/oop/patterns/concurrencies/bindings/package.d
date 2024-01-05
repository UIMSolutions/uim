/***********************************************************************************
*	Copyright: ©2015-2023 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
/**
Source Wikipedia [EN]:
The Binding properties pattern is combining multiple observers to force properties in different objects to be synchronized or coordinated in some way. 
This pattern was first described as a technique by Victor Porton. This pattern comes under concurrency patterns.
**/
module uim.oop.patterns.concurrencies.bindings;

import uim.oop;
@safe:

/* /// Code sketch for one-way binding may look like as follows:
bindMultipleOneWay(src_obj, src_prop, dst_objs[], dst_props[]) {
  for (i, j) in (dst_objs, dst_props) {
    bind_properties_one_way(src_obj, src_prop, i, j);
  }
}

/// Two-way binding can be expressed as follows (in C++):
// In this pseudo-code are not taken into the account initial values assignments
void bindTwoWay(prop1, prop2) {
  bind(prop1, prop2);
  bind(prop2, prop1);
}

/// Accomplishing the binding (i.e. connecting the property change notification in an event handler) may be like as follows:
void onPropertyChange(src_prop, dst_prop) {
  block_signal(src_obj, onPropertyChange);
  dst_prop = src_prop;
  unblock_signal(src_obj, onPropertyChange);
} */