package cn.yechen.crm.web.filter;

import javax.servlet.*;
import java.io.IOException;

/**
 * @author yechen
 * @create 2021-06-30 21:49
 */
public class EncodingFilter implements Filter {
    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        System.out.println("\n===进入到字符编码过滤器===");
        // 过滤 POST 请求中文参数编码
        servletRequest.setCharacterEncoding("UTF-8");
        // 过滤响应流乱码
        servletResponse.setContentType("text/html; charset=UTF-8");
        // 放行
        filterChain.doFilter(servletRequest, servletResponse);
    }
}
