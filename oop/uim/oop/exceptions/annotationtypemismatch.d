/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.oop.exceptions.annotationtypemismatch;

import uim.oop;
@safe:

// Thrown to indicate that a program has attempted to access an element of an annotation whose type has changed after the annotation was compiled (or serialized).
class DAnnotationTypeMismatchException : UimException {  
	mixin(ExceptionThis!("AnnotationTypeMismatchException"));
}
mixin(ExceptionCalls!("AnnotationTypeMismatchException"));

unittest {
	auto exception = AnnotationTypeMismatchException;
}