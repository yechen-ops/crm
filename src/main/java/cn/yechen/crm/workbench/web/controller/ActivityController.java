package cn.yechen.crm.workbench.web.controller;

import cn.yechen.crm.settings.domain.User;
import cn.yechen.crm.settings.service.UserService;
import cn.yechen.crm.settings.service.impl.UserServiceImpl;
import cn.yechen.crm.utils.DateTimeUtil;
import cn.yechen.crm.utils.PrintJson;
import cn.yechen.crm.utils.ServiceFactory;
import cn.yechen.crm.utils.UUIDUtil;
import cn.yechen.crm.workbench.domain.Activity;
import cn.yechen.crm.workbench.domain.ActivityRemark;
import cn.yechen.crm.workbench.exception.ConvertException;
import cn.yechen.crm.workbench.service.ActivityService;
import cn.yechen.crm.workbench.service.impl.ActivityServiceImpl;
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
 * @create 2021-07-01 12:36
 */
public class ActivityController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("===进入市场活动控制器===");
        // PathUtil.printAccessPath(request);
        String path = request.getServletPath();
        if ("/workbench/activity/getUserList.do".equals(path)) {
            // 获取用户列表
            getUserList(request, response);
        } else if ("/workbench/activity/saveActivity.do".equals(path)) {
            // 添加市场活动
            saveActivity(request, response);
        } else if ("/workbench/activity/pageList.do".equals(path)) {
            // 条件查询市场活动，实现分页
            pageList(request, response);
        } else if ("/workbench/activity/deleteActivities.do".equals(path)) {
            // 删除选中的市场活动
            deleteActivities(request, response);
        } else if ("/workbench/activity/getUserListAndActivity.do".equals(path)) {
            // 获取用户列表和选中的市场活动
            getUserListAndActivity(request, response);
        } else if ("/workbench/activity/updateActivity.do".equals(path)) {
            // 更新市场活动
            updateActivity(request, response);
        } else if ("/workbench/activity/getDetail.do".equals(path)) {
            // 获取市场活动的详细信息
            getDetail(request, response);
        } else if ("/workbench/activity/getRemarkListByAId.do".equals(path)) {
            // 获取备注信息列表
            getRemarkListByAId(request, response);
        } else if ("/workbench/activity/deleteRemarkById.do".equals(path)) {
            // 删除备注信息
            deleteRemarkById(request, response);
        } else if ("/workbench/activity/updateRemark.do".equals(path)) {
            // 更新备注信息
            updateRemark(request, response);
        } else if ("/workbench/activity/saveRemark.do".equals(path)) {
            // 添加市场活动备注
            saveRemark(request, response);
        }
    }

    private void saveRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("---执行添加市场活动备注的操作---");
        // 获取参数
        String noteContent = request.getParameter("noteContent");
        String activityId = request.getParameter("activityId");
        // 其他参数
        String id = UUIDUtil.getUUID();
        String editFlag = "0";
        String createTime = DateTimeUtil.getSystemTime();
        String createBy = ((User) request.getSession().getAttribute("user")).getName();

        // 封装成对象
        ActivityRemark remark = new ActivityRemark();
        remark.setId(id);
        remark.setNoteContent(noteContent);
        remark.setEditFlag(editFlag);
        remark.setCreateBy(createBy);
        remark.setCreateTime(createTime);
        remark.setActivityId(activityId);

        // 调用业务层
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        boolean flag = activityService.saveRemark(remark);

        Map<String, Object> map = new HashMap<>();
        map.put("success", flag);
        map.put("remark", remark);
        PrintJson.printJsonObj(response, map);
    }

    private void updateRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("---执行更新市场活动备注的方法---");
        // 获取参数
        String noteContent = request.getParameter("noteContent");
        String id = request.getParameter("id");
        // 其他参数
        String editTime = DateTimeUtil.getSystemTime();
        String editBy = ((User) request.getSession().getAttribute("user")).getName();
        // 封装对象
        ActivityRemark activityRemark = new ActivityRemark();
        activityRemark.setId(id);
        activityRemark.setNoteContent(noteContent);
        activityRemark.setEditFlag("1");
        activityRemark.setEditTime(editTime);
        activityRemark.setEditBy(editBy);

        // 调用业务层
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        boolean flag = activityService.updateRemark(activityRemark);

        Map<String, Object> map = new HashMap<>();
        map.put("success", flag);
        map.put("remark", activityRemark);
        PrintJson.printJsonObj(response, map);
    }

    private void deleteRemarkById(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("---执行删除备注的操作---");
        // 获取参数
        String id = request.getParameter("id");
        // 调用业务层
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        boolean flag = activityService.deleteRemarkById(id);
        PrintJson.printJsonFlag(response, flag);
    }

    private void getRemarkListByAId(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("---进入根根市场活动 id，获取备注信息列表的操作");
        // 获取参数
        String activityId = request.getParameter("activityId");
        // 调用业务层
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        List<ActivityRemark> list = activityService.getRemarkListByAId(activityId);
        PrintJson.printJsonObj(response, list);
    }

    private void getDetail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("---进入获取市场活动详细信息操作---");
        // 获取参数
        String id = request.getParameter("id");

        // 调用业务层
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        Activity activity = activityService.getDetailById(id);

        request.setAttribute("activity", activity);
        request.getRequestDispatcher("/workbench/activity/detail.jsp").forward(request, response);

    }

    private void updateActivity(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("---进入到市场活动更新操作---");
        // 获取前端数据
        String id = request.getParameter("id");
        String owner = request.getParameter("owner");
        String name = request.getParameter("name");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String cost = request.getParameter("cost");
        String description = request.getParameter("description");
        // 添加其他数据
        String editTime = DateTimeUtil.getSystemTime();
        String editBy = ((User) request.getSession().getAttribute("user")).getName();

        // 将参数封装成 Activity 对象
        Activity activity = new Activity();
        activity.setId(id);
        activity.setOwner(owner);
        activity.setName(name);
        activity.setStartDate(startDate);
        activity.setEndDate(endDate);
        activity.setCost(cost);
        activity.setDescription(description);
        activity.setEditTime(editTime);
        activity.setEditBy(editBy);

        // 调用业务层
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        boolean flag = activityService.updateActivity(activity);
        Activity a = getActivityById(id);
        // request.setAttribute("activity", a);

        Map<String, Object> map = new HashMap<>();
        map.put("success", flag);
        map.put("activity", a);
        PrintJson.printJsonObj(response, map);
    }

    private void getUserListAndActivity(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("---进入获得用户列表和市场活动的操作---");
        // 获取参数
        String id = request.getParameter("id");
        // 调用业务层
        UserService userService = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> userList = userService.getUserList();
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        Activity activity = activityService.getActivityById(id);
        // 打包成 Map
        Map<String, Object> map = new HashMap<>();
        map.put("userList", userList);
        map.put("activity", activity);
        PrintJson.printJsonObj(response, map);
    }

    private void deleteActivities(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("---执行删除市场活动的操作---");
        // 获取参数
        String[] ids = request.getParameterValues("id");

        // 调用业务层
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        boolean result = activityService.deleteActivitiesByIds(ids);
        PrintJson.printJsonFlag(response, result);
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("---进入到市场活动信息列表查询的操作---");
        // 获取前端参数
        int pageNo = Integer.parseInt(request.getParameter("pageNo"));
        System.out.println("当前查询的是第【" + pageNo + "】页");
        int pageSize = Integer.parseInt(request.getParameter("pageSize"));
        System.out.println("本页共展示【" + pageSize + "】页数据");
        String name = request.getParameter("name");
        String owner = request.getParameter("owner");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        // 查询需要使用两个参数：略过的记录数（skipCount），查询个数（pageSize）
        int skipCount = (pageNo - 1) * pageSize;
        // 将查询条件封装为 Map
        Map<String, Object> map = new HashMap<>();
        map.put("skipCount", skipCount);
        map.put("pageSize", pageSize);
        map.put("name", name);
        map.put("owner", owner);
        map.put("startDate", startDate);
        map.put("endDate", endDate);

        // 调用业务层
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        PaginationVo<Activity> result = activityService.pageList(map);
        PrintJson.printJsonObj(response, result);
    }

    private void saveActivity(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("---执行市场活动的添加操作---");
        // 接受前端信息
        String owner = request.getParameter("owner");
        String name = request.getParameter("name");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String cost = request.getParameter("cost");
        String description = request.getParameter("description");
        // 生成其他信息
        String id = UUIDUtil.getUUID();
        String createTime = DateTimeUtil.getSystemTime();
        String createBy = ((User) request.getSession().getAttribute("user")).getName();

        // 将参数封装成 Activity 对象
        Activity activity = new Activity();
        activity.setId(id);
        activity.setOwner(owner);
        activity.setName(name);
        activity.setStartDate(startDate);
        activity.setEndDate(endDate);
        activity.setCost(cost);
        activity.setDescription(description);
        activity.setCreateTime(createTime);
        activity.setCreateBy(createBy);

        // 调用业务层
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        boolean flag = activityService.saveActivity(activity);
        PrintJson.printJsonFlag(response, flag);
    }

    private void getUserList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("---进入获取用户列表操作---");
        UserService userService = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> list = userService.getUserList();
        PrintJson.printJsonObj(response, list);
    }

    private Activity getActivityById(String id) {
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        Activity activity = activityService.getActivityById(id);
        return activity;
    }
}
