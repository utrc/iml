package com.utc.utrc.hermes.iml.generator.infra;

import java.util.List;

import com.utc.utrc.hermes.iml.generator.infra.SExpr.Seq;
import com.utc.utrc.hermes.iml.generator.infra.SExpr.Token;

public class SExprTokens {

	public static SExpr.Token<String> EXCLAMATION_POINT = new SExpr.Token<String>("!") ;
	public static SExpr.Token<String> DECLARE_SORT = new SExpr.Token<String>("declare-sort") ;
	public static SExpr.Token<String> DECLARE_DATATYPE = new SExpr.Token<String>("declare-datatype") ;

	public static SExpr.Token<String> DECLARE_FUN = new SExpr.Token<String>("declare-fun") ;
	public static SExpr.Token<String> HOT_ARROW = new SExpr.Token<String>("~>") ;

	public static SExpr.Token<String> REC_CONS = new SExpr.Token<String>("rec") ;
	public static SExpr.Token<String> META = new SExpr.Token<String>(":meta") ;
	public static SExpr.Token<String> TYPE = new SExpr.Token<String>(":type") ;

	public static SExpr.Token<String> ASSERT = new SExpr.Token<String>("assert") ;
	
	public static void addToSequence(Seq s, SExpr e) {
		s.sexprs.add(e);
	}
	
	public static void addToSequence(Seq s, SExpr ... e) {
		for(int i = 0 ; i < e.length ; i++) {
			s.sexprs.add(e[i]);
		}
	}
	
	public static Seq createSequence() {
		return new Seq() ;
	}
	public static Seq createSequence(List<SExpr> s) {
		return new Seq(s);
	}
	public static Seq createSequence(SExpr ... e) {
		Seq retval = new Seq();
		for(int i = 0 ; i < e.length ; i++) {
			retval.sexprs.add(e[i]);
		}
		return retval;
	}
	
	public static Token<String> createToken(String s) {
		return new Token<String>(s);
	}
	public static Token<Integer> createToken(int s) {
		return new Token<Integer>(s);
	}
	


}
