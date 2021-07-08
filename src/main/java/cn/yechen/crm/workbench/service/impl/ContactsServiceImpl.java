package cn.yechen.crm.workbench.service.impl;

import cn.yechen.crm.utils.SqlSessionUtil;
import cn.yechen.crm.workbench.domain.Contacts;
import cn.yechen.crm.workbench.mapper.ContactsMapper;
import cn.yechen.crm.workbench.mapper.ContactsRemarkMapper;
import cn.yechen.crm.workbench.service.ContactsService;

import java.util.List;

/**
 * @author yechen
 * @create 2021-07-06 11:43
 */
public class ContactsServiceImpl implements ContactsService {
    private ContactsMapper contactsMapper = SqlSessionUtil.getSqlSession().getMapper(ContactsMapper.class);
    private ContactsRemarkMapper contactsRemarkMapper = SqlSessionUtil.getSqlSession().getMapper(ContactsRemarkMapper.class);

    @Override
    public List<Contacts> getContactsListByFullName(String fullName) {
        return contactsMapper.getContactsListByFullName(fullName);
    }
}
