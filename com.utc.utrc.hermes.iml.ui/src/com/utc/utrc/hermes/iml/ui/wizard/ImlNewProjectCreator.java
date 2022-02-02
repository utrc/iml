/*
 * Copyright (c) 2019 United Technologies Corporation. All rights reserved.
 * See License.txt in the project root directory for license information. */
package com.utc.utrc.hermes.iml.ui.wizard;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.eclipse.core.runtime.IConfigurationElement;
import org.eclipse.core.runtime.IExtensionRegistry;
import org.eclipse.core.runtime.Platform;

public class ImlNewProjectCreator extends ImlProjectCreator {
	protected static final String SDK_PROJECT_NAME = "com.utc.utrc.hermes.iml.lib";
	
	@Override
	protected List<String> getRequiredBundles() {
		List<String> requiredBundles = super.getRequiredBundles();
		requiredBundles.add(SDK_PROJECT_NAME);
		requiredBundles.addAll(getExtensionPointRequiredBundles());
		
		return requiredBundles;
	}

	private Collection<? extends String> getExtensionPointRequiredBundles() {
		List<String> requiredBundles = new ArrayList<>();
		IExtensionRegistry registry = Platform.getExtensionRegistry();
  		if (registry != null) {
  			IConfigurationElement[] extensions = registry.getConfigurationElementsFor("com.utc.utrc.hermes.iml.lib");
	   		for (IConfigurationElement libExtension : extensions) {
				requiredBundles.add(libExtension.getNamespaceIdentifier());
	   		}
		}
  		return requiredBundles;
	}

}
