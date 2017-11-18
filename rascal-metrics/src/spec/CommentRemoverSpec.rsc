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