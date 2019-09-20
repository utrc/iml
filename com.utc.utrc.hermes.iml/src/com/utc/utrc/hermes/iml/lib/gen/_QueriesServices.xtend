/*
 * Auto-Generated, please don't modify. Add your own logic to the child class {@link com.utc.utrc.hermes.iml.lib.QueriesServices} instead
 */
package com.utc.utrc.hermes.iml.lib.gen

import com.google.inject.Singleton
import com.google.inject.Inject
import com.utc.utrc.hermes.iml.iml.Trait
import com.utc.utrc.hermes.iml.iml.NamedType
import com.utc.utrc.hermes.iml.util.ImlUtil
import com.utc.utrc.hermes.iml.lib.BasicServices
import org.eclipse.emf.ecore.EObject
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration

@Singleton
class _QueriesServices extends BasicServices
 {
	public static final String PACKAGE_NAME = "iml.queries.gen"
	public static final String QUERY_VAR = "query"	
	public static final String PROPERTY = "Property"	
	public static final String PROPERTY_HOLDS_VAR = "holds"
	
	/**
	 * get Property trait declaration
	 */
	def getPropertyTrait() {
		return getTrait(PROPERTY)
	}
	
	/**
	 * check wether the given eObject refines or exhibits the Property trait
	 */
	def isProperty(EObject eObject) {
		return ImlUtil.exhibitsOrRefines(eObject, getPropertyTrait);
	}
	
	/**
	 * Get all symbols inside the given type that exhibits/refines the Property trait. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getPropertySymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithTrait(type, getPropertyTrait, recursive);
	}
	
	/**
	 * Get the holds symbol declaration inside the given Property type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getPropertyHolds(NamedType type, boolean recursive) {
		if (isProperty(type)) {
			return ImlUtil.findSymbol(type, PROPERTY_HOLDS_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	
	override getPackageName() {
		PACKAGE_NAME
	}
}
