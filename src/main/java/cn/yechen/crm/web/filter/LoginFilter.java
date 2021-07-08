package cn.yechen.crm.web.filter;

import cn.yechen.crm.settings.domain.User;
import cn.yechen.crm.utils.PathUtil;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * @author yechen
 * @create 2021-07-01 11:52
 */
public class LoginFilter implements Filter {
    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        System.out.println("===进入防止恶意登录过滤器===");
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;
        PathUtil.printAccessPath(request);
        // 获取当前访问路径
        String path = request.getServletPath();
        // 放行前端资源 /login.jsp 和 后端资源 /setting/user/login.do
        if ("/login.jsp".equals(path) || "/setting/user/login.do".equals(path)) {
            filterChain.doFilter(request, response);
        } else {
            // 否则就要验证 Session 域中是否保存了 User 对象
            User user = (User) request.getSession().getAttribute("user");
            // User 对象存在，放行
            if (user != null) {
                filterChain.doFilter(request, response);
            } else {
                // 否则就进行重定向到 /login.jsp，注意重定向路径要以 '/项目名' 开头
                response.sendRedirect(request.getContextPath() + "/login.jsp");
            }
        }
    }
}
