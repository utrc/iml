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
		assertFormulaType("5 + 6", ImlTypeProvider.Int);
	}
	
	@Test
	def testTermExpressionType_withAddition_real() {
		assertFormulaType("5 * 6.5", ImlTypeProvider.Real);
	}
	
	@Test
	def testTermExpressionType_withAddition_realDiv() {
		assertFormulaType("5 / 6", ImlTypeProvider.Real);
	}
	
	@Test
	def testTermExpressionType_withAddition_boolean() {
		assertFormulaType("5 = 6", ImlTypeProvider.Bool);
	}
	
	@Test
	def testTermExpressionType_withAnd_boolean() {
		assertFormulaType("True && False", ImlTypeProvider.Bool);
	}
	
	def assertFormulaType(String formula, HigherOrderType type) {
		val model = '''
			package p;
			type Int;
			type Real;
			type t1 {
				var1 : Int := «formula»;
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
				var1 : Int := var2;
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
		
		assertEquals((exprType as SimpleTypeReference).ref, t2)
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
		
		assertEquals((exprType as SimpleTypeReference).ref, intType)
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
		
		assertEquals((exprType as SimpleTypeReference).ref, intType)
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
		
		assertEquals((exprType as SimpleTypeReference).ref, intType)
	}
	
	@Test
	def testTermExpressionType_HOTWithoutTail() {
		val model = '''
			package p;
			type Int;
			type Real;
			type t1 {
				var1 : Int := var2;
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
				var1 : Int := var2->varx;
				var2 : t2<Int, Real>;
			}
			
			type t2 <type T, type P> {
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
		assertEquals(Int, (domain.symbols.get(0).type as SimpleTypeReference).ref)
		assertEquals(Real, (exprType.range as SimpleTypeReference).ref)
	}
	
	@Test
	def testTermExpressionType_BindingWithTemplate() {
		val model = '''
			package p;
			type Int;
			type Real;
			type List <type T>;
			
			type t1 {
				var1 : Int := var2->varx;
				var2 : t2<List<Int> >;
			}
			
			type t2 <type T> {
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
			
		assertEquals(List, exprType.ref)		
		assertEquals(Int, (exprType.typeBinding.get(0) as SimpleTypeReference).ref)
	}
	
	@Test
	def testTermExpressionType_BindingWithHOTTemplate() {
		val model = '''
			package p;
			type Int;
			type Real;
			type List <type T>;
			
			type t1 {
				var1 : Int := var2->varx;
				var2 : t2<List<(p: Int)~>Real> >;
			}
			
			type t2 <type T> {
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
		assertEquals(Int, (domain.symbols.get(0).type as SimpleTypeReference).ref)
		assertEquals(Real, (exprType.range as SimpleTypeReference).ref)
	}
	
	@Test
	def testTermExpressionType_BindingWithTemplatedTemplate() {
		val model = '''
			package p;
			type Int;
			type Real;
			type List <type T>;
			
			type t1 {
				var1 : Int := var3->var2->varx;
				var3 : t3<Int>;
			}
			
			type t2 <type T> {
				varx : T;
			}
			
			type t3 <type T> {
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
			
		assertEquals(List, exprType.ref)		
		assertEquals(Int, (exprType.typeBinding.get(0) as SimpleTypeReference).ref)
	}
	
	@Test
	def testTermExpressionType_LambdaWithOneElement() {
		val model = '''
			package p;
			type Int;
			type t1 {
				varx : Int := lambda (p1: Int) {True;};
			}
		'''.parse
		
		model.assertNoErrors
		val t1 = model.findSymbol("t1") as ConstrainedType
		val exprType = ImlTypeProvider.termExpressionType(t1.findSymbol("varx").definition)
		
		assertEquals(ImlTypeProvider.Bool, exprType)
	}
	
	@Test
	def testTermExpressionType_LambdaWithMultipleElement() {
		val model = '''
			package p;
			type Int;
			type t1 {
				varx : Int := lambda (p1: Int) {True;3*5;};
			}
		'''.parse
		
		model.assertNoErrors
		val t1 = model.findSymbol("t1") as ConstrainedType
		val exprType = ImlTypeProvider.termExpressionType(t1.findSymbol("varx").definition)
		
		assertEquals(ImlTypeProvider.Int, exprType)
	}
	
	@Test
	def testTermExpressionType_ArrayAccess() {
		val model = '''
			package p;
			type Int;
			type Real;
			type t1 {
				varx : Int := var1;
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
				varx : Int := var1[1];
				var1 : Real[10];
			}
		'''.parse
		
		model.assertNoErrors
		val t1 = model.findSymbol("t1") as ConstrainedType
		val Real = model.findSymbol("Real") 
		val exprType = ImlTypeProvider.termExpressionType(t1.findSymbol("varx").definition)
		
		assertEquals(Real, (exprType as SimpleTypeReference).ref)
	}
	
	@Test
	def testTermExpressionType_ArrayAccessWithPartialIndex() {
		val model = '''
			package p;
			type Int;
			type Real;
			type t1 {
				varx : Int := var1[1];
				var1 : Real[10][20][30];
			}
		'''.parse
		
		model.assertNoErrors
		val t1 = model.findSymbol("t1") as ConstrainedType
		val exprType = ImlTypeProvider.termExpressionType(t1.findSymbol("varx").definition)
		
		assertTrue(exprType instanceof ArrayType)
		assertEquals(2, (exprType as ArrayType).dimension.size)
	}
	
	@Test
	def testTermExpressionType_ArrayAccessWithTuple() {
		val model = '''
			package p;
			type Int;
			type Real;
			type t1 {
				varx : Int := var1[1];
				var1 : (e1: Int, e2:Real);
			}
		'''.parse
		
		model.assertNoErrors
		val t1 = model.findSymbol("t1") as ConstrainedType
		val Real = model.findSymbol("Real")
		val exprType = ImlTypeProvider.termExpressionType(t1.findSymbol("varx").definition)
		
		assertEquals(Real, (exprType as SimpleTypeReference).ref)
	}
	
	@Test
	def testTermExpressionType_ArrayAccessWithTupleUsingName() {
		val model = '''
			package p;
			type Int;
			type Real;
			type t1 {
				varx : Int := var1[e2];
				var1 : (e1: Int, e2:Real);
			}
		'''.parse
		
		model.assertNoErrors
		val t1 = model.findSymbol("t1") as ConstrainedType
		val Real = model.findSymbol("Real")
		val exprType = ImlTypeProvider.termExpressionType(t1.findSymbol("varx").definition)
		
		assertEquals(Real, (exprType as SimpleTypeReference).ref)
	}
	
	@Test
	def testTermExpressionType_TupleConstructor() {
		val model = '''
			package p;
			type Int;
			type Bool;
			type t1 {
				varx : Int := (2, False, 2.5);
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
	def testTermExpressionType_FinieSelection() {
		val model = '''
			package p;
			type Int;
			type Bool;
			type Real;
			type t1 {
				varx : Int := t2.e2;
			}
			type t2 finite |e1, e2|;
		'''.parse
		
		model.assertNoErrors
		
		val t1 = model.findSymbol("t1") as ConstrainedType
		val t2 = model.findSymbol("t2") as ConstrainedType
		val exprType = ImlTypeProvider.termExpressionType(t1.findSymbol("varx").definition)
		
		assertEquals(t2, (exprType as SimpleTypeReference).ref)
	}
	
	@Test
	def testTermExpressionType_LiteralSelectionWithLiteral() {
		val model = '''
			package p;
			type Int;
			type Bool;
			type Real;
			type t1 {
				varx : Int := t2.e2;
			}
			type t2 finite |e1, e2|;
		'''.parse
		
		model.assertNoErrors
		
		val t1 = model.findSymbol("t1") as ConstrainedType
		val t2 = model.findSymbol("t2") as ConstrainedType
		val exprType = ImlTypeProvider.termExpressionType(t1.findSymbol("varx").definition)
		
		assertEquals(t2, (exprType as SimpleTypeReference).ref)
	}
	
}