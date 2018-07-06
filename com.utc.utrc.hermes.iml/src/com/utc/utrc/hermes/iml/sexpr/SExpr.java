package com.utc.utrc.hermes.iml.sexpr;

import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

// TODO need major refactoring

/** This is the root class for S-expressions in the concrete syntax */
public abstract class SExpr {

	/** The class corresponding to sequences of S-expressions */
	public static class Seq extends SExpr {
		protected List<SExpr> sexprs;

		public Seq() {
			this.sexprs = new LinkedList<SExpr>();
		}

		public Seq(List<SExpr> sexprs) {
			this.sexprs = sexprs;
		}

		public List<SExpr> sexprs() {
			return sexprs;
		}
		
		public void add(SExpr ... e) {
			for(int i = 0 ; i < e.length ; i++) {
				sexprs.add(e[i]);
			}
		}

		@Override
		public String toString() {
			StringBuilder sb = new StringBuilder();
			Iterator<? extends SExpr> iter = sexprs.iterator();
			sb.append("( ");
			while (iter.hasNext()) {
				SExpr testMe = iter.next();
				sb.append(testMe.toString());
				sb.append(" ");
			}
			sb.append(")");
			return sb.toString();
		}

		public String kind() {
			return "sequence";
		}

	}

	/** Represents a single S-expression token with intrinsic type T */
	public static class Token<T> extends SExpr {
		protected T value;

		public Token(T value) {
			this.value = value;
		}

		public T value() {
			return value;
		}

		/** For debugging - for real printing use a Printer */
		@Override
		public String toString() {
			return value.toString();
		}
		
		public String kind() {
			return "token";
		}

	}

	

}