package com.utc.utrc.hermes.iml.tests.typing

import com.google.inject.Inject
import com.utc.utrc.hermes.iml.iml.ArrayType
import com.utc.utrc.hermes.iml.iml.FunctionType
import com.utc.utrc.hermes.iml.iml.ImlType
import com.utc.utrc.hermes.iml.iml.IteTermExpression
import com.utc.utrc.hermes.iml.iml.LambdaExpression
import com.utc.utrc.hermes.iml.iml.Model
import com.utc.utrc.hermes.iml.iml.NamedType
import com.utc.utrc.hermes.iml.iml.SequenceTerm
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration
import com.utc.utrc.hermes.iml.iml.TupleType
import com.utc.utrc.hermes.iml.tests.ImlInjectorProvider
import com.utc.utrc.hermes.iml.tests.TestHelper
import com.utc.utrc.hermes.iml.typing.ImlTypeProvider
import com.utc.utrc.hermes.iml.typing.TypingServices
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.util.ParseHelper
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import org.junit.Test
import org.junit.runner.RunWith

import static org.junit.Assert.*
import com.utc.utrc.hermes.iml.lib.ImlStdLib
import com.utc.utrc.hermes.iml.ImlParseHelper

/**
 * Test related helper methods
 * @author Ayman Elkfrawy
 */
@RunWith(XtextRunner)
@InjectWith(ImlInjectorProvider)
class ImlTypeProviderTest {
	
	@Inject extension ImlParseHelper
	
	@Inject extension ValidationTestHelper
	
	@Inject extension TestHelper
	
	@Inject extension ImlStdLib
	
	@Inject ImlTypeProvider typeProvider
	
	@Inject TypingServices typingServices
	
	@Test
	def testTermExpressionType_withAddition_int() {
		assertFormulaType("5 + 6", "Int", createIntRef);
	}
	
	@Test
	def testTermExpressionType_withAddition_real() {
		assertFormulaType("5 * 6.5", "Real", createRealRef);
	}
	
	@Test
	def testTermExpressionType_withAddition_realDiv() {
		assertFormulaType("5 / 6", "Real",createRealRef);
	}
	
	@Test
	def testTermExpressionType_withAddition_boolean() {
		assertFormulaType("5 = 6", "Bool", createBoolRef);
	}
	
	@Test
	def testTermExpressionType_withAnd_boolean() {
		assertFormulaType("true && false", "Bool", createBoolRef);
	}
	
	def assertFormulaType(String formula, String declaredType, ImlType type) {
		val model = '''
			package p;
			type t1 {
				var1 : «declaredType» := «formula»;
			}
			
		'''.parse
		model.assertNoErrors
		
		var t1 = model.findSymbol("t1") as NamedType
		val var1 = t1.findSymbol("var1") 
		val folForm = var1.definition
		
		assertTrue(typingServices.isEqual(typeProvider.termExpressionType(folForm), type))
		
	}
	
	@Test
	def testTermExpressionType() {
		val model = '''
			package p;
			type t1 {
				var1 : t2 := var2;
				var2 : t2;
			}
			
			type t2;
			
		'''.parse
		model.assertNoErrors
		
		var t1 = model.findSymbol("t1") as NamedType
		var t2 = model.findSymbol("t2") as NamedType
		val var1 = t1.findSymbol("var1") 
		val folForm = var1.definition
		
		val exprType = typeProvider.termExpressionType(folForm)
		
		assertTrue(typingServices.isEqual((exprType as SimpleTypeReference).type, t2))
	}
	
	@Test
	def testTermExpressionType_withTermSelection() {
		val model = '''
			package p;
			type t1 {
				var1 : Int := var2.varx;
				var2 : t2;
			}
			
			type t2 {
				varx : Int;	
			};
			
		'''.parse
		model.assertNoErrors
		
		var t1 = model.findSymbol("t1") as NamedType
		val var1 = t1.findSymbol("var1") 
		val folForm = var1.definition
		
		val exprType = typeProvider.termExpressionType(folForm)
		
		assertTrue(typingServices.isEqual((exprType as SimpleTypeReference).type, intType))
	}
	
	@Test
	def testTermExpressionType_withTermSelection_Extension() {
		val model = '''
			package p;
			type t1 {
				var1 : Int := var2.varx;
				var2 : t2;
			}
			
			type t2 extends (t3) {
			};
			
			type t3 {
				varx : Int;
			}
			
		'''.parse
		model.assertNoErrors
		
		var t1 = model.findSymbol("t1") as NamedType
		val folForm = t1.findSymbol("var1").definition
		
		val exprType = typeProvider.termExpressionType(folForm)
		
		assertTrue(typingServices.isEqual((exprType as SimpleTypeReference).type, intType))
	}
	
