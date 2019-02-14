package com.utc.utrc.hermes.iml.gen.smt.encoding;

import java.util.HashMap;
import java.util.Map;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.naming.IQualifiedNameProvider;

import com.google.inject.Inject;
import com.utc.utrc.hermes.iml.iml.Extension;
import com.utc.utrc.hermes.iml.iml.ImlType;
import com.utc.utrc.hermes.iml.iml.Relation;


/**
 * A factory responsible for creating EncodedId for any IML object
 * 
 * @author Ayman Elkfrawy (elkfraaf@utrc.utc.com)
 * @author Gerald Wang (wangg@utrc.utc.com)
 */
public class EncodedIdFactory {

	@Inject IQualifiedNameProvider qnp ;
	int lastId = 0;
	
	Map<EObject, EncodedId> specialIdList = new HashMap<>();
	
	public EncodedId createEncodedId(EObject imlObject) {
		EncodedId id = new EncodedId(imlObject, qnp);
		if (id.getName() == null || id.getName().isEmpty()) {
			if (specialIdList.containsKey(imlObject)) {
				return specialIdList.get(imlObject);
			} else {
				id.setName("__id_" + lastId++);
				specialIdList.put(imlObject, id);
			}
		}
		return id;
	}
	
	public String getStringId(EObject imlObject) {
		return createEncodedId(imlObject).stringId();
	}
}
