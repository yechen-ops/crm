package cn.yechen.crm.workbench.service.impl;

import cn.yechen.crm.utils.DateTimeUtil;
import cn.yechen.crm.utils.SqlSessionUtil;
import cn.yechen.crm.utils.UUIDUtil;
import cn.yechen.crm.workbench.domain.*;
import cn.yechen.crm.workbench.exception.ConvertException;
import cn.yechen.crm.workbench.mapper.*;
import cn.yechen.crm.workbench.service.ClueService;
import cn.yechen.crm.workbench.vo.PaginationVo;
import com.fasterxml.jackson.databind.node.ContainerNode;
import org.apache.ibatis.type.InstantTypeHandler;

import javax.swing.*;
import javax.xml.transform.Transformer;
import java.util.ArrayList;
import java.util.Currency;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CountDownLatch;

/**
 * @author yechen
 * @create 2021-07-03 12:37
 */
public class ClueServiceImpl implements ClueService {
    // 线索相关表
    private ClueMapper clueMapper = SqlSessionUtil.getSqlSession().getMapper(ClueMapper.class);
    private ClueActivityRelationMapper clueActivityRelationMapper = SqlSessionUtil.getSqlSession().getMapper(ClueActivityRelationMapper.class);
    private ClueRemarkMapper clueRemarkMapper = SqlSessionUtil.getSqlSession().getMapper(ClueRemarkMapper.class);

    // 客户相关表
    private CustomerMapper customerMapper = SqlSessionUtil.getSqlSession().getMapper(CustomerMapper.class);
    private CustomerRemarkMapper customerRemarkMapper = SqlSessionUtil.getSqlSession().getMapper(CustomerRemarkMapper.class);

    // 联系人相关表
    private ContactsMapper contactsMapper = SqlSessionUtil.getSqlSession().getMapper(ContactsMapper.class);
    private ContactsRemarkMapper contactsRemarkMapper = SqlSessionUtil.getSqlSession().getMapper(ContactsRemarkMapper.class);
    private ContactsActivityRelationMapper contactsActivityRelationMapper = SqlSessionUtil.getSqlSession().getMapper(ContactsActivityRelationMapper.class);

    // 交易相关表
    private TranMapper tranMapper = SqlSessionUtil.getSqlSession().getMapper(TranMapper.class);
    private TranHistoryMapper tranHistoryMapper = SqlSessionUtil.getSqlSession().getMapper(TranHistoryMapper.class);

    @Override
    public boolean saveClue(Clue clue) {
        boolean flag = false;
        int count = clueMapper.saveClue(clue);
        if (count == 1) {
            flag = true;
        }
        return flag;
    }

    @Override
    public PaginationVo<Clue> pageList(Map<String, Object> map) {
        // 查询符合条件的个数
        int totalCount = clueMapper.getTotalCountByConditions(map);
        // 查询符合条件并通过分页数据获取市场活动列表
        List<Clue> clueList = clueMapper.getCluesByConditions(map);
        PaginationVo<Clue> paginationVo = new PaginationVo<>();
        paginationVo.setTotalCount(totalCount);
        paginationVo.setDataList(clueList);
        return paginationVo;
    }

    @Override
    public Clue getDetailById(String id) {
        return clueMapper.getDetailById(id);
    }

    @Override
    public boolean deleteRelationById(String relationId) {
        boolean flag = false;
        int count  = clueActivityRelationMapper.deleteRelationById(relationId);
        if (count == 1) {
            flag = true;
        }
        return flag;
    }

    @Override
    public List<String> getAIdsByClueId(String clueId) {
        return clueActivityRelationMapper.getAIdsByClueId(clueId);
    }

    @Override
    public boolean saveRelation(String clueId, String[] activityIds) {
        int count = 0;
        for (String activityId : activityIds) {
            ClueActivityRelation relation = new ClueActivityRelation();
            relation.setId(UUIDUtil.getUUID());
            relation.setClueId(clueId);
            relation.setActivityId(activityId);
            count += clueActivityRelationMapper.saveRelation(relation);
        }
        return count == activityIds.length;
    }

