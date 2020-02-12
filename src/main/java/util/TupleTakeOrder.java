package util;

import scala.Tuple2;
import java.io.Serializable;
import java.util.Comparator;

class TupleTakeOrder implements Comparator<Tuple2<String, Integer>> ,Serializable {
    /**
	 * 
	 */
//	private static final long serialVersionUID = 1L;
	final static TupleTakeOrder INSTANCE = new TupleTakeOrder();

	public int compare(Tuple2<String, Integer> t1, Tuple2<String, Integer> t2) {
       return -t1._2.compareTo(t2._2);     // sorts RDD elements descending (use for Top-N)
       // return t1._2.compareTo(t2._2);   // sorts RDD elements ascending (use for Bottom-N)
    }
}