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
    return  result == 3;
}

test bool testDBMetaData() {
    return linesOfCodePerFile(|project://smallsql0.21_src/src/smallsql/junit/TestDBMetaData.java|) == 217;
}

test bool TransactionManagerMV2PL() {
	return linesOfCodePerFile(|project://hsqldb-2.3.1/hsqldb/src/org/hsqldb/TransactionManagerMV2PL.java|) == 338;
}

test bool jaasAuthBean() {
	return linesOfCodePerFile(|project://hsqldb-2.3.1/hsqldb/src/org/hsqldb/auth/JaasAuthBean.java|) == 144;
}