module main::LinesOfCode

import List;
import Map;

import lang::java::m3::AST;

public int totalLOCForProject(set[Declaration] fileAsts) {
	return sum([LOCForFile(fileAst) | fileAst <- fileAsts]);
}

public int LOCForFile(Declaration fileAst) {
	int locTotal = 0;
	visit(fileAst) {
		case x:\compilationUnit(_,_): locTotal += x.src.end.line - x.src.begin.line;
		case x:\compilationUnit(_,_,_): locTotal += x.src.end.line - x.src.begin.line;
	}
	return locTotal;
}