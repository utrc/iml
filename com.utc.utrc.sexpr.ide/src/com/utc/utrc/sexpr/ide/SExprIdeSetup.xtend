/*
 * generated by Xtext 2.12.0
 */
package com.utc.utrc.sexpr.ide

import com.google.inject.Guice
import com.utc.utrc.sexpr.SExprRuntimeModule
import com.utc.utrc.sexpr.SExprStandaloneSetup
import org.eclipse.xtext.util.Modules2

/**
 * Initialization support for running Xtext languages as language servers.
 */
class SExprIdeSetup extends SExprStandaloneSetup {

	override createInjector() {
		Guice.createInjector(Modules2.mixin(new SExprRuntimeModule, new SExprIdeModule))
	}
	
}
