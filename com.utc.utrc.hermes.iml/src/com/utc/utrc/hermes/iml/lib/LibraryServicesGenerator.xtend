package com.utc.utrc.hermes.iml.lib

import com.google.inject.Inject
import java.util.List
import com.utc.utrc.hermes.iml.iml.Symbol
import com.utc.utrc.hermes.iml.iml.Trait
import com.utc.utrc.hermes.iml.iml.NamedType
import com.utc.utrc.hermes.iml.iml.Annotation
import java.io.File
import java.nio.file.Files
import com.utc.utrc.hermes.iml.ImlStandaloneSetup
import com.utc.utrc.hermes.iml.ImlParseHelper
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration
import java.util.Set
import java.util.HashSet

class LibraryServicesGenerator {

	static final String PACKAGE_NAME = "com.utc.utrc.hermes.iml.lib"
	
	Set<String> declaredVariables = new HashSet;
	
	@Inject
	ImlStdLib stdLib
	
	def static void main(String[] args) {
		val injector = ImlStandaloneSetup.injector;
		val parseHelper = injector.getInstance(ImlParseHelper);
		parseHelper.parse("package p;")
		val libraryGenerator = injector.getInstance(LibraryServicesGenerator)
		libraryGenerator.generateServices
	}
	
	def generateServices() {
		if (stdLib === null) return;
		
		for (libName : stdLib.stdLibNames) {
			// Create the actual services file
			var classFile = getFile(libName, false)
			var serviceClass = generateSevices(libName, stdLib.getModelSymbols(libName));
			Files.write(classFile.toPath, serviceClass.toString.bytes);
			
			// Create user class
			classFile = getFile(libName, true)
			if (!classFile.exists) {
				serviceClass = generateSubClass(libName)
				Files.write(classFile.toPath, serviceClass.toString.bytes);
			}
		}
	}
	
	
	def generateSevices(String libName, List<Symbol> symbols) {
		'''
		/*
		 * Auto-Generated, please don't modify. Add your own logic to the child class {@link «getGenPackageName(true)».«getClassName(libName, true)»} instead
		 */
		package «getGenPackageName(false)»
		
		«staticImports»
		
		«getClassDecl(getClassName(libName, false))» {
			«getStaticVariables(libName, symbols)»
			
			«generateMethods(stdLib.getModelSymbols(libName))»
			
			«getStaticMethods(libName)»
		}
		'''
	}
	
	def generateSubClass(String libName) {
		'''
		/**
		 * This is a custom service class to add user-defined logic.
		 */
		package «getGenPackageName(true)»
		
		import «getGenPackageName(false)».«getClassName(libName, false)»
		
		public class «getClassName(libName, true)» extends «getClassName(libName, false)» {
			
		}
		'''
		
	}
	
	def getGenPackageName(boolean subClass) {
		if (subClass) {
			return PACKAGE_NAME
		} else {
			return PACKAGE_NAME + ".gen"	
		}
	}
	
	def generateMethods(List<Symbol> symbols) {
		'''
		«FOR symbol: symbols»«generateMethod(symbol)»
		«ENDFOR»
		'''
	}
	
