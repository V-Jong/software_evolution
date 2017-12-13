module main::IDEIntegration

import util::IDE;
import IO;
import demo::lang::Exp::Concrete::NoLayout::Syntax;
import ParseTree;
import lang::java::\syntax::Java15;

//start syntax ABC = [a-z]+;
//layout Whitespace = [\ \t\n]*;

data DuplicationTree = location(loc location) | duplicateLocations(set[loc] duplicates);


public map[str, set[loc]] duplicationMap = (
	"project://example/src/HelloWorld.java" : {|project://example/src/HelloWorld.java|(0,5,<1,0>,<1,5>), |project://example/src/HelloWorld.java|(19,5,<1,19>,<1,25>)}
);

private start[CompilationUnit] abc(str x, loc l) {
	println("parsingTree");
	return parse(#start[CompilationUnit], x, l); 
}

private Tree annotateModule(Tree t) {
	println("Annotate all the things");
	return t[@doc="Hello!"];
}

public node outlinerModule(Tree t) {
	println("Outline module");
	currentLocation = t@\loc;
	println(currentLocation.uri);
	set[loc] duplicatesInFile = duplicationMap["project://example/src/HelloWorld.java"];
	println(duplicatesInFile);
	return duplicateLocations(duplicatesInFile);
	//return t;
}


public void register() {
	str LANGUAGE_NAME = "abc";
	str FILE_EXTENSION = "java";
	
	clearLanguages();
	clearNonRascalContributions();
	registerLanguage(LANGUAGE_NAME, FILE_EXTENSION, abc);
	println("Registered the language <LANGUAGE_NAME> with file extension <FILE_EXTENSION>");	
	
	registerContributions(LANGUAGE_NAME, {outliner(outlinerModule), annotator(annotateModule)});
	

	println("Registered contributions");
}
