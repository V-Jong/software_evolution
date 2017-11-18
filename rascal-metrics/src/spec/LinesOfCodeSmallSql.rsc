module spec::LinesOfCodeSmallSql

import main::LinesOfCode;
import IO;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;

test bool testSmallSql() {
	println("Creating model ...");
    M3 model = createM3FromEclipseProject(|project://smallsql0.21_src|);
	int result = linesOfCodePerProject(model);
	println(result);
    return result == 24050;
}