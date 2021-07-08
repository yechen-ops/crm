package cn.yechen.crm.utils;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * @author yechen
 * @create 2021-06-30 16:05
 */
public class DateTimeUtil {
    public static String getSystemTime() {
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return simpleDateFormat.format(new Date());
    }


}
