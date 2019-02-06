package com.utc.utrc.hermes.iml.gen.smt.encoding;

import java.util.ArrayList;
import java.util.List;
import java.util.Map.Entry;

import com.utc.utrc.hermes.iml.iml.SimpleTypeReference;
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration;

public class FormulaContext<FormulaT> {
	
	List<Entry<SimpleTypeReference, FormulaT>> context;
	
	public FormulaContext() {
		context = new ArrayList<>();
	}
	
	public SimpleTypeReference getSymbolContext(SymbolDeclaration symbol) {
		return null;
	}
	
	public FormulaT getContextInst(SymbolDeclaration symbol) {
		return null;
	}

}
