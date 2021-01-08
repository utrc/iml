/*
 * Auto-Generated, please don't modify. Add your own logic to the child class {@link com.utc.utrc.hermes.iml.lib.LtlServices} instead
 */
package com.utc.utrc.hermes.iml.lib.gen

import com.google.inject.Singleton
import com.google.inject.Inject
import org.eclipse.emf.ecore.EObject
import com.utc.utrc.hermes.iml.iml.Trait
import com.utc.utrc.hermes.iml.iml.NamedType
import com.utc.utrc.hermes.iml.util.ImlUtil
import com.utc.utrc.hermes.iml.lib.BasicServices
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration
import com.utc.utrc.hermes.iml.iml.Model
import com.utc.utrc.hermes.iml.iml.Symbol

@Singleton
class _LtlServices extends BasicServices
 {
	public static final String PACKAGE_NAME = "iml.ltl"
	public static final String A_SYMBOL = "A"	
	public static final String B_SYMBOL = "B"	
	public static final String LTLU_SYMBOL = "ltlU"	
	public static final String LTLFORMULA = "LtlFormula"	
	public static final String LTLX_SYMBOL = "ltlX"	
	public static final String F_SYMBOL = "f"	
	public static final String MYSTATE = "MyState"	
	public static final String MYSTATE_REQUEST_VAR = "request"
	public static final String MYSTATE_RESPONSE_VAR = "response"
	public static final String G_SYMBOL = "g"	
	public static final String REQUEST_SYMBOL = "Request"	
	public static final String LTLNOT_SYMBOL = "ltlNot"	
	public static final String LTLOR_SYMBOL = "ltlOr"	
	public static final String LTLF_SYMBOL = "ltlF"	
	public static final String RESPONSE_SYMBOL = "Response"	
	public static final String LTLATOM_SYMBOL = "ltlAtom"	
	public static final String LTLG_SYMBOL = "ltlG"	
	public static final String LTLIMPLIES_SYMBOL = "ltlImplies"	
	public static final String LTLAND_SYMBOL = "ltlAnd"	
	public static final String LTLTRUE_SYMBOL = "ltlTrue"	
	public static final String INTSTATE = "IntState"	
	
	/**
	 * Get ASymbol symbol declaration
	 */
	 def getASymbol() {
	 	return getSymbolDeclaration(A_SYMBOL)
	 }
	/**
	 * Get BSymbol symbol declaration
	 */
	 def getBSymbol() {
	 	return getSymbolDeclaration(B_SYMBOL)
	 }
	/**
	 * Get LtlUSymbol symbol declaration
	 */
	 def getLtlUSymbol() {
	 	return getSymbolDeclaration(LTLU_SYMBOL)
	 }
	/**
	 * get LtlFormula type declaration
	 */
	def getLtlFormulaType() {
		return getType(LTLFORMULA)
	}
	
	/**
	 * check whether the given type is LtlFormula type
	 */
	def isLtlFormula(NamedType type) {
		return getLtlFormulaType == type
	}
	
	/**
	 * Get all symbols inside the given type that are LtlFormula type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getLtlFormulaSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getLtlFormulaType, recursive)
	}
	/**
	 * Get LtlXSymbol symbol declaration
	 */
	 def getLtlXSymbol() {
	 	return getSymbolDeclaration(LTLX_SYMBOL)
	 }
	/**
	 * Get FSymbol symbol declaration
	 */
	 def getFSymbol() {
	 	return getSymbolDeclaration(F_SYMBOL)
	 }
	/**
	 * get MyState type declaration
	 */
	def getMyStateType() {
		return getType(MYSTATE)
	}
	
	/**
	 * check whether the given type is MyState type
	 */
	def isMyState(NamedType type) {
		return getMyStateType == type
	}
	
	/**
	 * Get all symbols inside the given type that are MyState type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getMyStateSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getMyStateType, recursive)
	}
	/**
	 * Get the request symbol declaration inside the given MyState type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getMyStateRequestVar() {
		return ImlUtil.findSymbol(getType(MYSTATE), MYSTATE_REQUEST_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the response symbol declaration inside the given MyState type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getMyStateResponseVar() {
		return ImlUtil.findSymbol(getType(MYSTATE), MYSTATE_RESPONSE_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get GSymbol symbol declaration
	 */
	 def getGSymbol() {
	 	return getSymbolDeclaration(G_SYMBOL)
	 }
	/**
	 * Get RequestSymbol symbol declaration
	 */
	 def getRequestSymbol() {
	 	return getSymbolDeclaration(REQUEST_SYMBOL)
	 }
	/**
	 * Get LtlNotSymbol symbol declaration
	 */
	 def getLtlNotSymbol() {
	 	return getSymbolDeclaration(LTLNOT_SYMBOL)
	 }
	/**
	 * Get LtlOrSymbol symbol declaration
	 */
	 def getLtlOrSymbol() {
	 	return getSymbolDeclaration(LTLOR_SYMBOL)
	 }
	/**
	 * Get LtlFSymbol symbol declaration
	 */
	 def getLtlFSymbol() {
	 	return getSymbolDeclaration(LTLF_SYMBOL)
	 }
	/**
	 * Get ResponseSymbol symbol declaration
	 */
	 def getResponseSymbol() {
	 	return getSymbolDeclaration(RESPONSE_SYMBOL)
	 }
	/**
	 * Get LtlAtomSymbol symbol declaration
	 */
	 def getLtlAtomSymbol() {
	 	return getSymbolDeclaration(LTLATOM_SYMBOL)
	 }
	/**
	 * Get LtlGSymbol symbol declaration
	 */
	 def getLtlGSymbol() {
	 	return getSymbolDeclaration(LTLG_SYMBOL)
	 }
	/**
	 * Get LtlImpliesSymbol symbol declaration
	 */
	 def getLtlImpliesSymbol() {
	 	return getSymbolDeclaration(LTLIMPLIES_SYMBOL)
	 }
	/**
	 * Get LtlAndSymbol symbol declaration
	 */
	 def getLtlAndSymbol() {
	 	return getSymbolDeclaration(LTLAND_SYMBOL)
	 }
	/**
	 * Get LtlTrueSymbol symbol declaration
	 */
	 def getLtlTrueSymbol() {
	 	return getSymbolDeclaration(LTLTRUE_SYMBOL)
	 }
	/**
	 * get IntState type declaration
	 */
	def getIntStateType() {
		return getType(INTSTATE)
	}
	
	/**
	 * check whether the given type is IntState type
	 */
	def isIntState(NamedType type) {
		return getIntStateType == type
	}
	
	/**
	 * Get all symbols inside the given type that are IntState type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getIntStateSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getIntStateType, recursive)
	}
	
	override getPackageName() {
		PACKAGE_NAME
	}
	
	/**
	 * Checks if a symbol is defined inside Ltl IML library
	 */
	def isLtlSymbol(Symbol symbol) {
		if (symbol !== null) {
			val containerModel = ImlUtil.getContainerOfType(symbol, Model)
			if (containerModel.name == getPackageName()) {
				return true;
			}
		}
		return false;
	}
}
