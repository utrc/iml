package com.utc.utrc.hermes.iml.encoding;

public class StringModelProvider implements SmtModelProvider<String> {

	@Override
	public String createSort(String sortName) {
		return "(declare-sort |" + sortName + "|)";
	}

}
