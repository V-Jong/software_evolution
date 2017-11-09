module spec::LinesOfCodeSpec

import main::LinesOfCode;
import IO;

test bool shouldNotCountLineComments() {
    int result = linesOfCodePerFile(|project://rascal-metrics/src/spec/resources/LineComments.java|);
    return result == 0;
}

test bool shouldNotCountWhiteLines() {
    int result = linesOfCodePerFile(|project://rascal-metrics/src/spec/resources/WhiteLines.java|);
    return result == 0;
}

test bool shouldNotCountMultiLineComments() {
    int result = linesOfCodePerFile(|project://rascal-metrics/src/spec/resources/MultiLineComments.java|);
    return result == 0;
}

test bool shouldCorrectlyCountHelloWorld() {
    int result = linesOfCodePerFile(|project://rascal-metrics/src/spec/resources/HelloWorld.java|);
    return  result == 11;
}

test bool shouldNotCountEdgeCases() {
    int result = linesOfCodePerFile(|project://rascal-metrics/src/spec/resources/EdgeCase.java|);
    print("LOC: ");
    println(result);
    return  result == 3;
}
