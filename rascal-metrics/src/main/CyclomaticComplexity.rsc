module main::CyclomaticComplexity

import IO;
import List;
import Set;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::m3::AST;
import main::LinesOfCode;
import lang::java::\syntax::Java15;
import Exception;
import ParseTree;
import util::FileSystem;
import lang::java::\syntax::Disambiguate;

public set[loc] cyclomaticComplexityPerProject(loc project) {
	println("Creating model...");
    M3 model = createM3FromEclipseProject(project);
    println("Model created, calculating CC");
    
    projectFiles = files(model);
    
	return methods(model);
}

public map[str, int] profileOfFile(lrel[int cc, loc location] fileResult) { //, map[str, int] profile
	int simple = 0;
	int moreComplex = 0;
	int complex = 0;
	int untestable = 0;
	
	for (file <- fileResult) {
		int fCC = file.cc;
		loc fLoc = file.location;
		int linesOfCode = linesOfCodePerLocation(fLoc);
		if (fCC <= 10) {
			simple += linesOfCode;
		} else if (fCC <= 20) {
			moreComplex += linesOfCode;
		} else if (fCC <= 50) {
			complex += linesOfCode;
		} else {
			untestable += linesOfCode;
		}
	}
	return ("Simple": simple, "More complex": moreComplex, "Complex": complex, "Untestable": untestable);
}

set[MethodDec] allMethods(loc file) = { m | /MethodDec m := parse(#start[CompilationUnit], file) };

lrel[int cc, loc method] maxCC(loc file) = [<cyclomaticComplexity(m), m@\loc> | m <- allMethods(file)];

int cyclomaticComplexity(MethodDec m) {
	result = 1;
	visit (m) {
		case (Stm)`do <Stm _> while (<Expr _>);`: result += 1;
		case (Stm)`while (<Expr _>) <Stm _>`: result += 1;
		case (Stm)`if (<Expr _>) <Stm _>`: result +=1;
		case (Stm)`if (<Expr _>) <Stm _> else <Stm _>`: result +=1;
		case (Stm)`for (<{Expr ","}* _>; <Expr? _>; <{Expr ","}*_>) <Stm _>` : result += 1;
		case (Stm)`for (<LocalVarDec _> ; <Expr? e> ; <{Expr ","}* _>) <Stm _>`: result += 1;
		case (Stm)`for (<FormalParam _> : <Expr _>) <Stm _>` : result += 1;
		case (Stm)`switch (<Expr _> ) <SwitchBlock _>`: result += 1;
		case (SwitchLabel)`case <Expr _> :` : result += 1;
		case (CatchClause)`catch (<FormalParam _>) <Block _>` : result += 1;
	}
	return result;
}

//public int cyclomaticComplexityPerFile(loc location) {
//	str rawFile = readFile(location);
//	
//	list[str] cleaned = removeCommentsAndWhiteSpacesFromFile(rawFile);
////	println(cleaned);
//	
//	list[int] complexityPerLine = [ complexityForLine(input) | input <- cleaned];
//	
//	list[int] ifsPerLine = [ countIfs(input) | input <- cleaned];
//	int ifs = sum(ifsPerLine);
//	println("<ifs> if statements found");
//	list[int] forsPerLine = [ countFors(input) | input <- cleaned];
//	int fors = sum(forsPerLine);
//	println("<fors> for statements found");
//	list[int] switchesPerLine = [ countSwitches(input) | input <- cleaned];
//	int switches = sum(switchesPerLine);
//	println("<switches> switch statements found");
//	list[int] casesPerLine = [ countCases(input) | input <- cleaned];
//	int cases = sum(casesPerLine);
//	println("<cases> case statements found");
//	list[int] catchesPerLine = [ countCatches(input) | input <- cleaned];
//	int catches = sum(catchesPerLine);
//	println("<catches> catch statements found");
//	list[int] dosPerLine = [ countDos(input) | input <- cleaned];
//	int dos = sum(dosPerLine);
//	println("<dos> do statements found");
//	list[int] whilesPerLine = [ countWhiles(input) | input <- cleaned];
//	int whiles = sum(whilesPerLine);
//	println("<whiles> while statements found");
//	
//	int complexity = sum(complexityPerLine);
//	return complexity;
//}
//
//public int complexityForLine(str input) = countIfs(input) + countFors(input) + countSwitches(input) + countCases(input) + 
//	countCatches(input) + countDos(input) + countWhiles(input);
//
//public int countIfs(str content) = (0 | it + 1 | /if/ := content);
//
//public int countFors(str content) = (0 | it + 1 | /for/ := content);
//
//public int countSwitches(str content) = (0 | it + 1 | /switch/ := content);
//
//public int countCases(str content) = (0 | it + 1 | /case\s+/ := content);
//
//public int countCatches(str content) = (0 | it + 1 | /catch/ := content);
//
//public int countDos(str content) = (0 | it + 1 | /do/ := content);
//
//public int countWhiles(str content) = (0 | it + 1 | /while/ := content);