package com.utc.utrc.hermes.iml.example.generator;

import com.utc.utrc.hermes.iml.gen.common.IImlGenerator;
import com.utc.utrc.hermes.iml.gen.common.ImlGeneratorResult;
import com.utc.utrc.hermes.iml.iml.Symbol;

public class ExampleGenerator implements IImlGenerator {

	@Override
	public boolean canGenerate(Symbol query) {
		return true;
	}

	@Override
	public ImlGeneratorResult generate(Symbol query) {
		ImlGeneratorResult result = new ImlGeneratorResult();
		result.setGeneratedModel(query.toString());
		return result;
	}

	@Override
	public boolean canRunSolver() {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public String runSolver(String generatedModel) {
		// TODO Auto-generated method stub
		return null;
	}

}
