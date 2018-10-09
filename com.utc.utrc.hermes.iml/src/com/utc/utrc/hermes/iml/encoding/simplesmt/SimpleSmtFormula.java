package com.utc.utrc.hermes.iml.encoding.simplesmt;

import java.util.List;

import com.utc.utrc.hermes.iml.encoding.OperatorType;

public class SimpleSmtFormula {
	
	private SimpleFunDeclaration funDecl;
	private OperatorType op;
	private List<SimpleSmtFormula> params;
	private Object value;
	
	public SimpleSmtFormula() {
	}

	public SimpleSmtFormula(SimpleFunDeclaration funDecl, OperatorType op, List<SimpleSmtFormula> params, Object value) {
		super();
		this.funDecl = funDecl;
		this.op = op;
		this.params = params;
		this.value = value;
	}
	
	public SimpleSmtFormula(OperatorType op, List<SimpleSmtFormula> params) {
		this.op = op;
		this.params = params;
	}

	public SimpleSmtFormula(Object value) {
		this.value = value;
	}

	public SimpleFunDeclaration getFunDecl() {
		return funDecl;
	}
	public void setFunDecl(SimpleFunDeclaration funDecl) {
		this.funDecl = funDecl;
	}
	public OperatorType getOp() {
		return op;
	}
	public void setOp(OperatorType op) {
		this.op = op;
	}
	public List<SimpleSmtFormula> getParams() {
		return params;
	}
	public void setParams(List<SimpleSmtFormula> params) {
		this.params = params;
	}
	public Object getValue() {
		return value;
	}
	public void setValue(Object value) {
		this.value = value;
	}
	
	

}
