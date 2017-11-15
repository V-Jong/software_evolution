module main::CyclomaticComplexity

import IO;
import List;
import Set;
import util::Math;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::m3::AST;
import main::LinesOfCode;
import lang::java::\syntax::Java15;
import Exception;
import ParseTree;
import util::FileSystem;
import lang::java::\syntax::Disambiguate;

public void cyclomaticComplexityPerProject(loc project) {
	println("Creating model...");
    M3 model = createM3FromEclipseProject(project);
    println("Model created, calculating CC");
    
    int totalLines = linesOfCodePerProject(model);
    
    projectFiles = files(model);
    list[map[str, int]] profiles = [profileOfFile(maxCC(file)) | file <- projectFiles];
    map[str, int] projectComplexity = mergeProfiles(profiles);
    println("The total complexity is <projectComplexity>");
    
    evaluateProject(totalLines, projectComplexity);
}

public void evaluateProject(int totalLines, map[str, int] profile) {
	println("Total lines of code is: <totalLines>");
	real simple = toReal(profile["Simple"]);
	real moreComplex = toReal(profile["More complex"]);
	real complex = toReal(profile["Complex"]);
	real untestable = toReal(profile["Untestable"]);
	
	real simplePerc = (simple / totalLines) * 100;
	real moreComplexPerc = (moreComplex / totalLines) * 100;
	real complexPerc = (complex / totalLines) * 100;
	real untestablePerc = (untestable / totalLines) * 100;
	
	str rating = "--";
	if (moreComplexPerc <= 25.00 && complexPerc == 0.00 && untestablePerc == 0.00)
		rating = "++";
	else if (moreComplexPerc <= 30.00 && complexPerc == 5.00 && untestablePerc == 0.00)
		rating = "+";
	else if (moreComplexPerc <= 40.00 && complexPerc == 10.00 && untestablePerc == 0.00)
		rating = "o";
	else if (moreComplexPerc <= 50.00 && complexPerc == 15.00 && untestablePerc == 5.00)
		rating = "-";
	
	println("Simple percentage: <simplePerc> %");
	println("More complex percentage: <moreComplexPerc> %");
	println("Complex percentage: <complexPerc> %");
	println("Untestable percentage: <untestablePerc> %");
	println("This project get the rating: <rating>");
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

map[str, int] mergeProfiles(list[map[str, int]] profiles) {
	int totalSimple = 0;
	int totalMoreComplex = 0;
	int totalComplex = 0;
	int totalUntestable = 0;
	
	for (profile <- profiles) {
		int profileSimple = profile["Simple"];
		int profileMoreComplex = profile["More complex"];
		int profileComplex = profile["Complex"];
		int profileUntestable = profile["Untestable"];
		
		totalSimple += profileSimple;
		totalMoreComplex += profileMoreComplex;
		totalComplex += profileComplex;
		totalUntestable += profileUntestable;
	}
	return ("Simple": totalSimple, "More complex": totalMoreComplex, "Complex": totalComplex, "Untestable": totalUntestable);
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
