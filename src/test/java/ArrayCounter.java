import java.util.concurrent.*;
 
/**
 * This class illustrates how to create a ForkJoinTask that returns a result.
 * @author www.codejava.net
 */
public class ArrayCounter extends RecursiveTask<Integer> {
    int[] array;
    int threshold = 100_000;
    int start;
    int end;
 
    public ArrayCounter(int[] array, int start, int end) {
        this.array = array;
        this.start = start;
        this.end = end;
    }
 
    protected Integer compute() {
        if (end - start < threshold) {
            return computeDirectly();
        } else {
            int middle = (end + start) / 2;
 
            ArrayCounter subTask1 = new ArrayCounter(array, start, middle);
            ArrayCounter subTask2 = new ArrayCounter(array, middle, end);
 
            invokeAll(subTask1, subTask2);
 
 
            return subTask1.join() + subTask2.join();
        }
    }
 
    protected Integer computeDirectly() {
        Integer count = 0;
 
        for (int i = start; i < end; i++) {
            if (array[i] % 2 == 0) {
                count++;
            }
        }
 
        return count;
    }
    
    
    
}





