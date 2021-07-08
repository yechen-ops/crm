package cn.yechen.crm.workbench.service.impl;

import cn.yechen.crm.settings.domain.User;
import cn.yechen.crm.utils.DateTimeUtil;
import cn.yechen.crm.utils.SqlSessionUtil;
import cn.yechen.crm.utils.UUIDUtil;
import cn.yechen.crm.workbench.domain.Clue;
import cn.yechen.crm.workbench.domain.Customer;
import cn.yechen.crm.workbench.domain.Tran;
import cn.yechen.crm.workbench.domain.TranHistory;
import cn.yechen.crm.workbench.exception.ConvertException;
import cn.yechen.crm.workbench.exception.TranSaveException;
import cn.yechen.crm.workbench.mapper.CustomerMapper;
import cn.yechen.crm.workbench.mapper.TranHistoryMapper;
import cn.yechen.crm.workbench.mapper.TranMapper;
import cn.yechen.crm.workbench.service.TranService;
import cn.yechen.crm.workbench.vo.Charts;
import cn.yechen.crm.workbench.vo.PaginationVo;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * @author yechen
 * @create 2021-07-06 10:43
 */
public class TranServiceImpl implements TranService {
    private TranMapper tranMapper = SqlSessionUtil.getSqlSession().getMapper(TranMapper.class);
    private TranHistoryMapper tranHistoryMapper = SqlSessionUtil.getSqlSession().getMapper(TranHistoryMapper.class);
    private CustomerMapper customerMapper = SqlSessionUtil.getSqlSession().getMapper(CustomerMapper.class);

    @Override
    public boolean saveTransaction(Tran tran, String customerName) throws TranSaveException {
        /*
         1、通过 customerName 查当前客户是否存在，
            如果当前客户不存在，则保存该客户，
            如果当前客户存在，通过 name 查找 id，
            最后将 customerId 保存到 tran 对象，完善 tran 需要的参数
         */
        Customer customer = customerMapper.getCustomerByName(customerName);
        if (customer == null) {
            // 当前客户不存在，保存该客户
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setOwner(tran.getOwner());
            customer.setName(customerName);
            customer.setCreateBy(tran.getCreateBy());
            customer.setCreateTime(DateTimeUtil.getSystemTime());
            customer.setNextContactTime(tran.getNextContactTime());
            customer.setContactSummary(tran.getContactSummary());
            // 保存客户
            int count1 = customerMapper.save(customer);
            if (count1 != 1) {
                throw new TranSaveException("新客户保存失败！");
            }
            tran.setCustomerId(customer.getId());
        } else {
            // 当前客户存在，通过 name 查找 id
            String id = customerMapper.getIdByName(customerName);
            tran.setCustomerId(id);
        }

        // 2、保存交易
        int count2 = tranMapper.save(tran);
        if (count2 != 1) {
            throw new TranSaveException("交易保存失败！");
        }
        // 3、保存一条交易记录
        TranHistory tranHistory = new TranHistory();
        tranHistory.setId(UUIDUtil.getUUID());
        tranHistory.setStage(tran.getStage());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setExpectedDate(tran.getExpectedDate());
        tranHistory.setCreateTime(DateTimeUtil.getSystemTime());
        tranHistory.setCreateBy(tran.getCreateBy());
        tranHistory.setTranId(tran.getId());
        int count3 = tranHistoryMapper.save(tranHistory);
        if (count3 != 1) {
            throw new TranSaveException("交易历史保存失败！");
        }
        return true;
    }

    @Override
    public PaginationVo<Tran> pageList(int skipCount, int pageSize) {
        int totalCount = tranMapper.getTotalCount();
        List<Tran> tranList = tranMapper.getTranList(skipCount, pageSize);
        /*for (Tran tran : tranList) {
            tran.setStage(tran.getStage().substring(2));
        }*/
        PaginationVo<Tran> paginationVo = new PaginationVo<>();
        paginationVo.setTotalCount(totalCount);
        paginationVo.setDataList(tranList);
        return paginationVo;
    }

    @Override
    public Tran getDetailById(String id) {
        return tranMapper.getDetailById(id);
    }

    @Override
    public List<TranHistory> getTranHistoryListByTranId(String tranId) {
        return tranHistoryMapper.getTranHistoryListByTranId(tranId);
    }

    @Override
    public boolean changeStage(Tran tran) {
        boolean flag = true;
        // 通过交易 id，修改交易的阶段、修改时间、修改人
        int count1 = tranMapper.updateStageByTranId(tran);
        if (count1 != 1) {
            flag = false;
        }

        // 封装一条交易历史对象
        TranHistory tranHistory = new TranHistory();
        tranHistory.setId(UUIDUtil.getUUID());
        tranHistory.setStage(tran.getStage());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setExpectedDate(tran.getExpectedDate());
        tranHistory.setCreateTime(DateTimeUtil.getSystemTime());
        tranHistory.setCreateBy(tran.getEditBy());
        tranHistory.setTranId(tran.getId());
        // 添加一条交易历史
        int count2 = tranHistoryMapper.save(tranHistory);
        if (count2 != 1) {
            flag = false;
        }
        return flag;
    }

    @Override
    public List<Charts> getCharts() {
        return tranMapper.getStageAndCount();
    }
}
