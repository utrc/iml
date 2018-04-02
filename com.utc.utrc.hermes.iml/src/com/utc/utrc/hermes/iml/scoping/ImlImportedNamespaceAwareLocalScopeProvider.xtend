package com.utc.utrc.hermes.iml.scoping

import org.eclipse.xtext.scoping.impl.ImportNormalizer
import org.eclipse.xtext.scoping.impl.ImportedNamespaceAwareLocalScopeProvider
import org.eclipse.emf.ecore.EObject
import java.util.List
import com.utc.utrc.hermes.iml.iml.Model

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

}
