module main::UnitSize

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import main::LinesOfCode;
import main::CommentRemover;
import IO;
import List;

public list[int] unitSizePerModel(M3 model) {
	set[loc] methods = methods(model);
	return [size(removeCommentsAndWhiteSpacesFromFile(readFile(methodLocation))) | methodLocation <- methods];
}