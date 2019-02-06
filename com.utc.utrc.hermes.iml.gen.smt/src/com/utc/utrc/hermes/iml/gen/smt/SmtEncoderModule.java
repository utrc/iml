package com.utc.utrc.hermes.iml.gen.smt;

import com.google.inject.AbstractModule;
import com.google.inject.Binder;
import com.utc.utrc.hermes.iml.AbstractImlRuntimeModule;
import com.utc.utrc.hermes.iml.gen.smt.encoding.SimpleSmtModelProvider;
import com.utc.utrc.hermes.iml.gen.smt.encoding.simplesmt.SimpleSort;
import com.utc.utrc.hermes.iml.gen.smt.encoding.simplesmt.SimpleFunDeclaration;
import com.utc.utrc.hermes.iml.gen.smt.encoding.simplesmt.SimpleSmtFormula;
import com.utc.utrc.hermes.iml.gen.smt.encoding.SmtModelProvider;


import com.google.inject.TypeLiteral;

/**
 * @author SCHULZCH
 *
 */
public class SmtEncoderModule extends AbstractModule{

	@Override
	protected void configure() {
		bind(new TypeLiteral<SmtModelProvider<SimpleSort, SimpleFunDeclaration, SimpleSmtFormula>>(){}).
		to(SimpleSmtModelProvider.class);
		
	}
	
}
