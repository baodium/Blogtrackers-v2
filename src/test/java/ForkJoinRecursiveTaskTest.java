import java.util.*;
import java.util.concurrent.*;
 
/**
 * This program demonstrates how to execute a ForkJoinTask that returns
 * a result in a ForkJoinPool
 * @author www.codejava.net
 */
public class ForkJoinRecursiveTaskTest {
    static final int SIZE = 10_000_000;
    static int[] array = randomArray();
 
    public static void main(String[] args) {
 
        ArrayCounter mainTask = new ArrayCounter(array, 0, SIZE);
        ForkJoinPool pool = new ForkJoinPool();
        Integer evenNumberCount = pool.invoke(mainTask);
 
        System.out.println("Number of even numbers: " + evenNumberCount);
    }
 
    static int[] randomArray() {
        int[] array = new int[SIZE];
        Random random = new Random();
 
        for (int i = 0; i < SIZE; i++) {
            array[i] = random.nextInt(100);
        }
 
        return array;
    }
 
}