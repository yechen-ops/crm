package cn.yechen.crm.workbench.web.controller;

import cn.yechen.crm.settings.domain.User;
import cn.yechen.crm.settings.service.UserService;
import cn.yechen.crm.settings.service.impl.UserServiceImpl;
import cn.yechen.crm.utils.DateTimeUtil;
import cn.yechen.crm.utils.PrintJson;
import cn.yechen.crm.utils.ServiceFactory;
import cn.yechen.crm.utils.UUIDUtil;
import cn.yechen.crm.workbench.domain.Activity;
import cn.yechen.crm.workbench.domain.Contacts;
import cn.yechen.crm.workbench.domain.Tran;
import cn.yechen.crm.workbench.domain.TranHistory;
import cn.yechen.crm.workbench.exception.TranSaveException;
import cn.yechen.crm.workbench.service.ActivityService;
import cn.yechen.crm.workbench.service.ContactsService;
import cn.yechen.crm.workbench.service.CustomerService;
import cn.yechen.crm.workbench.service.TranService;
import cn.yechen.crm.workbench.service.impl.ActivityServiceImpl;
import cn.yechen.crm.workbench.service.impl.ContactsServiceImpl;
import cn.yechen.crm.workbench.service.impl.CustomerServiceImpl;
import cn.yechen.crm.workbench.service.impl.TranServiceImpl;
import cn.yechen.crm.workbench.vo.Charts;
import cn.yechen.crm.workbench.vo.PaginationVo;
import com.fasterxml.jackson.databind.ObjectMapper;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.transform.Transformer;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.chrono.MinguoChronology;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * @author yechen
 * @create 2021-07-06 10:45
 */
