package com.utc.utrc.hermes.iml.generator.infra;

import org.eclipse.xtext.naming.IQualifiedNameProvider;

import com.utc.utrc.hermes.iml.iml.FolFormula;
import com.utc.utrc.hermes.iml.iml.SymbolReferenceTerm;

public class SrlTerm extends SrlSymbol {
	
	private SrlTerm left;
	private SrlTerm right;
	private SrlOperator op;
	
	private FolFormula formula;

	public SrlTerm(IQualifiedNameProvider qnp) {
		super(qnp);
	}
	
//	public SrlObjectSymbol getSrlObjectOf(SymbolReferenceTerm symbolRef) {
//		
//	}

	public FolFormula getFormula() {
		return formula;
	}

	public void setFormula(FolFormula formula) {
		this.formula = formula;
	}
	
}
