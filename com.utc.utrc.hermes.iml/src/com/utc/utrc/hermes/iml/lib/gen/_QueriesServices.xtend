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
import com.utc.utrc.hermes.iml.iml.TypeWithProperties
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference

@Singleton
class _QueriesServices extends BasicServices
 {
	public static final String PACKAGE_NAME = "iml.queries"
	public static final String QUERYFORALL_SYMBOL = "queryForall"	
	public static final String QUERYEXISTS_SYMBOL = "queryExists"	
	public static final String QUERY = "Query"	
	public static final String MAX_SYMBOL = "max"	
	public static final String SAT_SYMBOL = "sat"	
	public static final String VALID_SYMBOL = "valid"	
	public static final String RELATIONALPROPERTY = "RelationalProperty"	
	public static final String MIN_SYMBOL = "min"	
	public static final String QUERYFUNCTION = "QueryFunction"	
	public static final String RQUERYFE_SYMBOL = "RqueryFE"	
	public static final String METRIC = "Metric"	
	public static final String RQUERYFF_SYMBOL = "RqueryFF"	
	public static final String RQUERYEE_SYMBOL = "RqueryEE"	
	public static final String RQUERYEF_SYMBOL = "RqueryEF"	
	public static final String PROPERTY = "Property"	
	
	/**
	 * Get QueryForallSymbol symbol declaration
	 */
	 def getQueryForallSymbol() {
	 	return getSymbolDeclaration(QUERYFORALL_SYMBOL)
	 }
	/**
	 * Get QueryExistsSymbol symbol declaration
	 */
	 def getQueryExistsSymbol() {
	 	return getSymbolDeclaration(QUERYEXISTS_SYMBOL)
	 }
	/**
	 * get Query annotation declaration
	 */
	def getQueryAnnotation() {
		return getAnnotation(QUERY)
	}
	
	/**
	 * check whether the given type is Query annotation
	 */
	def isQuery(NamedType annotation) {
		return getQueryAnnotation == annotation
	}
	
	/**
	 * check whether the given symbol is annotated with Query annotation
	 */
	def hasQueryAnnotation(Symbol symbol) {
		if (symbol.propertylist !== null) {
			return symbol.propertylist.properties.map[(it.ref as SimpleTypeReference).type].contains(getQueryAnnotation())	
		}
		return false;
	}
	
	/**
	 * check whether the given type is annotated with Query annotation
	 */
	def hasQueryAnnotation(TypeWithProperties type) {
		if (type.properties !== null) {
			return type.properties.properties.map[(it.ref as SimpleTypeReference).type].contains(getQueryAnnotation())	
		}
		return false;
	}
	
	/**
	 * Get all symbols inside the given type that has the Query annotation. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getQuerySymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithProperty(type, getQueryAnnotation, recursive);
	}		
	
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
	 * Get ValidSymbol symbol declaration
	 */
	 def getValidSymbol() {
	 	return getSymbolDeclaration(VALID_SYMBOL)
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
	 * get QueryFunction annotation declaration
	 */
	def getQueryFunctionAnnotation() {
		return getAnnotation(QUERYFUNCTION)
	}
	
	/**
	 * check whether the given type is QueryFunction annotation
	 */
	def isQueryFunction(NamedType annotation) {
		return getQueryFunctionAnnotation == annotation
	}
	
	/**
	 * check whether the given symbol is annotated with QueryFunction annotation
	 */
	def hasQueryFunctionAnnotation(Symbol symbol) {
		if (symbol.propertylist !== null) {
			return symbol.propertylist.properties.map[(it.ref as SimpleTypeReference).type].contains(getQueryFunctionAnnotation())	
		}
		return false;
	}
	
	/**
	 * check whether the given type is annotated with QueryFunction annotation
	 */
	def hasQueryFunctionAnnotation(TypeWithProperties type) {
		if (type.properties !== null) {
			return type.properties.properties.map[(it.ref as SimpleTypeReference).type].contains(getQueryFunctionAnnotation())	
		}
		return false;
	}
	
	/**
	 * Get all symbols inside the given type that has the QueryFunction annotation. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getQueryFunctionSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithProperty(type, getQueryFunctionAnnotation, recursive);
	}		
	
	/**
	 * Get RqueryFESymbol symbol declaration
	 */
	 def getRqueryFESymbol() {
	 	return getSymbolDeclaration(RQUERYFE_SYMBOL)
	 }
	/**
	 * get Metric type declaration
	 */
	def getMetricType() {
		return getType(METRIC)
	}
	
	/**
	 * check whether the given type is Metric type
	 */
	def isMetric(NamedType type) {
		return getMetricType == type
	}
	
	/**
	 * Get all symbols inside the given type that are Metric type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getMetricSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getMetricType, recursive)
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
