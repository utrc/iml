/*
 * Copyright (c) 2019 United Technologies Corporation. All rights reserved.
 * See License.txt in the project root directory for license information. */
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
import com.utc.utrc.hermes.iml.ImlParseHelper
import com.google.common.collect.Maps
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration
import com.utc.utrc.hermes.iml.iml.NumberLiteral
import java.math.BigInteger
import static org.junit.Assert.assertEquals

@RunWith(XtextRunner)
@InjectWith(ImlInjectorProvider)
class ImlParsingTest {

	@Inject extension ImlParseHelper
	
	@Inject extension ValidationTestHelper
	
	@Inject extension TestHelper
	
	@Test
	def void loadModel() {
		val result = '''
			package p;
		'''.parse(true)
		Assert.assertNotNull(result)
		Assert.assertTrue(result.eResource.errors.isEmpty)
	}
	
	@Test
	def void parsingImlType() {
		val model = '''
			package p;
			type t {
				var1 : Int -> (Int -> Int);
			}
		'''.parse(true)
		
		model.assertNoErrors
	}
	
	@Test
	def void testParsingArrayOfTuple() {
		val model = '''
			package p;
			type t {
				var1 : (Int, Int)[];
			}
		'''.parse(true)
		
		model.assertNoErrors
	}
	
		
	@Test
	def void testParsingArrayOfFunctions() {
		val model = '''
			package p;
			type t {
				var1 : (Int -> Int)[];
			}
		'''.parse(true)
		
		model.assertNoErrors
	}
	
		
	@Test
	def void testParsingArrayOfSimpleType() {
		val model = '''
			package p;
			type t {
				var1 : Int[];
			}
		'''.parse(true)
		
		model.assertNoErrors
	}
	
	@Test
	def void testParsingShortProperty() {
		val model = '''
			package p;
			type t {
				assert x {true};
			}
		'''.parse(true)
		
		model.assertNoErrors
	}
	
	@Test
	def void testParsingMetaProperty() {
		val model = '''
			package p;
			type myassertion;
			type t {
				[myassertion] a1 : Bool := true;
			}
		'''.parse(true)
		
		model.assertNoErrors
	}
	
	@Test
	def void testParseParentheizedType() {
		val model = '''
			package p;
			type T {
				x : Int -> Real [10];
				y : (Int -> Real) [10];				
			}
		'''.parse(true)
		
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
		'''.parse(false)
		
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
		model.eResource.save(System.out, Maps.newHashMap())
	}	
	
	@Test
	def testParsingCascadedMemeberSelection() {
		val model = '''
		package p;
		
		type T1 {
			f : T2;
		}
		
		type T2 {
			x : Int;
		}
		
		v1 : T1;
		v2 : Int := v1.f.x;
		
		'''.parse(true)
		
		model.assertNoErrors
	}
	
	@Test
	def testParsingCascadedFunctionCalls() {
		val model = '''
		package p;
		type T1 {
			f : Int -> T1;
		}
		
		v1 : T1;
		v2 : T1 := v1.f(5).f(6).f(7);
		
		'''.parse(true)
		
		model.assertNoErrors
	}
	
	@Test
	def testParsingMultipleTails() {
		val model = '''
		package p;
		
		type T1 {
			f : (Int -> T1[][]);
		}
		
		v1 : T1;
		v2 : T1 := v1.f(5)[10][20];
		
		'''.parse(true)
		
		model.assertNoErrors
	}
	
	@Test
	def void testParsingWithImplicitImportOfStdLibrary() {
		val model = '''
		package p;
		type T1 {
			v1: Int;
			v2: String;
			v3: Bool := v2.length = v1;
		}
		'''.parse(true)
		model.assertNoErrors
		model.eResource()
	}
	
	@Test
	def void testParsingDatatypes() {
		val model = '''
			package p;
			
			datatype T (nil, cons(T, Int));
		'''.parse
		
		model.assertNoErrors
	}
	
	@Test
	def void testParsingDatatypesWithMatch() {
		val model = '''
			package p;
			
			datatype T (nil, cons(T, Int)) {
				x : Int := match(self) {
					nil: 0;
					cons(t1, s): s+1;
				};
			}
		'''.parse
		
		model.assertNoErrors
	}
	
	@Test
	def void testParsingDatatypesConstructor() {
		val model = '''
			package p;
			
			datatype T (nil, cons(T, Int)) {
				x : Int := match(self) {
					nil: 0;
					cons(t1, s): s+1;
				};
			}
			
			l : T := T.nil;
		'''.parse
		
		model.assertNoErrors
	}
	
	@Test
	def void testParsingDatatypesConstructorWithParameters() {
		val model = '''
			package p;
			
			datatype T (nil, cons(T, Int)) {
				x : Int := match(self) {
					nil: 0;
					cons(t1, s): s+1;
				};
			}
			
			l : T := T.cons(T.nil, 10);
		'''.parse
		
		model.assertNoErrors
	}
	
	@Test
	def void testParsingBigInteger() {
		val model = '''
			package p;
			x : Int := 1234567890123456789;
		'''.parse
		
		model.assertNoErrors
		val x = model.findSymbol('x') as SymbolDeclaration
		assertEquals((x.definition.left as NumberLiteral).value, new BigInteger("1234567890123456789"))
	}
	
	@Test
	def void testParsingNegativeNumbers() {
		val model = '''
			package p;
			x1 : Int := - 12345;
			X2: Int := 5-3;
			x3: Int := 5- 3;
			x4 : Int := -1234567890123456789;
			y1 : Real := - 123.456;
			y2 : Real := 4.5-3.5;
			y3 : Real := 4.5- 3.5;
			y4 : Real := 1234567890123456789.1234567890123456789;
		'''.parse
		
		model.assertNoErrors
		val x1 = model.findSymbol("x1") as SymbolDeclaration
		assertEquals((x1.definition.left as NumberLiteral).value.intValue, -12345)
	}
	
	@Test
	def void testParsingNegative() {
		val model = '''
			package p;
			assert { - 12345 > 0};
		'''.parse(false)
		
		model.assertNoErrors
	}
	
	@Test
	def void testParsingDeliveryDroneModel() {
		val rs = "./models/DeliveryDrone/verdict".parseDir(true)
		for (res : rs.resources) {
			println((res.contents.get(0) as Model).name)
		}
		rs.assertNoErrors
		val errors = rs.checkErrors
		println(errors)
	}
	
}
