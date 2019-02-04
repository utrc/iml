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
import com.utc.utrc.hermes.iml.typing.ImlTypeProvider
import com.utc.utrc.hermes.iml.iml.HigherOrderType
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference
import com.utc.utrc.hermes.iml.iml.TupleType
import com.utc.utrc.hermes.iml.iml.ArrayType
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration
import com.utc.utrc.hermes.iml.iml.ImplicitInstanceConstructor
import com.utc.utrc.hermes.iml.iml.LambdaExpression
import com.utc.utrc.hermes.iml.iml.SequenceTerm
import com.utc.utrc.hermes.iml.iml.IteTermExpression
import com.utc.utrc.hermes.iml.iml.TermMemberSelection

import static com.utc.utrc.hermes.iml.lib.ImlStdLib.*

/**
 * Test related helper methods
 * @author Ayman Elkfrawy
 */
@RunWith(XtextRunner)
@InjectWith(ImlInjectorProvider)
class ImlTypeProviderTest {
	
	@Inject extension ParseHelper<Model>
	
	@Inject extension ValidationTestHelper
	
	@Inject extension TestHelper
	
	@Test
	def testTermExpressionType_withAddition_int() {
		assertFormulaType("5 + 6", "Int", INT_REF);
	}
	
	@Test
	def testTermExpressionType_withAddition_real() {
		assertFormulaType("5 * 6.5", "Real", REAL_REF);
	}
	
	@Test
	def testTermExpressionType_withAddition_realDiv() {
		assertFormulaType("5 / 6", "Real",REAL_REF);
	}
	
	@Test
	def testTermExpressionType_withAddition_boolean() {
		assertFormulaType("5 = 6", "Bool", BOOL_REF);
	}
	
	@Test
	def testTermExpressionType_withAnd_boolean() {
		assertFormulaType("true && false", "Bool", BOOL_REF);
	}
	
	def assertFormulaType(String formula, String declaredType, HigherOrderType type) {
		val model = '''
			package p;
			type Int;
			type Real;
			type Bool;
			type t1 {
				var1 : «declaredType» := «formula»;
			}
			
		'''.parse
		model.assertNoErrors
		
		var t1 = model.findSymbol("t1") as ConstrainedType
		val var1 = t1.findSymbol("var1") 
		val folForm = var1.definition
		
		assertEquals(ImlTypeProvider.termExpressionType(folForm), type)
		
	}
	
	@Test
	def testTermExpressionType() {
		val model = '''
			package p;
			type Int;
			type Real;
			type t1 {
				var1 : t2 := var2;
				var2 : t2;
			}
			
			type t2;
			
		'''.parse
		model.assertNoErrors
		
		var t1 = model.findSymbol("t1") as ConstrainedType
		var t2 = model.findSymbol("t2") as ConstrainedType
		val var1 = t1.findSymbol("var1") 
		val folForm = var1.definition
		
		val exprType = ImlTypeProvider.termExpressionType(folForm)
		
		assertEquals((exprType as SimpleTypeReference).type, t2)
	}
	
	@Test
	def testTermExpressionType_withTermSelection() {
		val model = '''
			package p;
			type Int;
			type Real;
			type t1 {
				var1 : Int := var2.varx;
				var2 : t2;
			}
			
			type t2 {
				varx : Int;	
			};
			
		'''.parse
		model.assertNoErrors
		
		var t1 = model.findSymbol("t1") as ConstrainedType
		var intType = model.findSymbol("Int") as ConstrainedType
		val var1 = t1.findSymbol("var1") 
		val folForm = var1.definition
		
		val exprType = ImlTypeProvider.termExpressionType(folForm)
		
		assertEquals((exprType as SimpleTypeReference).type, intType)
	}
	
