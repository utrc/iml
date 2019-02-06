package com.utc.utrc.hermes.iml.tests.typing

import org.junit.runner.RunWith
import org.eclipse.xtext.testing.XtextRunner
import com.utc.utrc.hermes.iml.tests.ImlInjectorProvider
import org.eclipse.xtext.testing.InjectWith
import com.google.inject.Inject
import org.eclipse.xtext.testing.util.ParseHelper
import com.utc.utrc.hermes.iml.iml.Model
import org.junit.Test
import static org.junit.Assert.*
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import com.utc.utrc.hermes.iml.tests.TestHelper
import com.utc.utrc.hermes.iml.typing.TypingServices
import com.utc.utrc.hermes.iml.iml.ConstrainedType
import java.util.Arrays
import java.util.List
import java.util.ArrayList
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration
import com.utc.utrc.hermes.iml.typing.ImlTypeProvider
import com.google.common.reflect.TypeToken.TypeSet

/**
 * @author Ayman Elkfrawy
 */
@RunWith(XtextRunner)
@InjectWith(ImlInjectorProvider)
class TypingServicesTest {
	
	@Inject extension ParseHelper<Model>
	
	@Inject extension ValidationTestHelper
	
	@Inject extension TestHelper
	
	
	/**************************
	 * Testing isEqual methods 
	 * ************************/
	@Test
	def testIsEqual_HigherOrderType() {
		val model = '''
			package p;
			type Int;
			type t1 {
				var1 : Int;
				var2 : Int;
			}
		'''.parse
		
		model.assertNoErrors
		val var1 = (model.findSymbol("t1") as ConstrainedType).findSymbol("var1")
		val var2 = (model.findSymbol("t1") as ConstrainedType).findSymbol("var2")
		
		assertTrue(TypingServices.isEqual(var1.type, var2.type))
	}
	
	@Test
	def testIsEqual_HigherOrderType_WithTemplate() {
		val model = '''
			package p;
			type TemType<T, P>;
			type Int;
			type Float;
			type t1 {
				var1 : TemType<Int, Float>;
				var2 : TemType<Int, Float>;
			}
		'''.parse
		
		model.assertNoErrors
		val var1 = (model.findSymbol("t1") as ConstrainedType).findSymbol("var1")
		val var2 = (model.findSymbol("t1") as ConstrainedType).findSymbol("var2")
		
		assertTrue(TypingServices.isEqual(var1.type, var2.type))
	}
	
	@Test
	def testIsEqual_HigherOrderType_WithTemplate_DifferentTypes() {
		val model = '''
			package p;
			type TemType<T, P>;
			type Int;
			type Float;
			type t1 {
				var1 : TemType<Float, Int>;
				var2 : TemType<Int, Float>;
			}
		'''.parse
		
		model.assertNoErrors
		val var1 = (model.findSymbol("t1") as ConstrainedType).findSymbol("var1")
		val var2 = (model.findSymbol("t1") as ConstrainedType).findSymbol("var2")
		
		assertFalse(TypingServices.isEqual(var1.type, var2.type))
	}
	
	@Test
	def testIsEqual_HigherOrderType_WithArray() {
		val model = '''
			package p;
			type Int;
			type t1 {
				var1 : Int[10];
				var2 : Int[20];
			}
		'''.parse
		
		model.assertNoErrors
		val var1 = (model.findSymbol("t1") as ConstrainedType).findSymbol("var1")
		val var2 = (model.findSymbol("t1") as ConstrainedType).findSymbol("var2")
		
		assertTrue(TypingServices.isEqual(var1.type, var2.type))
	}
	
	@Test
	def testIsEqual_HigherOrderType_WithArray_DifferentTypes() {
		val model = '''
			package p;
			type Int;
			type Boolean;
			type t1 {
				var1 : Boolean[10];
				var2 : Int[20];
			}
		'''.parse
		
		model.assertNoErrors
		val var1 = (model.findSymbol("t1") as ConstrainedType).findSymbol("var1")
		val var2 = (model.findSymbol("t1") as ConstrainedType).findSymbol("var2")
		
		assertFalse(TypingServices.isEqual(var1.type, var2.type))
	}
	
