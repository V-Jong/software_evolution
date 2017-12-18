module main::IDEIntegration

import util::IDE;
import IO;
import Set;
import Map;
import Node;
import demo::lang::Exp::Concrete::NoLayout::Syntax;
import ParseTree;
import lang::java::\syntax::Java15;
import Type;

import main::lib::SetHelpers;

import main::Main;
import main::Config;

import lang::java::m3::AST;
import lang::java::jdt::m3::Core;

data DuplicationTree = TreeRoot(ClonesCurrentFile duplicates);
data ClonesCurrentFile = clonesCurrentFile(set[loc] clones);

public bool clonesDetected = false; 

public void register() {
	str LANGUAGE_NAME = "Clone Detection";
	str FILE_EXTENSION = "java";
	
	clearLanguages();
	clearNonRascalContributions();
	registerLanguage(LANGUAGE_NAME, FILE_EXTENSION, abc);
	println("Registered the language <LANGUAGE_NAME> with file extension <FILE_EXTENSION>");	
	menuItem = popup(action("Detect clones", performCloneDetection));
	registerContributions(LANGUAGE_NAME, {outliner(outlinerModule), annotator(annotateModule), menuItem});
	
	println("Registered contributions");
}

private void performCloneDetection(Tree t, loc s) {
	clonesDetected = true;
	tmp = |project:///|;
	tmp.authority = s.authority;
 	detectClones(tmp);
}

private start[CompilationUnit] abc(str x, loc l) {
	parseTree = parse(#start[CompilationUnit], x, l) ;
	return parseTree; 
}

public loc setSchemeToProject(loc location) {
	location.scheme = "project";
	location.authority = PROJECT.authority;
	return location;
}

public bool isTreeAClone(loc locationParseTree, set[loc] cloneLocations) {
	return any(loc cloneLocation <- cloneLocations, sameLocation(cloneLocation, locationParseTree));
}

public node getCloneNodeFromParseTree(loc location, set[node] clonesInFile) {
	for (node clone <- clonesInFile) {
		cloneLocation = getLocation(clone);
		same = sameLocation(location, cloneLocation);
		if(same) {
			return clone;	
		}
	}
}

public bool sameLocation(loc location1, loc location2) {
	return location1.begin.line == location2.begin.line && 
	location1.begin.column == location2.begin.column &&
	location1.end.line == location2.end.line &&
	location1.end.column == location2.end.column;
}

private Tree annotateModule(Tree t) {	
	if (!clonesDetected) {
		return t;
	}
	currentLocation = t@\loc;
	
	set[node] clonesInFile = clonesPerFile[currentLocation.path];
	
	set[loc] cloneLocations = mapper(clonesInFile, getLocation);

	// The goal here is to annotate each clone in the file with links to it's siblings.

	visit(t) {
		case Tree x: {
			if("loc" in getAnnotations(x)) {
				if(isTreeAClone(x@\loc, cloneLocations)) {
					node cloneAtThisLocation = getCloneNodeFromParseTree(x@\loc, clonesInFile);
					
					set[node] siblings = flatten(getSiblings(cloneAtThisLocation, range(cloneMap)));
					
					siblingLocations = mapper(siblings, getLocation);
					
					x@links = siblingLocations;
				}
			}
		}
	}
	
	// messages are set on the root of the parse tree
	set[Message] messages = {info(getLocation(sibling).path , getLocation(clone)) | clone <- clonesInFile, siblings <- getSiblings(clone, range(cloneMap)), sibling <- siblings};
	
	t@\messages = messages;
	
	return t;
}

private node outlinerModule(Tree t) {
	if (!clonesDetected) {
		return t;
	}
	
	currentLocation = t@\loc;
	
	clonesInFile = clonesCurrentFile(mapper(clonesPerFile[currentLocation.path], getLocation));
	clonesInFile@label = "Clones detected in this file:";
	 
	customTree = TreeRoot(clonesInFile);
	
	return customTree;
}