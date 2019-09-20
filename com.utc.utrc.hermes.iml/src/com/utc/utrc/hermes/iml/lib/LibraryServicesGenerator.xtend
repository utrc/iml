package com.utc.utrc.hermes.iml.lib

import com.google.inject.Inject
import java.util.List
import com.utc.utrc.hermes.iml.iml.Symbol
import com.utc.utrc.hermes.iml.iml.Trait
import com.utc.utrc.hermes.iml.iml.NamedType
import com.utc.utrc.hermes.iml.iml.Annotation

class LibraryServicesGenerator {
	private static final String PACKAGE_NAME = "com.utc.utrc.hermes.iml.lib"
	
	
	
	StringBuilder varsSection = new StringBuilder
	StringBuilder methodsSection = new StringBuilder
	
	@Inject
	ImlStdLib stdLib
	
	def generateServices() {
		if (stdLib === null) return;
		
		for (libName : stdLib.stdLibNames) {
			val serviceClass = generateSevices(libName, stdLib.getModelSymbols(libName), "");
		}
	}
	
	def generateSevices(String libName, List<Symbol> symbols, String oldContent) {
			'''
			package «PACKAGE_NAME»
			
			«staticImports»
			// 
			«getUserDefinedImports(oldContent)»
			// 
			«getClassDecl(getClassName(libName))» {
				«getStaticVariables()»
				«generateStringLiterals(stdLib.getModelSymbols(libName))»
				«getUserDefinedVariables(oldContent)»
				
				«generateMethods(stdLib.getModelSymbols(libName))»
				«staticMethods»
				«getUserDefinedMethods(oldContent)»
			}
			'''
	}
	
	def getStaticVariables() {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	def generateStringLiterals(List<Symbol> symbols) {
		
	}
	
	def generateMethods(List<Symbol> symbols) {
		'''
		«FOR symbol: symbols»«generateMethod(symbol)»\n«ENDFOR»
		'''
	}
	
	def generateMethod(Symbol symbol) {
		val symbolName = symbol.name
		'''
		«IF symbol instanceof Trait»
		def get«symbolName»Trait() {
			return getTrait(«symbolName»)
		}
		
		def is«symbolName»(EObject eObject) {
			return ImlUtil.exhibitsOrRefines(eObject, «symbolName»Trait);
		}
		
		def get«symbolName»s(NamedType type, boolean recursive) {
			ImlUtil.getSymbolsWithTrait(type, «symbolName»Trait, recursive);
		}
		
		«ELSEIF symbol instanceof NamedType»
		def get«symbolName»Type() {
			return getType(«symbolName»)
		}
		
		def is«symbolName»(NamedType type) {
			return «symbolName»Type == type
		}
		
		def get«symbolName»s(NamedType type, boolean recursive) {
			ImlUtil.getSymbolsWithType(type, «symbolName»Type, recursive)
		}
		«ELSEIF symbol instanceof Annotation»
		def get«symbolName»Annotation() {
			return getAnnotation(«symbolName»)
		}
		«ENDIF»
		'''
	}
	
	def getClassName(String libFqn) {
		var String libName
		if (libFqn.contains(".")) {
			libName = libFqn.substring(libFqn.lastIndexOf(".") + 1).toFirstUpper
		} else {
			libName = libFqn.toFirstUpper
		}
		return "_" + libName + "Services"
	}
	
	
	def private getStaticImports() {
		'''
		import com.google.inject.Singleton
		import com.google.inject.Inject
		import com.utc.utrc.hermes.iml.iml.Trait
		import com.utc.utrc.hermes.iml.iml.NamedType
		import com.utc.utrc.hermes.iml.util.ImlUtil
		import org.eclipse.emf.ecore.EObject
		'''
	}
	
	def private getClassDecl(String className) {
		'''
		@Singleton
		class «className» extends BasicServices
		'''
	}
	
	def private getStaticMethods() {
		'''
		override getPackageName() {
			PACKAGE_NAME
		}
		'''
	}
	
	def getUserDefinedImports(String oldContent) {
		return "";
	}
	
	def getUserDefinedVariables(String oldContent) {
		return "";
	}
	
	def getUserDefinedMethods(String oldContent) {
		return "";
	}
}