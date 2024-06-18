module uim.html.classes.elements.dl;

import uim.html;
@safe:

/**
 * Definitionslisten, seit HTML5 Beschreibungslisten, werden durch dl-Elemente beschrieben. (dl = definition / description list)
 * Beispiel: Listen für Glossare (Glossar = meist eine Liste von Einträgen, die wiederum aus mindestens einem zu erklärenden Sachverhalt nebst mindestens einer Erklärung besteht)
 * 
 * Eine Definitions- bzw. Beschreibungliste wird mit <dl> eingeleitet und mit </dl> beendet.
 * Der zu erläuternde Ausdruck steht zwischen <dt>…</dt> (description (list) term).
 * <dd>…</dd> (description (list) description) umschließt die Erläuterung. 
 * Die Abfolge von dt- und dd-Elementen innerhalb einer dl-Liste ist nicht streng geregelt. Es dürfen auch mehrere dt- oder dd-Elemente hintereinander folgen. Zum Beispiel könnten Begriffe mit einer Erklärung abgehandelt werden oder mehrere Bedeutungen für einen Begriff existieren.
 * Das Verschachteln von Definitionslisten ist ebenfalls möglich. Dadurch können Sie baumartige Strukturen im Text abbilden. „Innere“ Listen müssen dabei innerhalb des dd-Elements notiert werden. 
*/
class DH5Dl : DH5Obj {
	mixin(H5This!"dl");
}
mixin(H5Short!"Dl");

version(test_uim_html) { unittest {
  testH5Obj(H5Dl, "dl");
}}
