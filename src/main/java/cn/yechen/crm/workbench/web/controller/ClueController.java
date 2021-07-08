package cn.yechen.crm.workbench.web.controller;

import cn.yechen.crm.settings.domain.User;
import cn.yechen.crm.settings.service.UserService;
import cn.yechen.crm.settings.service.impl.UserServiceImpl;
import cn.yechen.crm.utils.DateTimeUtil;
import cn.yechen.crm.utils.PrintJson;
import cn.yechen.crm.utils.ServiceFactory;
import cn.yechen.crm.utils.UUIDUtil;
import cn.yechen.crm.workbench.domain.Activity;
import cn.yechen.crm.workbench.domain.Clue;
import cn.yechen.crm.workbench.domain.Customer;
import cn.yechen.crm.workbench.domain.Tran;
import cn.yechen.crm.workbench.exception.ConvertException;
import cn.yechen.crm.workbench.service.ActivityService;
import cn.yechen.crm.workbench.service.ClueService;
import cn.yechen.crm.workbench.service.impl.ActivityServiceImpl;
import cn.yechen.crm.workbench.service.impl.ClueServiceImpl;
import cn.yechen.crm.workbench.vo.PaginationVo;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author yechen
 * @create 2021-07-03 12:39
 */
public class ClueController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("===进入线索控制器===");
        String path = request.getServletPath();
        if ("/workbench/clue/getUserList.do".equals(path)) {
            // 获取用户列表
            getUserList(request, response);
        } else if ("/workbench/clue/saveClue.do".equals(path)) {
            // 保存线索
            saveClue(request, response);
        } else if ("/workbench/clue/pageList.do".equals(path)) {
            // 分页查询
            pageList(request, response);
        } else if ("/workbench/clue/detail.do".equals(path)) {
            // 通过 id 获取具体线索
            getDetailById(request, response);
        } else if ("/workbench/clue/getActivityListByClueId.do".equals(path)) {
            // 通过线索 id 获取市场活动列表
            getActivityListByClueId(request, response);
        } else if ("/workbench/clue/deleteRelation.do".equals(path)) {
            // 通过关系表的 id 删除关系
            deleteRelation(request, response);
        } else if ("/workbench/clue/getActivityListByNameAndClueId.do".equals(path)) {
            // 通过名称查询市场活动列表，并过滤掉已经关联的市场活动
            getActivityListByNameAndClueId(request, response);
        } else if ("/workbench/clue/boundActivityAndClue.do".equals(path)) {
            // 绑定当前线索和选中的市场活动
            boundActivityAndClue(request, response);
        } else if ("/workbench/clue/getActivityListByName.do".equals(path)) {
            // 通过名称查询市场活动列表
            getActivityListByName(request, response);
        } else if ("/workbench/clue/convert.do".equals(path)) {
            // 线索转换
            convert(request, response);
        } else if ("/workbench/clue/getUserListAndClue.do".equals(path)) {
            // 获取用户列表和对应的线索
            getUserListAndClue(request, response);
        }

    }

    private void getUserListAndClue(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("---执行获取用户列表和对应的线索的操作---");
        String clueId = request.getParameter("id");
        UserService userService = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> userList = userService.getUserList();
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        Clue clue = clueService.getClueById(clueId);
        // 打包成 Map
        Map<String, Object> map = new HashMap<>();
        map.put("userList", userList);
        map.put("clue", clue);
        PrintJson.printJsonObj(response, map);
    }

    private void convert(HttpServletRequest request, HttpServletResponse response) throws IOException {
        System.out.println("---执行线索转换操作---");
        // 获取参数
        String clueId = request.getParameter("clueId");
        String flag = request.getParameter("flag");
        // 可以通过判断 tran 对象是否为空来知道是否要创建交易
        Tran tran = null;
        String createBy = ((User) request.getSession().getAttribute("user")).getName();
        if ("true".equals(flag)) {
            // 接受表单中的参数
            String money = request.getParameter("money");
            String name = request.getParameter("name");
            String expectedDate = request.getParameter("expectedDate");
            String stage = request.getParameter("stage");
            String activityId = request.getParameter("activityId");
            // 封装交易对象
            tran = new Tran();
            tran.setId(UUIDUtil.getUUID());
            tran.setMoney(money);
            tran.setName(name);
            tran.setExpectedDate(expectedDate);
            tran.setStage(stage);
            tran.setActivityId(activityId);
            tran.setCreateTime(DateTimeUtil.getSystemTime());
            tran.setCreateBy(createBy);
        }
        System.out.println("tran--->"+tran);
        // 调用业务层
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean result = false;
        try {
            result = clueService.convert(clueId, tran, createBy);
        } catch (ConvertException e) {
            e.printStackTrace();
        }
        // 重定向
        if (result) {
            response.sendRedirect(request.getContextPath() + "/workbench/clue/index.jsp");
        }
    }

    private void getActivityListByName(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("---执行通过名称查询市场活动列表的操作---");
        // 获取参数
        String name = request.getParameter("name");
        System.out.println("name-->"+name);
        // 调用业务层
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        List<Activity> activityList = activityService.getActivityListByName(name);
        PrintJson.printJsonObj(response, activityList);
    }

    private void boundActivityAndClue(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("---执行绑定当前线索和选中的市场活动的操作---");
        // 获取参数
        String clueId = request.getParameter("clueId");
        String[] activityIds = request.getParameterValues("activityId");
        // 调用业务层
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean flag = clueService.saveRelation(clueId, activityIds);
        PrintJson.printJsonFlag(response, flag);
    }

    private void getActivityListByNameAndClueId(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("---执行通过名称查询市场活动列表，并过滤掉已经关联的场市活动的操作---");
        // 获取参数
        String name = request.getParameter("name");
        String clueId = request.getParameter("clueId");
        // 调用业务层
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        List<String> activityIds = clueService.getAIdsByClueId(clueId);
        System.out.println("控制器(activityIds)-->"+activityIds);
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        List<Activity> activityList = activityService.getActivityListByNameAndAIds(name, activityIds);
        PrintJson.printJsonObj(response, activityList);
    }

    private void deleteRelation(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("---解除关联操作---");
        // 获取参数
        String relationId = request.getParameter("relationId");
        // 调用业务层
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean flag = clueService.deleteRelationById(relationId);
        PrintJson.printJsonFlag(response, flag);
    }

    private void getActivityListByClueId(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("---执行通过线索 id 获取市场活动列表的操作---");
        // 获取参数
        String clueId = request.getParameter("clueId");
        // 调用业务层
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        List<Activity> activityList = activityService.getActivityListByClueId(clueId);
        PrintJson.printJsonObj(response, activityList);
    }

    private void getDetailById(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("---获取线索详细信息页---");
        // 获取参数
        String id = request.getParameter("id");
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        Clue clue = clueService.getDetailById(id);
        // 请求转发
        request.setAttribute("clue", clue);
        request.getRequestDispatcher("/workbench/clue/detail.jsp").forward(request, response);
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("---进入分页查询操作---");
        // 获取参数
        int pageNo = Integer.parseInt(request.getParameter("pageNo"));
        System.out.println("当前查询的是第【" + pageNo + "】页");
        int pageSize = Integer.parseInt(request.getParameter("pageSize"));
        System.out.println("本页共展示【" + pageSize + "】页数据");
        String fullName = request.getParameter("fullName");
        String company = request.getParameter("company");
        String phone = request.getParameter("phone");
        String source = request.getParameter("source");
        String owner = request.getParameter("owner");
        String mphone = request.getParameter("mphone");
        String state = request.getParameter("state");
        // 查询需要使用两个参数：略过的记录数（skipCount），查询个数（pageSize）
        int skipCount = (pageNo - 1) * pageSize;
        // 将查询条件封装为 Map
        Map<String, Object> map = new HashMap<>();
        map.put("skipCount", skipCount);
        map.put("pageSize", pageSize);
        map.put("fullName", fullName);
        map.put("company", company);
        map.put("phone", phone);
        map.put("source", source);
        map.put("owner", owner);
        map.put("mphone", mphone);
        map.put("state", state);
        System.out.println(map);

        // 调用业务层
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        PaginationVo<Clue> vo = clueService.pageList(map);
        PrintJson.printJsonObj(response, vo);
    }

    private void saveClue(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("---进入创建线索的操作---");
        // 获取参数
        String fullName = request.getParameter("fullName");
        String appellation = request.getParameter("appellation");
        String owner = request.getParameter("owner");
        String company = request.getParameter("company");
        String job = request.getParameter("job");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String website = request.getParameter("website");
        String mphone = request.getParameter("mphone");
        String state = request.getParameter("state");
        String source = request.getParameter("source");
        String description = request.getParameter("description");
        String contactSummary = request.getParameter("contactSummary");
        String nextContactTime = request.getParameter("nextContactTime");
        String address = request.getParameter("address");
        // 赋值
        String id = UUIDUtil.getUUID();
        String createBy = ((User) request.getSession().getAttribute("user")).getName();
        String createTime = DateTimeUtil.getSystemTime();
        // 封装成 Clue 对象
        Clue clue = new Clue();
        clue.setFullName(fullName);
        clue.setAppellation(appellation);
        clue.setOwner(owner);
        clue.setCompany(company);
        clue.setJob(job);
        clue.setEmail(email);
        clue.setPhone(phone);
        clue.setWebsite(website);
        clue.setMphone(mphone);
        clue.setState(state);
        clue.setSource(source);
        clue.setDescription(description);
        clue.setContactSummary(contactSummary);
        clue.setNextContactTime(nextContactTime);
        clue.setAddress(address);
        clue.setId(id);
        clue.setCreateBy(createBy);
        clue.setCreateTime(createTime);
        // 调用业务层
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean flag = clueService.saveClue(clue);
        // 输出
        PrintJson.printJsonFlag(response, flag);
    }

    private void getUserList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("---进入获取用户列表操作---");
        UserService userService = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> list = userService.getUserList();
        PrintJson.printJsonObj(response, list);
    }
}
