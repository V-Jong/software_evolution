module spec::LinesOfCodeSmallSql

import main::LinesOfCode;
import IO;

test bool testSmallSql() {
	int result = linesOfCodePerProject(|project://smallsql0.21_src|);
    return result == 24050;
}