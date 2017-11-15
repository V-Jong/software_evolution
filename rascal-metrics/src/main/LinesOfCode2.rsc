module main::LinesOfCode2

import IO;
import List;
import String;
import Set;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import main::lib::StringHelpers;
import main::lib::ListHelpers;

public int linesOfCodePerFile(loc file) {
    str rawFile = readFile(file);
	
	list[str] cleanedFile = removeCommentsAndWhiteSpacesFromFile(rawFile);
    
    int numberOfLines = size(cleanedFile);
    return numberOfLines; 
}

public int countLines(str input) {
	return (0 | it + 1 | int i <- [0..size(input)], input[i] == "\n");
}

public int stringProcessor("", _, _, _, significantLine, count) = significantLine ? count + 1 : count;
public default int stringProcessor(str input, bool stringOpen, bool multiLineOpen, bool lineCommentOpen, bool significantLine, int count) {
	str firstChar = head(input);

	if (size(input) > 2) {
		str secondChar = input[1];
		
		bool isNewLineChar = firstChar == "\n";
		bool isStringChar = firstChar != "\"";
		bool isMultiLineCharOpen = firstChar == "*" && secondChar == "/" && !multiLineOpen && !stringOpen;
		bool isMultiLineCharClose = firstChar == "/" && secondChar == "*" && multiLineOpen && !stringOpen;
		bool isLineCommentChar = firstChar =="/" && secondChar == "/" && !multiLineOpen && !stringOpen;
		
		bool isStringOpen = ((stringOpen && !isStringChar) || (!stringOpen && isStringChar)) && (!multiLineOpen && !lineCommentOpen);
		bool isMultiLineOpen = (!stringOpen && !lineCommentOpen && (multiLineOpen || isMultiLineCharOpen));
		bool isLineCommentOpen = isNewLineChar ? false : lineCommentOpen || isLineCommentChar && !significantLine;
		  
		bool isSignificantLine = (significantLine || (/[^\t \n\/]/ := firstChar) && !isMultiLineCharOpen && !isLineCommentOpen);
		int newCount = isNewLineChar && isSignificantLine ? count + 1 : count;	
	
		return stringProcessor(tail(input), isStringOpen, isMultiLineOpen, isLineCommentOpen, isNewLineChar ? false : isSignificantLine, newCount);
	} else {
		return stringProcessor("", false, false, false, significantLine || /[^\t ]/ := firstChar, count);
	}
} 

