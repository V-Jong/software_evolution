module spec::LinesOfCodeHSql

import main::LinesOfCode;
import IO;

test bool testBigSql() {
    int result = linesOfCodePerFile(|project://hsqldb-2.3.1|);
    return  result == 3;
}