public class TranController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("===进入交易控制器===");
        String path = request.getServletPath();
        if ("/workbench/transaction/add.do".equals(path)) {
            // 执行到跳转交易添加页的操作，获取用户列表，并请求转发
            add(request, response);
        } else if ("/workbench/transaction/getContactsListByFullName.do".equals(path)) {
            // 通过联系人名称获取联系人列表
            getContactsListByFullName(request, response);
        } else if ("/workbench/transaction/getActivityListByName.do".equals(path)) {
            // 通过市场活动名称获取市场活动列表
            getActivityListByName(request, response);
        } else if ("/workbench/transaction/getCustomerName.do".equals(path)) {
            // 通过客户名称模糊查询客户名称列表
            getCustomerName(request, response);
        } else if ("/workbench/transaction/saveTransaction.do".equals(path)) {
            // 保存交易
            saveTransaction(request, response);
        } else if ("/workbench/transaction/pageList.do".equals(path)) {
            // 分页查询
            pageList(request, response);
        } else if ("/workbench/transaction/detail.do".equals(path)) {
            // 获取详细信息
            getDetailById(request, response);
        } else if ("/workbench/transaction/getTranHistoryListByTranId.do".equals(path)) {
            // 通过交易id获取相应的交易历史列表
            getTranHistoryListByTranId(request, response);
        } else if ("/workbench/transaction/changeStage.do".equals(path)) {
            // 更改交易阶段，并添加一条交易历史
            changeStage(request, response);
        } else if ("/workbench/transaction/getCharts.do".equals(path)) {
            // 获取图表所需要的数据
            getCharts(request, response);
        }
    }

    private void getCharts(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("---执行获取图表所需要的数据的操作---");
        TranService tranService = (TranService) ServiceFactory.getService(new TranServiceImpl());
        List<Charts> dataList = tranService.getCharts();
        PrintJson.printJsonObj(response, dataList);
    }

    private void changeStage(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("---执行更改交易阶段，并添加一条交易历史的操作---");
        String tranId = request.getParameter("tranId");
        String stage = request.getParameter("stage");
        String money = request.getParameter("money");
        String expectedDate = request.getParameter("expectedDate");

        // 封装一条交易对象
        Tran tran = new Tran();
        tran.setId(tranId);
        tran.setStage(stage);
        tran.setMoney(money);
        tran.setExpectedDate(expectedDate);
        tran.setEditTime(DateTimeUtil.getSystemTime());
        tran.setEditBy(((User) request.getSession().getAttribute("user")).getName());
        Map<String, String> possibilityMap = (Map<String, String>) request.getServletContext().getAttribute("possibilityMap");
        tran.setPossibility(possibilityMap.get(stage));

        TranService tranService = (TranService) ServiceFactory.getService(new TranServiceImpl());
        boolean success = tranService.changeStage(tran);

        Map<String, Object> map = new HashMap<>();
        map.put("success", success);
        map.put("tran", tran);
        PrintJson.printJsonObj(response, map);

    }

    private void getTranHistoryListByTranId(HttpServletRequest request, HttpServletResponse response) throws IOException {
        System.out.println("---通过交易id获取相应的交易历史列表---");
        String tranId = request.getParameter("tranId");
        TranService tranService = (TranService) ServiceFactory.getService(new TranServiceImpl());
        List<TranHistory> tranHistoryList = tranService.getTranHistoryListByTranId(tranId);

        Map<String, String> possibilityMap = (Map<String, String>) request.getServletContext().getAttribute("possibilityMap");
        for (TranHistory tranHistory : tranHistoryList) {
            tranHistory.setPossibility(possibilityMap.get(tranHistory.getStage()));
            tranHistory.setStage(tranHistory.getStage().substring(2));
        }

        PrintJson.printJsonObj(response, tranHistoryList);
    }

    private void getDetailById(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("---执行获取详细信息的操作---");
        String id = request.getParameter("id");
        TranService tranService = (TranService) ServiceFactory.getService(new TranServiceImpl());
        Tran tran = tranService.getDetailById(id);

        // String possibility = (String)request.getServletContext().getAttribute("possibility");
        // ObjectMapper objectMapper = new ObjectMapper();
        // Map map = objectMapper.readValue(possibility, Map.class);
        // String p = (String) map.get(tran.getStage());

        Map<String, String> possibilityMap = (Map<String, String>) request.getServletContext().getAttribute("possibilityMap");
        String possibility = possibilityMap.get(tran.getStage());

        // tran.setStage(tran.getStage().substring(2));
        request.setAttribute("possibility", possibility);
        request.setAttribute("tran", tran);
        request.getRequestDispatcher("/workbench/transaction/detail.jsp").forward(request, response);
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("---执行分页查询的操作---");
        // 获取参数
        int pageNo = Integer.parseInt(request.getParameter("pageNo"));
        System.out.println("当前查询的是第【" + pageNo + "】页");
        int pageSize = Integer.parseInt(request.getParameter("pageSize"));
        System.out.println("本页共展示【" + pageSize + "】页数据");
        // 查询需要使用两个参数：略过的记录数（skipCount），查询个数（pageSize）
        int skipCount = (pageNo - 1) * pageSize;

        TranService tranService = (TranService) ServiceFactory.getService(new TranServiceImpl());
        PaginationVo<Tran> vo = tranService.pageList(skipCount, pageSize);
        PrintJson.printJsonObj(response, vo);
    }

    private void saveTransaction(HttpServletRequest request, HttpServletResponse response) throws IOException {
        System.out.println("---执行保存交易的操作---");
        // 取值
        String owner = request.getParameter("owner");
        String money = request.getParameter("money");
        String name = request.getParameter("name");
        String expectedDate = request.getParameter("expectedDate");
        String stage = request.getParameter("stage");
        String type = request.getParameter("type");
        String source = request.getParameter("source");
        String activityId = request.getParameter("activityId");
        String contactsId = request.getParameter("contactsId");
        String description = request.getParameter("description");
        String contactSummary = request.getParameter("contactSummary");
        String nextContactTime = request.getParameter("nextContactTime");

        String customerName = request.getParameter("customerName");
        // 赋值
        String id = UUIDUtil.getUUID();
        String createBy = ((User) request.getSession().getAttribute("user")).getName();
        String createTime = DateTimeUtil.getSystemTime();

        // 打包
        Tran tran = new Tran();
        tran.setId(id);
        tran.setOwner(owner);
        tran.setMoney(money);
        tran.setName(name);
        tran.setExpectedDate(expectedDate);
        tran.setStage(stage);
        tran.setType(type);
        tran.setSource(source);
        tran.setActivityId(activityId);
        tran.setContactsId(contactsId);
        tran.setCreateBy(createBy);
        tran.setCreateTime(createTime);
        tran.setDescription(description);
        tran.setContactSummary(contactSummary);
        tran.setNextContactTime(nextContactTime);

        TranService tranService = (TranService) ServiceFactory.getService(new TranServiceImpl());
        boolean flag = false;
        try {
            flag = tranService.saveTransaction(tran, customerName);
        } catch (TranSaveException e) {
            e.printStackTrace();
        }
        if (flag) {
            response.sendRedirect(request.getContextPath() + "/workbench/transaction/index.jsp");
        }

    }

    private void getCustomerName(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("---执行通过客户名称模糊查询客户名称列表的操作---");
        String name = request.getParameter("name");
        CustomerService customerService = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        List<String> customerNameList = customerService.getCustomerNameList(name);
        PrintJson.printJsonObj(response, customerNameList);
    }

    private void getActivityListByName(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("---通过市场活动名称获取市场活动列表---");
        String name = request.getParameter("name");
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        List<Activity> activityList = activityService.getActivityListByName(name);
        PrintJson.printJsonObj(response, activityList);
    }

    private void getContactsListByFullName(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("---执行通过联系人名称获取联系人列表的操作---");
        // 获取参数
        String fullName = request.getParameter("fullName");
        ContactsService contactsService = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        List<Contacts> contactsList = contactsService.getContactsListByFullName(fullName);
        PrintJson.printJsonObj(response, contactsList);
    }

    private void add(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("---执行到跳转交易添加页的操作，获取用户列表，并请求转发---");
        UserService userService = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> userList = userService.getUserList();
        request.setAttribute("userList", userList);
        // 请求转发
        request.getRequestDispatcher("/workbench/transaction/save.jsp").forward(request, response);
    }
}
