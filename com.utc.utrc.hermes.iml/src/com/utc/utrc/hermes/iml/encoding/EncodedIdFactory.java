package com.utc.utrc.hermes.iml.encoding;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.naming.IQualifiedNameProvider;

import com.google.inject.Inject;

public class EncodedIdFactory {

	@Inject IQualifiedNameProvider qnp ;
	
	public EncodedId createEncodedId(EObject type) {
		return new EncodedId(type, qnp);
	}
}
