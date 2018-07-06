package com.utc.utrc.hermes.iml.generator.infra;

import java.util.List;

import com.utc.utrc.hermes.iml.iml.Symbol;
import com.utc.utrc.hermes.iml.sexpr.SExpr.Seq;

public class EncodedSymbol {

	private SrlSymbol symbol;
	private List<Seq> encoding;

	public EncodedSymbol(SrlSymbol s, List<Seq> e) {
		symbol = s;
		encoding = e;
	}

	public SrlSymbol getSymbol() {
		return symbol;
	}

	public void setSymbol(SrlSymbol symbol) {
		this.symbol = symbol;
	}

	public List<Seq> getEncoding() {
		return encoding;
	}

	public void setEncoding(List<Seq> encoding) {
		this.encoding = encoding;
	}

}
