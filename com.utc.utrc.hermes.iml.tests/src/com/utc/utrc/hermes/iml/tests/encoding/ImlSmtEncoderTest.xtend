package com.utc.utrc.hermes.iml.tests.encoding

import com.utc.utrc.hermes.iml.tests.ImlInjectorProvider
import org.eclipse.xtext.testing.XtextRunner
import org.junit.runner.RunWith
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.util.ParseHelper
import com.utc.utrc.hermes.iml.iml.Model
import com.google.inject.Inject
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import com.utc.utrc.hermes.iml.tests.TestHelper
import org.junit.Test
import com.utc.utrc.hermes.iml.encoding.ImlSmtEncoder
import com.utc.utrc.hermes.iml.encoding.simplesmt.SimpleSort
import com.utc.utrc.hermes.iml.encoding.simplesmt.SimpleFunDeclaration
import static extension org.junit.Assert.*
import java.util.List
import org.eclipse.emf.ecore.EObject
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration
import java.util.stream.Collectors
import com.utc.utrc.hermes.iml.iml.ConstrainedType
import com.utc.utrc.hermes.iml.typing.ImlTypeProvider
import com.utc.utrc.hermes.iml.iml.ArrayType
import com.utc.utrc.hermes.iml.typing.TypingServices
import com.utc.utrc.hermes.iml.iml.HigherOrderType
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference

@RunWith(XtextRunner)
@InjectWith(ImlInjectorProvider)
class ImlSmtEncoderTest {
	
	@Inject extension ParseHelper<Model>
	
	@Inject extension ValidationTestHelper
	
	@Inject extension TestHelper
	
	@Inject ImlSmtEncoder<SimpleSort, SimpleFunDeclaration> encoder
	
	@Test
	def void testSimpleConstrainedTypeEncoder() {
		val model = 
		encode('''
			package p1;
			type T1;
		''', "T1")
		
		assertSorts(model.findSymbol("T1"))
	}
	
	@Test
	def void testConstrainedTypeWithElementsEncoder() {
		val model = 
		encode('''
			package p1;
			type Int;
			type T1 {
				var1 : Int;
				var2 : Int;
			}
		''', "T1")
		val t1Sort = assertAndGetSort(model.findSymbol("T1"))
		val intSort = assertAndGetSort(model.findSymbol("Int"))
		
		val var1Fun = assertAndGetFuncDecl(
			model.findSymbol("T1").findSymbol("var1"), #[t1Sort], intSort
		)
		
		val var2Fun = assertAndGetFuncDecl(
			model.findSymbol("T1").findSymbol("var2"), #[t1Sort], intSort
		)
	}
	
	@Test
	def void testConstrainedTypeWithExtensionEncoder() {
		val model = 
		encode('''
			package p1;
			type T1 extends T2;
			type T2;
		''', "T1")
		
		val t1Sort = assertAndGetSort(model.findSymbol("T1"))
		val t2Sort =  assertAndGetSort(model.findSymbol("T2"))
		
		val extensionFun = assertAndGetFuncDecl(
			(model.findSymbol("T1") as ConstrainedType).relations.get(0),
			#[t1Sort], t2Sort
		)
	}
	
	@Test
	def void testConstrainedTypeWithAliasEncoder() {
		val model = 
		encode('''
			package p1;
			type T1 sameas T2;
			type T2;
		''', "T1")
		
		val t1Sort = assertAndGetSort(model.findSymbol("T1"))
		val t2Sort =  assertAndGetSort(model.findSymbol("T2"))
		
		val extensionFun = assertAndGetFuncDecl(
			(model.findSymbol("T1") as ConstrainedType).relations.get(0),
			#[t1Sort], t2Sort 
		)
	}
	
