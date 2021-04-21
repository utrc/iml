/*
 * Auto-Generated, please don't modify. Add your own logic to the child class {@link com.utc.utrc.hermes.iml.lib.GraphsServices} instead
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
class _GraphsServices extends BasicServices
 {
	public static final String PACKAGE_NAME = "iml.graphs"
	public static final String VERTEX = "Vertex"	
	public static final String GRAPH = "Graph"	
	public static final String GRAPH_EDGES_VAR = "edges"
	public static final String EDGE = "Edge"	
	
	/**
	 * get Vertex type declaration
	 */
	def getVertexType() {
		return getType(VERTEX)
	}
	
	/**
	 * check whether the given type is Vertex type
	 */
	def isVertex(NamedType type) {
		return getVertexType == type
	}
	
	/**
	 * Get all symbols inside the given type that are Vertex type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getVertexSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getVertexType, recursive)
	}
	/**
	 * get Graph type declaration
	 */
	def getGraphType() {
		return getType(GRAPH)
	}
	
	/**
	 * check whether the given type is Graph type
	 */
	def isGraph(NamedType type) {
		return getGraphType == type
	}
	
	/**
	 * Get all symbols inside the given type that are Graph type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getGraphSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getGraphType, recursive)
	}
	/**
	 * Get the edges symbol declaration inside the given Graph type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getGraphEdgesVar() {
		return ImlUtil.findSymbol(getType(GRAPH), GRAPH_EDGES_VAR, true) as SymbolDeclaration;
	}
	/**
	 * get Edge type declaration
	 */
	def getEdgeType() {
		return getType(EDGE)
	}
	
	/**
	 * check whether the given type is Edge type
	 */
	def isEdge(NamedType type) {
		return getEdgeType == type
	}
	
	/**
	 * Get all symbols inside the given type that are Edge type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getEdgeSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getEdgeType, recursive)
	}
	
	override getPackageName() {
		PACKAGE_NAME
	}
	
	/**
	 * Checks if a symbol is defined inside Graphs IML library
	 */
	def isGraphsSymbol(Symbol symbol) {
		if (symbol !== null) {
			val containerModel = ImlUtil.getContainerOfType(symbol, Model)
			if (containerModel.name == getPackageName()) {
				return true;
			}
		}
		return false;
	}
}
