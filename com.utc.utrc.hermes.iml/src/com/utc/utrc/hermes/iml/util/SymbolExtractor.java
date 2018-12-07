package com.utc.utrc.hermes.iml.util;

import java.util.ArrayList;
import java.util.List;

import com.utc.utrc.hermes.iml.iml.FolFormula;
import com.utc.utrc.hermes.iml.iml.Symbol;
import com.utc.utrc.hermes.iml.iml.SymbolReferenceTerm;
import com.utc.utrc.hermes.iml.iml.TermExpression;
import com.utc.utrc.hermes.iml.iml.TermMemberSelection;

/**
 * @author Alessandro Pinto (pintoa@utrc.utc.com)
 * 
 */
public class SymbolExtractor {
	
	static private class TermVisitor extends AbstractModelVisitor {
		private List<Symbol> symbols ;
		public TermVisitor() {
			symbols = new ArrayList<>();
		}
		
		@Override
		public void visit(SymbolReferenceTerm e) {
			symbols.add(e.getSymbol());
		}
		
		public List<Symbol> getSymbols(){
			return symbols;
		}
		
		
	}
	
	static private class TermAcceptor extends AbstractModelAcceptor {
		public TermAcceptor() {
			// TODO Auto-generated constructor stub
		}
	}
	
	
	
	public static List<Symbol> extractFrom(FolFormula f) {
		TermAcceptor acceptor = new TermAcceptor();
		TermVisitor visitor = new TermVisitor() ;
		acceptor.accept(f, visitor);
		return visitor.getSymbols();
		
	}
	
}
