package cn.yechen.crm.workbench.mapper;

import cn.yechen.crm.workbench.domain.Customer;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface CustomerMapper {

    Customer getCustomerByName(@Param("customerName") String customerName);

    int save(Customer customer);

    List<String> getCustomerNameList(String name);

    String getIdByName(String customerName);

}