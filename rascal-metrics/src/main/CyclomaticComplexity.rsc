module main::CyclomaticComplexity

import IO;
import List;
import Set;
import util::Math;
import String;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::m3::AST;
import main::LinesOfCode;
import lang::java::\syntax::Java15;
import Exception;
import ParseTree;
import util::FileSystem;
import lang::java::\syntax::Disambiguate;

//TODO: make methods shorter and simpler, find a way to compute in single string

public void init(loc project) { //cyclomaticComplexityPerProject
	println("Creating model...");
    M3 model = createM3FromEclipseProject(project);
    println("Calculating Cyclomatic Complexity");
    
    int totalLines = 24050; //linesOfCodePerProject(model);
    
    projectFiles = files(model);
    list[map[str, int]] profiles = [profileOfFile(calculateCyclomaticComplexityForFile2(file)) | file <- projectFiles];
    map[str, int] projectComplexity = mergeProfiles(profiles);
    println("The complexity profile is: <projectComplexity>");
    
    printComplexityForProject(totalLines, projectComplexity);
}

public void printComplexityForProject(int totalLines, map[str, int] profile) {
	println("Total lines of code is: <totalLines>");
	println();
	
	map[str, real] percentages = getRiskProfilePercentages(profile, totalLines);
	simplePerc = percentages[simpleKey()];
	modPerc = percentages[modKey()];
	highPerc = percentages[highKey()];
	vHighPerc = percentages[vHighKey()];
	rating = getComplexityRating(modPerc, highPerc, vHighPerc);
	
	println("Low: <simplePerc>%");
	println("Moderate: <modPerc>%");
	println("High: <highPerc>%");
	println("Very high: <vHighPerc>%");
	println();
	println("This project gets the rating: <rating>");
	println();
}

public str getComplexityRating(real moderate, real high, real vHigh) {
	str rating = "--";
	if (moderate <= 25.00 && high == 0.00 && vHigh == 0.00)
		rating = "++";
	else if (moderate <= 30.00 && high == 5.00 && vHigh == 0.00)
		rating = "+";
	else if (moderate <= 40.00 && high == 10.00 && vHigh == 0.00)
		rating = "o";
	else if (moderate <= 50.00 && high == 15.00 && vHigh == 5.00)
		rating = "-";
	return rating;
}

public map[str, real] getRiskProfilePercentages(map[str, int] locProfile, totalLoc) {	
	simple = toReal(locProfile[simpleKey()]);
	moderate = toReal(locProfile[modKey()]);
	high = toReal(locProfile[highKey()]);
	vHigh = toReal(locProfile[vHighKey()]);
	
	real decimal = 0.01;
	real simplePerc = round((simple / totalLoc) * 100, decimal);
	real modPerc = round((moderate / totalLoc) * 100, decimal);
	real highPerc = round((high / totalLoc) * 100, decimal);
	real vHighPerc = round((vHigh / totalLoc) * 100, decimal);
	return (simpleKey(): simplePerc, modKey(): modPerc, highKey(): highPerc, vHighKey(): vHighPerc);
}

public map[str, int] profileOfFile(lrel[int cc, loc location] fileResult) {
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
	return (simpleKey(): simple, modKey(): moreComplex, highKey(): complex, vHighKey(): untestable);
}

map[str, int] mergeProfiles(list[map[str, int]] profiles) {
	int totalSimple = 0;
	int totalMoreComplex = 0;
	int totalComplex = 0;
	int totalUntestable = 0;
	
	for (profile <- profiles) {
		int profileSimple = profile[simpleKey()];
		int profileMoreComplex = profile[modKey()];
		int profileComplex = profile[highKey()];
		int profileUntestable = profile[vHighKey()];
		
		totalSimple += profileSimple;
		totalMoreComplex += profileMoreComplex;
		totalComplex += profileComplex;
		totalUntestable += profileUntestable;
	}
	return (simpleKey(): totalSimple, modKey(): totalMoreComplex, highKey(): totalComplex, vHighKey(): totalUntestable);
}

set[MethodDec] allMethods(loc file) = { m | /MethodDec m := parse(#start[CompilationUnit], file) };

set[MethodDec] allConstructors(loc file) = { m | /ConstructorDec m := parse(#start[CompilationUnit], file) };

lrel[int cc, loc method] calculateCyclomaticComplexityForFile(loc file) = [<calculateCyclomaticComplexityForMethod(m), m@\loc> | m <- allMethods(file)];

int calculateCyclomaticComplexityForMethod(MethodDec m) {
	result = 1;
	visit (m) {
		case (Expr)`<Expr _> || <Expr _>`: result += 1;
		case (Expr)`<Expr _> && <Expr _>`: result += 1;
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

str simpleKey() = "low";
str modKey() = "moderate";
str highKey() = "high";
str vHighKey() = "very high";

int calculateCyclomaticComplexity2(Statement impl) {
    result = 1;
    visit (impl) {
        case \if(_,_) : result += 1;
        case \if(_,_,_) : result += 1;
        case \switch(_,_) : result += 1;
        case \case(_) : result += 1;
        case \do(_,_) : result += 1;
        case \while(_,_) : result += 1;
        case \for(_,_,_) : result += 1;
        case \for(_,_,_,_) : result += 1;
        case foreach(_,_,_) : result += 1;
        case \catch(_,_): result += 1;
        case \conditional(_,_,_): result += 1;
        case infix(_,"&&",_) : result += 1;
        case infix(_,"||",_) : result += 1;
    }
    return result;
}

list[tuple[int, loc]] calculateCyclomaticComplexityForFile2(loc fileLocation) { //calculateCyclomaticComplexityForFile2
	result = [];
    cc = 0;
    //nr = 0;
    Declaration ast = createAstFromFile(fileLocation, true);
    list[Declaration] decls = ast.types;
    visit (decls) {
        case \method(_, name, params, exceptions, impl): {
        	location = impl.src;
        	//linesOfCode = linesOfCodePerLocation(location);
            cc = calculateCyclomaticComplexity2(impl);
            //println("Found method <name>");
            //println("Location: <location>");
            result += <cc, location>;
        	//println("Lines of code: <linesOfCode>");
            //nr += 1;
        }
    }
    //println("cc = <cc>");
    //println("<nr> function(s) in file");
    return result;
}