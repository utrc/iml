/*
 * generated by Xtext 2.12.0
 */
package com.utc.utrc.hermes.iml.tests

import com.google.inject.Inject
import com.utc.utrc.hermes.iml.custom.ImlCustomFactory
import com.utc.utrc.hermes.iml.iml.Model
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.util.ParseHelper
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith
import com.utc.utrc.hermes.iml.iml.NamedType

@RunWith(XtextRunner)
@InjectWith(ImlInjectorProvider)
class ImlParsingTest {
	@Inject extension ParseHelper<Model> 
	
	@Inject extension ValidationTestHelper
	
	@Inject extension TestHelper
	
	
	@Test
	def void loadModel() {
		val result = '''
			package p;
		'''.parse
		Assert.assertNotNull(result)
		Assert.assertTrue(result.eResource.errors.isEmpty)
	}
	
	@Test
	def void parsingImlType() {
		val model = '''
			package p;
			type Int;
			type t {
				var1 : Int -> (Int -> Int);
			}
		'''.parse
		
		model.assertNoErrors
	}
	
	@Test
	def void testParsingArrayOfTuple() {
		val model = '''
			package p;
			type Int;
			type t {
				var1 : (Int, Int)[];
			}
		'''.parse
		
		model.assertNoErrors
	}
	
		
	@Test
	def void testParsingArrayOfHot() {
		val model = '''
			package p;
			type Int;
			type t {
				var1 : (Int -> Int)[];
			}
		'''.parse
		
		model.assertNoErrors
	}
	
		
	@Test
	def void testParsingArrayOfSimpleType() {
		val model = '''
			package p;
			type Int;
			type t {
				var1 : Int[];
			}
		'''.parse
		
		model.assertNoErrors
	}
	
	@Test
	def void testParsingShortProperty() {
		val model = '''
			package p;
			type t {
				assert x {true};
			}
		'''.parse
		
		model.assertNoErrors
	}
	
	@Test
	def void testParsingMetaProperty() {
		val model = '''
			package p;
			type myassertion;
			type Bool;
			type t {
				[myassertion] a1 : Bool := true;
			}
		'''.parse
		
		model.assertNoErrors
	}
	
	@Test
	def void testParseParentheizedType() {
		val model = '''
			package p;
			type Int;
			type Real;
			type T {
				x : Int -> Real [10];
				y : (Int -> Real) [10];				
			}
		'''.parse
		
		model.assertNoErrors
	}
	
	@Test
	def void testSerializingParentheizedType() {
		val model = '''
			package p;
			type Int;
			type Real;
			type T {
			} 
		'''.parse
		
		val intType = model.findSymbol("Int") as NamedType;
		val realType = model.findSymbol("Real") as NamedType;
		val T = model.findSymbol("T") as NamedType
		T.symbols.add(ImlCustomFactory.INST.createSymbolDeclaration("x", 
			ImlCustomFactory.INST.createFunctionType => [
				domain = ImlCustomFactory.INST.createSimpleTypeReference(intType)
				range = ImlCustomFactory.INST.createArrayType => [
					type = ImlCustomFactory.INST.createSimpleTypeReference(realType)
					dimensions.add(ImlCustomFactory.INST.createOptionalTermExpr)
				]
		]))
		T.symbols.add(ImlCustomFactory.INST.createSymbolDeclaration("y", 
			ImlCustomFactory.INST.createArrayType => [
				type = ImlCustomFactory.INST.createFunctionType => [
						domain = ImlCustomFactory.INST.createSimpleTypeReference(intType)
						range = ImlCustomFactory.INST.createSimpleTypeReference(realType)
					]
				dimensions.add(ImlCustomFactory.INST.createOptionalTermExpr)
			]))
		
		model.assertNoErrors
		model.eResource.save(System.out, newHashMap)
	}	
	
	@Test
	def testParsingCascadedMemeberSelection() {
		val model = '''
		package p;
		type Int;
		
		type T1 {
			f : T2;
		}
		
		type T2 {
			x : Int;
		}
		
		v1 : T1;
		v2 : Int := v1.f.x;
		
		'''.parse
		
		model.assertNoErrors
	}
	
	@Test
	def testParsingCascadedFunctionCalls() {
		val model = '''
		package p;
		type Int;
		
		type T1 {
			f : Int -> T1;
		}
		
		v1 : T1;
		v2 : T1 := v1.f(5).f(6).f(7);
		
		'''.parse
		
		model.assertNoErrors
	}
	
	@Test
	def testParsingMultipleTails() {
		val model = '''
		package p;
		type Int;
		
		type T1 {
			f : (Int -> T1[][]);
		}
		
		v1 : T1;
		v2 : T1 := v1.f(5)[10][20];
		
		'''.parse
		
		model.assertNoErrors
	}
}
