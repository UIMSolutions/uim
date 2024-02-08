/**
The naked objects pattern is defined by three principles:

All business logic should be encapsulated onto the domain objects. This principle is not unique to naked objects; it is a strong commitment to encapsulation.
The user interface should be a direct representation of the domain objects, with all user actions consisting of creating, retrieving, or invoking methods 
on domain objects. This principle is not unique to naked objects: it is an interpretation of an object-oriented user interface.
The naked object pattern's innovative feature arises by combining the 1st and 2nd principles into a 3rd principle:

The user interface shall be entirely automatically created from the definitions of the domain objects. This may be done using several different technologies, 
including source code generation. To date,[when?] implementations[which?] of the naked objects pattern have favored the technology of reflection.
The naked objects pattern was first described formally in Richard Pawson's PhD thesis[1] which includes investigation of antecedents and inspirations for 
the pattern including, for example, the Morphic user interface.

Naked Objects is commonly contrasted[by whom?] with the model–view–controller pattern. However, the published version of Pawson's thesis[1] contains a 
foreword by Trygve Reenskaug, who first formulated the model–view–controller pattern, suggesting that naked objects is closer to the original intent of 
model-view-controller (MVC) than many of the subsequent interpretations and implementations.
**/
/***********************************************************************************
*	Copyright: ©2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.patterns.architecturals.naked_objects;

import uim.oop;
@safe: