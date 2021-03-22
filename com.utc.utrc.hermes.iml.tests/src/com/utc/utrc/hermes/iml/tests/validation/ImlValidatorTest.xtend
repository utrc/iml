/*
 * Copyright (c) 2019 United Technologies Corporation. All rights reserved.
 * See License.txt in the project root directory for license information. */
package com.utc.utrc.hermes.iml.tests.validation

import com.utc.utrc.hermes.iml.tests.ImlInjectorProvider
import org.eclipse.xtext.testing.XtextRunner
import org.junit.runner.RunWith
import org.eclipse.xtext.testing.InjectWith
import com.utc.utrc.hermes.iml.tests.TestHelper
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import org.eclipse.xtext.testing.util.ParseHelper
import com.utc.utrc.hermes.iml.iml.Model
import com.google.inject.Inject
import org.junit.Test
import com.utc.utrc.hermes.iml.iml.ImlPackage
import static com.utc.utrc.hermes.iml.validation.ImlValidator.*
import com.utc.utrc.hermes.iml.iml.NamedType
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference
import static extension org.junit.Assert.*
import com.utc.utrc.hermes.iml.ImlParseHelper
import com.utc.utrc.hermes.iml.example.validator.*

/**
 * Test related helper methods
 * @author Ayman Elkfrawy
 */
@RunWith(XtextRunner)
@InjectWith(ImlInjectorProvider)
class ImlValidatorTest {
	
	@Inject extension ImlParseHelper
	
	@Inject extension ValidationTestHelper
	
	@Inject extension TestHelper
	
	/***********************************
	 *  test checkNoDuplicateElement   *
	 * *********************************/
	
	@Test
	def testCheckNoDuplicateElement_CT_noDuplicates() {
		val model = '''
			package p;
			type T1;
			type T2;
			
		'''.parse
		model.assertNoErrors
	}
	
	@Test
	def testCheckNoDuplicateElement_CT_duplicates() {
		val model = '''
			package p;
			type T1;
			type T2;
			type T2;
			
		'''.parse
		model.assertError(ImlPackage.eINSTANCE.namedType, DUPLICATE_ELEMENT)
	}
	
	@Test
	def testCheckNoDuplicateElement_CT_differentPackages_noDuplicate() {
		val model1 = '''
			package p1;
			type T1;
		'''.parse
		
		val model2 = '''
			package p2;
			type T1;
		'''.parse(model1.eResource.resourceSet)
		
		model1.assertNoErrors
		model2.assertNoErrors
	}
	
	@Test
	def testCheckNoDuplicateElement_CT_differentPackages_duplicate() {
		val model1 = '''
			package p1;
			type T1;
		'''.parse
		
		val model2 = '''
			package p2;
			import p1;
			type T1;
		'''.parse(model1.eResource.resourceSet)
		
		model1.assertNoErrors
		model2.assertNoErrors
	}
	
	@Test
	def testCheckNoDuplicateElement_CT_samePackages_differentFiles_duplicate() {
		val model1 = '''
			package p1;
			type T1;
			type x {
				varx : T1;				
			}
		'''.parse
		
		val model2 = '''
			package p1;
			type T1;
			
			type x {
				varx : T1;				
			}
		'''.parse(model1.eResource.resourceSet)
		
		model1.assertNoErrors
		model2.assertNoErrors
		// Check if shadowing work
		val model1T = model1.findSymbol("T1")
		val model1Ref = ((model1.findSymbol("x") as NamedType).findSymbol("varx").type as SimpleTypeReference).type
		assertSame(model1T, model1Ref)
		
		val model2T = model2.findSymbol("T1")
		val model2Ref = ((model2.findSymbol("x") as NamedType).findSymbol("varx").type as SimpleTypeReference).type
		assertSame(model2T, model2Ref)
		assertNotSame(model1Ref, model2Ref)
	}
	
	
	@Test
	def testCheckNoDuplicateElement_symbolDeclaration_noDuplicates() {
		val model = '''
			package p;
			type T1 {
				var1 : Int;
				var2 : Int;
			};
			
		'''.parse
		model.assertNoErrors
	}
	
	@Test
	def testCheckNoDuplicateElement_symbolDeclaration_duplicates() {
		val model = '''
			package p;
			type T1 {
				var1 : Int;
				var2 : Int;
				var2 : Int;
			};
			
		'''.parse
		model.assertError(ImlPackage.eINSTANCE.symbolDeclaration, DUPLICATE_ELEMENT)
	}
	
		@Test
	def testCheckNoDuplicateElement_templateDeclaration() {
		val model = '''
			package p;
			type T1 <T, T>;
		'''.parse
		model.assertError(ImlPackage.eINSTANCE.namedType, DUPLICATE_ELEMENT)
	}
	
	/*****************************
	 *  test checkTemplateType   *
	 * ***************************/
	
	@Test
	def testCheckTemplateType_valid() {
		val model = '''
			package p;
			type x<T, P>;
			
		'''.parse
		model.assertNoErrors
	}
	
	/**************************
	 *  test checkExtension   *
	 * ************************/	
	
	@Test
	def testCheckIncludesSimpleType_Valid() {
		val model = '''
			package p;
			type Parent;
			
			type Child includes (Parent);
		'''.parse
		
		model.assertNoErrors
	}
	
		@Test
	def testCheckIncludesSimpleType_ValidMultipleIncludes() {
		val model = '''
			package p;
			type Parent;
			type Parent2;
			
			type Child includes (Parent, Parent2);
		'''.parse
		
		model.assertNoErrors
	}
	
	@Test
	def testCheckIncludesSimpleType_Invalid() {
		testInvalidIncludes("includes ((Parent1, Parent2))")
		testInvalidIncludes("includes (Parent1->Parent1)")
		testInvalidIncludes("includes (Parent1[10])")
		testInvalidIncludes("includes (Parent1, Parent1[10])")
	}
	
	def testInvalidIncludes(String extensions) {
		val model = '''
			package p;
			type Parent1;
			type Parent2;
			
			type Child «extensions»;
		'''.parse
		
		model.assertError(ImlPackage.eINSTANCE.relation, INVALID_RELATION)
	}
	
	/************************
	 *  test checkNoCycle   *
	 * **********************/	
	
	@Test
	def testNoCycle_Valid() {
		val model = '''
			package p;
			type T1;
			type T2 includes (T1);
		'''.parse
		
		model.assertNoErrors
	}
	
	@Test
	def testNoCycle_IncludeDirectCycle() {
		val model = '''
			package p;
			type T1 includes (T2);
			type T2 includes (T1);
		'''.parse
		
		model.assertError(ImlPackage.eINSTANCE.namedType, CYCLIC_NAMEDTYPE_HIERARCHY)
	}
	
	@Test
	def testNoCycle_IncludeIndirectCycle() {
		val model = '''
			package p;
			type Tx;
			type T1 includes (T2);
			type T2 includes (Tx, T3);
			type T3 includes (T1);
		'''.parse
		
		model.assertError(ImlPackage.eINSTANCE.namedType, CYCLIC_NAMEDTYPE_HIERARCHY)
	}
	
	
	/******************************
	 *  test checkParameterList   *
	 * ****************************/	
	
	@Test
	def testCheckParameterList_Valid() {
		val model = '''
			package p;
			type x {
				var1 : {p1 : Int, p2 : Real} -> Int;
				var2 : Int := var1(5,10.5);
			}
		'''.parse
		
		model.assertNoErrors
	}
	
	@Test
	def testCheckParameterList_ValidParameterCompatible() {
		val model = '''
			package p;
			type T1 includes (T2);
			type T2;
			type x {
				var1: {p1 : T2, p2 : Real} -> Int;
				varT : T1;
				var2 : Int := var1(varT,10.5);
			}
		'''.parse
		
		model.assertNoErrors
	}
	
	@Test
	def testCheckParameterList_() {
		val model = '''
			package p;
			type x {
				var1 : {p1 : Int, p2 : Real} -> Int;
				var2 : Int := var1(5,10.0);
			}
		'''.parse
		
		model.assertNoErrors
	}
	