	@Test
	def testTermExpressionType_withTermSelection_Extension() {
		val model = '''
			package p;
			type Int;
			type Real;
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
		
		var t1 = model.findSymbol("t1") as ConstrainedType
		var intType = model.findSymbol("Int") as ConstrainedType
		val folForm = t1.findSymbol("var1").definition
		
		val exprType = ImlTypeProvider.termExpressionType(folForm)
		
		assertEquals((exprType as SimpleTypeReference).type, intType)
	}
	
	@Test
	def testTermExpressionType_HOTWithTail() {
		val model = '''
			package p;
			type Int;
			type Real;
			type t1 {
				var1 : Int := var2 (5, 6);
				var2 : (p1 : Int, p2 : Real) -> Int;
			}			
		'''.parse
		model.assertNoErrors
		
		var t1 = model.findSymbol("t1") as ConstrainedType
		var intType = model.findSymbol("Int") as ConstrainedType
		val var1 = t1.findSymbol("var1") 
		val folForm = var1.definition
		
		val exprType = ImlTypeProvider.termExpressionType(folForm)
		
		assertEquals((exprType as SimpleTypeReference).type, intType)
	}
	
	@Test
	def testTermExpressionType_HOTWithoutTail() {
		val model = '''
			package p;
			type Int;
			type Real;
			type t1 {
				var1 : (Int, Real)->Int := var2;
				var2 : (p1 : Int, p2 : Real) -> Int;
			}			
		'''.parse
		model.assertNoErrors
		
		var t1 = model.findSymbol("t1") as ConstrainedType
		val var1 = t1.findSymbol("var1") 
		val var2 = t1.findSymbol("var2") 
		val folForm = var1.definition
		
		val exprType = ImlTypeProvider.termExpressionType(folForm)
		
		assertTrue(TypingServices.isEqual(exprType, var2.type))
	} 
	
	@Test
	def testTermExpressionType_HOTWithTemplate() {
		val model = '''
			package p;
			type Int;
			type Real;
			type t1 {
				var1 : (Int)->Real := var2.varx;
				var2 : t2<Int, Real>;
			}
			
			type t2 <T, P> {
				varx : (p : T) -> P;
			}		
		'''.parse
		model.assertNoErrors
		
		var t1 = model.findSymbol("t1") as ConstrainedType
		val var1 = t1.findSymbol("var1") 
		val Int = model.findSymbol("Int")
		val Real = model.findSymbol("Real")
		val folForm = var1.definition
		val exprType = ImlTypeProvider.termExpressionType(folForm)

		assertNotNull(exprType.domain)
		assertNotNull(exprType.range)
		val domain = exprType.domain as TupleType
		assertEquals(Int, (domain.symbols.get(0).type as SimpleTypeReference).type)
		assertEquals(Real, (exprType.range as SimpleTypeReference).type)
	}
	
	@Test
	def testTermExpressionType_BindingWithTemplate() {
		val model = '''
			package p;
			type Int;
			type Real;
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
		
		var t1 = model.findSymbol("t1") as ConstrainedType
		val var1 = t1.findSymbol("var1") 
		val List = model.findSymbol("List")
		val Int = model.findSymbol("Int")
		val folForm = var1.definition
		val exprType = ImlTypeProvider.termExpressionType(folForm) as SimpleTypeReference	
			
		assertEquals(List, exprType.type)		
		assertEquals(Int, (exprType.typeBinding.get(0) as SimpleTypeReference).type)
	}
	
	@Test
	def testTermExpressionType_BindingWithHOTTemplate() {
		val model = '''
			package p;
			type Int;
			type Real;
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
		
		var t1 = model.findSymbol("t1") as ConstrainedType
		val var1 = t1.findSymbol("var1") 
		val Int = model.findSymbol("Int")
		val Real = model.findSymbol("Real")
		val folForm = var1.definition
		val exprType = (ImlTypeProvider.termExpressionType(folForm) as SimpleTypeReference)
						.typeBinding.get(0)	
			
		assertNotNull(exprType.domain)
		assertNotNull(exprType.range)
		assertEquals(Int, (exprType.domain as SimpleTypeReference).type)
		assertEquals(Real, (exprType.range as SimpleTypeReference).type)
	}
	
	@Test
	def testTermExpressionType_BindingWithTemplatedTemplate() {
		val model = '''
			package p;
			type Int;
			type Real;
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
		
		var t1 = model.findSymbol("t1") as ConstrainedType
		val var1 = t1.findSymbol("var1") 
		val List = model.findSymbol("List")
		val Int = model.findSymbol("Int")
		val folForm = var1.definition
		val exprType = ImlTypeProvider.termExpressionType(folForm) as SimpleTypeReference	// t2<List<Int>>
			
		assertEquals(List, exprType.type)		
		assertEquals(Int, (exprType.typeBinding.get(0) as SimpleTypeReference).type)
	}
	
	@Test
	def testTermExpressionType_LambdaWithOneElement() {
		val model = '''
			package p;
			type Int;
			type Bool;
			type t1 {
				varx : (Int)->Bool := fun (p1: Int) {true;};
			}
		'''.parse
		
		model.assertNoErrors
		val t1 = model.findSymbol("t1") as ConstrainedType
		val Int = model.findSymbol("Int")
		val exprType = ImlTypeProvider.termExpressionType(t1.findSymbol("varx").definition)
		
		assertEquals(Int, (exprType.domain  as SimpleTypeReference).type)
		assertEquals(BOOL_REF, exprType.range)
	}
	
