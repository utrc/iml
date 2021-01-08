/*
 * Auto-Generated, please don't modify. Add your own logic to the child class {@link com.utc.utrc.hermes.iml.lib.SoftwareServices} instead
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
class _SoftwareServices extends BasicServices
 {
	public static final String PACKAGE_NAME = "iml.software"
	public static final String SUBPROGRAM = "SubProgram"	
	public static final String PROCESS = "Process"	
	public static final String DATA = "Data"	
	public static final String THREAD = "Thread"	
	
	/**
	 * get SubProgram trait declaration
	 */
	def getSubProgramTrait() {
		return getTrait(SUBPROGRAM)
	}
	
	/**
	 * check wether the given eObject refines or exhibits the SubProgram trait
	 */
	def isSubProgram(EObject eObject) {
		return ImlUtil.exhibitsOrRefines(eObject, getSubProgramTrait);
	}
	
	/**
	 * Get all symbols inside the given type that exhibits/refines the SubProgram trait. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getSubProgramSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithTrait(type, getSubProgramTrait, recursive);
	}
	
	/**
	 * get Process trait declaration
	 */
	def getProcessTrait() {
		return getTrait(PROCESS)
	}
	
	/**
	 * check wether the given eObject refines or exhibits the Process trait
	 */
	def isProcess(EObject eObject) {
		return ImlUtil.exhibitsOrRefines(eObject, getProcessTrait);
	}
	
	/**
	 * Get all symbols inside the given type that exhibits/refines the Process trait. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getProcessSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithTrait(type, getProcessTrait, recursive);
	}
	
	/**
	 * get Data trait declaration
	 */
	def getDataTrait() {
		return getTrait(DATA)
	}
	
	/**
	 * check wether the given eObject refines or exhibits the Data trait
	 */
	def isData(EObject eObject) {
		return ImlUtil.exhibitsOrRefines(eObject, getDataTrait);
	}
	
	/**
	 * Get all symbols inside the given type that exhibits/refines the Data trait. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getDataSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithTrait(type, getDataTrait, recursive);
	}
	
	/**
	 * get Thread trait declaration
	 */
	def getThreadTrait() {
		return getTrait(THREAD)
	}
	
	/**
	 * check wether the given eObject refines or exhibits the Thread trait
	 */
	def isThread(EObject eObject) {
		return ImlUtil.exhibitsOrRefines(eObject, getThreadTrait);
	}
	
	/**
	 * Get all symbols inside the given type that exhibits/refines the Thread trait. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getThreadSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithTrait(type, getThreadTrait, recursive);
	}
	
	
	override getPackageName() {
		PACKAGE_NAME
	}
	
	/**
	 * Checks if a symbol is defined inside Software IML library
	 */
	def isSoftwareSymbol(Symbol symbol) {
		if (symbol !== null) {
			val containerModel = ImlUtil.getContainerOfType(symbol, Model)
			if (containerModel.name == getPackageName()) {
				return true;
			}
		}
		return false;
	}
}