	@Test
	def testCheckParameterList_NotFunctionCall_STR() {
		val model = '''
			package p;
			type Int;
			type Real;
			type x {
				var1 : Int;
				var2 : Int := var1(5);
			}
		'''.parse
		
		model.assertError(ImlPackage.eINSTANCE.tailedExpression, METHOD_INVOCATION_ON_NAMEDTYPE)
	}
	
	@Test
	def testCheckParameterList_NotFunctionCall_Array() {
		val model = '''
			package p;
			type x {
				var1 : Int[][];
				var2 : Int := var1(5);
			}
		'''.parse
		
		model.assertError(ImlPackage.eINSTANCE.tailedExpression, METHOD_INVOCATION_ON_ARRAY)
	}
	
	@Test
	def testCheckParameterList_NotFunctionCall_Tuple() {
		val model = '''
			package p;
			type x {
				var1 : (Int, Real);
				var2 : Real := var1(1);
			}
		'''.parse
		
		model.assertError(ImlPackage.eINSTANCE.tailedExpression, METHOD_INVOCATION_ON_TUPLE)
	}
	
	
	@Test
	def testCheckParameterList_TupleAccessWrongIndex() {
		val model = '''
			package p;
			type x {
				var1 : (Int, Real);
				var2 : Real := var1[2];
			}
		'''.parse
		
		model.assertError(ImlPackage.eINSTANCE.tailedExpression, INVALID_INDEX_ACCESS)
	}
	
	@Test
	def testCheckParameterList_TupleAccessRight() {
		val model = '''
			package p;
			type x {
				var1 : (Int, Real);
				var2 : Real := var1[1];
			}
		'''.parse
		model.assertNoErrors
	}
	
	@Test
	def testCheckParameterList_ArrayAccessOverRecord() {
		val model = '''
			package p;
			type x {
				var1 : {a: Int, b: Real};
				var2 : Real := var1[1];
			}
		'''.parse
		model.assertError(ImlPackage.eINSTANCE.tailedExpression, METHOD_INVOCATION_ON_RECORD)
	}
	
	@Test
	def testCheckParameterList_MethodInvocationOverRecord() {
		val model = '''
			package p;
			type x {
				var1 : {a: Int, b: Real};
				var2 : Real := var1(1);
			}
		'''.parse
		model.assertError(ImlPackage.eINSTANCE.tailedExpression, METHOD_INVOCATION_ON_RECORD)
	}
	
	@Test
	def testCheckParameterList_ArrayOverFunction() {
		val model = '''
			package p;
			type x {
				var1 : Int -> Real;
				var2 : Real := var1[10];
			}
		'''.parse
		model.assertError(ImlPackage.eINSTANCE.tailedExpression, ARRAY_ACCESS_ON_FUNCTIONTYPE)
	}
	
	@Test
	def testCheckParameterList_WrongListSizeFunction_More() {
		val model = '''
			package p;
			type x {
				var1 : Int -> Real;
				var2 : Real := var1(5, 6);
			}
		'''.parse
		model.assertError(ImlPackage.eINSTANCE.tailedExpression, INVALID_PARAMETER_LIST)
	}
	
	@Test
	def testCheckParameterList_WrongListSizeFunction_Less() {
		val model = '''
			package p;
			type x {
				var1 : (Int, Real) -> Real;
				var2 : Real := var1(5);
			}
		'''.parse
		model.assertError(ImlPackage.eINSTANCE.tailedExpression, INVALID_PARAMETER_LIST)
	}
	
	@Test
	def testCheckParameterList_TailOnNamedType() {
		val model = '''
			package p;
			type x {
				var1 : Real := Real[10];
			}
		'''.parse
		model.assertError(ImlPackage.eINSTANCE.tailedExpression, METHOD_INVOCATION_ON_NAMEDTYPE)
	}
	
	@Test
	def testCheckParameterList_TailOnNamedType_Method() {
		val model = '''
			package p;
			type x {
				var1 : Real := Real(10);
			}
		'''.parse
		model.assertError(ImlPackage.eINSTANCE.tailedExpression, METHOD_INVOCATION_ON_NAMEDTYPE)
	}
	
