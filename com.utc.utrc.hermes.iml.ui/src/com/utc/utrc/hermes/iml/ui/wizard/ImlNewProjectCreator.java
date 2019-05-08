/*
 * Copyright (c) 2019 United Technologies Corporation. All rights reserved.
 * See License.txt in the project root directory for license information. */
package com.utc.utrc.hermes.iml.ui.wizard;

import java.util.List;

public class ImlNewProjectCreator extends ImlProjectCreator {
	protected static final String SDK_PROJECT_NAME = "com.utc.utrc.hermes.iml.lib";
	
	@Override
	protected List<String> getRequiredBundles() {
		List<String> requiredBundles = super.getRequiredBundles();
		requiredBundles.add(SDK_PROJECT_NAME);
		return requiredBundles;
	}

}