	@Test
	def testTermExpressionType_FunctionWithTail() {
		val model = '''
			package p;
			type t1 {
				var1 : Int := var2 (5, 6);
				var2 : (p1 : Int, p2 : Real) -> Int;
			}			
		'''.parse
		model.assertNoErrors
		
		var t1 = model.findSymbol("t1") as NamedType
		val var1 = t1.findSymbol("var1") 
		val folForm = var1.definition
		
		val exprType = typeProvider.termExpressionType(folForm)
		
		assertEquals((exprType as SimpleTypeReference).type, intType)
	}
	
	@Test
	def testTermExpressionType_FunctionWithoutTail() {
		val model = '''
			package p;
			type t1 {
				var1 : (Int, Real)->Int := var2;
				var2 : (p1 : Int, p2 : Real) -> Int;
			}			
		'''.parse
		model.assertNoErrors
		
		var t1 = model.findSymbol("t1") as NamedType
		val var1 = t1.findSymbol("var1") 
		val var2 = t1.findSymbol("var2") 
		val folForm = var1.definition
		
		val exprType = typeProvider.termExpressionType(folForm)
		
		assertTrue(typingServices.isEqual(exprType, var2.type))
	} 
	
	@Test
	def testTermExpressionType_FTWithTemplate() {
		val model = '''
			package p;
			type t1 {
				var1 : (Int)->Real := var2.varx;
				var2 : t2<Int, Real>;
			}
			
			type t2 <T, P> {
				varx : (p : T) -> P;
			}		
		'''.parse
		model.assertNoErrors
		
		var t1 = model.findSymbol("t1") as NamedType
		val var1 = t1.findSymbol("var1") 
		val folForm = var1.definition
		val exprType = typeProvider.termExpressionType(folForm)

		assertTrue(exprType instanceof FunctionType)
		val domain = (exprType as FunctionType).domain as TupleType
		assertEquals(intType, (domain.symbols.get(0).type as SimpleTypeReference).type)
		assertEquals(realType, ((exprType as FunctionType).range as SimpleTypeReference).type)
	}
	
	@Test
	def testTermExpressionType_BindingWithTemplate() {
		val model = '''
			package p;
			type List <T>;
			
			type t1 {
				var1 : List<Int> := var2.varx;
				var2 : t2<List<Int> >;
			}
			
			type t2 <T> {
				varx : T;
			}		
		'''.parse
		model.assertNoErrors
		
		var t1 = model.findSymbol("t1") as NamedType
		val var1 = t1.findSymbol("var1") 
		val List = model.findSymbol("List")
		val folForm = var1.definition
		val exprType = typeProvider.termExpressionType(folForm) as SimpleTypeReference	
			
		assertEquals(List, exprType.type)		
		assertEquals(intType, (exprType.typeBinding.get(0) as SimpleTypeReference).type)
	}
	
	@Test
	def testTermExpressionType_BindingWithFunctionTemplate() {
		val model = '''
			package p;
			type List <T>;
			
			type t1 {
				var1 : List<Int->Real> := var2.varx;
				var2 : t2<List<Int->Real> >;
			}
			
			type t2 <T> {
				varx : T;
			}		
		'''.parse
		model.assertNoErrors
		
		var t1 = model.findSymbol("t1") as NamedType
		val var1 = t1.findSymbol("var1") 
		val folForm = var1.definition
		val exprType = (typeProvider.termExpressionType(folForm) as SimpleTypeReference)
						.typeBinding.get(0)	
			
		assertTrue(exprType instanceof FunctionType)
		assertEquals(intType, ((exprType as FunctionType).domain as SimpleTypeReference).type)
		assertEquals(realType, ((exprType as FunctionType).range as SimpleTypeReference).type)
	}
	
