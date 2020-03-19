/*
 * Copyright (c) 2019 United Technologies Corporation. All rights reserved.
 * See License.txt in the project root directory for license information. */
/*
 * generated by Xtext 2.12.0
 */
package com.utc.utrc.hermes.iml

import com.google.inject.Binder
import org.eclipse.xtext.scoping.impl.AbstractDeclarativeScopeProvider
import com.utc.utrc.hermes.iml.scoping.ImlImportedNamespaceAwareLocalScopeProvider
import org.eclipse.xtext.validation.CompositeEValidator
import com.google.inject.name.Names
import com.utc.utrc.hermes.iml.custom.ImlCustomLinker
import org.eclipse.xtext.linking.ILinker
import org.eclipse.xtext.resource.IDefaultResourceDescriptionStrategy
import com.utc.utrc.hermes.iml.scoping.ImlResourceDescriptionsStrategy
import com.utc.utrc.hermes.iml.custom.ImlValueConverters

/**
 * Use this class to register components to be used at runtime / without the Equinox extension registry.
 */
class ImlRuntimeModule extends AbstractImlRuntimeModule {
	
	override configureIScopeProviderDelegate(Binder binder) {
		binder.bind(org.eclipse.xtext.scoping.IScopeProvider)
				.annotatedWith(
						com.google.inject.name.Names
								.named(AbstractDeclarativeScopeProvider.NAMED_DELEGATE))
				.to(ImlImportedNamespaceAwareLocalScopeProvider);
				
		binder.bind(boolean).annotatedWith(Names.named((CompositeEValidator.USE_EOBJECT_VALIDATOR))).toInstance(false)
	}
	
	override Class<? extends ILinker> bindILinker() {
		ImlCustomLinker
	}
	
	override bindIValueConverterService() {
		ImlValueConverters
	}
	
	def Class<? extends IDefaultResourceDescriptionStrategy> bindIDefaultResourceDescriptionStrategy() {
		return ImlResourceDescriptionsStrategy
	}
	
	
}
