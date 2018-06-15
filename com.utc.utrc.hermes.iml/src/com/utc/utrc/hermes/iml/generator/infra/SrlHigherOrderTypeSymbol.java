package com.utc.utrc.hermes.iml.generator.infra;

import java.util.ArrayList;
import java.util.List;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.naming.IQualifiedNameProvider;

import com.utc.utrc.hermes.iml.iml.HigherOrderType;
import com.utc.utrc.hermes.iml.typing.TypingServices;

public class SrlHigherOrderTypeSymbol extends SrlTypeSymbol {

	private SrlTypeSymbol domain ;
	private SrlTypeSymbol range ;
	private List<SrlTerm> dimensions ;
	private List<SrlObjectSymbol> tupleElements ;
	private List<SrlTypeSymbol> bindings ;

	public SrlHigherOrderTypeSymbol(IQualifiedNameProvider qnp) {
		super(qnp);
		domain = null ;
		range = null ;
		dimensions = new ArrayList<SrlTerm>();
		tupleElements = new ArrayList<>();
		bindings = new ArrayList<>();
	}
	
	public SrlSymbol getDomain() {
		return domain;
	}

	public void setDomain(SrlTypeSymbol domain) {
		this.domain = domain;
	}

	public SrlSymbol getRange() {
		return range;
	}

	public void setRange(SrlTypeSymbol range) {
		this.range = range;
	}

	public List<SrlTerm> getDimensions() {
		return dimensions;
	}

	public List<SrlObjectSymbol> getTupleElements() {
		return tupleElements;
	}

	public List<SrlTypeSymbol> getBindings() {
		return bindings;
	}

	public boolean isHigherOrder() {
		return (range != null) ;
	}
	public boolean isArray() {
		return (dimensions.size() > 0);
	}
	public boolean isTuple() {
		return (tupleElements.size() > 0);
	}
	
}
