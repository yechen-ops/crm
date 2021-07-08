package cn.yechen.crm.settings.web.controller;

import cn.yechen.crm.settings.domain.User;
import cn.yechen.crm.settings.service.UserService;
import cn.yechen.crm.settings.service.impl.UserServiceImpl;
import cn.yechen.crm.utils.MD5Util;
import cn.yechen.crm.utils.PathUtil;
import cn.yechen.crm.utils.PrintJson;
import cn.yechen.crm.utils.ServiceFactory;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

/**
 * @author yechen
 * @create 2021-06-30 15:21
 */
public class UserController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("\n===进入用户控制器===");
        PathUtil.printAccessPath(request);
        String path = request.getServletPath();
        if ("/setting/user/login.do".equals(path)) {
            login(request, response);
        }
    }

    private void login(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("---进入验证登录操作---");
        // 取值
        String loginAct = request.getParameter("loginAct");
        String loginPwd = request.getParameter("loginPwd");
        loginPwd = MD5Util.getMD5(loginPwd);
        String ip = request.getRemoteAddr();
        System.out.println("ip--->" + ip);

        // 调用业务层
        UserService userService = (UserService) ServiceFactory.getService(new UserServiceImpl());
        try {
            User user = userService.login(loginAct, loginPwd, ip);
            request.getSession().setAttribute("user", user);
            // 运行到这儿，登录成功
            PrintJson.printJsonFlag(response, true);
        } catch (Exception e) {
            e.printStackTrace();
            // 运行到这儿，登录失败
            Map<String, Object> map = new HashMap<>();
            map.put("success", false);
            map.put("msg", e.getMessage());
            PrintJson.printJsonObj(response, map);
        }
    }
}
