/*
 * Auto-Generated, please don't modify. Add your own logic to the child class {@link com.utc.utrc.hermes.iml.lib.GraphsServices} instead
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
	def getGraphEdges(NamedType type, boolean recursive) {
		if (isGraph(type)) {
			return ImlUtil.findSymbol(type, GRAPH_EDGES_VAR, recursive) as SymbolDeclaration;
		}
		return null;
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
}