	@Test
	def testTermExpressionType_LambdaWithMultipleElement() {
		val model = '''
			package p;
			type Int;
			type Bool;
			type t1 {
				varx : (Int)->Int := fun (p1: Int) {var x: Bool := true; 3*5;};
			}
		'''.parse
		
		model.assertNoErrors
		val t1 = model.findSymbol("t1") as ConstrainedType
		val exprType = ImlTypeProvider.termExpressionType(t1.findSymbol("varx").definition)
		val Int = model.findSymbol("Int")
		
		assertEquals(Int, (exprType.domain as SimpleTypeReference).type)
		assertEquals(INT_REF, exprType.range)
	}
	
	@Test
	def testTermExpressionType_ArrayAccess() {
		val model = '''
			package p;
			type Int;
			type Real;
			type t1 {
				varx : Real[] := var1;
				var1 : Real[10];
			}
		'''.parse
		
		model.assertNoErrors
		val t1 = model.findSymbol("t1") as ConstrainedType
		val var1 = t1.findSymbol("var1").type
		val exprType = ImlTypeProvider.termExpressionType(t1.findSymbol("varx").definition)
		
		assertTrue(TypingServices.isEqual(var1, exprType))
	}
	
	@Test
	def testTermExpressionType_ArrayAccessWithIndex() {
		val model = '''
			package p;
			type Int;
			type Real;
			type t1 {
				varx : Real := var1[1];
				var1 : Real[10];
			}
		'''.parse
		
		model.assertNoErrors
		val t1 = model.findSymbol("t1") as ConstrainedType
		val Real = model.findSymbol("Real") 
		val exprType = ImlTypeProvider.termExpressionType(t1.findSymbol("varx").definition)
		
		assertEquals(Real, (exprType as SimpleTypeReference).type)
	}
	
	@Test
	def testTermExpressionType_ArrayAccessWithPartialIndex() {
		val model = '''
			package p;
			type Int;
			type Real;
			type t1 {
				varx : Real[][] := var1[1];
				var1 : Real[10][20][30];
			}
		'''.parse
		
		model.assertNoErrors
		val t1 = model.findSymbol("t1") as ConstrainedType
		val exprType = ImlTypeProvider.termExpressionType(t1.findSymbol("varx").definition)
		
		assertTrue(exprType instanceof ArrayType)
		assertEquals(2, (exprType as ArrayType).dimensions.size)
	}
	
	@Test
	def testTermExpressionType_ArrayAccessWithTuple() {
		val model = '''
			package p;
			type Int;
			type Real;
			type t1 {
				varx : Real := var1[1];
				var1 : (e1: Int, e2:Real);
			}
		'''.parse
		
		model.assertNoErrors
		val t1 = model.findSymbol("t1") as ConstrainedType
		val Real = model.findSymbol("Real")
		val exprType = ImlTypeProvider.termExpressionType(t1.findSymbol("varx").definition)
		
		assertEquals(Real, (exprType as SimpleTypeReference).type)
	}
	
	@Test
	def testTermExpressionType_ArrayAccessWithTupleUsingName() {
		val model = '''
			package p;
			type Int;
			type Real;
			type t1 {
				varx : Real := var1[e2];
				var1 : (e1: Int, e2:Real);
			}
		'''.parse
		
		model.assertNoErrors
		val t1 = model.findSymbol("t1") as ConstrainedType
		val Real = model.findSymbol("Real")
		val exprType = ImlTypeProvider.termExpressionType(t1.findSymbol("varx").definition)
		
		assertEquals(Real, (exprType as SimpleTypeReference).type)
	}
	
	@Test
	def testTermExpressionType_TupleConstructor() {
		val model = '''
			package p;
			type Int;
			type Bool;
			type Real;
			type t1 {
				varx : (Int, Bool, Real) := (2, false, 2.5);
			}
		'''.parse
		
		model.assertNoErrors
		
		val t1 = model.findSymbol("t1") as ConstrainedType
		val exprType = ImlTypeProvider.termExpressionType(t1.findSymbol("varx").definition)
		
		assertTrue(exprType instanceof TupleType)
		assertEquals(3, (exprType as TupleType).symbols.size)
		assertEquals(INT_REF, (exprType as TupleType).symbols.get(0).type)
		assertEquals(BOOL_REF, (exprType as TupleType).symbols.get(1).type)
		assertEquals(REAL_REF, (exprType as TupleType).symbols.get(2).type)
	}
	
	@Test
	def testTermExpressionType_IfThen() {
		val model = '''
			package p;
			type Int;
			type Bool;
			type t1 {
				varx : Int := if (true) {5};
			}
		'''.parse
		
		model.assertNoErrors
		
		val t1 = model.findSymbol("t1") as ConstrainedType
		val exprType = ImlTypeProvider.termExpressionType(t1.findSymbol("varx").definition)
		
		assertEquals(INT_REF, exprType)
	}
	
