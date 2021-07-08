package cn.yechen.crm.settings.exception;

/**
 * @author yechen
 * @create 2021-06-30 16:01
 * 登录功能自定义异常
 */
public class LoginException extends Exception{
    public LoginException(String msg) {
        super(msg);
    }
}
