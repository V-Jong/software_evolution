module spec::CommentRemoverSpec

import IO;
import List;

import main::CommentRemover;
import main::lib::ListHelpers;

test bool shouldNotCountEdgeCases() {
	string = readFile(|project://rascal-metrics/src/spec/resources/EdgeCase.java|);	
    list[str] result = removeCommentsAndWhiteSpacesFromFile(string);
   
    return size(result) == 3;
}

test bool shouldRemoveLineComments() {
    string = readFile(|project://rascal-metrics/src/spec/resources/LineComments.java|);
    list[str] result = removeCommentsAndWhiteSpacesFromFile(string);

    return size(result) == 0;
}

test bool shouldNotCountWhiteLines() {
    string = readFile(|project://rascal-metrics/src/spec/resources/WhiteLines.java|);
    list[str] result = removeCommentsAndWhiteSpacesFromFile(string);
    
    return size(result) == 0;
}

test bool shouldNotCountMultiLineComments() {
    string = readFile(|project://rascal-metrics/src/spec/resources/MultiLineComments.java|);
    list[str] result = removeCommentsAndWhiteSpacesFromFile(string);

    return size(result) == 0;
}

test bool shouldCorrectlyCountHelloWorld() {
    string = readFile(|project://rascal-metrics/src/spec/resources/HelloWorld.java|);
    list[str] result = removeCommentsAndWhiteSpacesFromFile(string);

    return size(result) == 11;
}

