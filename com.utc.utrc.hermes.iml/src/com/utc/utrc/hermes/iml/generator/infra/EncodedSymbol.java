package com.utc.utrc.hermes.iml.generator.infra;

import com.utc.utrc.hermes.iml.iml.Symbol;

public class EncodedSymbol {
	
	private Symbol symbol ;
	private SExpr encoding ;
	
	public EncodedSymbol(Symbol s, SExpr e) {
		symbol = s ;
		encoding = e ;
	}

	public Symbol getSymbol() {
		return symbol;
	}

	public void setSymbol(Symbol symbol) {
		this.symbol = symbol;
	}

	public SExpr getEncoding() {
		return encoding;
	}

	public void setEncoding(SExpr encoding) {
		this.encoding = encoding;
	}
	
	
	
}
