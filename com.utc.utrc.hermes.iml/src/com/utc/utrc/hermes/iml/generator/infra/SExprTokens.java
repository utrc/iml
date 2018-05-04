package com.utc.utrc.hermes.iml.generator.infra;

import com.utc.utrc.hermes.iml.generator.infra.SExpr.Token;

public class SExprTokens {

	public static SExpr.Token<String> EXCLAMATION_POINT = new SExpr.Token<String>("!") ;
	public static SExpr.Token<String> DECLARE_SORT = new SExpr.Token<String>("declare-sort") ;
	
	public static SExpr.Token<String> createToken(String s) {
		return new SExpr.Token<String>(s);
	}
	
}
