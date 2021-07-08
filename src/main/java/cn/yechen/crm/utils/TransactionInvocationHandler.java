package cn.yechen.crm.utils;

import org.apache.ibatis.session.SqlSession;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;

/**
 * @author yechen
 * @create 2021-06-30 13:02
 * 用来代理 service 类，主要用来处理事务
 */
public class TransactionInvocationHandler implements InvocationHandler {

    // 被代理类
    private Object target;

    public TransactionInvocationHandler(Object target) {
        this.target = target;
    }

    @Override
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
        // 代理结果
        Object result = null;
        SqlSession sqlSession = SqlSessionUtil.getSqlSession();
        try {
            // 执行被代理类的方法
            result = method.invoke(target, args);
            // 代理增强（只有业务没有出现异常的情况下才会继续）
            sqlSession.commit();
        } catch (Exception e) {
            // 一旦抛出异常，就回滚事务
            sqlSession.rollback();
            // e.printStackTrace();

            // 处理什么异常，继续往上抛什么异常
            throw e.getCause();
        } finally {
            // 关闭 SqlSession
            SqlSessionUtil.closeSqlSession(sqlSession);
        }
        return result;
    }

    // 生成代理类
    public Object getProxy() {
        return Proxy.newProxyInstance(target.getClass().getClassLoader(), target.getClass().getInterfaces(), this);
    }
}
