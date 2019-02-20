package com.utc.utrc.hermes.iml.tests.string

import org.junit.runner.RunWith
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import com.utc.utrc.hermes.iml.tests.ImlInjectorProvider
import com.google.inject.Inject
import org.eclipse.xtext.testing.util.ParseHelper
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import com.utc.utrc.hermes.iml.tests.TestHelper
import com.utc.utrc.hermes.iml.iml.Model
import org.junit.Test
import com.utc.utrc.hermes.iml.ImlParseHelper
import com.utc.utrc.hermes.iml.iml.ImlPackage
import com.utc.utrc.hermes.iml.validation.ImlValidator

@RunWith(XtextRunner)
@InjectWith(ImlInjectorProvider)

class ImlStringTests {
	
	@Inject extension ImlParseHelper
	@Inject extension ValidationTestHelper
	
	@Test
	def void testStringsCompatible(){
		'''
		package p ;
		
		x : String ;
		y : String ;
		z : Int ;
		assert a { x = y };
		'''.parse.assertNoErrors
	
	}
	
	@Test
	def void testStringsNotCompatible(){
		'''
		package p ;
		
		x : String ;
		y : String ;
		z : Int ;
		assert a { x = z };
		'''.parse.assertError(ImlPackage.eINSTANCE.atomicExpression, ImlValidator.INCOMPATIBLE_TYPES)
	
	}
	
	@Test
	def void testStringCharTerm(){
		'''
		package p ;
		
		x : String := "hermes";
		y : String ;
		z : Char := 'a' ;
		assert a { x = y };
		assert b { x.length = 6} ;
		assert c { x.charAt(0) = 'h' } ;
		'''.parse.assertNoErrors
	
	}
	
}