	@Test
	def testCheckParameterList_WithTemplate() {
		val model = '''
			package p;
			type Tx<T> {
				 varx : T;
			}
			type x {
				var0 : Tx<Int->Int>;
				var1 : Int := var0.varx(0);
			}
		'''.parse
		model.assertNoErrors
	}
	
	@Test
	def testCheckParameterList_CompatibleTypes_Valid() {
		val model = '''
			package p;
			type x {
				f1 : (Real, Int) -> Int;
				v1 : Int := f1(5.5, 10);
			}
		'''.parse
		model.assertNoErrors
	}
	
	@Test
	def testCheckParameterList_CompatibleTypes_Invalid() {
		val model = '''
			package p;
			type x {
				f1 : (Real, Int) -> Int;
				v1 : Int := f1(10, 5.5);
			}
		'''.parse
		model.assertError(ImlPackage.eINSTANCE.tailedExpression, INVALID_PARAMETER_LIST)
	}
	
	/**********************************************
	 *  test CompatibleDeclarationAndDefinition   *
	 * ********************************************/
	 @Test
	 def testCompatibleDeclarationAndDefinition() {
		val model = '''
			package p;
			type x {
				var1 : Int := 5;
			}
		'''.parse
		
		model.assertNoErrors	 	
	 }
	 
	 @Test
	 def testCompatibleDeclarationAndDefinition_ReatToInt() {
		val model = '''
			package p;
			type x {
				var1 : Int := 5.5;
			}
		'''.parse
		
		model.assertError(ImlPackage.eINSTANCE.symbolDeclaration, TYPE_MISMATCH_IN_TERM_EXPRESSION)
	 }
	 
	 @Test
	 def testCompatibleDeclarationAndDefinition_Tuple() {
	 	val model = '''
			package p;
			type x {
				var1 : (Int, Int) := (5, 3);
			}
		'''.parse
		model.assertNoErrors
	 }
	 
	 @Test
	 def testCompatibleDeclarationAndDefinition_TupleMismatch() {
	 	val model = '''
			package p;
			type x {
				var1 : (Int, Int) := (5, 3.5);
			}
		'''.parse
		model.assertError(ImlPackage.eINSTANCE.symbolDeclaration, TYPE_MISMATCH_IN_TERM_EXPRESSION)
	 }
	 
	/************************************
	 *  test CorrectSymbolDeclaration   *
	 * **********************************/
	 
	 @Test
	 def testCTSymbolDeclarationMustHaveType() {
	 	val model = '''
			package p;
			type x {
				var1;
			}
		'''.parse
		model.assertError(ImlPackage.eINSTANCE.symbolDeclaration, INVALID_SYMBOL_DECLARATION)
	 }
	 
	 @Test
	 def testCTAssersionShouldnotHaveType() {
	 	val model = '''
			package p;
			type x {
				assert {5 > 4};
			}
		'''.parse
		model.assertNoErrors
	 }
	 
	 @Test
	 def testProgramSymbolDeclarationMustHaveType() {
	 	val model = '''
			package p;
			type x {
				var1 : Int := {
					var var2;
				};
			}
		'''.parse
		model.assertError(ImlPackage.eINSTANCE.symbolDeclaration, INVALID_SYMBOL_DECLARATION)
	 }
	 
	 @Test
	 def testCTLiteralsNoError() {
	 	val model = '''
			package p;
			type X enum {a, b};
		'''.parse
		model.assertNoErrors
	 }
	 
	 @Test
	 def testAliasShouldBeOneLevelOnly_valid() {
	 	val model = '''
			package p;
			type T1;
			type T2 is T1;
		'''.parse
		model.assertNoErrors
	 }
	 
	 @Test
	 def testAliasShouldBeOneLevelOnly_validComplex() {
	 	val model = '''
			package p;
			type T1;
			type T2 is (T1, T1);
		'''.parse
		model.assertNoErrors
	 }
	 
