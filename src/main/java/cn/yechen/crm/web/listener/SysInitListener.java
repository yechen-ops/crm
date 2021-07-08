package cn.yechen.crm.web.listener;

import cn.yechen.crm.settings.domain.DicValue;
import cn.yechen.crm.settings.service.DicService;
import cn.yechen.crm.settings.service.impl.DicServiceImpl;
import cn.yechen.crm.utils.ServiceFactory;
import com.fasterxml.jackson.databind.ObjectMapper;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.io.IOException;
import java.util.*;

/**
 * @author yechen
 * @create 2021-07-03 17:11
 * 监听上下文域对象的方法，当服务器启动，上下文域对象创建完毕后，将数据字典保存到 application 中
 */
public class SysInitListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("===上下文域对象创建了===");
        System.out.println("===服务器缓存处理数据字典开始===");
        // 获取上下文域对象
        ServletContext application = sce.getServletContext();
        // 获取数据字典
        DicService service = (DicService) ServiceFactory.getService(new DicServiceImpl());
        Map<String, List<DicValue>> map = service.getDicValueMap();
        // 将数据保存到 application
        Set<String> keys = map.keySet();
        for (String key : keys) {
            application.setAttribute(key, map.get(key));
            System.out.println("数据【"+key+"】已保存");
        }
        System.out.println("===服务器缓存处理数据字典结束===");

        System.out.println("===处理 Stage2Possibility.properties 文件开始===");
        Map<String, String> possibilityMap = new HashMap<>();
        ResourceBundle resourceBundle = ResourceBundle.getBundle("Stage2Possibility");
        Enumeration<String> keys1 = resourceBundle.getKeys();
        while (keys1.hasMoreElements()) {
            String key = keys1.nextElement();
            String value = resourceBundle.getString(key);
            possibilityMap.put(key, value);
        }
        ObjectMapper objectMapper = new ObjectMapper();
        String json = null;
        try {
            json = objectMapper.writeValueAsString(possibilityMap);
        } catch (IOException e) {
            e.printStackTrace();
        }
        System.out.println(json);
        System.out.println(possibilityMap);
        application.setAttribute("possibility", json);
        application.setAttribute("possibilityMap", possibilityMap);
        System.out.println("===处理 Stage2Possibility.properties 文件结束===");

    }
}
