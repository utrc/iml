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
import com.utc.utrc.hermes.iml.iml.Model
import com.utc.utrc.hermes.iml.iml.Assertion

/**
 * Standalone class that generates the services for IML standard library. This should be executed after any modification
 * to the IML Standard Library at <em>com.utc.utrc.hermes.iml.lib</em>.
 * The generator works by loading all Standard Libraries defined under <em>com.utc.utrc.hermes.iml.lib</em> project and 
 * for each IML file, create a Java class with service methods to work with this IML library. The generator uses 
 * <i>Generation Gap</i> design pattern where the generated classes are stored and overridden inside <em>com.utc.utrc.hermes.iml.lib.gen<em/> 
 * package. Any user custom code should be added to the subclasses under <em>com.utc.utrc.hermes.iml.lib</em>.
 * 
 * @author Ayman Elkfrawy
 */
class LibraryServicesGenerator {

	static final String PACKAGE_NAME = "com.utc.utrc.hermes.iml.lib"
	
	Set<String> declaredVariables = new HashSet;
	
	@Inject
	ImlStdLib stdLib
	
	@Inject
	ImlParseHelper parseHelper;
	
	/**
	 * Standalone run to generate new library services. It loads IML standard libraries, then 
	 * iterate over all of them to generate services classes
	 */
	def static void main(String[] args) {
		val injector = ImlStandaloneSetup.injector;
		val libraryGenerator = injector.getInstance(LibraryServicesGenerator)
		
		if (args.length == 2) {
			// Custom Lib service generator
			val customLibFolder = args.get(0);
			val outputFolder = args.get(1);
			libraryGenerator.generateCustomLibServices(customLibFolder, outputFolder);
		} else {
			libraryGenerator.parseHelper.loadStdLibs
			libraryGenerator.generateServices			
		}
		
	}
	
	def generateCustomLibServices(String customLibFolder, String outputFolder) {
		val rs = parseHelper.parseDir(customLibFolder, true);
		for (res : rs.resources) {
			if (res.URI.toFileString.contains(customLibFolder) && !res.contents.empty && res.contents.get(0) instanceof Model) {
				val model = res.contents.get(0) as Model
//				val classFile = getFile(model.name, true);
				val libName = model.name
				val serviceClass = generateSevices(libName, model.symbols)
				val outputFile = outputFolder + "/" + getClassName(libName, false) + ".xtend"
				Files.write( new File(outputFile).toPath , serviceClass.toString.bytes)
			}
		}
	}
	
	def generateServices() {
		if (stdLib === null) return;
		
		for (libName : stdLib.stdLibNames) {
			println("Generating " + libName)
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
		public static final String PACKAGE_NAME = "«libName»"
		«FOR symbol: symbols»public static final String «getSymbolName(symbol, true)» = "«symbol.name»"	
			«IF symbol instanceof NamedType»
				«FOR element : symbol.symbols.filter[! (it instanceof Assertion)]»
		public static final String «getSymbolName(element, true)» = "«element.name»"
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
		 * check whether the given symbol is annotated with «symbolName» annotation
		 */
		def has«symbolName»Annotation(Symbol symbol) {
			if (symbol.propertylist !== null) {
				return symbol.propertylist.properties.map[(it.ref as SimpleTypeReference).type].contains(get«symbolName»Annotation())	
			}
			return false;
		}
		
		/**
		 * check whether the given type is annotated with «symbolName» annotation
		 */
		def has«symbolName»Annotation(TypeWithProperties type) {
			if (type.properties !== null) {
				return type.properties.properties.map[(it.ref as SimpleTypeReference).type].contains(get«symbolName»Annotation())	
			}
			return false;
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
		«ELSEIF symbol instanceof SymbolDeclaration && !(symbol instanceof Assertion)»
		/**
		 * Get «symbolName» symbol declaration
		 */
		 def get«symbolName»() {
		 	return getSymbolDeclaration(«symbolUpperCase»)
		 }
		«ENDIF»
«««		Create get methods for symbols inside the type
		«IF symbol instanceof NamedType»
			«FOR element : symbol.symbols.filter[! (it instanceof Assertion)]»
				/**
				 * Get the «element.name» symbol declaration inside the given «symbol.name» type. If recursive is true
				 * then it will search for symbols inside type's parents 
				 */
				def get«getSymbolName(element, false)»() {
					return ImlUtil.findSymbol(getType(«symbolUpperCase»), «getSymbolName(element, true)», true) as SymbolDeclaration;
				}
			«ENDFOR»
		«ENDIF»
		'''
	}
	
	def getClassName(String libFqn, boolean subClass) {
		var String libName = getHumanLibName(libFqn)
		if (subClass) {
			return libName + "Services"
		} else {
			return "_" + libName + "Services"
		}
	}
	
	def getHumanLibName(String libFqn) {
		if (libFqn.contains(".")) {
			return libFqn.substring(libFqn.lastIndexOf(".") + 1).toFirstUpper
		} else {
			return libFqn.toFirstUpper
		}
	}
	
	
	def private getStaticImports() {
		'''
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
		
		/**
		 * Checks if a symbol is defined inside «libName.humanLibName» IML library
		 */
		def is«libName.humanLibName»Symbol(Symbol symbol) {
			if (symbol !== null) {
				val containerModel = ImlUtil.getContainerOfType(symbol, Model)
				if (containerModel.name == getPackageName()) {
					return true;
				}
			}
			return false;
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
	
	def String getSymbolName(Symbol symbol, boolean upperCase) {
		val parts = <String>newArrayList()
		if (symbol instanceof SymbolDeclaration) {
			if (symbol.eContainer instanceof NamedType) {
				parts.add(getSymbolName(symbol.eContainer as NamedType, upperCase))
				parts.add(symbol.name)
				parts.add("Var")
			} else {
				parts.add(symbol.name)
				parts.add("Symbol")
			}
		} else {
			parts.add(symbol.name)
		}
		
		if (upperCase) {
			parts.join("_").toUpperCase
		} else {
			parts.map[it.toFirstUpper].join
		}
	}
	
	def toUpperCase(String string) {
		return string.toUpperCase
	}
}