	 @Test
	 def testAliasShouldBeOneLevelOnly_invalid() {
	 	val model = '''
			package p;
			
			type T1;
			type T2 is T1;
			type T3 is T2;
		'''.parse
		model.assertError(ImlPackage.eINSTANCE.alias, INVALID_TYPE_DECLARATION)
	 }
	 
	 @Test
	 def testAliasShouldBeOneLevelOnly_invalidComplex() {
	 	val model = '''
			package p;
			
			type T1;
			type T2 is T1;
			type T3 is (T2, T1);
		'''.parse
		model.assertError(ImlPackage.eINSTANCE.alias, INVALID_TYPE_DECLARATION)
	 }
	 
	 @Test
	 def testTypesRelationsShouldHaveOnlyOneAlias() {
	 	val model = '''
			package p;
			
			type T1;
			type T2;
			type T3 is T1 is T2;
		'''.parse
		model.assertError(ImlPackage.eINSTANCE.namedType, INVALID_TYPE_DECLARATION)
	 }
	 
	 /*********************
	  * Check FolFormula
	  *********************  */
	 @Test
	 def testFormula_QuantifiedFormula_Valid() {
	 	val model = '''
			package p;
			
			type T1 {
				var0 : Bool;
				var1 : Bool := forall (a : Int) {a > 10 && var0};
			}
		'''.parse
		
		model.assertNoErrors
	 }
	 
	 @Test
	 def testFormula_QuantifiedFormula_Invalid() {
	 	val model = '''
			package p;
			
			type T1 {
				var1 : Bool := forall (a : Int) {10};
			}
		'''.parse
		
		model.assertError(ImlPackage.eINSTANCE.folFormula, INVALID_TYPE_PARAMETER)
	 }	 
	 
	@Test
	 def testFormula_Boolean_Valid() {
	 	val model = '''
			package p;
			
			type T1 {
				var1 : Bool := 5 > 2 && true;
			}
		'''.parse
		
		model.assertNoErrors
	 }		
	 
	 @Test
	 def testFormula_Boolean_Invalid() {
	 	val model = '''
			package p;
			
			type T1 {
				var1 : Bool := 5-2 && true;
			}
		'''.parse
		
		model.assertError(ImlPackage.eINSTANCE.folFormula, INVALID_TYPE_PARAMETER)
	 }	
	 
	@Test
	 def testFormula_SignedAtomicFormula_Valid() {
	 	val model = '''
			package p;
			
			type T1 {
				var1 : Bool := !true;
			}
		'''.parse
		
		model.assertNoErrors
	 }		
	 
	 @Test
	 def testFormula_SignedAtomicFormula_Invalid() {
	 	val model = '''
			package p;
			
			type T1 {
				var1 : Bool := 5-2 && true;
			}
		'''.parse
		
		model.assertError(ImlPackage.eINSTANCE.folFormula, INVALID_TYPE_PARAMETER)
	 }
	 
	 @Test
	 def testFormula_AtomicFormula_ValidEq() {
	 	val model = '''
			package p;
			
			type T1 {
				var0: Int;
				var1 : Bool := 5 = var0;
			}
		'''.parse
		
		model.assertNoErrors
	 }		
	 
	 @Test
	 def testFormula_AtomicFormula_InvalidEq() {
	 	val model = '''
			package p;
			
			type T1 {
				var0 : Int;
				var1 : Bool := var0 = 5.5;
			}
		'''.parse
		
		model.assertError(ImlPackage.eINSTANCE.folFormula, INCOMPATIBLE_TYPES)
	 }	
	 
	 @Test
	 def testFormula_AtomicFormula_ValidRel() {
	 	val model = '''
			package p;
			
			type T1 {
				var0: Int;
				var1 : Bool := 5.5 > var0;
			}
		'''.parse
		
		model.assertNoErrors
	 }		
	 
	 @Test
	 def testFormula_AtomicFormula_InvalidRel() {
	 	val model = '''
			package p;
			
			type T1 {
				var0 : Int;
				var1 : Bool := var0 < true;
			}
		'''.parse
		
		model.assertError(ImlPackage.eINSTANCE.folFormula, INVALID_TYPE_PARAMETER)
	 }
	 
