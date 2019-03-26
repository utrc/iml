# HERMES-IML
Hybrid Efficient Reasoning Methods For Explainable and Scalable Formal Methods - IML SDK


# Build Instructions
1.  Under `releng/com.utc.utrc.hermes.iml.parent` directory run `mvn clean install`. This will take time first time as it will download a lot of dependancies. If you got an error regarding test cases fails, you can run `mvn –DskipTests clean install` to skip tests for now.
2. Under `releng/com.utc.utrc.hermes.iml.product/target/products/com.utc.utrc.hermes.iml.rcp.product` folder, you will find different 
3. eclipse products with IML plugins already installed. 
4. Open the instance according to your operating system
5. Inside eclipse create new IML project (`File` > `New` > `Project` > `IML` > `IML Project`)
6. You can now start writing your IML code!

# Using your own eclipse
If you want to use IML inside your own Eclipse instance, you can follow the following steps:
1. Inside your own eclipse instance, you can install our IML plugins from `Help` > `Install New Software`
2. Click `Add..` then `Local…` and choose the following directory `releng/com.utc.utrc.hermes.iml.repository/target/repository`
3. You should see `IML feature`, select it and continue the installation.
4. Now you can create projects to develop IML code as before or you can create eclipse plugins that depends on IML plugins


# Contributing to IML
To modify or contribute to IML: 
* You need Eclipse for Java and DSL Developers (find it [here](https://www.eclipse.org/downloads/packages/release/oxygen/3a/eclipse-ide-java-and-dsl-developers)). 
* Change Eclipse workspace encoding to `UTF-8`: From `Window` > `Preferences` > `General` > `Workspace`: Select Text file encoding as `Other`>`UTF-8`
* Import all IML plugins inside that eclipse instance.