	@Test
	def void testHotEncoder() {
		val model = 
		encode('''
			package p1;
			type T1 {
				var1: Int ~> Real;
			}
			type Int;
			type Real;
		''', "T1")
		
		val t1Sort = assertAndGetSort(model.findSymbol("T1"))
		val intSort =  assertAndGetSort(model.findSymbol("Int"))
		val realSort =  assertAndGetSort(model.findSymbol("Real"))
		val var1 = model.findSymbol("T1").findSymbol("var1") as SymbolDeclaration;
		val hotSort = assertAndGetSort(var1.type)
		
		assertEquals(intSort, hotSort.domain)
		assertEquals(realSort, hotSort.range)
		
		val var1Fun = assertAndGetFuncDecl(
			var1, #[t1Sort], hotSort 
		)
	}
	
	
	@Test
	def void testArrayTypeEncoder() {
		val model = 
		encode('''
			package p1;
			type T1 {
				var1: Int[10][];
			}
			type Int;
		''', "T1")
		
		val t1Sort = assertAndGetSort(model.findSymbol("T1"))
		val intSort =  assertAndGetSort(model.findSymbol("Int"))
		val var1 = model.findSymbol("T1").findSymbol("var1") as SymbolDeclaration;
		val int2Sort = assertAndGetSort(var1.type)
		val int1Sort = assertAndGetSort(TypingServices.accessArray(var1.type as ArrayType, 1))
		
		val int2Access = assertAndGetFuncDecl(
			var1.type, #[int2Sort, intSort], int1Sort
		)
		
		val int1Access = assertAndGetFuncDecl(
			TypingServices.accessArray(var1.type as ArrayType, 1),
			#[int1Sort, intSort], intSort
		)
	}
	