	 @Test
	 def testFormula_Mod_Valid() {
	 	val model = '''
			package p;
			
			type T1 {
				var1 : Int := 5 mod 3;
			}
		'''.parse
		
		model.assertNoErrors
	 }		
	 
	 @Test
	 def testFormula_Mod_Invalid() {
	 	val model = '''
			package p;
			
			type T1 {
				var1 : Int := 5.5 mod 2;
			}
		'''.parse
		
		model.assertError(ImlPackage.eINSTANCE.folFormula, TYPE_MISMATCH_IN_TERM_EXPRESSION)
	 }
	 
	  @Test
	 def testFormula_TypeParameters_Valid() {
	 	val model = '''
			package p;
			
			type T1 <T, P>;
			
			type T2 {
				var1 : T1<Int,Bool>;
			}
		'''.parse
		
		model.assertNoErrors
	 }		
	 
	 @Test
	 def testFormula_TypeParameters_Invalid() {
	 	val model = '''
			package p;
						
			type T1 <T, P>;
			
			type T2 {
				var1 : T1<Int>;
			}
		'''.parse
		
		model.assertError(ImlPackage.eINSTANCE.simpleTypeReference, INVALID_PARAMETER_LIST)
	 }
	 
	 @Test
	 def issue26_AliasWithTuple() {
	 	val model = '''
	 	package iml.graphs;
	 	
	 	type Vertex ;
	 	
	 	type Edge is {v1:Vertex,v2:Vertex};
	 	
	 	type Graph {
	 	    edges : List<Edge> ;
	 	    something : List<Vertex>;
	 	    var1 : Graph := add(something.head, something.head);
	 	    add : Edge -> Graph := fun(x:Edge) {
	 	        some (y:Graph){y.edges = self.edges.push(x)}//<---------------- here!
	 	    } ;
	 	}
	 	
	 	type List<T> {
	 	    isEmpty : Bool ;
	 	    head :T ;
	 	    tail : List<T>;
	 	    push : T -> List<T> := fun (x:T) {
	 	        some (y:List<T>) { y.head = x && y.tail = self && y.isEmpty = false }  
	 		};
	 	}
	 	
	 	'''.parse
	 	
	 	model.assertNoErrors
	 }
	 
	 @Test
	 def testAliasWithTupleUsage() {
	 	val model = '''
	 	package test;
	 	
	 	type IntPair is (Int, Int);
	 	
	 	type T1 {
	 		fun1 : IntPair -> Real;
	 		fun2 : (Int, Int) -> Real;
	 		pair : IntPair;
	 		var1 : Real := fun1(pair);
	 		var2 : Real := fun1(1, 2);
	 		var3 : Real := fun2(pair);
	 		var4 : Real := fun2(1, 2);	 		
	 	}
	 	'''.parse
	 	
	 	model.assertNoErrors
	 }
	 
	 @Test
	 def issue39_TraitSelfBug() {
	 	val model = '''
	 	package p;
	 	trait Equatable {
	 	  eq: Self -> Bool;
	 	  // Reflexivity of eq
	 	  assert {
	 	       self.eq(self)
	 	  };
	 	  // Symmetry of eq
	 	  assert {
	 	       forall (x:Self) {self.eq(x) => x.eq(self)}
	 	  };
	 	  // Associativity of eq
	 	  assert {
	 	       forall (x:Self,y:Self) { 
	 	             self.eq(x) && x.eq(y) => self.eq(y) 
	 	       };
	 	  };
	 	};
	 	
	 	type T exhibits(Equatable) {
	 		x : Bool := eq(self);
	 	}
	 	'''.parse
	 	model.assertNoErrors
	 }
	 
	 @Test
	 def tesValidatorOverPolymorphicSymbol_Error() {
	 	val model = '''
	 		package test02;
	 		
	 		type ArrayList<T> ;
	 		
	 		empty_list<T>: ArrayList<T>;
	 		
	 		l: ArrayList<Int> := empty_list;
	 		
	 	'''.parse
	 	
	 	model.assertError(ImlPackage.eINSTANCE.symbolDeclaration, TYPE_MISMATCH_IN_TERM_EXPRESSION)
	 }
	 
