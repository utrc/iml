package com.utc.utrc.hermes.iml.encoding;

public enum OperatorType {
	IMPL("=>", "=>"),
	EQUIV("<=>", null), FOR_ALL("forall", "forall"), EXISTS("exists", null), 
	AND("&&", "and"), OR("||", "or"), NOT("!", "not"), NEGATIVE("-", "-")
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