	@Test
	def void testTupleTypeEncoder() {
		val model = encode('''
			package p1;
			type Int;
			type Real;
			var1 : (Int, Real);
		''', "var1")
		val intSort = assertAndGetSort(model.findSymbol("Int"))
		val realSort = assertAndGetSort(model.findSymbol("Real"))
		val tupleSort = assertAndGetSort((model.findSymbol("var1") as SymbolDeclaration).type)
		
		assertEquals(intSort, tupleSort.tupleElements.get(0))
		assertEquals(realSort, tupleSort.tupleElements.get(1))
						
		val var1 = assertAndGetFuncDecl(model.findSymbol("var1"), #[], tupleSort)
	}
	
	@Test
	def void testTemplateTypeEncoder() {
		val model = encode('''
			package p1;
			type Int;
			type Real;
			type T1<type T, type P> {
				vart: T ~> P;
			}
			
			type T2 {
				var1 : T1<Int, Real>;
				var2 : T1<Int, Int>;
				var3 : T1<Int, Real>;
			}
			
		''', "T2")
		val intSort = assertAndGetSort(model.findSymbol("Int"))
		val realSort = assertAndGetSort(model.findSymbol("Real"))
		assertNull(encoder.getSort(model.findSymbol("T1"))) // T<type T, type P> should not be encoded
		val T2Sort = assertAndGetSort(model.findSymbol("T2"))
		
		// Test new types for binding
		val t1IntReal = assertAndGetSort(model.getSymbolType("T2", "var1"))
		val t1IntInt = assertAndGetSort(model.getSymbolType("T2", "var2"))
		val t1IntReal2 = assertAndGetSort(model.getSymbolType("T2", "var3"))		
		
		assertNotSame(t1IntReal, t1IntInt) // Different sorts for different binding
		assertSame(t1IntReal, t1IntReal2)  // Same sort for same binding
		
		// Make sure we create concurrent sorts for T ~> P
		val intToRealType = ImlTypeProvider.getType(
			model.findSymbol("T1").findSymbol("vart") as SymbolDeclaration,
			model.getSymbolType("T2", "var1") as SimpleTypeReference
		)
		
		val intToIntType = ImlTypeProvider.getType(
			model.findSymbol("T1").findSymbol("vart") as SymbolDeclaration,
			model.getSymbolType("T2", "var2") as SimpleTypeReference
		)
		
		val intToRealSort = assertAndGetSort(intToRealType)
		val intToIntSort = assertAndGetSort(intToIntType)
		assertNotSame(intToRealSort, intToIntSort)
		
		// Make sure we create function declarations for concurrent sorts
		val vartIntRealFun = assertAndGetFuncDecl(model.getSymbolType("T2", "var1"), 
			model.findSymbol("T1").findSymbol("vart"),
			#[t1IntReal], intToRealSort
		)
		val vartIntIntFun = assertAndGetFuncDecl(model.getSymbolType("T2", "var2"), 
			model.findSymbol("T1").findSymbol("vart"),
			#[t1IntInt], intToIntSort
		)
		assertNotSame(vartIntRealFun, vartIntIntFun)
	}
	
	
	def HigherOrderType getSymbolType(Model model, String ctName, String symbolName) {
		if (ctName === null || ctName.empty) {
			return (model.findSymbol(symbolName) as SymbolDeclaration).type
		} else {
			return (model.findSymbol(ctName).findSymbol(symbolName) as SymbolDeclaration).type
		}
	}
	
	def assertAndGetFuncDecl(EObject imlObject, List<SimpleSort> inputSorts, SimpleSort outputSort) {
		return assertAndGetFuncDecl(null, imlObject, inputSorts, outputSort)
	}
	
	def assertAndGetFuncDecl(EObject container, EObject imlObject, List<SimpleSort> inputSorts, SimpleSort outputSort) {
		var SimpleFunDeclaration funcDecl;
		if (container === null) {
			funcDecl = encoder.getFuncDeclaration(imlObject)
		} else {
			funcDecl = encoder.getFuncDeclaration(container, imlObject)
		}
		assertNotNull(funcDecl)
		assertEquals(outputSort, funcDecl.outputSort)
		assertContainTheSameElements(inputSorts, funcDecl.inputSorts);
		return funcDecl;
	}
	
	def assertAndGetSort(EObject type) {
		val sort = encoder.getSort(type)
		assertNotNull(sort)
		assertNotNull(sort.name)
		return sort;
	}
	
	def assertSorts(EObject ... types) {
		assertContainTheSameElements(types.map[encoder.getSort(it)], encoder.allSorts)
	}
	
	def assertContainTheSameElements(List list1, List list2) {
		if (list1 === null && list2 === null) return;
		if (list1 === null || list2 === null) 
		
		if (list1 === null) {
			if (list2 === null || list2.isEmpty) return;
			assertTrue("One of the lists is null, but the other has elements", false)
		}
		if (list2 === null) {
			if (list1.isEmpty) return;
			assertTrue("One of the lists is null, but the other has elements", false)
		}
		
		assertEquals(list1.length, list2.size)
		for (Object funcName : list1) {
			assertTrue("Couldn't find " + funcName, list2.contains(funcName))
		}
	}
	
	def encode(String modelString, String ctName) {
		val model = modelString.parse;
		model.assertNoErrors
		encoder.encode(model.findSymbol(ctName))
		// TODO make sure names are unique
		val distinctSorts = encoder.allSorts.map[it.name].stream.distinct.collect(Collectors.toList)
		assertEquals(distinctSorts.size, encoder.allSorts.size)
		val distinctFuncDecls = encoder.allFuncDeclarations.map[it.name].stream.distinct.collect(Collectors.toList)
		assertEquals(distinctFuncDecls.size, encoder.allFuncDeclarations.size)
		return model
	}
	
	@Test
	def void testTypeWithSymbolsEncoder() {
		val model = 
		'''
			package p;
			
			type Int;
			type T1 {
				a : Int;
				b : T2;
			}
			
			type T2;
		'''.parse
		model.assertNoErrors
		
		encoder.encode(model.findSymbol("T1"))
		println(encoder.toString)
	}
	
	@Test
	def void testComplexTypesEncoder() {
		val model = 
		'''
			package p;
			
			type Int;
			type Real;
			type T1 extends T2 {
				a : Int;
				b : Int ~> T2;
				c : (Int, Real);
				d : Int[10][];
				e : (Int~>Real)[][];
			}
			
			type T2 {
				x: Int;	
				y: Float;
			};
			
			type Float sameas Real;
		'''.parse
		model.assertNoErrors
		
		encoder.encode(model.findSymbol("T1"))
		println(encoder.toString)
	}
	
	@Test
	def void testExtendsEncoding() {
		val model = 
		'''
			package p;
			type T1 extends T2;
			type T2;
		'''.parse
		model.assertNoErrors
		
		encoder.encode(model.findSymbol("T1"))
		println(encoder.toString)
	}
	
	@Test
	def void testAliasEncoding() {
		val model = 
		'''
			package p;
			type T1 sameas T2;
			type T2;
		'''.parse
		model.assertNoErrors
		
		encoder.encode(model.findSymbol("T1"))
		println(encoder.toString)
	}
	
	@Test
	def void testTypeWithTemplates() {
		val model = 
		'''
			package p;
			
			type Int;
			type T1<type T> {
				a : T;
			}
			
			type T2 {
				b : T1<Int>;
			}
		'''.parse
		model.assertNoErrors
		
		encoder.encode(model.findSymbol("T2"))
		println(encoder.toString)
	}
	
	
	
}