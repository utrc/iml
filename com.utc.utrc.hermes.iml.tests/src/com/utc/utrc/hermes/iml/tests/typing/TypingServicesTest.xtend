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
import com.utc.utrc.hermes.iml.iml.NamedType
import java.util.Arrays
import java.util.List
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration
import com.utc.utrc.hermes.iml.typing.ImlTypeProvider
import com.utc.utrc.hermes.iml.ImlParseHelper
import com.utc.utrc.hermes.iml.iml.ImlType

/**
 * @author Ayman Elkfrawy
 */
@RunWith(XtextRunner)
@InjectWith(ImlInjectorProvider)
class TypingServicesTest {
	
	@Inject extension ImlParseHelper
	
	@Inject extension ValidationTestHelper
	
	@Inject extension TestHelper
	
	@Inject ImlTypeProvider typeProvider
	
	@Inject TypingServices typingServices
	
	
	/**************************
	 * Testing isEqual methods 
	 * ************************/
	 
	@Test
	def testIsEqual_ImlType() {
	 	assertEqualTypes("Int", "Int", true)
	}
	
	@Test
	def testIsEqual_ImlType_WithTemplate() {
		assertEqualTypes("TemType<Int, Real>", " TemType<Int, Real>", true)
	}
	
	@Test
	def testIsEqual_ImlType_WithTemplate_DifferentTypes() {
		assertEqualTypes("TemType<Real, Int>", "TemType<Int, Real>", false)
	}
	
	@Test
	def testIsEqual_ImlType_WithArray() {
		assertEqualTypes("Int[10]", "Int[20]", true)
	}
	
	@Test
	def testIsEqual_ImlType_WithArray_DifferentTypes() {
		assertEqualTypes("Bool[10]", "Int[10]", false)
	}
	
	@Test
	def testIsEqual_ImlType_WithArray_DifferentDiminsions() {
		assertEqualTypes("Int[10][20]", "Int[20]", false)
	}
	
	@Test
	def testIsEqual_ImlType_WithRecord() {
		assertEqualTypes("(p1: Int, p2: Bool)", "(p1: Int, p2: Bool)", true)
	}
	
	@Test
	def testIsEqual_ImlType_WithRecord_DifferentLocation() {
		assertEqualTypes("(p1: Int, p2: Bool)", "(p2: Bool, p1: Int)", true)
	}
	
	@Test
	def testIsEqual_ImlType_WithRecord_DifferentNames() {
		assertEqualTypes("(p1: Int, p2: Bool)", "(p1: Int, p10: Bool)", false)
	}
	
	@Test
	def testIsEqual_ImlType_WithRecord_DifferentTypes() {
		assertEqualTypes("(p1: Int, p2: Bool)", "(p1: Int, p2: Real)", false)
	}
	
	@Test
	def testIsEqual_ImlType_WithRecord_DifferentSize() {
		assertEqualTypes("(p1: Int)", "(p1: Int, p2: Bool)", false)
	}
	
	@Test
	def testIsEqual_ImlType_WithTuples() {
		assertEqualTypes("(Int, Bool)", "(Int, Bool)", true)
	}
	
	@Test
	def testIsEqual_ImlType_WithTuples_DifferentSize() {
		assertEqualTypes("(Int, Bool, Bool)", "(Int, Bool)", false)
	}
	
	@Test
	def testIsEqual_ImlType_WithTuples_DifferentOrder() {
		assertEqualTypes("(Int, Bool)", "(Bool, Int)", false)
	}
	
	@Test
	def testIsEqual_ImlType_Range() {
		assertEqualTypes("(Int, Bool) -> Int", "(Int, Bool) -> Int", true)
	}
	
	@Test
	def testIsEqual_ImlType_RangeAndNoRange() {
		assertEqualTypes("(Int, Bool) -> Int", "(Int, Bool)", false)
	}
	
	@Test
	def testIsEqual_ImlType_Range_DifferentTypes() {
		assertEqualTypes("(Int, Bool) -> Int", "(Int, Bool) -> Bool", false)
	}
	
	@Test
	def testIsEqual_ImlType_RecordAndTuple() {
		assertEqualTypes("(Int, Bool)", "(a: Int, b: Bool)", false)
	}
	
	@Test
	def testIsEqual_ImlType_Domain_Tuples() {
		assertEqualTypes("(Int, Bool) -> Int", "(Bool, Int) -> Int", false)
	}
	
