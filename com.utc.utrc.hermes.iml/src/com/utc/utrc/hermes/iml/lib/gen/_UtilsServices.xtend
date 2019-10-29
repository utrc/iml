/*
 * Auto-Generated, please don't modify. Add your own logic to the child class {@link com.utc.utrc.hermes.iml.lib.UtilsServices} instead
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
class _UtilsServices extends BasicServices
 {
	public static final String PACKAGE_NAME = "iml.lang.utils"
	public static final String TREE = "Tree"	
	public static final String TREE_ROOT_VAR = "root"
	public static final String TREE_LEFT_VAR = "left"
	public static final String TREE_RIGHT_VAR = "right"
	public static final String TREE_SIZE_VAR = "size"
	public static final String LIST = "List"	
	public static final String LIST_HEAD_VAR = "head"
	public static final String LIST_TAIL_VAR = "tail"
	public static final String LIST_LEN_VAR = "len"
	
	/**
	 * get Tree type declaration
	 */
	def getTreeType() {
		return getType(TREE)
	}
	
	/**
	 * check whether the given type is Tree type
	 */
	def isTree(NamedType type) {
		return getTreeType == type
	}
	
	/**
	 * Get all symbols inside the given type that are Tree type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getTreeSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getTreeType, recursive)
	}
	/**
	 * Get the root symbol declaration inside the given Tree type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getTreeRoot(NamedType type, boolean recursive) {
		if (isTree(type)) {
			return ImlUtil.findSymbol(type, TREE_ROOT_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the left symbol declaration inside the given Tree type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getTreeLeft(NamedType type, boolean recursive) {
		if (isTree(type)) {
			return ImlUtil.findSymbol(type, TREE_LEFT_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the right symbol declaration inside the given Tree type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getTreeRight(NamedType type, boolean recursive) {
		if (isTree(type)) {
			return ImlUtil.findSymbol(type, TREE_RIGHT_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the size symbol declaration inside the given Tree type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getTreeSize(NamedType type, boolean recursive) {
		if (isTree(type)) {
			return ImlUtil.findSymbol(type, TREE_SIZE_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * get List type declaration
	 */
	def getListType() {
		return getType(LIST)
	}
	
	/**
	 * check whether the given type is List type
	 */
	def isList(NamedType type) {
		return getListType == type
	}
	
	/**
	 * Get all symbols inside the given type that are List type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getListSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getListType, recursive)
	}
	/**
	 * Get the head symbol declaration inside the given List type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getListHead(NamedType type, boolean recursive) {
		if (isList(type)) {
			return ImlUtil.findSymbol(type, LIST_HEAD_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the tail symbol declaration inside the given List type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getListTail(NamedType type, boolean recursive) {
		if (isList(type)) {
			return ImlUtil.findSymbol(type, LIST_TAIL_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the len symbol declaration inside the given List type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getListLen(NamedType type, boolean recursive) {
		if (isList(type)) {
			return ImlUtil.findSymbol(type, LIST_LEN_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	
	override getPackageName() {
		PACKAGE_NAME
	}
}
