module main::UnitSize

import IO;
import List;

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;

import main::CommentRemover;
import main::LinesOfCode;

public list[int] unitSizePerModel(M3 model) {
	set[loc] methods = methods(model);
	return [size(removeCommentsAndWhiteSpacesFromFile(readFile(methodLocation))) | methodLocation <- methods];
}