	@Test
	def testIsEqual_HigherOrderType_WithArray_DifferentDiminsions() {
		val model = '''
			package p;
			type Int;
			type Boolean;
			type t1 {
				var1 : Int[10][20];
				var2 : Int[20];
			}
		'''.parse
		
		model.assertNoErrors
		val var1 = (model.findSymbol("t1") as ConstrainedType).findSymbol("var1")
		val var2 = (model.findSymbol("t1") as ConstrainedType).findSymbol("var2")
		
		assertFalse(TypingServices.isEqual(var1.type, var2.type))
	}
	
	@Test
	def testIsEqual_HigherOrderType_WithTuples() {
		val model = '''
			package p;
			type Int;
			type Boolean;
			type t1 {
				var1 : (p1: Int, p2: Boolean);
				var2 : (p1: Int, p3: Boolean);
			}
		'''.parse
		
		model.assertNoErrors
		val var1 = (model.findSymbol("t1") as ConstrainedType).findSymbol("var1")
		val var2 = (model.findSymbol("t1") as ConstrainedType).findSymbol("var2")
		
		assertTrue(TypingServices.isEqual(var1.type, var2.type))
	}
	
	@Test
	def testIsEqual_HigherOrderType_WithTuples_DifferentTypes() {
		val model = '''
			package p;
			type Int;
			type Boolean;
			type t1 {
				var1 : (p1: Boolean, p2: Int);
				var2 : (p1: Int, p3: Boolean);
			}
		'''.parse
		
		model.assertNoErrors
		val var1 = (model.findSymbol("t1") as ConstrainedType).findSymbol("var1")
		val var2 = (model.findSymbol("t1") as ConstrainedType).findSymbol("var2")
		
		assertFalse(TypingServices.isEqual(var1.type, var2.type))
	}
	
	@Test
	def testIsEqual_HigherOrderType_WithTuples_DifferentSize() {
		val model = '''
			package p;
			type Int;
			type Boolean;
			type t1 {
				var1 : (p1: Int, p2: Boolean, p3: Boolean);
				var2 : (p3: Int, p4: Boolean);
			}
		'''.parse
		
		model.assertNoErrors
		val var1 = (model.findSymbol("t1") as ConstrainedType).findSymbol("var1")
		val var2 = (model.findSymbol("t1") as ConstrainedType).findSymbol("var2")
		
		assertFalse(TypingServices.isEqual(var1.type, var2.type))
	}
	
	@Test
	def testIsEqual_HigherOrderType_Range() {
		val model = '''
			package p;
			type Int;
			type Boolean;
			type t1 {
				var1 : (p1: Int, p2: Boolean) -> Int;
				var2 : (p1: Int, p3: Boolean) -> Int;
			}
		'''.parse
		
		model.assertNoErrors
		val var1 = (model.findSymbol("t1") as ConstrainedType).findSymbol("var1")
		val var2 = (model.findSymbol("t1") as ConstrainedType).findSymbol("var2")
		
		assertTrue(TypingServices.isEqual(var1.type, var2.type))
	}
	
	@Test
	def testIsEqual_HigherOrderType_RangeAndNoRange() {
		val model = '''
			package p;
			type Int;
			type Boolean;
			type t1 {
				var1 : (p1: Int, p2: Boolean) -> Int;
				var2 : (p1: Int, p3: Boolean);
			}
		'''.parse
		
		model.assertNoErrors
		val var1 = (model.findSymbol("t1") as ConstrainedType).findSymbol("var1")
		val var2 = (model.findSymbol("t1") as ConstrainedType).findSymbol("var2")
		
		assertFalse(TypingServices.isEqual(var1.type, var2.type))
	}
	
	@Test
	def testIsEqual_HigherOrderType_Range_DifferentTypes() {
		val model = '''
			package p;
			type Int;
			type Boolean;
			type t1 {
				var1 : (p1: Int, p2: Boolean) -> Int;
				var2 : (p1: Int, p2: Boolean) -> Boolean;
			}
		'''.parse
		
		model.assertNoErrors
		val var1 = (model.findSymbol("t1") as ConstrainedType).findSymbol("var1")
		val var2 = (model.findSymbol("t1") as ConstrainedType).findSymbol("var2")
		
		assertFalse(TypingServices.isEqual(var1.type, var2.type))
	}
	/***********************************
	 * Testing GetAllSuperTypes methods 
	 * *********************************/
	@Test
	def testGetAllSuperTypes_NoParent() {
		val model = '''
			package p;
			type Int;
			type t1 {
				
			}
		'''.parse
		
		model.assertNoErrors
		val t1 = model.findSymbol("t1") as ConstrainedType
		
		assertParents(TypingServices.getAllSuperTypes(t1), Arrays.asList("t1"))
	}
	
