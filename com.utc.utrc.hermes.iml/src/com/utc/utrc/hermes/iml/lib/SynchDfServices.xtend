package com.utc.utrc.hermes.iml.lib

import javax.inject.Inject
import com.utc.utrc.hermes.iml.iml.Trait
import com.utc.utrc.hermes.iml.util.ImlUtil
import org.eclipse.emf.ecore.EObject

class SynchDfServices {

	@Inject ImlStdLib stdLib;

	public static final String PACKAGE_NAME = "iml.synchdf.ontological"
	
	public static final String SYNCHRONOUS = "Synchronous"

	def getSynchronousTrait() {
		return stdLib.getSymbol(PACKAGE_NAME, SYNCHRONOUS, Trait)
	}
	
	def isSynchronous(EObject type) {
		return ImlUtil.exhibitsOrRefines(type, synchronousTrait)
	}
}
