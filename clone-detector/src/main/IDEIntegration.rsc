module main::IDEIntegration

import util::IDE;
import IO;
import demo::lang::Exp::Concrete::NoLayout::Syntax;
import ParseTree;
import lang::java::\syntax::Java15;

import main::Main;

data DuplicationTree = location(loc location) | duplicateLocations(set[loc] duplicates);

public void register() {
	str LANGUAGE_NAME = "abc";
	str FILE_EXTENSION = "java";
	
	clearLanguages();
	clearNonRascalContributions();
	registerLanguage(LANGUAGE_NAME, FILE_EXTENSION, abc);
	println("Registered the language <LANGUAGE_NAME> with file extension <FILE_EXTENSION>");	
	m1 = popup(menu("CloneDetector", [action("Run clone detection", performCloneDetection)]));
	registerContributions(LANGUAGE_NAME, {outliner(outlinerModule), m1});
	
	println("Registered contributions");
}

private void performCloneDetection(Tree t, loc s) {
	println("Performing clone detection");
	tmp = |project:///|;
	tmp.authority = s.authority;
	println(tmp);
	detectClones(tmp);
}

private start[CompilationUnit] abc(str x, loc l) {
	println("parsingTree");
	return parse(#start[CompilationUnit], x, l); 
}

//private Tree annotateModule(Tree t) {
//	println("Annotate all the things");
//	return t[@doc="Hello!"];
//}

private node outlinerModule(Tree t) {
	currentLocation = t@\loc;
	set[loc] duplicatesInFile = cloneLocationsPerFile[currentLocation.uri];
	
	return duplicateLocations(duplicatesInFile);
}