	 @Test
	 def tesValidatorOverPolymorphicSymbol_NoError() {
	 	val model = '''
	 		package test02;
	 		
	 		type ArrayList<T> ;
	 		
	 		empty_list<T>: ArrayList<T>;
	 		
	 		l: ArrayList<Int> := empty_list<Int>;
	 		
	 	'''.parse
	 	
	 	model.assertNoErrors
	 }
	 
	 @Test
	 def testTupleConstructorForRecord() {
	 	val model = '''
	 		package p;
	 		
	 		type T {
	 			v1 : {a: Int, b: Real} := (5, 0.5);
	 		}
	 	'''.parse
	 	
	 	model.assertError(ImlPackage.eINSTANCE.symbolDeclaration, 
	 		TYPE_MISMATCH_IN_TERM_EXPRESSION
	 	)
	 }
	 
	 @Test
	 def testRecordConstructor() {
	 	val model = '''
	 		package p;
	 		
	 		type T {
	 			v1 : {a: Int, b: Real} := some(x: {a: Int, b: Real}) {
	 				x.a=5 && x.b=0.5;
	 			};
	 		}
	 	'''.parse
	 	
	 	model.assertNoErrors
	 }
	 
	 /**
	  * Datatypes validation
	  */
	 @Test
	 def testValidDatatypeDeclaration() {
	 	val model = '''
	 		package p;
	 		
	 		datatype T (empty, cons(T, Int));
	 	'''.parse
	 	
	 	model.assertNoErrors
	 }
	 
	 @Test
	 def testValidDatatypeDeclaration_Invalid_MissingConstructors() {
	 	val model = '''
	 		package p;
	 		datatype T;
	 	'''.parse
	 	
	 	model.assertError(ImlPackage.eINSTANCE.datatype, INVALID_TYPE_DECLARATION)
	 }
	 
	 @Test
	 def testValidDatatypeDeclaration_Invalid_NotDatatype() {
	 	val model = '''
	 		package p;
	 		type T (empty);
	 	'''.parse
	 	
	 	model.assertError(ImlPackage.eINSTANCE.namedType, INVALID_TYPE_DECLARATION)
	 }
	 
	 @Test
	 def testValidMatchExpression_ValidDatatype() {
	 	val model = '''
	 		package p;
	 		datatype T(empty) {
	 			x : Int := match(self) {empty: 0;};
	 		};
	 	'''.parse
	 	
	 	model.assertNoErrors
	 }
	 
	 @Test
	 def testValidMatchExpression_NotDatatype() {
	 	val model = '''
	 		package p;
	 		type T {
	 			x : Int := match(self) {empty: 0;};
	 		};
	 	'''.parse
	 	
	 	model.assertError(ImlPackage.eINSTANCE.matchExpression, MATCH_NOT_DATATYPE)
	 }
	 
	 @Test
	 def testValidMatchStatment_ValidParamList_Zero() {
	 	val model = '''
	 		package p;
	 		datatype T(empty, something(Int, Real)) {
	 			x : Int := match(self) {empty: 0;};
	 		};
	 	'''.parse
	 	
	 	model.assertNoErrors
	 }
	 
	 @Test
	 def testValidMatchStatment_ValidParamList() {
	 	val model = '''
	 		package p;
	 		datatype T(empty, something(Int, Real)) {
	 			x : Int := match(self) {something(a, b): 0;};
	 		};
	 	'''.parse
	 	
	 	model.assertNoErrors
	 }
	 
	 @Test
	 def testValidMatchStatment_InvalidParamList() {
	 	val model = '''
	 		package p;
	 		datatype T(empty, something(Int, Real)) {
	 			x : Int := match(self) {something: 0;};
	 		};
	 	'''.parse
	 	
	 	model.assertError(ImlPackage.eINSTANCE.matchStatement, INVALID_PARAMETER_LIST)
	 }
	 
	 @Test
	 def testDatatypeInit_Valid_NoParams() {
	 	val model = '''
	 		package p;
	 		datatype T(empty, something(Int, Real)) {
	 		};
	 		
	 		d : T := T.empty;
	 	'''.parse
	 	
	 	model.assertNoErrors
	 }
	 
