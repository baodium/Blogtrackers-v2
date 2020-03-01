package util;

import scala.Tuple2;
import java.io.Serializable;
import java.util.Comparator;

public class DummyComparator implements Comparator<Tuple2<String, Integer>>, Serializable {
	public int compare(Tuple2<String, Integer> x, Tuple2<String, Integer> y) {
		return Integer.compare(x._2(), y._2());
	}

//	public static class TupleComparator implements Comparator<Tuple2<Integer, Iterable<String>>>, Serializable {
//        @Override
//        public int compare(Tuple2<Integer, Iterable<String>> x, Tuple2<Integer, Iterable<String>> y) {
//            return Integer.compare(x._1(), y._1());
//        }
}