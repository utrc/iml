/**
 * This is a custom service class to add user-defined logic.
 */
package com.utc.utrc.hermes.iml.lib

import com.utc.utrc.hermes.iml.lib.gen._QueriesServices
import com.utc.utrc.hermes.iml.iml.Symbol
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration
import com.utc.utrc.hermes.iml.iml.SymbolReferenceTerm
import com.utc.utrc.hermes.iml.util.ImlUtil
import com.utc.utrc.hermes.iml.iml.Model

class QueriesServices extends _QueriesServices {
	
	/**
	 * Check if a symbol has a query in its definition. I.e. if the Symbol.def uses a symbol from Queries library
	 */
	def hasQueryDefinition(Symbol symbol) {
		val symbolDef = getQuerySymbolDef(symbol)
		if (symbolDef === null) return false;
		return isQueriesSymbol(symbolDef.symbol)
	}
	
	def getQuerySymbolDef(Symbol symbol) {
		if (symbol instanceof SymbolDeclaration) {
			if (symbol.definition !== null && symbol.definition.left.left instanceof SymbolReferenceTerm) {
				return symbol.definition.left.left as SymbolReferenceTerm
			}
		}
		return null;
	}
	
}
