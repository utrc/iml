/*
 * Auto-Generated, please don't modify. Add your own logic to the child class {@link com.utc.utrc.hermes.iml.lib.ProbabilisticServices} instead
 */
package com.utc.utrc.hermes.iml.lib.gen

import com.google.inject.Singleton
import com.google.inject.Inject
import org.eclipse.emf.ecore.EObject
import com.utc.utrc.hermes.iml.iml.Trait
import com.utc.utrc.hermes.iml.iml.NamedType
import com.utc.utrc.hermes.iml.util.ImlUtil
import com.utc.utrc.hermes.iml.lib.BasicServices
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration
import com.utc.utrc.hermes.iml.iml.Model
import com.utc.utrc.hermes.iml.iml.Symbol
import com.utc.utrc.hermes.iml.iml.TypeWithProperties
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference

@Singleton
class _ProbabilisticServices extends BasicServices
 {
	public static final String PACKAGE_NAME = "iml.probabilistic"
	public static final String PROB_SYMBOL = "Prob"	
	public static final String PROBABILISTIC = "Probabilistic"	
	public static final String PROBABILISTIC_SAMPLE_VAR = "sample"
	public static final String DISTRIBUTION = "Distribution"	
	public static final String DISTRIBUTION_POSSIBLE_VAR = "possible"
	public static final String PROBABILITY = "Probability"	
	public static final String PROBABILITY_VALUE_VAR = "value"
	public static final String UNIFORMREAL = "UniformReal"	
	public static final String UNIFORMREAL_LOW_VAR = "low"
	public static final String UNIFORMREAL_HIGH_VAR = "high"
	public static final String UNIFORMREAL_POSSIBLE_VAR = "possible"
	public static final String GAUSSIAN = "Gaussian"	
	public static final String GAUSSIAN_MEAN_VAR = "mean"
	public static final String GAUSSIAN_VARIANCE_VAR = "variance"
	public static final String GAUSSIAN_POSSIBLE_VAR = "possible"
	public static final String DENSITY = "Density"	
	public static final String UNIFORMINT = "UniformInt"	
	public static final String UNIFORMINT_LOW_VAR = "low"
	public static final String UNIFORMINT_HIGH_VAR = "high"
	public static final String UNIFORMINT_POSSIBLE_VAR = "possible"
	
	/**
	 * Get ProbSymbol symbol declaration
	 */
	 def getProbSymbol() {
	 	return getSymbolDeclaration(PROB_SYMBOL)
	 }
	/**
	 * get Probabilistic trait declaration
	 */
	def getProbabilisticTrait() {
		return getTrait(PROBABILISTIC)
	}
	
	/**
	 * check wether the given eObject refines or exhibits the Probabilistic trait
	 */
	def isProbabilistic(EObject eObject) {
		return ImlUtil.exhibitsOrRefines(eObject, getProbabilisticTrait);
	}
	
	/**
	 * Get all symbols inside the given type that exhibits/refines the Probabilistic trait. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getProbabilisticSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithTrait(type, getProbabilisticTrait, recursive);
	}
	
	/**
	 * Get the sample symbol declaration inside the given Probabilistic type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getProbabilisticSampleVar() {
		return ImlUtil.findSymbol(getType(PROBABILISTIC), PROBABILISTIC_SAMPLE_VAR, true) as SymbolDeclaration;
	}
	/**
	 * get Distribution trait declaration
	 */
	def getDistributionTrait() {
		return getTrait(DISTRIBUTION)
	}
	
	/**
	 * check wether the given eObject refines or exhibits the Distribution trait
	 */
	def isDistribution(EObject eObject) {
		return ImlUtil.exhibitsOrRefines(eObject, getDistributionTrait);
	}
	
	/**
	 * Get all symbols inside the given type that exhibits/refines the Distribution trait. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getDistributionSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithTrait(type, getDistributionTrait, recursive);
	}
	
	/**
	 * Get the possible symbol declaration inside the given Distribution type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getDistributionPossibleVar() {
		return ImlUtil.findSymbol(getType(DISTRIBUTION), DISTRIBUTION_POSSIBLE_VAR, true) as SymbolDeclaration;
	}
	/**
	 * get Probability type declaration
	 */
	def getProbabilityType() {
		return getType(PROBABILITY)
	}
	
	/**
	 * check whether the given type is Probability type
	 */
	def isProbability(NamedType type) {
		return equalOrSameQn(getProbabilityType, type)
	}
	
	/**
	 * Get all symbols inside the given type that are Probability type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getProbabilitySymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getProbabilityType, recursive)
	}
	/**
	 * Get the value symbol declaration inside the given Probability type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getProbabilityValueVar() {
		return ImlUtil.findSymbol(getType(PROBABILITY), PROBABILITY_VALUE_VAR, true) as SymbolDeclaration;
	}
	/**
	 * get UniformReal type declaration
	 */
	def getUniformRealType() {
		return getType(UNIFORMREAL)
	}
	
	/**
	 * check whether the given type is UniformReal type
	 */
	def isUniformReal(NamedType type) {
		return equalOrSameQn(getUniformRealType, type)
	}
	
	/**
	 * Get all symbols inside the given type that are UniformReal type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getUniformRealSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getUniformRealType, recursive)
	}
	/**
	 * Get the low symbol declaration inside the given UniformReal type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getUniformRealLowVar() {
		return ImlUtil.findSymbol(getType(UNIFORMREAL), UNIFORMREAL_LOW_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the high symbol declaration inside the given UniformReal type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getUniformRealHighVar() {
		return ImlUtil.findSymbol(getType(UNIFORMREAL), UNIFORMREAL_HIGH_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the possible symbol declaration inside the given UniformReal type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getUniformRealPossibleVar() {
		return ImlUtil.findSymbol(getType(UNIFORMREAL), UNIFORMREAL_POSSIBLE_VAR, true) as SymbolDeclaration;
	}
	/**
	 * get Gaussian type declaration
	 */
	def getGaussianType() {
		return getType(GAUSSIAN)
	}
	
	/**
	 * check whether the given type is Gaussian type
	 */
	def isGaussian(NamedType type) {
		return equalOrSameQn(getGaussianType, type)
	}
	
	/**
	 * Get all symbols inside the given type that are Gaussian type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getGaussianSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getGaussianType, recursive)
	}
	/**
	 * Get the mean symbol declaration inside the given Gaussian type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getGaussianMeanVar() {
		return ImlUtil.findSymbol(getType(GAUSSIAN), GAUSSIAN_MEAN_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the variance symbol declaration inside the given Gaussian type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getGaussianVarianceVar() {
		return ImlUtil.findSymbol(getType(GAUSSIAN), GAUSSIAN_VARIANCE_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the possible symbol declaration inside the given Gaussian type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getGaussianPossibleVar() {
		return ImlUtil.findSymbol(getType(GAUSSIAN), GAUSSIAN_POSSIBLE_VAR, true) as SymbolDeclaration;
	}
	/**
	 * get Density trait declaration
	 */
	def getDensityTrait() {
		return getTrait(DENSITY)
	}
	
	/**
	 * check wether the given eObject refines or exhibits the Density trait
	 */
	def isDensity(EObject eObject) {
		return ImlUtil.exhibitsOrRefines(eObject, getDensityTrait);
	}
	
	/**
	 * Get all symbols inside the given type that exhibits/refines the Density trait. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getDensitySymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithTrait(type, getDensityTrait, recursive);
	}
	
	/**
	 * get UniformInt type declaration
	 */
	def getUniformIntType() {
		return getType(UNIFORMINT)
	}
	
	/**
	 * check whether the given type is UniformInt type
	 */
	def isUniformInt(NamedType type) {
		return equalOrSameQn(getUniformIntType, type)
	}
	
	/**
	 * Get all symbols inside the given type that are UniformInt type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getUniformIntSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getUniformIntType, recursive)
	}
	/**
	 * Get the low symbol declaration inside the given UniformInt type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getUniformIntLowVar() {
		return ImlUtil.findSymbol(getType(UNIFORMINT), UNIFORMINT_LOW_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the high symbol declaration inside the given UniformInt type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getUniformIntHighVar() {
		return ImlUtil.findSymbol(getType(UNIFORMINT), UNIFORMINT_HIGH_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the possible symbol declaration inside the given UniformInt type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getUniformIntPossibleVar() {
		return ImlUtil.findSymbol(getType(UNIFORMINT), UNIFORMINT_POSSIBLE_VAR, true) as SymbolDeclaration;
	}
	
	override getPackageName() {
		PACKAGE_NAME
	}
	
	/**
	 * Checks if a symbol is defined inside Probabilistic IML library
	 */
	def isProbabilisticSymbol(Symbol symbol) {
		if (symbol !== null) {
			val containerModel = ImlUtil.getContainerOfType(symbol, Model)
			if (containerModel.name == getPackageName()) {
				return true;
			}
		}
		return false;
	}
}
