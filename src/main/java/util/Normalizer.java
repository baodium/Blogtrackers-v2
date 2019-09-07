package util;

import java.util.ArrayList;
import java.util.*;

import authentication.*;

public class Normalizer {
	public String  _normalize(int minrange, int maxrange, int minimum, int maximum, int value) {		
		String [] labels = new String[5];
		labels[0] = "Very Low";
		labels[1] = "Low";
		labels[2] = "Medium";
		labels[3] = "High";
		labels[4] = "Very High";
		int den = (maximum-minimum);
		if(den==0) {
			den=1;
		}
		
		int ret =  ((maxrange-minrange)*((value-minimum)/(den)))+1;
		return labels[ret-1];
	}
		
}
