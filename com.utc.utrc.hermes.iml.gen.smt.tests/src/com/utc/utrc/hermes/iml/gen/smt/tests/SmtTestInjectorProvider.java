package com.utc.utrc.hermes.iml.gen.smt.tests;

import org.eclipse.xtext.testing.GlobalRegistries;

import com.google.inject.Injector;
import com.utc.utrc.hermes.iml.gen.smt.SmtEncoderModule;
import com.utc.utrc.hermes.iml.tests.ImlInjectorProvider;

public class SmtTestInjectorProvider extends ImlInjectorProvider {
	
	@Override
	public Injector getInjector() {
		if (injector == null) {
			stateBeforeInjectorCreation = GlobalRegistries.makeCopyOfGlobalState();
			this.injector = internalCreateInjector().createChildInjector(new SmtEncoderModule());
			stateAfterInjectorCreation = GlobalRegistries.makeCopyOfGlobalState();
		}
		return injector;
	}
}