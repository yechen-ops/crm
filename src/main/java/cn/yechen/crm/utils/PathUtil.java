package cn.yechen.crm.utils;

import javax.servlet.http.HttpServletRequest;

/**
 * @author yechen
 * @create 2021-06-30 15:35
 * 打印当前访问路径
 */
public class PathUtil {
    public static void printAccessPath(HttpServletRequest request) {
        String path = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getRequestURI();
        System.out.println("当前访问路径 ---> "+path);
    }
}
