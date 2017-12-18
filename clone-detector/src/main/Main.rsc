module main::Main

import List;
import Node;
import Set;
import Map;

import IO;

import util::Math;

import main::LinesOfCode;
import main::lib::SetHelpers;
import main::lib::PrintHelpers;
import main::Logger;

import main::Config;
import visualisation::Visualiser;

import lang::java::m3::AST;
import lang::java::jdt::m3::Core;

public map[str, set[node]] clonesPerFile = ();
public map[node, set[node]] cloneMap = ();

public void detectClones(loc project) {
	println("Running clone detection for <project>");
	M3 model = createM3FromEclipseProject(project);
	
	println("Creating AST\'s for project files");
	
	set[loc] projectFiles = files(model);
	set[Declaration] fileAsts = createAstsFromFiles(projectFiles);
	
	totalLOC = totalLOCForProjectAst(fileAsts);

	println("Searching for subtrees");
	
	set[node] subtrees = findSubtrees(fileAsts);

//	set[node] normalisedSubtrees = normaliseNodes(subtrees);

	println("Searching type 1 clones");
	
	type1Clones = findClonesForTree(subtrees);
//	type2Clones = findClonesForTree(normalisedSubtrees);

	clonesPerFile = getClonesPerFile(type1Clones);
	println("Finished clone detection");

//	printCloneClasses(type1Clones);
//
//    printClonesReport(type1Clones, totalLOC);
//
//    printCloneClasses(type2Clones);
//
//    printClonesReport(type2Clones, totalLOC);
	
	logClones(LOG_FILE, type1Clones);
    
    getFileVisualisations(cloneLocationsPerFile, project);
}

private map[node, set[node]] findClonesForTree(set[node] tree) {
	map[node, set[node]] groupedByNormalisedAst = classify(tree, unsetRec);
	map[node, set[node]] cloneClasses = filterNonDuplicates(groupedByNormalisedAst);
	map[node, set[node]] noSubsumptedCloneClasses = dropSubsumptedCloneClasses(cloneClasses);

	clonesPerFile = getClonesPerFile(noSubsumptedCloneClasses);
	cloneMap = noSubsumptedCloneClasses;
	println("Finished clone detection");

	//printCloneClasses(noSubsumptedCloneClasses);

    //printClonesReport(noSubsumptedCloneClasses, totalLOC);

    return noSubsumptedCloneClasses;
}

public set[set[&T]] getSiblings(&T clone, set[set[&T]] cloneClasses) {
	return {cloneClass - clone | cloneClass <- cloneClasses, {clone} < cloneClass};
}

private map[str, set[node]] getClonesPerFile (map[node, set[node]] cloneClasses) {
	allClones = flatten(range(cloneClasses));
	return classify(allClones, getLocationUri);
}

public loc getLocation(node tree) {
	switch (tree) {
		case Declaration x: return x.src;
		case Expression x: return x.src;
		case Statement x: return x.src;
	}
}

private str getLocationUri(node tree) {
	switch (tree) {
		case Declaration x: return x.src.path;
		case Expression x: return x.src.path;
		case Statement x: return x.src.path;
	}
}

public map[&T, set[&T]] filterNonDuplicates(map[&T, set[&T]] grouped) {
	return (group: grouped[group] | group <- grouped, size(grouped[group]) > 1);
}

public map[node, set[node]] dropSubsumptedCloneClasses(map[node, set[node]] cloneClasses) {
	set[set[node]] valuesOnly = range(cloneClasses);
	set[set[node]] cloneClassesChildren = mapper(valuesOnly, findSubtreesNodes);
	
	return (cloneClass: cloneClasses[cloneClass] | cloneClass <- cloneClasses, !isSubsumpted(cloneClasses[cloneClass], cloneClassesChildren));
}

// A subsumpted clone class is a clone class that is strictly included in another
public bool isSubsumpted(set[&T] cloneClass, set[set[&T]] cloneClassesChildren) {
	return any(set[&T] setOfChildren <- cloneClassesChildren, cloneClass < setOfChildren);
}

private set[Declaration] createAstsFromFiles(set[loc] javaFiles) {
	return {createAstFromFile(location, true) | location <- javaFiles};
}

private set[node] findSubtrees(set[Declaration] fileAsts) {
	 return flatten({findSubtrees(ast) | ast <- fileAsts});
}

private set[node] findSubtrees(Declaration fileAst){
	set[node] subtrees = {};
	visit(fileAst.types) {
		case Declaration x: subtrees += x;
		case Expression x: subtrees += x;
		case Statement x: subtrees += x;
	}
	return subtrees;
}

private set[node] findSubtreesNodes(set[node] parents) {
	 return flatten({findSubtreesNode(parent) | parent <- parents});
}

private set[node] findSubtreesNode(node parent) {
	set[node] subtrees = {};
	visit(parent) {
		case node x: subtrees += x;
	}	
	return subtrees - parent;
}

public str standardName() = "Non determinism is bad mmkay";
public str standardValue() = "5";

private set[node] normaliseNodes(set[node] nodes) {
    set[node] result = {};
    normalised = visit (nodes) {
        case x:\method(_, _, _, _, _) => createNormalisedNode(x)
        case x:\variable(_, _) => createNormalisedNode(x)
        case x:\variable(_, _, _) => createNormalisedNode(x)
        case x:\number(_) => createNormalisedNode(x)
        case x:\stringLiteral(_) => createNormalisedNode(x)
        case x:\booleanLiteral(_) => createNormalisedNode(x)
        case Type x => wildcard()
    }
    
    return normalised;
}

private node createNormalisedNode(node original) {
    node newNode;
    switch (original) {
        case x:\method(xRet, _, xParam, xExc, xImpl): {
            newNode = \method(xRet, standardName(), xParam, xExc, xImpl);
        }
        case x:\variable(_, xExtraDims, xInit): {
            newNode = \variable(standardName(), xExtraDims, xInit);
        }
        case x:\variable(_, xExtraDims): {
            newNode = \variable(standardName(), xExtraDims);
        }
        case x:\number(_): {
            newNode = \number(standardValue());
        }
        case x:\stringLiteral(_): {
            newNode = \number(standardValue());
        }
        case x:\booleanLiteral(_): {
            newNode = \number(standardValue());
        }
    }
    newNode.src = getNodeLoc(original);
    return newNode;
}

private loc getNodeLoc(node pNode) {
    loc location = |unknown:///|;
    if (loc l := pNode.src) location = l;
    return location;
}
