/***********************************************************************************
*	Copyright: ©2015 - 2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.filesystems.mixins.entrymanager;

import uim.filesystems;

@safe:
template EntryManagerTemplate() {
  bool isHidden(string aPath) {
    return this.isHidden(aPath.split(pathSeparator));    
  }
}

