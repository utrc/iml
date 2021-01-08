/*
 * Auto-Generated, please don't modify. Add your own logic to the child class {@link com.utc.utrc.hermes.iml.lib.QueriesServices} instead
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
class _QueriesServices extends BasicServices
 {
	public static final String PACKAGE_NAME = "iml.queries"
	public static final String MAX_SYMBOL = "max"	
	public static final String SAT_SYMBOL = "sat"	
	public static final String PROBABILITY = "Probability"	
	public static final String PROBABILITY_VALUE_VAR = "value"
	public static final String QUERYE_SYMBOL = "queryE"	
	public static final String QUERYF_SYMBOL = "queryF"	
	public static final String PRBABILISTICPROPERTY = "PrbabilisticProperty"	
	public static final String RELATIONALPROPERTY = "RelationalProperty"	
	public static final String MIN_SYMBOL = "min"	
	public static final String PROBOF_SYMBOL = "probOf"	
	public static final String RELATIONALPROBABILISTICPROPERTY = "RelationalProbabilisticProperty"	
	public static final String RQUERYFE_SYMBOL = "RqueryFE"	
	public static final String RQUERYFF_SYMBOL = "RqueryFF"	
	public static final String RQUERYEE_SYMBOL = "RqueryEE"	
	public static final String RQUERYEF_SYMBOL = "RqueryEF"	
	public static final String PROPERTY = "Property"	
	public static final String PQUERY_GE_SYMBOL = "Pquery_ge"	
	
	/**
	 * Get MaxSymbol symbol declaration
	 */
	 def getMaxSymbol() {
	 	return getSymbolDeclaration(MAX_SYMBOL)
	 }
	/**
	 * Get SatSymbol symbol declaration
	 */
	 def getSatSymbol() {
	 	return getSymbolDeclaration(SAT_SYMBOL)
	 }
	/**
	 * get Probability type declaration
	 */
	def getProbabilityType() {
		return getType(PROBABILITY)
	}
	
	/**
	 * check whether the given type is Probability type
	 */
	def isProbability(NamedType type) {
		return getProbabilityType == type
	}
	
	/**
	 * Get all symbols inside the given type that are Probability type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getProbabilitySymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getProbabilityType, recursive)
	}
	/**
	 * Get the value symbol declaration inside the given Probability type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getProbabilityValueVar() {
		return ImlUtil.findSymbol(getType(PROBABILITY), PROBABILITY_VALUE_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get QueryESymbol symbol declaration
	 */
	 def getQueryESymbol() {
	 	return getSymbolDeclaration(QUERYE_SYMBOL)
	 }
	/**
	 * Get QueryFSymbol symbol declaration
	 */
	 def getQueryFSymbol() {
	 	return getSymbolDeclaration(QUERYF_SYMBOL)
	 }
	/**
	 * get PrbabilisticProperty type declaration
	 */
	def getPrbabilisticPropertyType() {
		return getType(PRBABILISTICPROPERTY)
	}
	
	/**
	 * check whether the given type is PrbabilisticProperty type
	 */
	def isPrbabilisticProperty(NamedType type) {
		return getPrbabilisticPropertyType == type
	}
	
	/**
	 * Get all symbols inside the given type that are PrbabilisticProperty type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getPrbabilisticPropertySymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getPrbabilisticPropertyType, recursive)
	}
	/**
	 * get RelationalProperty type declaration
	 */
	def getRelationalPropertyType() {
		return getType(RELATIONALPROPERTY)
	}
	
	/**
	 * check whether the given type is RelationalProperty type
	 */
	def isRelationalProperty(NamedType type) {
		return getRelationalPropertyType == type
	}
	
	/**
	 * Get all symbols inside the given type that are RelationalProperty type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getRelationalPropertySymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getRelationalPropertyType, recursive)
	}
	/**
	 * Get MinSymbol symbol declaration
	 */
	 def getMinSymbol() {
	 	return getSymbolDeclaration(MIN_SYMBOL)
	 }
	/**
	 * Get ProbOfSymbol symbol declaration
	 */
	 def getProbOfSymbol() {
	 	return getSymbolDeclaration(PROBOF_SYMBOL)
	 }
	/**
	 * get RelationalProbabilisticProperty type declaration
	 */
	def getRelationalProbabilisticPropertyType() {
		return getType(RELATIONALPROBABILISTICPROPERTY)
	}
	
	/**
	 * check whether the given type is RelationalProbabilisticProperty type
	 */
	def isRelationalProbabilisticProperty(NamedType type) {
		return getRelationalProbabilisticPropertyType == type
	}
	
	/**
	 * Get all symbols inside the given type that are RelationalProbabilisticProperty type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getRelationalProbabilisticPropertySymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getRelationalProbabilisticPropertyType, recursive)
	}
	/**
	 * Get RqueryFESymbol symbol declaration
	 */
	 def getRqueryFESymbol() {
	 	return getSymbolDeclaration(RQUERYFE_SYMBOL)
	 }
	/**
	 * Get RqueryFFSymbol symbol declaration
	 */
	 def getRqueryFFSymbol() {
	 	return getSymbolDeclaration(RQUERYFF_SYMBOL)
	 }
	/**
	 * Get RqueryEESymbol symbol declaration
	 */
	 def getRqueryEESymbol() {
	 	return getSymbolDeclaration(RQUERYEE_SYMBOL)
	 }
	/**
	 * Get RqueryEFSymbol symbol declaration
	 */
	 def getRqueryEFSymbol() {
	 	return getSymbolDeclaration(RQUERYEF_SYMBOL)
	 }
	/**
	 * get Property type declaration
	 */
	def getPropertyType() {
		return getType(PROPERTY)
	}
	
	/**
	 * check whether the given type is Property type
	 */
	def isProperty(NamedType type) {
		return getPropertyType == type
	}
	
	/**
	 * Get all symbols inside the given type that are Property type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getPropertySymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getPropertyType, recursive)
	}
	/**
	 * Get Pquery_geSymbol symbol declaration
	 */
	 def getPquery_geSymbol() {
	 	return getSymbolDeclaration(PQUERY_GE_SYMBOL)
	 }
	
	override getPackageName() {
		PACKAGE_NAME
	}
	
	/**
	 * Checks if a symbol is defined inside Queries IML library
	 */
	def isQueriesSymbol(Symbol symbol) {
		if (symbol !== null) {
			val containerModel = ImlUtil.getContainerOfType(symbol, Model)
			if (containerModel.name == getPackageName()) {
				return true;
			}
		}
		return false;
	}
}
