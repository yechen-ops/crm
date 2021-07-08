package cn.yechen.crm.workbench.service;

import cn.yechen.crm.workbench.domain.Contacts;

import java.util.List;

/**
 * @author yechen
 * @create 2021-07-06 11:42
 */
public interface ContactsService {
    List<Contacts> getContactsListByFullName(String fullName);
}