	 @Test
	 def testDatatypeInit_Valid_WithParams() {
	 	val model = '''
	 		package p;
	 		datatype T(empty, something(Int, Bool)) {
	 		};
	 		
	 		d : T := T.something(5, false);
	 	'''.parse
	 	
	 	model.assertNoErrors
	 }
	 
	 @Test
	 def testDatatypeInit_Invalid_ExtraParams() {
	 	val model = '''
	 		package p;
	 		datatype T(empty, something(Int, Bool)) {
	 		};
	 		
	 		d : T := T.empty(5, false);
	 	'''.parse
	 	
	 	model.assertError(ImlPackage.eINSTANCE.termMemberSelection, INVALID_PARAMETER_LIST)
	 }
	 
	 @Test
	 def testDatatypeInit_Invalid_NoParams() {
	 	val model = '''
	 		package p;
	 		datatype T(empty, something(Int, Bool)) {
	 		};
	 		
	 		d : T := T.something;
	 	'''.parse
	 	
	 	model.assertError(ImlPackage.eINSTANCE.termMemberSelection, INVALID_PARAMETER_LIST)
	 }
	 
	 @Test
	 def testDatatypeInit_Invalid_WrongSizeParams() {
	 	val model = '''
	 		package p;
	 		datatype T(empty, something(Int, Bool)) {
	 		};
	 		
	 		d : T := T.something(5);
	 	'''.parse
	 	
	 	model.assertError(ImlPackage.eINSTANCE.termMemberSelection, INVALID_PARAMETER_LIST)
	 }
	 
	 @Test
	 def testDatatypeInit_Invalid_NotMatchingParams() {
	 	val model = '''
	 		package p;
	 		datatype T(empty, something(Int, Bool)) {
	 		};
	 		
	 		d : T := T.something(false, 5);
	 	'''.parse
	 	
	 	model.assertError(ImlPackage.eINSTANCE.termMemberSelection, INVALID_PARAMETER_LIST)
	 }
	 
	 @Test
	 def testDatatypeInit_Valid_WithTemplates() {
	 	val model = '''
	 		package p;
	 		datatype List<T> ( empty, cons(T, List<T>) ) {
	 		};
	 		
	 		d : List<Int> := List<Int>.cons(5, List<Int>.empty);
	 	'''.parse
	 	
	 	model.assertNoErrors
	 }
	 
	 @Test
	 def testDatatypeInit_Invalid_WithTemplates() {
	 	val model = '''
	 		package p;
	 		datatype List<T> ( empty, cons(T, List<T>) ) {
	 		};
	 		
	 		d : List<Int> := List<Int>.cons(5, List<Bool>.empty);
	 	'''.parse
	 	
	 	model.assertError(ImlPackage.eINSTANCE.termMemberSelection, INVALID_PARAMETER_LIST)
	 }
	 
	 @Test
	 def void testCorrectRelationForRefinement_Valid() {
	 	'''
	 		package p;
	 		trait tr;
	 		trait tr2 refines(tr); 		
	 	'''.parse.assertNoErrors
	 }
	 
	 @Test
	 def void testCorrectRelationForRefinement_InvalidInclues() {
	 	'''
	 		package p;
	 		trait tr;
	 		trait tr2 includes(tr); 		
	 	'''.parse.assertError(ImlPackage.eINSTANCE.inclusion, INVALID_RELATION)
	 }
	 
	 @Test
	 def void testCorrectRelationForRefinement_NotTrait() {
	 	'''
	 		package p;
	 		type t1;
	 		trait tr2 refines(tr); 		
	 	'''.parse.assertError(ImlPackage.eINSTANCE.refinement, INVALID_RELATION)
	 }
	 
	 @Test
	 def void testScopeOfAnnotation() {
	 	'''
	 	package p;
	 	annotation An {
	 		a : Int;
	 	}
	 	
	 	type [An {a=1}] t1 {
	 		
	 	}
	 	'''.parse.assertNoErrors
	 }
	 
	 
}