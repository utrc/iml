/*
 * Copyright (c) 2019 United Technologies Corporation. All rights reserved.
 * See License.txt in the project root directory for license information. */
package com.utc.utrc.hermes.iml.util;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import com.utc.utrc.hermes.iml.iml.Assertion;
import com.utc.utrc.hermes.iml.iml.FolFormula;
import com.utc.utrc.hermes.iml.iml.Symbol;
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration;
import com.utc.utrc.hermes.iml.iml.SymbolReferenceTerm;
import com.utc.utrc.hermes.iml.lib.ImlStdLib;

/**
 * @author Alessandro Pinto (pintoa@utrc.utc.com)
 * 
 */
public class SymbolExtractor {
	
	static private class TermVisitor extends AbstractModelVisitor {
		private Set<Symbol> symbols ;
		public TermVisitor() {
			symbols = new HashSet<>();
		}
		
		@Override
		public Object visit(SymbolReferenceTerm e) {
			symbols.add(e.getSymbol());
			return null;
		}
		
		public Set<Symbol> getSymbols(){
			return symbols;
		}
		
		
	}
	
	static private class TermAcceptor extends AbstractModelAcceptor {
		private ImlStdLib lib;
		
		public TermAcceptor(ImlStdLib lib) {
			this.lib = lib;
		}

		@Override
		public void accept(FolFormula e, IModelVisitor visitor) {
			super.accept(e, visitor);
			if (e instanceof SymbolReferenceTerm && ((SymbolReferenceTerm) e).getSymbol() instanceof SymbolDeclaration) {
				SymbolDeclaration symbol = (SymbolDeclaration) ((SymbolReferenceTerm) e).getSymbol();
				if (lib.isBool(symbol.getType()) && symbol.getDefinition() != null) {
					accept(symbol.getDefinition(), visitor);
				}
			}
		}
	}
	
	
	
	public static Set<Symbol> extractFrom(FolFormula f, ImlStdLib lib) {
		TermAcceptor acceptor = new TermAcceptor(lib);
		TermVisitor visitor = new TermVisitor() ;
		acceptor.accept(f, visitor);
		return visitor.getSymbols();
		
	}
	
}
