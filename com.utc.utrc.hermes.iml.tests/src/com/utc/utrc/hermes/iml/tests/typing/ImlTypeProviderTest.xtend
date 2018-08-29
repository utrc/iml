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
		assertFormulaType("5 + 6", "Int", ImlTypeProvider.Int);
	}
	
	@Test
	def testTermExpressionType_withAddition_real() {
		assertFormulaType("5 * 6.5", "Real", ImlTypeProvider.Real);
	}
	
	@Test
	def testTermExpressionType_withAddition_realDiv() {
		assertFormulaType("5 / 6", "Real",ImlTypeProvider.Real);
	}
	
	@Test
	def testTermExpressionType_withAddition_boolean() {
		assertFormulaType("5 = 6", "Bool", ImlTypeProvider.Bool);
	}
	
	@Test
	def testTermExpressionType_withAnd_boolean() {
		assertFormulaType("True && False", "Bool", ImlTypeProvider.Bool);
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
				var1 : Int := var2->varx;
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
				var1 : Int := var2->varx;
				var2 : t2;
			}
			
			type t2 extends t3 {
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
				var2 : (p1 : Int, p2 : Real) ~> Int;
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
				var1 : (Int, Real)~>Int := var2;
				var2 : (p1 : Int, p2 : Real) ~> Int;
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
				var1 : (Int)~>Real := var2->varx;
				var2 : t2<Int, Real>;
			}
			
			type t2 <T, P> {
				varx : (p : T) ~> P;
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
				var1 : List<Int> := var2->varx;
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
				var1 : List<(Int)~>Real> := var2->varx;
				var2 : t2<List<(p: Int)~>Real> >;
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
		val domain = exprType.domain as TupleType
		assertEquals(Int, (domain.symbols.get(0).type as SimpleTypeReference).type)
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
				var1 : List<Int> := var3->var2->varx;
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
				varx : (Int)~>Bool := lambda (p1: Int) {True;};
			}
		'''.parse
		
		model.assertNoErrors
		val t1 = model.findSymbol("t1") as ConstrainedType
		val Int = model.findSymbol("Int")
		val exprType = ImlTypeProvider.termExpressionType(t1.findSymbol("varx").definition)
		
		assertEquals(Int, ((exprType.domain as TupleType).symbols.get(0).type as SimpleTypeReference).type)
		assertEquals(ImlTypeProvider.Bool, exprType.range)
	}
	
	@Test
	def testTermExpressionType_LambdaWithMultipleElement() {
		val model = '''
			package p;
			type Int;
			type t1 {
				varx : (Int)~>Int := lambda (p1: Int) {True;3*5;};
			}
		'''.parse
		
		model.assertNoErrors
		val t1 = model.findSymbol("t1") as ConstrainedType
		val exprType = ImlTypeProvider.termExpressionType(t1.findSymbol("varx").definition)
		val Int = model.findSymbol("Int")
		
		assertEquals(Int,  ((exprType.domain as TupleType).symbols.get(0).type as SimpleTypeReference).type)
		assertEquals(ImlTypeProvider.Int, exprType.range)
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
				varx : (Int, Bool, Real) := (2, False, 2.5);
			}
		'''.parse
		
		model.assertNoErrors
		
		val t1 = model.findSymbol("t1") as ConstrainedType
		val exprType = ImlTypeProvider.termExpressionType(t1.findSymbol("varx").definition)
		
		assertTrue(exprType instanceof TupleType)
		assertEquals(3, (exprType as TupleType).symbols.size)
		assertEquals(ImlTypeProvider.Int, (exprType as TupleType).symbols.get(0).type)
		assertEquals(ImlTypeProvider.Bool, (exprType as TupleType).symbols.get(1).type)
		assertEquals(ImlTypeProvider.Real, (exprType as TupleType).symbols.get(2).type)
	}
	
	@Test
	def testTermExpressionType_IfThen() {
		val model = '''
			package p;
			type Int;
			type Bool;
			type t1 {
				varx : Int := if (True) {5};
			}
		'''.parse
		
		model.assertNoErrors
		
		val t1 = model.findSymbol("t1") as ConstrainedType
		val exprType = ImlTypeProvider.termExpressionType(t1.findSymbol("varx").definition)
		
		assertEquals(ImlTypeProvider.Int, exprType)
	}
	
	@Test
	def testTermExpressionType_IfThenElse() {
		val model = '''
			package p;
			type Int;
			type Bool;
			type t1 {
				varx : Int := if (True) {5} else {True};
			}
		'''.parse
		
		model.assertNoErrors
		
		val t1 = model.findSymbol("t1") as ConstrainedType
		val exprType = ImlTypeProvider.termExpressionType(t1.findSymbol("varx").definition)
		
		assertEquals(ImlTypeProvider.Int, exprType)
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
		    	vx: (Int, Real ~> (size: Int, matrix: Real[10][20]));
		    	v1: (Int, Real ~> (Int, Real[10][20])) := vx;
		    	v2: Int := vx[0];
		    	v3: Real ~> (Int, Real[0][0]) := vx[1];
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
	def testTermExpressionType_TypeConstructor() {
		val model = '''
			package p;
			type Int;
			type Bool;
			type Real;
			type t1 { 
				varx : t2 := new t2{};
			}
			type t2;
		'''.parse
		
		model.assertNoErrors
		
		val t1 = model.findSymbol("t1") as ConstrainedType
		val t2 = model.findSymbol("t2") as ConstrainedType
		val exprType = ImlTypeProvider.termExpressionType(t1.findSymbol("varx").definition)
		
		assertEquals(t2, (exprType as SimpleTypeReference).type)
	}
	
	def assertTypeMatches(SymbolDeclaration symbol) {
		assertTrue(TypingServices.isEqual(symbol.type, ImlTypeProvider.termExpressionType(symbol.definition)))
	}
	
}