	@Test
	def testGetAllSuperTypes_WitParent() {
		val model = '''
			package p;
			type Int;
			type Parent;
			type t1 extends Parent {
				
			}
		'''.parse
		
		model.assertNoErrors
		val t1 = model.findSymbol("t1") as ConstrainedType
		
		assertParents(TypingServices.getAllSuperTypes(t1), Arrays.asList("t1", "Parent"))
	}

	@Test
	def testGetAllSuperTypes_MultipleParents() {
		val model = '''
			package p;
			type Int;
			type Parent;
			type t1 extends Parent extends Int {
				
			}
		'''.parse
		
		model.assertNoErrors
		val t1 = model.findSymbol("t1") as ConstrainedType
		
		assertParents(TypingServices.getAllSuperTypes(t1), Arrays.asList("t1", "Parent", "Int"))
	}
	
	@Test
	def testGetAllSuperTypes_MultipleParentsMultipleLevels() {
		val model = '''
			package p;
			type Int;
			type Parent33;
			type Parent3 sameas Parent33;
			type Parent2 extends Parent3 extends Int;
			type Parent extends Parent2;
			type t1 extends Parent {
				
			}
		'''.parse
		
		model.assertNoErrors
		val t1 = model.findSymbol("t1") as ConstrainedType
		
		assertParents(TypingServices.getAllSuperTypes(t1), Arrays.asList("t1", "Parent", "Parent2", "Parent3", "Int"))
	}
	
	def assertParents(List<List<ConstrainedType>> parents, List<String> types) {
		val parentsFlat = parents.flatten.toList.map[it.name]
		assertEquals(types.size, parentsFlat.size)
		assertTrue(parentsFlat.containsAll(types))
	}
	
	
	@Test
	def testTypeProviderForArrayOfTuple() {
		val model = '''
			package p;
			type Int;
			type T1 {
				var1 : (a: Int, b: Int)[10];
				var2 : (Int, Int)[] := var1;
			}
		'''.parse
		
		model.assertNoErrors
	}
	
	@Test
	def testAliasWithTypeParameters() {
		val model = '''
			package p;
			type Int;
			type Connector<T> is (T,T);
			type S {
				p1 : Int ;
				p2 : Int ;
				c : Connector<Int> := (p1,p2) ;
			};
		'''.parse
		
		val c = (model.symbols.last as ConstrainedType).symbols.last as SymbolDeclaration
		val decltype = c.type
		val deftype = ImlTypeProvider.termExpressionType(c.definition)
		val eq = TypingServices.isCompatible(decltype,deftype)
		assertTrue(eq)
		model.assertNoErrors
	}
	
	@Test
	def testRemoveAliases() {
		assertTrue(testRemoveAliases("T2", "T1"))
		assertTrue(testRemoveAliases("T3", "T1"))
		assertTrue(testRemoveAliases("(T2, T3)", "(T1, T1)"))
		assertTrue(testRemoveAliases("T2 -> T3", "T1 -> T1"))
		assertTrue(testRemoveAliases("T2[][]", "T1[][]"))
		assertTrue(testRemoveAliases("(T2, T1) -> T3", "(T1, T1)->T1"))
		assertTrue(testRemoveAliases("T1", "T1"))
	}
	
	def testRemoveAliases(String var1TypeString, String var2TypeString) {
		val model = '''
			package p;
			type T1;
			type T2 is T1;
			type T3 is T2;
			type Tx {
				var1 : «var1TypeString»;
				var2 : «var2TypeString»;
			}
		'''.parse
		
		val var1Type = ((model.findSymbol("Tx") as ConstrainedType).findSymbol("var1") as SymbolDeclaration).type
		val var2Type = ((model.findSymbol("Tx") as ConstrainedType).findSymbol("var2") as SymbolDeclaration).type
		return TypingServices.isEqual(var2Type, TypingServices.resolveAliases(var1Type))
		
	}
	
}