package cn.yechen.crm.utils;

import java.lang.reflect.Field;
import java.util.Map;

/**
 * @author yechen
 * @create 2021-05-04 11:11
 */
public class MapToObjectUtil {

    public static <T>T autoBeanToMap(Class<T> myClass , Map map)throws Exception{
        if (map == null){
            return null;
        }
        //得到class
        T obj = myClass.newInstance();
        Field[] fields = obj.getClass().getDeclaredFields();
        for (int i = 0; i < fields.length; i++) {
            try {
                //得到属性
                Field field = fields[i];
                //打开私有访问
                field.setAccessible(true);
                //获取属性
                String name = field.getName();
                if (map.containsKey(name)){
                    if (null!=map.get(name)){
                        field.set(obj,map.get(name).toString());
                    }else{
                        field.set(obj,"");
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return obj;
    }
}
