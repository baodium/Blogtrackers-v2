package util;

import java.io.*;
import java.util.*;
public class LanguageMapper {
	HashMap<String, String> lang = new HashMap<String, String>();		
	
	public static void main(String[] args) {
		LanguageMapper mapper = new LanguageMapper();
		System.out.println(mapper.loadLang().get("en"));
	}
	public LanguageMapper(){
		HashMap<String, String> hm = new HashMap<String, String>();
		BufferedReader br = null;
		try {
			br = new BufferedReader(new FileReader("0.csv"));
			String temp = "";
			String[] arr;
			while((temp= br.readLine()) != null) {
				temp = temp.trim();  											 	// Strip the whitespaces 
				if(temp.isEmpty()) { 						
					continue;														// Skip the comments, for example the author, created on and document type
				}
				else {
					arr = temp.split(",");											// Split it by ##, for example, if you have name##wale, then arr[0] = name and arr[1] = wale and arr.length = 2 since it contains 2 elements
					if(arr.length == 2) {
						hm.put(arr[0].trim(), arr[1].trim());	
						this.lang = hm;// Save the element as a key value pair. Using example above, the Hashmap will be [user, wale], where user is the key and wale is the value
					}
				}	
			}
		}catch(Exception e) {
			
		}
		
	}
	public HashMap<String, String> loadLang(){
				
		return lang;
	}
}
