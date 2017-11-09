module spec::LinesOfCodeSpec

import main::LinesOfCode;
import IO;

//test bool shouldNotCountLineComments() {
//    int result = linesOfCodePerFile(|project://rascal-metrics/src/spec/resources/LineComments.java|);
//    return result == 0;
//}
//
//test bool shouldNotCountWhiteLines() {
//    int result = linesOfCodePerFile(|project://rascal-metrics/src/spec/resources/WhiteLines.java|);
//    return result == 0;
//}
//
//test bool shouldNotCountMultiLineComments() {
//    int result = linesOfCodePerFile(|project://rascal-metrics/src/spec/resources/MultiLineComments.java|);
//    return result == 0;
//}
//
//test bool shouldCorrectlyCountHelloWorld() {
//    int result = linesOfCodePerFile(|project://rascal-metrics/src/spec/resources/HelloWorld.java|);
//    return  result == 11;
//}
//
//test bool shouldNotCountEdgeCases() {
//    int result = linesOfCodePerFile(|project://rascal-metrics/src/spec/resources/EdgeCase.java|);
//    return  result == 3;
//}

test bool testSmallSql() {
    int result = linesOfCodePerProject(|project://smallsql0.21_src|);
	println(result);
    return  result == 24050;
}

//
//test bool testBigSql() {
//    int result = linesOfCodePerFile(|project://hsqldb-2.3.1|);
//    return  result == 3;
//}