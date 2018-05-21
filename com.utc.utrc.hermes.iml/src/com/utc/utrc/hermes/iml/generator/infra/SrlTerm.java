package com.utc.utrc.hermes.iml.generator.infra;

import org.eclipse.xtext.naming.IQualifiedNameProvider;

public class SrlTerm extends SrlSymbol {
	
	private SrlTerm left;
	private SrlTerm right;
	private SrlOperator op;

	public SrlTerm(IQualifiedNameProvider qnp) {
		super(qnp);
	}

}