	def getStaticVariables(String libName, List<Symbol> symbols) {
		'''
		public static final String PACKAGE_NAME = "«libName».gen"
		«FOR symbol: symbols»public static final String «getSymbolName(symbol, true)» = "«symbol.name»"	
			«IF symbol instanceof NamedType»
				«FOR element : symbol.symbols»
		public static final String «getSymbolName(symbol, true)»_«getSymbolName(element, true)» = "«element.name»"
				«ENDFOR»
			«ENDIF»
		«ENDFOR»
		'''
	}
	/**
	 * 
	 */
	def generateMethod(Symbol symbol) {
		val symbolName = getSymbolName(symbol, false)
		val symbolUpperCase = getSymbolName(symbol, true)
		'''
		«IF symbol instanceof Trait»
		/**
		 * get «symbolName» trait declaration
		 */
		def get«symbolName»Trait() {
			return getTrait(«symbolUpperCase»)
		}
		
		/**
		 * check wether the given eObject refines or exhibits the «symbolName» trait
		 */
		def is«symbolName»(EObject eObject) {
			return ImlUtil.exhibitsOrRefines(eObject, get«symbolName»Trait);
		}
		
		/**
		 * Get all symbols inside the given type that exhibits/refines the «symbolName» trait. If recursive is true
		 * then it will search for symbols inside type's parents
		 */
		def get«symbolName»Symbols(NamedType type, boolean recursive) {
			ImlUtil.getSymbolsWithTrait(type, get«symbolName»Trait, recursive);
		}
		
		«ELSEIF symbol instanceof Annotation»
		/**
		 * get «symbolName» annotation declaration
		 */
		def get«symbolName»Annotation() {
			return getAnnotation(«symbolUpperCase»)
		}
		
		/**
		 * check whether the given type is «symbolName» annotation
		 */
		def is«symbolName»(NamedType annotation) {
			return get«symbolName»Annotation == annotation
		}
		
		/**
		 * Get all symbols inside the given type that has the «symbolName» annotation. If recursive is true
		 * then it will search for symbols inside type's parents
		 */
		def get«symbolName»Symbols(NamedType type, boolean recursive) {
			ImlUtil.getSymbolsWithProperty(type, get«symbolName»Annotation, recursive);
		}		
		
		«ELSEIF symbol instanceof NamedType»
		/**
		 * get «symbolName» type declaration
		 */
		def get«symbolName»Type() {
			return getType(«symbolUpperCase»)
		}
		
		/**
		 * check whether the given type is «symbolName» type
		 */
		def is«symbolName»(NamedType type) {
			return get«symbolName»Type == type
		}
		
		/**
		 * Get all symbols inside the given type that are «symbolName» type. If recursive is true
		 * then it will search for symbols inside type's parents
		 */
		def get«symbolName»Symbols(NamedType type, boolean recursive) {
			ImlUtil.getSymbolsWithType(type, get«symbolName»Type, recursive)
		}
		«ENDIF»
«««		Create get methods for symbols inside the type
		«IF symbol instanceof NamedType»
			«FOR element : symbol.symbols»
				/**
				 * Get the «element.name» symbol declaration inside the given «symbol.name» type. If recursive is true
				 * then it will search for symbols inside type's parents 
				 */
				def get«symbolName»«element.name.toFirstUpper»(NamedType type, boolean recursive) {
					if (is«symbolName»(type)) {
						return ImlUtil.findSymbol(type, «getSymbolName(symbol, true)»_«getSymbolName(element, true)», recursive) as SymbolDeclaration;
					}
					return null;
				}
			«ENDFOR»
		«ENDIF»
		'''
	}
	
	def getClassName(String libFqn, boolean subClass) {
		var String libName
		if (libFqn.contains(".")) {
			libName = libFqn.substring(libFqn.lastIndexOf(".") + 1).toFirstUpper
		} else {
			libName = libFqn.toFirstUpper
		}
		if (subClass) {
			return libName + "Services"
		} else {
			return "_" + libName + "Services"
		}
	}
	
	
	def private getStaticImports() {
		'''
		import com.google.inject.Singleton
		import com.google.inject.Inject
		import com.utc.utrc.hermes.iml.iml.Trait
		import com.utc.utrc.hermes.iml.iml.NamedType
		import com.utc.utrc.hermes.iml.util.ImlUtil
		import com.utc.utrc.hermes.iml.lib.BasicServices
		import org.eclipse.emf.ecore.EObject
		import com.utc.utrc.hermes.iml.iml.SymbolDeclaration
		'''
	}
	
	def private getClassDecl(String className) {
		'''
		@Singleton
		class «className» extends BasicServices
		'''
	}
	
	def private getStaticMethods(String libName) {
		'''
		override getPackageName() {
			PACKAGE_NAME
		}
		'''
	}
	
	def getFile(String libName, boolean subClass) {
		val targetFile = new File('''src/«getGenPackageName(subClass).replaceAll("\\.", "/")»/«getClassName(libName, subClass)».xtend''');
		val parent = targetFile.getParentFile();
		if (!parent.exists() && !parent.mkdirs()) {
		    throw new IllegalStateException("Couldn't create dir: " + parent);
		}
		return targetFile;
	}
	
	def getSymbolName(Symbol symbol, boolean upperCase) {
		var suffix = ""
		if (symbol instanceof SymbolDeclaration) {
			suffix = "Var"
		}
		if (upperCase) {
			toUpperCase(symbol.name + '''«IF !suffix.empty»_«suffix»«ENDIF»''')			
		} else {
			return symbol.name + suffix
		}
	}
	
	def toUpperCase(String string) {
		return string.toUpperCase
	}
}