# Extending IML Libraries
IML comes with standard libraries that include constructs for commonly used domains. User can extend these libraries for supporting new domains or solvers. In such library, the user can define custom types, traits, and their related properties. The end-users can then use these elements by importing the library. 

## Setting up IML Custom Library
1. *Create new eclipse plugin project*: `File` > `New` > `Project` and select from `Plug-in Development` > `Plug-in Project`.
1. *Create IML package*: Under the `src` folder, create package named `iml`.
1. Write your IML library files under that package directory.
1. Each IML module package name must start with `iml.`. I.e. the first line of each library must be `package iml.<Your_library_name_here>;`
1. *Export `iml` package*: open `META-INF` > `MANIFEST.MF` then select `Runtime` tab. Under `Exported Packages` click `Add...`, check `Show non-Java packages`, select `iml` then press `Add`.
1. *Contribute to the extension point*: Go to the `META-INF` > `MANIFEST.MF` then select `Extensions` tab. Click `Add` and select `com.utc.utrc.hermes.iml.lib` extension point from the list. Under that extension point, right click and click `New` > `library` then provide the relative library directory (i.e. `src/iml/`).
1. If you didn't find `com.utc.utrc.hermes.iml.lib` extension point in the list from previous step, you can directly add/modify `plugin.xml` by adding the following:
  ```xml
  <extension point="com.utc.utrc.hermes.iml.lib">
      <library lib_directory="src/iml/"> </library>
   </extension>
  ```

## Using the IML custom library
After setting up and defining the language as described in the previous section, a user can use this library in multiple ways. In the following sections, we describe two common methods of using it. In both cases, the user will need to add this library to the project dependencies in `META-INF` > `MANIFEST.MF` > `Dependencies` and add it under `Required Plug-ins`. 
### Programmatically for Parsing IML file
In this method user can use the library to write IML files that import that library and programmatically parse these IML files using `ImlParseHelper.parse(String)` method from `com.utc.utrc.hermes.iml` package. This method will take care of looking at all contributions to the extension point `com.utc.utrc.hermes.iml.lib` and automatically loading their related IML files. 

This method is typically used in standalone applications or in testing projects. See `com.utc.utrc.hermes.iml.example.test` project for an example of this usage.

### Runtime as part of Eclipse IDE
This work when the user install the custom library plugin inside an eclipse IDE instance with IML already installed or as part of a feature. An example is to install the plugin inside `HERMES Reasoning` eclipse product. Creating new IML project (`File` > `New` > `IML` > `IML Project`) while such custom library installed will allow the wizard to load that library and make it available for the user to import and use.

## Generating Service classes for the library
Traversing and processing an IML model that uses custom library can be tedious. To address this issue, we provide a method to generate service classes for custom libraries. These service classes contain utility methods to easily process the IML model. For instance, you can use these classes while writing a validator or generator for your library as described in the next sections.

To generate these classes, you need to run main method of Java class `com.utc.utrc.hermes.iml.lib.LibraryServicesGenerator` with the following arguments `<iml_library_src_folder> <output_folder>`. After running the class, the `<out_folder>` will contains `xtend` classes (one per `.iml` file) with commonly used utility methods for processing the model. 

The generated classes have the same structure for service classes generated for IML standard libraries under `com.utc.utrc.hermes.iml.lib.gen` package. They also can be used in the same fashion by injecting them inside your custom code using `@inject` keyword. 