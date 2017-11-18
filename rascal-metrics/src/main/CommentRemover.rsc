module main::CommentRemover

import String;

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