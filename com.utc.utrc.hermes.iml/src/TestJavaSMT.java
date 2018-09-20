//import org.sosy_lab.common.ShutdownManager;
//import org.sosy_lab.common.configuration.Configuration;
//import org.sosy_lab.common.configuration.InvalidConfigurationException;
//import org.sosy_lab.common.log.BasicLogManager;
//import org.sosy_lab.common.log.LogManager;
//import org.sosy_lab.java_smt.SolverContextFactory;
//import org.sosy_lab.java_smt.SolverContextFactory.Solvers;
//import org.sosy_lab.java_smt.api.BooleanFormula;
//import org.sosy_lab.java_smt.api.BooleanFormulaManager;
//import org.sosy_lab.java_smt.api.FormulaManager;
//import org.sosy_lab.java_smt.api.IntegerFormulaManager;
//import org.sosy_lab.java_smt.api.Model;
//import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;
//import org.sosy_lab.java_smt.api.ProverEnvironment;
//import org.sosy_lab.java_smt.api.SolverContext;
//import org.sosy_lab.java_smt.api.SolverContext.ProverOptions;
//import org.sosy_lab.java_smt.api.SolverException;
//
//
//public class TestJavaSMT {
//	
//	public static void main(String[] args) throws InvalidConfigurationException, SolverException, InterruptedException {
//		Configuration config = Configuration.fromCmdLineArguments(args);
//	    LogManager logger = BasicLogManager.create(config);
//	    ShutdownManager shutdown = ShutdownManager.create();
//
//	    // SolverContext is a class wrapping a solver context.
//	    // Solver can be selected either using an argument or a configuration option
//	    // inside `config`.
//	    SolverContext context = SolverContextFactory.createSolverContext(
//	        config, logger, shutdown.getNotifier(), Solvers.SMTINTERPOL);
//	    
//	    // Assume we have a SolverContext instance.
//	    FormulaManager fmgr = context.getFormulaManager();
//
//	    BooleanFormulaManager bmgr = fmgr.getBooleanFormulaManager();
//	    IntegerFormulaManager imgr = fmgr.getIntegerFormulaManager();
//	    
//	    IntegerFormula a = imgr.makeVariable("a"),
//	                   b = imgr.makeVariable("b"),
//	                   c = imgr.makeVariable("c");
//	    
//	    
//	    BooleanFormula constraint = bmgr.or(
//	        imgr.equal(
//	            imgr.add(a, b), c
//	        ),
//	        imgr.equal(
//	            imgr.add(a, c), imgr.multiply(imgr.makeNumber(2), b)
//	        )
//	    );
//	    
//	    try (ProverEnvironment prover = context.newProverEnvironment(ProverOptions.GENERATE_MODELS)) {
//	        prover.addConstraint(constraint);
//	        boolean isUnsat = prover.isUnsat();
//	        
//	        if (!isUnsat) {
//	          Model model = prover.getModel();
//	        }
//	      }
//	}
//
//}
