package cn.yechen.crm.settings.service;

import cn.yechen.crm.settings.domain.User;
import cn.yechen.crm.settings.exception.LoginException;

import java.util.List;

/**
 * @author yechen
 * @create 2021-06-30 15:19
 */
public interface UserService {
    User login(String loginAct, String loginPwd, String ip) throws LoginException;

    List<User> getUserList();
}