	@Test
	def testTermExpressionType_BindingWithTemplatedTemplate() {
		val model = '''
			package p;
			type List <T>;
			
			type t1 {
				var1 : List<Int> := var3.var2.varx;
				var3 : t3<Int>;
			}
			
			type t2 <T> {
				varx : T;
			}
			
			type t3 <T> {
				var2 : t2<List<T> >;
			}
		'''.parse
		model.assertNoErrors
		
		var t1 = model.findSymbol("t1") as NamedType
		val var1 = t1.findSymbol("var1") 
		val List = model.findSymbol("List")
		val folForm = var1.definition
		val exprType = typeProvider.termExpressionType(folForm) as SimpleTypeReference	// t2<List<Int>>
			
		assertEquals(List, exprType.type)		
		assertEquals(intType, (exprType.typeBinding.get(0) as SimpleTypeReference).type)
	}
	
	@Test
	def testTermExpressionType_TemplateWithExtension() {
		val model = '''
			package p;
			
			type T1<T> {
				t1Var : T -> T;
			}
			
			type T2<T> extends (T1<Int>) {
				t2Var : T[];
			}
			
			type T3 {
				var1 : T2<Real>;
				x : Int -> Int := var1.t1Var;
			}
		'''.parse
		
		model.assertNoErrors
		
		val x = (model.findSymbol("T3") as NamedType).findSymbol("x") as SymbolDeclaration
		val xExprType = typeProvider.termExpressionType(x.definition)
		assertTrue(typingServices.isEqual(xExprType, x.type))
	}
	
	@Test
	def testTermExpressionType_LambdaWithOneElement() {
		val model = '''
			package p;
			type t1 {
				varx : (Int)->Bool := fun (p1: Int) {true;};
			}
		'''.parse
		
		model.assertNoErrors
		val t1 = model.findSymbol("t1") as NamedType
		val exprType = typeProvider.termExpressionType(t1.findSymbol("varx").definition)
		
		assertEquals(intType, ((exprType as FunctionType).domain  as SimpleTypeReference).type)
		assertTrue(typingServices.isEqual(createBoolRef, (exprType as FunctionType).range))
	}
	
	@Test
	def testTermExpressionType_LambdaWithMultipleElement() {
		val model = '''
			package p;
			type t1 {
				varx : (Int)->Int := fun (p1: Int) {var x: Bool := true; 3*5;};
			}
		'''.parse
		
		model.assertNoErrors
		val t1 = model.findSymbol("t1") as NamedType
		val exprType = typeProvider.termExpressionType(t1.findSymbol("varx").definition)
		
		assertEquals(intType, ((exprType as FunctionType).domain as SimpleTypeReference).type)
		assertTrue(typingServices.isEqual(createIntRef, (exprType as FunctionType).range))
	}
	
	@Test
	def testTermExpressionType_ArrayAccess() {
		val model = '''
			package p;
			type t1 {
				varx : Real[] := var1;
				var1 : Real[10];
			}
		'''.parse
		
		model.assertNoErrors
		val t1 = model.findSymbol("t1") as NamedType
		val var1 = t1.findSymbol("var1").type
		val exprType = typeProvider.termExpressionType(t1.findSymbol("varx").definition)
		
		assertTrue(typingServices.isEqual(var1, exprType))
	}
	
	@Test
	def testTermExpressionType_ArrayAccessWithIndex() {
		val model = '''
			package p;
			type t1 {
				varx : Real := var1[1];
				var1 : Real[10];
			}
		'''.parse
		
		model.assertNoErrors
		val t1 = model.findSymbol("t1") as NamedType
		val exprType = typeProvider.termExpressionType(t1.findSymbol("varx").definition)
		
		assertEquals(realType, (exprType as SimpleTypeReference).type)
	}
	
	@Test
	def testTermExpressionType_ArrayAccessWithPartialIndex() {
		val model = '''
			package p;
			type t1 {
				varx : Real[][] := var1[1];
				var1 : Real[10][20][30];
			}
		'''.parse
		
		model.assertNoErrors
		val t1 = model.findSymbol("t1") as NamedType
		val exprType = typeProvider.termExpressionType(t1.findSymbol("varx").definition)
		
		assertTrue(exprType instanceof ArrayType)
		assertEquals(2, (exprType as ArrayType).dimensions.size)
	}
	
	@Test
	def testTermExpressionType_ArrayAccessWithTuple() {
		val model = '''
			package p;
			type t1 {
				varx : Real := var1[1];
				var1 : (e1: Int, e2:Real);
			}
		'''.parse
		
		model.assertNoErrors
		val t1 = model.findSymbol("t1") as NamedType
		val exprType = typeProvider.termExpressionType(t1.findSymbol("varx").definition)
		
		assertEquals(realType, (exprType as SimpleTypeReference).type)
	}
	
