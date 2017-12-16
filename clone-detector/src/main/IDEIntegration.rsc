module main::IDEIntegration

import util::IDE;
import IO;
import Set;
import Map;
import Node;
import demo::lang::Exp::Concrete::NoLayout::Syntax;
import ParseTree;
import lang::java::\syntax::Java15;

import main::Main;

data DuplicationTree = TreeRoot(ClonesCurrentFile duplicates);
data ClonesCurrentFile = clonesCurrentFile(set[loc] clones);
//data AllClones = allClones(map[str, set[loc]] cloneLocationsPerFile);
data OtherFile = otherFile(str fileName);

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
	tmp = |project:///|;
	tmp.authority = s.authority;
 	detectClones(tmp);
}

private start[CompilationUnit] abc(str x, loc l) {
	parseTree = parse(#start[CompilationUnit], x, l) ;
	return parseTree; 
}

private Tree annotateModule(Tree t) {
	currentLocation = t@\loc;
	//iprintln(t);
	location = |project://example/src/HelloWorld2.java|(0,0,<1,0>,<1,0>);
	visit(t) {
		case node x:
			if("loc" in getAnnotations(x) && x@\loc == location) {
				println("!!!");
			}
	}
	
	set[node] clonesInFile = clonesPerFile[currentLocation.path];
	set[Message] messages = {info(getLocation(sibling).path , getLocation(clone)) | clone <- clonesInFile, siblings <- getSiblings(clone, range(cloneMap)), sibling <- siblings};
	//map[loc, str] documentation = (getLocation(clone): "documentation" | clone <- clonesInFile);
	t@\messages = messages;
	t@\links = mapper(clonesInFile, getLocation);
	return t;
}

private node outlinerModule(Tree t) {
	println("outlining");
	currentLocation = t@\loc;
	
	clonesInFile = clonesCurrentFile(mapper(clonesPerFile[currentLocation.path], getLocation));
	clonesInFile@label = "Clones detected in this file:";
	customTree = TreeRoot(clonesInFile);
	
	return customTree;
}