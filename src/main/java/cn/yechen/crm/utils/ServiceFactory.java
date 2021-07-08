package cn.yechen.crm.utils;

/**
 * @author yechen
 * @create 2021-06-30 13:12
 * 用来获取 service 类的代理对象（处理事务）
 */
public class ServiceFactory {
    public static Object getService(Object service) {
        return new TransactionInvocationHandler(service).getProxy();
    }
}
