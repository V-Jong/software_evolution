module main::CyclomaticComplexity

import IO;
import util::Math;
import lang::java::m3::AST;
import lang::java::\syntax::Java15;
import ParseTree;
import main::CommentRemover;

public map[str, real] getCyclomaticComplexityFootprint(map[str, int] locPerCCCategory, int totalLoc) {
	return getRiskProfilePercentages(locPerCCCategory, totalLoc);
}

public str getCyclomaticComplexityRating(map[str, real] ccFootprint) {
	modPerc = ccFootprint[modKey()];
	highPerc = ccFootprint[highKey()];
	vHighPerc = ccFootprint[vHighKey()];
	return getComplexityRating(modPerc, highPerc, vHighPerc);
}

public lrel[int, loc] ccPerProjectFiles(set[loc] files) {
	ccOfFiles = [ccPerFile(file) | file <- files];
    return ccPerFiles(ccOfFiles);
}

public list[int] filterCC(lrel[int cc, loc location] ccOfFiles) {
	return [ccOfFile.cc | ccOfFile <- ccOfFiles];
}

private lrel[int, loc] ccPerFiles(list[lrel[int,loc]] ccPerFiles) {
	result = [];
	for (ccPerFile <- ccPerFiles) {
		result += ccPerFile;
	}
	return result;
}

private list[tuple[int, loc]] ccPerFile(loc fileLocation) {
	result = [];
    cc = 0;
    Declaration ast = createAstFromFile(fileLocation, true);
    list[Declaration] decls = ast.types;
    visit (decls) {
        case \method(_, name, params, exceptions, impl): {
            result += ccPerMethod(impl.src, impl);
        }
        case \constructor(name, params, exceptions, impl): {
            result += ccPerMethod(impl.src, impl);
        }
    }
    return result;
}

private tuple[int, loc] ccPerMethod(loc location, Statement impl) = <calculateCyclomaticComplexity(impl), location>;

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

public map[str, real] getRiskProfilePercentagesInt(map[str, int] locProfile, totalLoc) {	
	int simplePerc = percent(locProfile[simpleKey()], totalLoc);
	int modPerc = percent(locProfile[modKey()], totalLoc);
	int highPerc = percent(locProfile[highKey()], totalLoc);
	int vHighPerc = percent(locProfile[vHighKey()], totalLoc);
	return (simpleKey(): simplePerc, modKey(): modPerc, highKey(): highPerc, vHighKey(): vHighPerc);
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

public map[str, int] locPerComplexityCategory(lrel[int cc, loc location] ccPerFile) {
	int simple = 0;
	int moreComplex = 0;
	int complex = 0;
	int untestable = 0;
	
	for (ccOfFile <- ccPerFile) {
		int fCC = ccOfFile.cc;
		loc fLoc = ccOfFile.location;
		int linesOfCode = size(removeCommentsAndWhiteSpacesFromFile(readFile(fLoc)));
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

str simpleKey() = "low";
str modKey() = "moderate";
str highKey() = "high";
str vHighKey() = "extreme";

int calculateCyclomaticComplexity(Statement impl) {
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
