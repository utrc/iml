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

@RunWith(XtextRunner)
@InjectWith(ImlInjectorProvider)
class ImlSmtEncoderTest {
	
	@Inject extension ParseHelper<Model>
	
	@Inject extension ValidationTestHelper
	
	@Inject extension TestHelper
	
	@Inject ImlSmtEncoder<SimpleSort, SimpleFunDeclaration> encoder
	
	@Test
	def void testSimpleTypeEncoder() {
		val model = 
		'''
			package p;
			
			type Tx;
		'''.parse
		model.assertNoErrors
		
		encoder.encode(model.findSymbol("Tx"))
		println(encoder.toString)
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