    @Override
    public boolean convert(String clueId, Tran tran, String createBy) throws ConvertException {
        String createTime = DateTimeUtil.getSystemTime();

        // 1、通过 clueId 获取线索对象 clue
        Clue clue = clueMapper.getCLueById(clueId);

        // 2、通过线索对象提取客户信息（根据公司名精确匹配），从而判断当前客户是否存在，当客户不存在的时候，新建并保存客户客户
        String customerName = clue.getCompany();
        Customer customer = customerMapper.getCustomerByName(customerName);
        if (customer == null) {
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setOwner(clue.getOwner());
            customer.setName(customerName);
            customer.setWebsite(clue.getWebsite());
            customer.setPhone(clue.getPhone());
            customer.setCreateBy(createBy);
            customer.setCreateTime(createTime);
            customer.setContactSummary(clue.getContactSummary());
            customer.setNextContactTime(clue.getNextContactTime());
            customer.setDescription(clue.getDescription());
            customer.setAddress(clue.getAddress());
            // 保存客户
            int count1 = customerMapper.save(customer);
            if (count1 != 1) {
                throw new ConvertException("客户保存失败");
            }
        }

        // 3、通过线索对象提取联系人信息，新建并保存联系人
        Contacts contacts = new Contacts();
        contacts.setId(UUIDUtil.getUUID());
        contacts.setOwner(clue.getOwner());
        contacts.setSource(clue.getSource());
        contacts.setCustomerId(customer.getId());
        contacts.setFullName(clue.getFullName());
        contacts.setAppellation(clue.getAppellation());
        contacts.setEmail(clue.getEmail());
        contacts.setMphone(clue.getMphone());
        contacts.setJob(clue.getJob());
        contacts.setCreateBy(createBy);
        contacts.setCreateTime(createTime);
        contacts.setDescription(clue.getDescription());
        contacts.setContactSummary(clue.getContactSummary());
        contacts.setNextContactTime(clue.getNextContactTime());
        contacts.setAddress(clue.getAddress());
        // 保存联系人
        int count2 = contactsMapper.save(contacts);
        if (count2 != 1) {
            throw new ConvertException("联系人保存失败");
        }

        // 4、将线索备注表中的数据分别保存到客户备注表和联系人备注表中
        // 获取线索备注列表
        List<ClueRemark> clueRemarkList = clueRemarkMapper.getRemarkListByClueId(clueId);
        // 编历线索备注列表将备注保存到客户备注表和联系人备注表中
        for (ClueRemark clueRemark : clueRemarkList) {
            // 新建客户备注对象
            CustomerRemark customerRemark = new CustomerRemark();
            customerRemark.setId(UUIDUtil.getUUID());
            customerRemark.setNoteContent(clueRemark.getNoteContent());
            customerRemark.setCreateBy(clueRemark.getCreateBy());
            customerRemark.setCreateTime(clueRemark.getCreateTime());
            customerRemark.setEditFlag("0");
            customerRemark.setCustomerId(customer.getId());
            // 保存客户备注表
            int count3 = customerRemarkMapper.save(customerRemark);
            if (count3 != 1) {
                throw new ConvertException("客户备注保存失败");
            }

            // 新建联系人备注对象
            ContactsRemark contactsRemark = new ContactsRemark();
            contactsRemark.setId(UUIDUtil.getUUID());
            contactsRemark.setNoteContent(clueRemark.getNoteContent());
            contactsRemark.setCreateBy(clueRemark.getCreateBy());
            contactsRemark.setCreateTime(clueRemark.getCreateTime());
            contactsRemark.setEditFlag("0");
            contactsRemark.setContactsId(contacts.getId());
            // 保存联系人备注
            int count4 = contactsRemarkMapper.save(contactsRemark);
            if (count4 != 1) {
                throw new ConvertException("联系人备注保存失败");
            }
        }

        // 5、从线索和市场活动关系表中获取数据线索对应的市场活动id列表，将 ”线索和市活场动“ 的关系转换为 “联系人和市场活动的关系”，保存到联系人和市场活动关系表中
        List<String> activityIdList = clueActivityRelationMapper.getAIdsByClueId(clueId);
        for (String activityId : activityIdList) {
            // 新建联系人和市场活动关系表对象
            ContactsActivityRelation contactsActivityRelation = new ContactsActivityRelation();
            contactsActivityRelation.setId(UUIDUtil.getUUID());
            contactsActivityRelation.setContactsId(contacts.getId());
            contactsActivityRelation.setActivityId(activityId);
            // 保存联系
            int count5 = contactsActivityRelationMapper.save(contactsActivityRelation);
            if (count5 != 1) {
                throw new ConvertException("联系人和市场活动关联关系保存失败");
            }
        }

        // 6、如果有创建交易的需求，则创建一条交易
        if (tran != null) {
            // tran 对象里已经封装了一些信息，接下来完善对 tran 的封装
            tran.setSource(clue.getSource());
            tran.setOwner(clue.getOwner());
            tran.setNextContactTime(clue.getNextContactTime());
            tran.setDescription(clue.getDescription());
            tran.setContactSummary(clue.getContactSummary());
            tran.setCustomerId(customer.getId());
            tran.setContactsId(contacts.getId());
            // 保存交易
            int count6 = tranMapper.save(tran);
            if (count6 != 1) {
                throw new ConvertException("交易保存失败");
            }

            // 7、如果创建了交易，则创建一条交易历史
            TranHistory tranHistory = new TranHistory();
            tranHistory.setId(UUIDUtil.getUUID());
            tranHistory.setStage(tran.getStage());
            tranHistory.setMoney(tran.getMoney());
            tranHistory.setExpectedDate(tran.getExpectedDate());
            tranHistory.setCreateTime(createTime);
            tranHistory.setCreateBy(createBy);
            tranHistory.setTranId(tran.getId());
            // 保存交易历史
            int count7 = tranHistoryMapper.save(tranHistory);
            if (count7 != 1) {
                throw new ConvertException("交易历史保存失败");
            }
        }

        // 8、删除线索备注
        int num1 = clueRemarkMapper.getNumByClueId(clueId);
        int count8 = clueRemarkMapper.deleteByClueId(clueId);
        if (count8 != num1) {
            throw new ConvertException("线索备注删除失败");
        }

        // 9、解除（删除）线索和市场活动的关联
        int num2 = clueActivityRelationMapper.getNumByClueId(clueId);
        int count9 = clueActivityRelationMapper.deleteRelationByClueId(clueId);
        if (count9 != num2) {
            throw new ConvertException("解除线索和市场活动关联失败");
        }

        // 10、删除线索
        int count10 = clueMapper.deleteById(clueId);
        if (count10 != 1) {
            throw new ConvertException("线索删除失败");
        }
        return true;
    }

    @Override
    public Clue getClueById(String clueId) {
        return clueMapper.getClueById(clueId);
    }


}
