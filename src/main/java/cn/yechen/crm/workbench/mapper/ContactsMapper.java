package cn.yechen.crm.workbench.mapper;

import cn.yechen.crm.workbench.domain.Contacts;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ContactsMapper {

    int save(Contacts contacts);

    List<Contacts> getContactsListByFullName(@Param("fullName") String fullName);
}