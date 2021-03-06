/*
 * Copyright (c) 2019 United Technologies Corporation. All rights reserved.
 * See License.txt in the project root directory for license information. */
package com.utc.utrc.hermes.iml.scoping

import org.eclipse.xtext.scoping.impl.ImportNormalizer
import org.eclipse.xtext.scoping.impl.ImportedNamespaceAwareLocalScopeProvider
import org.eclipse.emf.ecore.EObject
import java.util.List
import com.utc.utrc.hermes.iml.iml.Model
import org.eclipse.xtext.naming.QualifiedName
import com.google.common.collect.Lists

class ImlImportedNamespaceAwareLocalScopeProvider extends ImportedNamespaceAwareLocalScopeProvider {

	override internalGetImportedNamespaceResolvers(EObject context, boolean ignoreCase) {

		if (context instanceof Model) {

			var List<ImportNormalizer> importedNamespaceResolvers = super.internalGetImportedNamespaceResolvers(context, ignoreCase);
			var String ownNamespace = (context as Model).getName() + ".*";
			importedNamespaceResolvers.add(createImportedNamespaceResolver(ownNamespace, ignoreCase));
			return importedNamespaceResolvers;
		}
		return super.internalGetImportedNamespaceResolvers(context, ignoreCase);
	}
	
	override public getImplicitImports(boolean ignoreCase) {
		Lists.newArrayList(new ImportNormalizer(QualifiedName.create("iml","lang"),true,ignoreCase))
	}
	
}
