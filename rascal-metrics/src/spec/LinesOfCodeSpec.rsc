module spec::LinesOfCodeSpec

import main::LinesOfCode;
import main::CommentRemover;
import IO;

test bool testDBMetaData() {
	list[loc] javaFiles = [|project://smallsql0.21_src/src/smallsql/junit/TestDBMetaData.java|];
	
	map[loc, list[str]] locationLinesMap = (location: removeCommentsAndWhiteSpacesFromFile(readFile(location)) | location <- javaFiles);
    return totalLines(locationLinesMap) == 217;
}

test bool TransactionManagerMV2PL() {
	list[loc] javaFiles = [|project://hsqldb-2.3.1/hsqldb/src/org/hsqldb/TransactionManagerMV2PL.java|];
	
	map[loc, list[str]] locationLinesMap = (location: removeCommentsAndWhiteSpacesFromFile(readFile(location)) | location <- javaFiles);
	return totalLines(locationLinesMap) == 338;
}

test bool jaasAuthBean() {
	list[loc] javaFiles = [|project://hsqldb-2.3.1/hsqldb/src/org/hsqldb/auth/JaasAuthBean.java|];

	map[loc, list[str]] locationLinesMap = (location: removeCommentsAndWhiteSpacesFromFile(readFile(location)) | location <- javaFiles);	
	return totalLines(locationLinesMap) == 144;
}
