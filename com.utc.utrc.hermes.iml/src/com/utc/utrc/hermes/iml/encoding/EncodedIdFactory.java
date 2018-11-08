package com.utc.utrc.hermes.iml.encoding;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.naming.IQualifiedNameProvider;

import com.google.inject.Inject;
import com.utc.utrc.hermes.iml.iml.Extension;
import com.utc.utrc.hermes.iml.iml.HigherOrderType;
import com.utc.utrc.hermes.iml.iml.Relation;


/**
 * A factory responsible for creating EncodedId for any IML object
 * 
 * @author Ayman Elkfrawy (elkfraaf@utrc.utc.com)
 * @author Gerald Wang (wangg@utrc.utc.com)
 */
public class EncodedIdFactory {

	@Inject IQualifiedNameProvider qnp ;
	
	public EncodedId createEncodedId(EObject type) {
		return new EncodedId(type, qnp);
	}
	
	public String getStringId(EObject type) {
		return createEncodedId(type).stringId();
	}
}
