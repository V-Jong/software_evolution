module spec::CommentRemoverSpec

import main::CommentRemover;
import IO;
import main::lib::ListHelpers;

test bool shouldReplaceMultiLineCommentCharactersInString() {
	string = readFile(|project://rascal-metrics/src/spec/resources/EdgeCase.java|);	
    list[str] result = removeCommentsAndWhiteSpacesFromFile(string);
    printStringList(result);
    return true;
}

test bool shouldRemoveLineComments() {
    int result = linesOfCodePerLocation(|project://rascal-metrics/src/spec/resources/LineComments.java|);
    return result == 0;
}

test bool shouldNotCountWhiteLines() {
    int result = linesOfCodePerLocation(|project://rascal-metrics/src/spec/resources/WhiteLines.java|);
    return result == 0;
}

test bool shouldNotCountMultiLineComments() {
    int result = linesOfCodePerLocation(|project://rascal-metrics/src/spec/resources/MultiLineComments.java|);
    return result == 0;
}

test bool shouldCorrectlyCountHelloWorld() {
    int result = linesOfCodePerLocation(|project://rascal-metrics/src/spec/resources/HelloWorld.java|);
    return  result == 11;
}

test bool shouldNotCountEdgeCases() {
    int result = linesOfCodePerLocation(|project://rascal-metrics/src/spec/resources/EdgeCase.java|);
    return  result == 3;
}
