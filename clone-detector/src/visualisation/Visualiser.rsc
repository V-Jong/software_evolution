module visualisation::Visualiser

import vis::Figure;
import vis::Render;
import vis::KeySym;

public void main() {
	s = "";
	b = box(text(str () { return s; }), fillColor("red"), shrink(0.5), onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
		s = "<butnr>";
		return true;
	}));
	render(b);
//	render(tree());
}

public Figure inc(){
	int n = 0;
	return vcat([ button("Increment", void(){n += 1;}),
	              text(str(){return "<n>";})
	              ]);
}

public Figure check(){
	bool state = false;
	return vcat([ checkbox("Check me", void(bool s){ state = s;}),
	              text(str(){return "I am " + (state ? "checked" : "unchecked");}, left())
	              ]);
}

public Figure scaledbox(){
	int n = 100;
	return vcat([ hcat([ scaleSlider(int() { return 0; },     
			int () { return 200; },  
			int () { return n; },    
			void (int s) { n = s; }, 
			width(200)),
	                     text(str () { return "n: <n>";})
	                     ], left(),  top(), resizable(false)),  
	              computeFigure(Figure (){ return box(size(n), resizable(false)); })
	              ]);
}

public Figure tree() {
	return tree(ellipse(size(30), fillColor("green")),
			[ tree(ellipse(size(45), fillColor("red")),
					[ ellipse(size(60), fillColor("blue")),
					  ellipse(size(75), fillColor("purple"))
					  ]),
			  tree(ellipse(size(90), fillColor("lightblue")),
					  [ box(size(30), fillColor("orange")),
					    box(size(30), fillColor("brown")),
					    box(size(30), fillColor("grey")),
					    ellipse(size(30), fillColor("white"))
					    ]),
			  box(size(30), fillColor("black"))
			  ],
			std(gap(30)));
}