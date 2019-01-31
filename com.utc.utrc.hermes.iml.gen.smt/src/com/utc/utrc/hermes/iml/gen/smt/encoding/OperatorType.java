package com.utc.utrc.hermes.iml.gen.smt.encoding;

public enum OperatorType {
	IMPL("=>", "=>"),
	EQUIV("<=>", null), FOR_ALL("forall", "forall"), EXISTS("exists", "exists"),
	AND("&&", "and"), OR("||", "or"), NOT("!", "not"), NEGATIVE("-", "-"),
	GT(">",">"), GTE(">=", ">="), LT("<", "<"), LTE("<=", "<="), EQ("=","="), NEQ("!=", "!="),
	MULT("*", "*"), DIV("/", "/"), REM("%", "%"), ADD("+", "+"), MOF("mod", "%"), ITE("if", "ite") ,
	ASSERT("assert", "assert"), LET("", "let");
	;
	
	private String imlOp;
	private String smtOp;
	private OperatorType(String imlOp, String smtOp) {
		this.imlOp = imlOp;
		this.smtOp = smtOp;
	}
	public String getImlOp() {
		return imlOp;
	}
	
	public String getSmtOp() {
		return smtOp;
	}
	
	public static OperatorType parseOp(String imlOp) {
		for (OperatorType op : values()) {
			if (imlOp != null && imlOp.equals(op.imlOp)) {
				return op;
			}
		}
		return null;
	}
	
}
