package util;


import org.json.JSONObject;


import org.json.JSONArray;
import org.json.JSONException;

import java.*;



public class ControllerRunnable implements  Runnable {
    private String i_res;
    private String i_scroll_id;
    private int i_index;
    private JSONArray i_hits;
    private JSONObject i_result;

    ControllerRunnable(int index_copy, String _scroll_id_copy) {
        i_index = index_copy;
        i_scroll_id = _scroll_id_copy;
    }

    @Override
    public void run(){
        try {
            s_logger.debug("index:{}", i_index );
            String nexturl = m_scrollUrl.replace("--", i_scroll_id);
            s_logger.debug("nexturl:{}", nexturl);
            i_res = get(nexturl);

            s_logger.debug("i_res:{}", i_res);

            i_result = JSONObject.parseObject(i_res);
            if (i_result == null) {
                s_logger.info("controller thread parsed result object NULL, res:{}", i_res);
                s_counter++;
                return;
            }
            i_scroll_id = (String) i_result.get("_scroll_id");
            i_hits = i_result.getJSONObject("hits").getJSONArray("hits");
            s_logger.debug("hits content:{}\n", i_hits.toString());

            s_logger.info("hits_size:{}", i_hits.size());

            if (i_hits.size() > 0) {
                int per_thread_data_num = i_hits.size() / s_threadnumber;
                for (int i = 0; i < s_threadnumber; i++) {
                    Runnable worker = new DataRunnable(i * per_thread_data_num,
                            (i + 1) * per_thread_data_num);
                    m_executor.execute(worker);
                }
                // Wait until all threads are finish
                m_executor.awaitTermination(1, TimeUnit.SECONDS);
            } else {
                s_counter++;
                return;
            }
        } catch (Exception e) {
            s_logger.error(e.getMessage(),e);
        }
    }
}
