/**
 * This is a custom service class to add user-defined logic.
 */
package com.utc.utrc.hermes.iml.lib

import com.utc.utrc.hermes.iml.lib.gen._QueriesServices
import com.utc.utrc.hermes.iml.iml.Symbol
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration
import com.utc.utrc.hermes.iml.iml.SymbolReferenceTerm
import com.utc.utrc.hermes.iml.iml.FolFormula
import com.utc.utrc.hermes.iml.iml.SignedAtomicFormula
import com.utc.utrc.hermes.iml.iml.TailedExpression
import com.utc.utrc.hermes.iml.util.ImlUtil

class QueriesServices extends _QueriesServices {
	
	/**
	 * Check if a symbol has a query in its definition. I.e. if the Symbol.def uses a symbol with [QueryFunction] annotation
	 */
	def hasQueryDefinition(Symbol symbol) {
		if (symbol instanceof SymbolDeclaration) {
			val queryFun = getQueryFromFormula(symbol.definition);
			if (queryFun !== null) {
				return queryFun.hasQueryFunctionAnnotation
			}
		}
		return false;
	}
	
	def SymbolDeclaration getQueryFromFormula(FolFormula query) {
		if (query instanceof SymbolReferenceTerm) {
			if ((query as SymbolReferenceTerm).getSymbol() instanceof SymbolDeclaration) {
				return (query as SymbolReferenceTerm).getSymbol() as SymbolDeclaration;
			} else return null;
		} 
		if (query instanceof SignedAtomicFormula) {
			return getQueryFromFormula(query.getLeft());
		}
		if (query instanceof TailedExpression) {
			return getQueryFromFormula(query.getLeft());
		}
		
		return null;
	}
	
}
