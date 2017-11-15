module main::UnitSize

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import main::LinesOfCode;
import Set;

public lrel[int, loc] unitSizePerModel(M3 model) {
	set[loc] methods = methods(model);
	return [<linesOfCodePerLocation(methodLocation), methodLocation> | methodLocation <- methods];
}