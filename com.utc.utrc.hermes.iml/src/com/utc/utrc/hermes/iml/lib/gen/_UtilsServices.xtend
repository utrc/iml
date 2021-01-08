/*
 * Auto-Generated, please don't modify. Add your own logic to the child class {@link com.utc.utrc.hermes.iml.lib.UtilsServices} instead
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
	public static final String LIST_LAST_VAR = "last"
	public static final String LIST_LEN_VAR = "len"
	public static final String LIST_CONTAINS_VAR = "contains"
	public static final String LIST_NEXT_VAR = "next"
	
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
	def getTreeRootVar() {
		return ImlUtil.findSymbol(getType(TREE), TREE_ROOT_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the left symbol declaration inside the given Tree type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getTreeLeftVar() {
		return ImlUtil.findSymbol(getType(TREE), TREE_LEFT_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the right symbol declaration inside the given Tree type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getTreeRightVar() {
		return ImlUtil.findSymbol(getType(TREE), TREE_RIGHT_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the size symbol declaration inside the given Tree type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getTreeSizeVar() {
		return ImlUtil.findSymbol(getType(TREE), TREE_SIZE_VAR, true) as SymbolDeclaration;
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
	def getListHeadVar() {
		return ImlUtil.findSymbol(getType(LIST), LIST_HEAD_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the tail symbol declaration inside the given List type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getListTailVar() {
		return ImlUtil.findSymbol(getType(LIST), LIST_TAIL_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the last symbol declaration inside the given List type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getListLastVar() {
		return ImlUtil.findSymbol(getType(LIST), LIST_LAST_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the len symbol declaration inside the given List type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getListLenVar() {
		return ImlUtil.findSymbol(getType(LIST), LIST_LEN_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the contains symbol declaration inside the given List type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getListContainsVar() {
		return ImlUtil.findSymbol(getType(LIST), LIST_CONTAINS_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the next symbol declaration inside the given List type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getListNextVar() {
		return ImlUtil.findSymbol(getType(LIST), LIST_NEXT_VAR, true) as SymbolDeclaration;
	}
	
	override getPackageName() {
		PACKAGE_NAME
	}
	
	/**
	 * Checks if a symbol is defined inside Utils IML library
	 */
	def isUtilsSymbol(Symbol symbol) {
		if (symbol !== null) {
			val containerModel = ImlUtil.getContainerOfType(symbol, Model)
			if (containerModel.name == getPackageName()) {
				return true;
			}
		}
		return false;
	}
}