	@Test
	def testIsEqual_ImlType_Domain_Record() {
		assertEqualTypes("(a: Int, b: Bool) -> Int", "(b: Bool, a: Int) -> Int", true)
	}
	
	def assertEqualTypes(String type1, String type2, boolean isEqual) {
		val model = '''
			package p;
			type TemType<T, P>;
			type t1 {
				var1 : «type1»;
				var2 : «type2»;
			}
		'''.parse
		
		model.assertNoErrors
		val var1 = (model.findSymbol("t1") as NamedType).findSymbol("var1")
		val var2 = (model.findSymbol("t1") as NamedType).findSymbol("var2")
		
		assertEquals(isEqual, typingServices.isEqual(var1.type, var2.type))
	}
	/***********************************
	 * Testing GetAllSuperTypes methods 
	 * *********************************/
	@Test
	def testGetAllSuperTypes_NoParent() {
		val model = '''
			package p;
			type t1 {
				
			}
		'''.parse
		
		model.assertNoErrors
		val t1 = model.findSymbol("t1") as NamedType
		
		assertParents(typingServices.getAllSuperTypes(t1), Arrays.asList("t1"))
	}
	
	@Test
	def testGetAllSuperTypes_WitParent() {
		val model = '''
			package p;
			type Parent;
			type t1 extends (Parent) {
				
			}
		'''.parse
		
		model.assertNoErrors
		val t1 = model.findSymbol("t1") as NamedType
		
		assertParents(typingServices.getAllSuperTypes(t1), Arrays.asList("t1", "Parent"))
	}

	@Test
	def testGetAllSuperTypes_MultipleParents() {
		val model = '''
			package p;
			type Parent;
			type t1 extends (Parent, Int) {
				
			}
		'''.parse
		
		model.assertNoErrors
		val t1 = model.findSymbol("t1") as NamedType
		
		assertParents(typingServices.getAllSuperTypes(t1), Arrays.asList("t1", "Parent", "Int"))
	}
	
	@Test
	def testGetAllSuperTypes_MultipleParentsMultipleLevels() {
		val model = '''
			package p;
			type Parent33;
			type Parent3 is Parent33;
			type Parent2 extends (Parent3, Int);
			type Parent extends (Parent2);
			type t1 extends (Parent) {
				
			}
		'''.parse
		 
		model.assertNoErrors
		val t1 = model.findSymbol("t1") as NamedType
		
		assertParents(typingServices.getAllSuperTypes(t1), Arrays.asList("t1", "Parent", "Parent2", "Parent3", "Int", "Parent33"))
	}
	
	def assertParents(List<List<NamedType>> parents, List<String> types) {
		val parentsFlat = parents.flatten.toList.map[it.name]
		assertEquals(types.size, parentsFlat.size)
		assertTrue(parentsFlat.containsAll(types))
	}
	
	
	@Test
	def testTypeProviderForArrayOfTuple() {
		val model = '''
			package p;
			type T1 {
				var1 : (Int, Int)[10];
				var2 : (Int, Int)[] := var1;
			}
		'''.parse
		
		model.assertNoErrors
	}
	
	@Test
	def testTypeProviderForArrayOfRecords() {
		val model = '''
			package p;
			type T1 {
				var1 : (a: Int, b: Int)[10];
				var2 : (a: Int, b: Int)[] := var1;
			}
		'''.parse
		
		model.assertNoErrors
	}
	
	@Test
	def testAliasWithTypeParameters() {
		val model = '''
			package p;
			type Connector<T> is (T,T);
			type S {
				p1 : Int ;
				p2 : Int ;
				c : Connector<Int> := (p1,p2) ;
			};
		'''.parse
		
		val c = (model.symbols.last as NamedType).symbols.last as SymbolDeclaration
		val decltype = c.type
		val deftype = typeProvider.termExpressionType(c.definition)
		val eq = typingServices.isCompatible(decltype,deftype)
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
		
		val var1Type = ((model.findSymbol("Tx") as NamedType).findSymbol("var1") as SymbolDeclaration).type
		val var2Type = ((model.findSymbol("Tx") as NamedType).findSymbol("var2") as SymbolDeclaration).type
		return typingServices.isEqual(var2Type, typingServices.resolveAliases(var1Type))
		
	}
	
}