	@Test
	def testTermExpressionType_ArrayAccessWithTupleUsingName() {
		val model = '''
			package p;
			type t1 {
				varx : Real := var1[e2];
				var1 : (e1: Int, e2:Real);
			}
		'''.parse
		
		model.assertNoErrors
		val t1 = model.findSymbol("t1") as NamedType
		val exprType = typeProvider.termExpressionType(t1.findSymbol("varx").definition)
		
		assertEquals(realType, (exprType as SimpleTypeReference).type)
	}
	
	@Test
	def testTermExpressionType_TupleConstructor() {
		val model = '''
			package p;
			type t1 {
				varx : (Int, Bool, Real) := (2, false, 2.5);
			}
		'''.parse
		
		model.assertNoErrors
		
		val t1 = model.findSymbol("t1") as NamedType
		val exprType = typeProvider.termExpressionType(t1.findSymbol("varx").definition)
		
		assertTrue(exprType instanceof TupleType)
		assertEquals(3, (exprType as TupleType).symbols.size)
		assertTrue(typingServices.isEqual(createIntRef, (exprType as TupleType).symbols.get(0).type))
		assertTrue(typingServices.isEqual(createBoolRef, (exprType as TupleType).symbols.get(1).type))
		assertTrue(typingServices.isEqual(createRealRef, (exprType as TupleType).symbols.get(2).type))
	}
	
	@Test
	def testTermExpressionType_IfThen() {
		val model = '''
			package p;
			type t1 {
				varx : Int := if (true) {5};
			}
		'''.parse
		
		model.assertNoErrors
		
		val t1 = model.findSymbol("t1") as NamedType
		val exprType = typeProvider.termExpressionType(t1.findSymbol("varx").definition)
		
		assertTrue(typingServices.isEqual(createIntRef, exprType))
	}
	
	@Test
	def testTermExpressionType_IfThenElse() {
		val model = '''
			package p;
			type t1 {
				varx : Int := if (true) {5} else {true};
			}
		'''.parse
		
		model.assertNoErrors
		
		val t1 = model.findSymbol("t1") as NamedType
		val exprType = typeProvider.termExpressionType(t1.findSymbol("varx").definition)
		
		assertTrue(typingServices.isEqual(createIntRef, exprType))
	}
	
	@Test
	def testTermExpressionType_FiniteSelection() {
		val model = '''
			package p;
			type t1 {
				varx : t2 := t2[0];
			}
			type t2 finite 2;
		'''.parse
		
		model.assertNoErrors
		
		val t1 = model.findSymbol("t1") as NamedType
		val t2 = model.findSymbol("t2") as NamedType
		val exprType = typeProvider.termExpressionType(t1.findSymbol("varx").definition)
		
		assertEquals(t2, (exprType as SimpleTypeReference).type)
	}
	
	@Test
	def testTermExpressionType_LiteralSelectionWithLiteral() {
		val model = '''
			package p;
			type t1 {
				varx : t2 := t2.e2;
			}
			type t2 enum {e1, e2};
		'''.parse
		
		model.assertNoErrors
		
		val t1 = model.findSymbol("t1") as NamedType
		val t2 = model.findSymbol("t2") as NamedType
		val exprType = typeProvider.termExpressionType(t1.findSymbol("varx").definition)
		
		assertEquals(t2, (exprType as SimpleTypeReference).type)
	}
	
	@Test
	def testTermExpressionType_ComplexTail() {
		val model = '''
		    package p;
		    type t1 {
		    	vx: (Int, Real -> (size: Int, matrix: Real[10][20]));
		    	v1: (Int, Real -> (Int, Real[10][20])) := vx;
		    	v2: Int := vx[0];
		    	v3: Real -> (Int, Real[0][0]) := vx[1];
		    	v4: (Int, Real[0][0]) := vx[1](100);
		    	v5: Int := vx[1](100)[0];
		    	v6: Real[0][0] := vx[1](100)[matrix];
		    	v7: Real[0] := vx[1](100)[1][5];
		    	v8: Real := vx[1](100)[matrix][5][50];
		    }
		'''.parse
		
		model.assertNoErrors
		
		val t1 = model.findSymbol("t1") as NamedType
		#["v1", "v2", "v3", "v4", "v5", "v6", "v7", "v8"]
		      .forEach[assertTypeMatches(t1.findSymbol(it))]
	}
	
