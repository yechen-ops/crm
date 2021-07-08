package cn.yechen.crm.workbench.service.impl;

import cn.yechen.crm.utils.SqlSessionUtil;
import cn.yechen.crm.workbench.mapper.CustomerMapper;
import cn.yechen.crm.workbench.service.CustomerService;

import java.util.List;

/**
 * @author yechen
 * @create 2021-07-06 13:01
 */
public class CustomerServiceImpl implements CustomerService {
    private CustomerMapper customerMapper = SqlSessionUtil.getSqlSession().getMapper(CustomerMapper.class);

    @Override
    public List<String> getCustomerNameList(String name) {
        return customerMapper.getCustomerNameList(name);
    }
}
