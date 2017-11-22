module spec::LinesOfCodeSpec

import main::LinesOfCode;
import IO;

test bool testDBMetaData() {
    return linesOfCodePerLocation(|project://smallsql0.21_src/src/smallsql/junit/TestDBMetaData.java|) == 217;
}

test bool TransactionManagerMV2PL() {
	return linesOfCodePerLocation(|project://hsqldb-2.3.1/hsqldb/src/org/hsqldb/TransactionManagerMV2PL.java|) == 338;
}

test bool jaasAuthBean() {
	return linesOfCodePerLocation(|project://hsqldb-2.3.1/hsqldb/src/org/hsqldb/auth/JaasAuthBean.java|) == 144;
}