	@Test
	def typeOfImplicitConstructor(){
		val model = '''
		package iml.notes ;
		type Date ;
		type Employee {
			level : Int;
			supervisor : Employee;
			salary : Date -> Int; 
		};
		sup : Employee ;
		aEmployee : Employee := some(x:Employee) { x.level = 4 && x.supervisor = sup} ;
		'''.parse
		model.assertNoErrors

		val aEmployee = model.symbols.last as SymbolDeclaration
//		val constr = aEmployee.definition.left as ImplicitInstanceConstructor
//		val type = typeProvider.termExpressionType(constr)
		return 
	}
	
	@Test
	def typeForLambdas(){
		val model = '''
		package iml.notes ;
		type A1 {
			c : Int := 4 ;
			d : Int ;
			f : Int -> Int := fun ( x : Int ) { x + 1 } ;
			assert { d > 0 };
		};
		'''.parse
		
		val f = findSymbol(model.symbols.last as NamedType,"f")
		val fdef = f.definition.left
		val type  = typeProvider.termExpressionType(fdef)
		model.assertNoErrors
		return
		
	}
	
	@Test
	def typeForPolymorphicTypes(){
		val model = '''
		package iml.notes.stackmodel ;
		type Stack<T> {
		  top: T;
		  rest : Stack<T>;
		  isEmpty: Bool;
		  pop : () -> Stack<T> := fun (x:()) {
		     if (!isEmpty) { 
		       some (s : Stack<T>) { s.top = s.rest.top && 
		                 s.rest = s.rest.pop() &&
		                 s.isEmpty = s.rest.isEmpty } 
		    }
		  } ;
		  push : T -> Stack<T> := fun (x:T) {
		    some (s: Stack<T>) { s.top = x && s.rest = self && s.isEmpty = false } 
		  } ;
		} ;
		
		<T>emptyStack : Stack<T> := some (s: Stack<T>) { s.isEmpty = true };
		
		e : Stack<Int> := <Int>emptyStack ;
		
		s : Stack<Int> := e.push(1).push(2).push(3) ;
		'''.parse
		
		model.assertNoErrors
		
		val stackt = model.findSymbol("Stack") as NamedType
		val pop = stackt.findSymbol("pop") as SymbolDeclaration
		val popdefite = ((pop.definition.left as LambdaExpression).definition as SequenceTerm).^return.left as IteTermExpression
//		val rest_pop = (popdefite.left as SequenceTerm).^return.left.left.left.right as TermMemberSelection
//		val rest = rest_pop.receiver
//		val type = typeProvider.termExpressionType(rest);
//		val rest_decl = stackt.symbols.get(1) as SymbolDeclaration
//		assertTrue(typingServices.isEqual(type,rest_decl.type))
//		
//		val s = model.symbols.last as SymbolDeclaration
//		val e_push = s.definition.left as TermMemberSelection
//		val e_push_type = typeProvider.termExpressionType(e_push)
//		assertTrue(typingServices.isEqual(e_push_type,s.type))
		
	}
	
	@Test
	def typeForPolymorphicSymbols(){
		val model = '''
		package iml.notes.stackmodel ;
		type Stack<T> {
		  top: T;
		  rest : Stack<T>;
		  isEmpty: Bool;
		  pop : () -> Stack<T> := fun (x:()) {
		     if (!isEmpty) { 
		       some(Stack<T>) { top = rest.top && 
		                 rest = rest.pop() &&
		                 isEmpty = rest.isEmpty } 
		    }
		  } ;
		  push : T -> Stack<T> := fun (x:T) {
		    some(Stack<T>) { top = x && rest = self && isEmpty = false } 
		  } ;
		} ;
		
		<T>emptyStack : Stack<T> := some(Stack<T>) { isEmpty = true };
		
		e : Stack<Int> := <Int>emptyStack ;
		'''.parse
		
		val e = model.symbols.last as SymbolDeclaration
		val d = e.definition.left
		val t = typeProvider.termExpressionType(d)
		val equal = typingServices.isEqual(e.type, t)
		assertTrue(equal)
	}
	
	@Test
	def testAliasWithBinding() {
		val model = '''
		package p;
		type List<T> {
			item : T;
		}
		type IntList is List<Int>;
		
		v1 : IntList;
		v2 : Int := v1.item;		
		'''.parse
		
		model.assertNoErrors
	}
	
	
	def assertTypeMatches(SymbolDeclaration symbol) {
		assertTrue(typingServices.isEqual(symbol.type, typeProvider.termExpressionType(symbol.definition)))
	}
	
}