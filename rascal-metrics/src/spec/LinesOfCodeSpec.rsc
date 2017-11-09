module src::spec::LinesOfCodeSpec

import src::main::LinesOfCode;
import IO;

test bool shouldNotCountLineComments() {
    int result = linesOfCodePerFile(|cwd:///src/spec/resources/LineComments.java|);
    return result == 0;
}

test bool shouldNotCountWhiteLines() {
    int result = linesOfCodePerFile(|cwd:///src/spec/resources/WhiteLines.java|);
    return result == 0;
}

test bool shouldNotCountMultiLineComments() {
    int result = linesOfCodePerFile(|cwd:///src/spec/resources/MultiLineComments.java|);
    return result == 0;
}

test bool shouldCorrectlyCountHelloWorld() {
    int result = linesOfCodePerFile(|cwd:///src/spec/resources/HelloWorld.java|);
    return  result == 11;
}

test bool shouldNotCountEdgeCases() {
    int result = linesOfCodePerFile(|cwd:///src/spec/resources/EdgeCase.java|);
    return  result == 0;
}