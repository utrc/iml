# Extending IML Documentations

Extending IML documentations is a good place for documenting any of the custom extensions that user might have. For example, the user can create a help extension to describe a custom library and how an end user can use such library. Actually, all these extensions documentations are created using the method described below and can be found under the example extension project `com.utc.utrc.hermes.iml.example`. 

## Setting up custom IML Generator
1. *Create new eclipse plugin project or use an existing one*: `File` > `New` > `Project` and select from `Plug-in Development` > `Plug-in Project`.
1. *Create Table Of Content (TOC) file*: inside the main project directory, create `toc.xml` file.
1. *Contribute to the extension point*: Go to the `META-INF` > `MANIFEST.MF` then select `Extensions` tab. Click `Add` and select `"org.eclipse.help.toc"` extension point from the list. Under that extension point, right click and click `New` > `toc` then provide the name of the `toc.xml` file and set `primary` to be `true`.

## Writing the documentations
After setting up the documentation project as in the previous section, you will need to change the `toc.xml` to provide the layout of your documentation menu and files. The main outline for the `toc.xml` file should be as following:
```xml
<toc label=""  link_to="../com.utc.utrc.hermes.docs/toc.xml#extensions">
	<topic label="[MAIN_PAGE_MENU_LABEL]" href="[MAIN_PAGE.html]">
	   <topic label="[SUBPAGE_1_MENU_LABEL]" href="[SUBPAGE_1.html]"> </topic>
	   <topic label="[SUBPAGE_2_MENU_LABEL]" href="[SUBPAGE_2.html]"> </topic>
	</topic>
</toc>
```
The user need to change parts with `[]` accordingly. Having `link_to` reference to `../com.utc.utrc.hermes.docs/toc.xml#extensions` will allow the documentations to be displayed under `HERMES Documentations` menu. Although the user can choose most suitable method to generate the HTML for topics we recommend the following method:
1. Create `html` directory and inside it write markdown (`.md`) file for each topic.
1. Generate the HTML files from `.md` files by using tool like `GFM Viewer` here: [https://github.com/satyagraha/gfm_viewer]. After installing that tool, right click on the `html` folder and press `Generate Markdown Preview`. This feature requires internet access.
1. If used the `GFM Viewer` tool, the resulting files will be in format `.[original_file_name].md.html`. Then use that inside the `href` property. For example `href=".main.md.html"`.

## Using custom documentations
Custom extension documentation can be used by installing the plugin in an Eclipse IDE or an Eclipse custom product. The documentations can be viewed by pressing `Help` menu and choosing `Help Contents`. If the standard IML documentations is already installed (`com.utc.utrc.hermes.docs`), the documentations will be found under `HERMES Documentation` section.