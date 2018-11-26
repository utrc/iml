package com.utc.utrc.hermes.iml.encoding;

public class AbstractSort implements NamedEntity {

	protected String name;
	
	@Override
	public String getName() {
		if (SmtStandardLib.isNative(name)) {
			String[] parts = name.split("\\.");
			return parts[parts.length - 1];
		}
		return name;
	}
	
	public void setName(String name) {
		this.name = name;
	}

}
