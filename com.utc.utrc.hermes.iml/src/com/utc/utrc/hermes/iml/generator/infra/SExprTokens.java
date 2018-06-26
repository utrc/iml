package com.utc.utrc.hermes.iml.generator.infra;

import java.util.List;

import com.utc.utrc.hermes.iml.generator.infra.SExpr.Seq;
import com.utc.utrc.hermes.iml.generator.infra.SExpr.Token;

public class SExprTokens {

	public static SExpr.Token<String> OPEN_PARANTHESIS = new SExpr.Token<String>("(") ;
	public static SExpr.Token<String> CLOSE_PARANTHESIS = new SExpr.Token<String>(")") ;
	public static SExpr.Token<String> EXCLAMATION_POINT = new SExpr.Token<String>("!") ;
	public static SExpr.Token<String> DECLARE_SORT = new SExpr.Token<String>("declare-sort") ;
	public static SExpr.Token<String> DECLARE_DATATYPE = new SExpr.Token<String>("declare-datatype") ;
//<<<<<<< HEAD

	public static SExpr.Token<String> DECLARE_FUN = new SExpr.Token<String>("declare-fun") ;
	public static SExpr.Token<String> DEFINE_FUN = new SExpr.Token<String>("define-fun") ;
	public static SExpr.Token<String> HOT_ARROW = new SExpr.Token<String>("~>") ;

//=======
	public static SExpr.Token<String> DECLARE_DATATYPES = new SExpr.Token<String>("declare-datatypes") ;
//>>>>>>> master
	public static SExpr.Token<String> REC_CONS = new SExpr.Token<String>("rec") ;
	public static SExpr.Token<String> ASSERT = new SExpr.Token<String>("assert") ;
	public static SExpr.Token<String> FOR_ALL = new SExpr.Token<String>("forall") ;
	public static SExpr.Token<String> META = new SExpr.Token<String>(":meta") ;
	public static SExpr.Token<String> TYPE = new SExpr.Token<String>(":type") ;
//<<<<<<< HEAD
//
//	public static SExpr.Token<String> ASSERT = new SExpr.Token<String>("assert") ;
//=======
	public static SExpr.Token<String> DEFINES = new SExpr.Token<String>(":defines") ;
	public static SExpr.Token<String> EQ = new SExpr.Token<String>("=") ;
	public static SExpr.Token<String> NOT = new SExpr.Token<String>("not") ;
	public static SExpr.Token<String> NEG = new SExpr.Token<String>("neg") ;

	public static SExpr.Token<String> EXISTS = new SExpr.Token<String>("exists") ;
	
	
	public static SExpr.Token<String> AND = new SExpr.Token<String>("and") ;
	public static SExpr.Token<String> OR = new SExpr.Token<String>("or") ;
	
	public static SExpr.Token<String> GREATER = new SExpr.Token<String>(">") ;
	public static SExpr.Token<String> SMALLER = new SExpr.Token<String>("<") ;
	public static SExpr.Token<String> GREATEREQ = new SExpr.Token<String>(">=") ;
	public static SExpr.Token<String> SMALLEREQ = new SExpr.Token<String>("<=") ;
	public static SExpr.Token<String> TRUE = new SExpr.Token<String>("true") ;
	
	//>>>>>>> master
	
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
	public static Token<Float> createToken(float s) {
		return new Token<Float>(s);
	}
	public static Token<Boolean> createToken(boolean s) {
		return new Token<Boolean>(s);
	}
	
	


}
