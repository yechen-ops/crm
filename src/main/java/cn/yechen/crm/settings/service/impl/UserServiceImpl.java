package cn.yechen.crm.settings.service.impl;

import cn.yechen.crm.settings.domain.User;
import cn.yechen.crm.settings.exception.LoginException;
import cn.yechen.crm.settings.mapper.UserMapper;
import cn.yechen.crm.settings.service.UserService;
import cn.yechen.crm.utils.DateTimeUtil;
import cn.yechen.crm.utils.SqlSessionUtil;

import java.util.List;

/**
 * @author yechen
 * @create 2021-06-30 15:19
 */
public class UserServiceImpl implements UserService {
    private UserMapper userMapper = SqlSessionUtil.getSqlSession().getMapper(UserMapper.class);

    @Override
    public User login(String loginAct, String loginPwd, String ip) throws LoginException {

        User user = userMapper.getUser(loginAct, loginPwd);
        if (user == null) {
            throw new LoginException("账号或密码错误，登录失败");
        }

        // 判断失效时间
        if (user.getExpireTime().compareTo(DateTimeUtil.getSystemTime()) < 0) {
            throw new LoginException("账号已失效，登录失败");
        }
        // 判断是否锁定
        if ("0".equals(user.getLockState())) {
            throw new LoginException("账号已锁定，登录失败");
        }
        // 判断 ip 是否允许
        /*if (!user.getAllowIps().contains(ip)) {
            throw new LoginException("IP不合法，登录失败");
        }*/

        return user;
    }

    @Override
    public List<User> getUserList() {
        List<User> list = userMapper.getUserList();
        return list;
    }
}
