package com.utc.utrc.hermes.iml.generator.infra;

import java.util.List;

import com.utc.utrc.hermes.iml.generator.infra.SExpr.Seq;
import com.utc.utrc.hermes.iml.iml.Symbol;

public class EncodedSymbol {

	private SrlSymbol symbol;
	private SExpr encoding ;
//	private List<Seq> encoding;

	public EncodedSymbol(SrlSymbol s, SExpr e) {
//	public EncodedSymbol(SrlSymbol s, List<Seq> e) {
		symbol = s;
		encoding = e;
	}

	public SrlSymbol getSymbol() {
		return symbol;
	}

	public void setSymbol(SrlSymbol symbol) {
		this.symbol = symbol;
	}

	public SExpr getEncoding() {
//	public List<Seq> getEncoding() {
		return encoding;
	}

	public void setEncoding(SExpr encoding) {
//	public void setEncoding(List<Seq> encoding) {
		this.encoding = encoding;
	}

}
