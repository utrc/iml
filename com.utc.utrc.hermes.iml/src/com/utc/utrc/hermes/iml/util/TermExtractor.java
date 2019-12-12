/*
 * Copyright (c) 2019 United Technologies Corporation. All rights reserved.
 * See License.txt in the project root directory for license information. */
package com.utc.utrc.hermes.iml.util;

import java.util.ArrayList;
import java.util.List;

import com.utc.utrc.hermes.iml.iml.FolFormula;
import com.utc.utrc.hermes.iml.iml.SymbolReferenceTerm;
import com.utc.utrc.hermes.iml.iml.TermExpression;
import com.utc.utrc.hermes.iml.iml.TermMemberSelection;

/**
 * @author Alessandro Pinto (pintoa@utrc.utc.com)
 * 
 */
public class TermExtractor {
	
	static private class TermVisitor extends AbstractModelVisitor {
		private List<TermExpression> terms ;
		public TermVisitor() {
			terms = new ArrayList<TermExpression>();
		}
		@Override
		public Object visit(TermMemberSelection e) {
			terms.add(e);
			return null;
		}
		@Override
		public Object visit(SymbolReferenceTerm e) {
			if (! (e.eContainer() instanceof TermMemberSelection)) {
				terms.add(e);
			}
			return null;
		}
		
		public List<TermExpression> getTerms(){
			return terms;
		}
		
		
	}
	
	static private class TermAcceptor extends AbstractModelAcceptor {
		public TermAcceptor() {
			// TODO Auto-generated constructor stub
		}
	}
	
	
	
	public static List<TermExpression> extractFrom(FolFormula f) {
		TermAcceptor acceptor = new TermAcceptor();
		TermVisitor visitor = new TermVisitor() ;
		acceptor.accept(f, visitor);
		return visitor.getTerms();
		
	}
	
}
