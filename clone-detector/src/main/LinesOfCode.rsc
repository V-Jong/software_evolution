module main::LinesOfCode

import IO;
import List;
import Map;
import String;

import lang::java::m3::AST;

public int totalLOCForProjectAst(set[Declaration] fileAsts) {
	sizesPerFile = [LOCForFileAst(fileAst) | fileAst <- fileAsts];
//	iprintln(sizesPerFile);
	return sum(sizesPerFile);
}

public int LOCForFileAst(Declaration fileAst) {
	int fileLoc = 0;
	visit(fileAst) {
		case x:\compilationUnit(_,_): fileLoc += x.src.end.line - x.src.begin.line + 1;
		case x:\compilationUnit(_,_,_): fileLoc += x.src.end.line - x.src.begin.line + 1;
	}
	return fileLoc;
}

public int totalLOCForProject(set[loc] fileLocations) {
	sizesPerFile = [LOCForFile(fileLocation) | fileLocation <- fileLocations];
	iprintln(sizesPerFile);
	return sum(sizesPerFile);
}

public int LOCForFile(loc fileLocation) {
	return size(removeCommentsAndWhiteSpacesFromFile(readFile(fileLocation)));
}

public list[str] removeCommentsAndWhiteSpacesFromFile(str input) {
	str clearedStringContent = clearStringContent(input);
    str withoutComments = removeComments(clearedStringContent);
    
    list[str] lines = split("\n", withoutComments);
    list[str] withoutWhiteLines = [trim(line) | line <- lines, !isWhiteLine(line)];    
	
    return withoutWhiteLines;
}

public str clearStringContent(str input) {
    return visit(input) {
       case /<string:".*?">/ => replaceAll(string, "/*", "")
    };
}

private str removeComments(str input) {
    return visit(input) {
       case /\/\*[\s\S]*?\*\/|\/\/.*/ => ""  
    };
}

private bool isWhiteLine(str line) {
    return isEmpty(trim(line));
}