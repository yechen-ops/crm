package cn.yechen.crm.settings.mapper;

import cn.yechen.crm.settings.domain.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface UserMapper {

    User getUser(@Param("loginAct") String loginAct, @Param("loginPwd") String loginPwd);

    List<User> getUserList();

}