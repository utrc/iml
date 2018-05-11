package com.utc.utrc.hermes.iml.generator.infra;

import com.utc.utrc.hermes.iml.iml.Symbol;

public class EncodedSymbol {
	
	private SrlSymbol symbol ;
	private SExpr encoding ;
	
	public EncodedSymbol(SrlSymbol s, SExpr e) {
		symbol = s ;
		encoding = e ;
	}

	public SrlSymbol getSymbol() {
		return symbol;
	}

	public void setSymbol(SrlSymbol symbol) {
		this.symbol = symbol;
	}

	public SExpr getEncoding() {
		return encoding;
	}

	public void setEncoding(SExpr encoding) {
		this.encoding = encoding;
	}
	
	
	
}
