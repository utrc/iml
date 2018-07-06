package com.utc.utrc.hermes.iml.util;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;

/**
 * 
 * @author Ayman Elkfrawy (elkfraaf@utrc.utc.com)
 *
 */
public class FileUtil {
	
	/**
	 * Read contents of the given file or the all files under given directory
	 * @param path the path of file or folder
	 * @return list of files contents as strings
	 */
	public static List<String> readAllFilesUnderDir(String path) {
		LinkedList<File> queue = new LinkedList<File>();
		List<String> allFiles = new ArrayList<String>();
		queue.add(new File(path));
		while(!queue.isEmpty()) {
			File currentFile = queue.remove(0);
			if (currentFile.isDirectory()) {
				queue.addAll(Arrays.asList(currentFile.listFiles()));
			} else if (currentFile.isFile()) {
				allFiles.add(readFileContent(currentFile));
			}
		}
		return allFiles;
	}

	public static String readFileContent(String filepath) {
		return readFileContent(new File(filepath));
	}
	
	private static String readFileContent(File file) {
		try {
			return new String(Files.readAllBytes(file.toPath()));
		} catch (IOException e) {
			e.printStackTrace();
			return null;
		}
	}

	public static void writeFileContent(String filePath, String content) {
		try {
			Files.write(new File(filePath).toPath(), content.getBytes());
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public static void removeFile(String filePath) {
		try {
			if (Files.exists(new File(filePath).toPath())) {
				Files.delete(new File(filePath).toPath());
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public static boolean exists(String filePath) {
		return Files.exists(new File(filePath).toPath());
	}

}