	@Test
	def testTermExpressionType_IfThenElse() {
		val model = '''
			package p;
			type Int;
			type Bool;
			type t1 {
				varx : Int := if (true) {5} else {true};
			}
		'''.parse
		
		model.assertNoErrors
		
		val t1 = model.findSymbol("t1") as ConstrainedType
		val exprType = ImlTypeProvider.termExpressionType(t1.findSymbol("varx").definition)
		
		assertEquals(INT_REF, exprType)
	}
	
	@Test
	def testTermExpressionType_FiniteSelection() {
		val model = '''
			package p;
			type Int;
			type Bool;
			type Real;
			type t1 {
				varx : t2 := t2[0];
			}
			type t2 finite 2;
		'''.parse
		
		model.assertNoErrors
		
		val t1 = model.findSymbol("t1") as ConstrainedType
		val t2 = model.findSymbol("t2") as ConstrainedType
		val exprType = ImlTypeProvider.termExpressionType(t1.findSymbol("varx").definition)
		
		assertEquals(t2, (exprType as SimpleTypeReference).type)
	}
	
	@Test
	def testTermExpressionType_LiteralSelectionWithLiteral() {
		val model = '''
			package p;
			type Int;
			type Bool;
			type Real;
			type t1 {
				varx : t2 := t2.e2;
			}
			type t2 enum {e1, e2};
		'''.parse
		
		model.assertNoErrors
		
		val t1 = model.findSymbol("t1") as ConstrainedType
		val t2 = model.findSymbol("t2") as ConstrainedType
		val exprType = ImlTypeProvider.termExpressionType(t1.findSymbol("varx").definition)
		
		assertEquals(t2, (exprType as SimpleTypeReference).type)
	}
	
	@Test
	def testTermExpressionType_ComplexTail() {
		val model = '''
		    package p;
		    type Int;
		    type Real;
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
		
		val t1 = model.findSymbol("t1") as ConstrainedType
		#["v1", "v2", "v3", "v4", "v5", "v6", "v7", "v8"]
		      .forEach[assertTypeMatches(t1.findSymbol(it))]
	}
	
	@Test
	def typeOfImplicitConstructor(){
		val model = '''
		package iml.notes ;
		type Int ;
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
//		val type = ImlTypeProvider.termExpressionType(constr)
		return 
	}
	
	@Test
	def typeForLambdas(){
		val model = '''
		package iml.notes ;
		type Int ;
		type A1 {
			c : Int := 4 ;
			d : Int ;
			f : Int -> Int := fun ( x : Int ) { x + 1 } ;
			assert { d > 0 };
		};
		'''.parse
		
		val f = findSymbol(model.symbols.last as ConstrainedType,"f")
		val fdef = f.definition.left
		val type  = ImlTypeProvider.termExpressionType(fdef)
		model.assertNoErrors
		return
		
	}
	
	@Test
	def typeForPolymorphicTypes(){
		val model = '''
		package iml.notes.stackmodel ;
		type Int ;
		type Bool ;
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
		
		s : Stack<Int> := e.push(1); //.push(2).push(3) ;
		'''.parse
		
		model.assertNoErrors
		
		val stackt = model.findSymbol("Stack") as ConstrainedType
		val pop = stackt.findSymbol("pop") as SymbolDeclaration
		val popdefite = ((pop.definition.left as LambdaExpression).definition as SequenceTerm).^return.left as IteTermExpression
//		val rest_pop = (popdefite.left as SequenceTerm).^return.left.left.left.right as TermMemberSelection
//		val rest = rest_pop.receiver
//		val type = ImlTypeProvider.termExpressionType(rest);
//		val rest_decl = stackt.symbols.get(1) as SymbolDeclaration
//		assertTrue(TypingServices.isEqual(type,rest_decl.type))
//		
//		val s = model.symbols.last as SymbolDeclaration
//		val e_push = s.definition.left as TermMemberSelection
//		val e_push_type = ImlTypeProvider.termExpressionType(e_push)
//		assertTrue(TypingServices.isEqual(e_push_type,s.type))
		
	}
	
	@Test
	def typeForPolymorphicSymbols(){
		val model = '''
		package iml.notes.stackmodel ;
		type Int ;
		type Bool ;
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
		val t = ImlTypeProvider.termExpressionType(d)
		val equal = TypingServices.isEqual(e.type, t)
		assertTrue(equal)
	}
	
	
	def assertTypeMatches(SymbolDeclaration symbol) {
		assertTrue(TypingServices.isEqual(symbol.type, ImlTypeProvider.termExpressionType(symbol.definition)))
	}
	
}