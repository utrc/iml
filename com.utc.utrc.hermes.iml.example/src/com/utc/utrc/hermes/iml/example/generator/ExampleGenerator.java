package com.utc.utrc.hermes.iml.example.generator;

import java.util.Map;

import com.utc.utrc.hermes.iml.gen.common.IImlGenerator;
import com.utc.utrc.hermes.iml.gen.common.IImlGeneratorResult;
import com.utc.utrc.hermes.iml.gen.common.ModelClass;
import com.utc.utrc.hermes.iml.gen.common.UnsupportedQueryException;
import com.utc.utrc.hermes.iml.gen.common.impl.AbstractImlGeneratorResult;
import com.utc.utrc.hermes.iml.iml.FolFormula;

public class ExampleGenerator implements IImlGenerator {

	@Override
	public boolean canGenerate(FolFormula query) {
		return true;
	}

	@Override
	public IImlGeneratorResult generate(FolFormula query, Map<String, String> params) throws UnsupportedQueryException {
		AbstractImlGeneratorResult result = new AbstractImlGeneratorResult(ModelClass.OPT);
		result.setGeneratedModel(query.toString());
		return result;
	}

	@Override
	public String generateFragment(FolFormula fragment) {
		return fragment.toString();
	}

	@Override
	public ModelClass getGneratedModelClass() {
		return ModelClass.OPT;
	}

}
