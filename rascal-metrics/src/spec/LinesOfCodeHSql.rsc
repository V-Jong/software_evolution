module spec::LinesOfCodeHSql

import main::LinesOfCode;
import IO;

test bool testBigSql() {
	int result = linesOfCodePerProject(|project://hsqldb-2.3.1|);
	println(result);
	// 169094
    return result == 169184;
}