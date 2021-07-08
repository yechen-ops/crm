package cn.yechen.crm.utils;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.Configuration;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

import java.io.IOException;
import java.io.InputStream;

/**
 * @author yechen
 * @create 2021-06-30 12:51
 */
public class SqlSessionUtil {

    private static SqlSessionFactory sqlSessionFactory;
    private static ThreadLocal<SqlSession> threadLocal = new ThreadLocal<>();

    // 静态代码块保证只生成一个 SqlSessionFactory 对象
    static {
        String resource = "mybatis-config.xml";
        InputStream inputStream = null;
        try {
            inputStream = Resources.getResourceAsStream(resource);
        } catch (IOException e) {
            e.printStackTrace();
        }
        Configuration config;
        sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
    }

    // 获取 SqlSession
    public static SqlSession getSqlSession() {
        // 从当前线程中获取 SqlSession 对象，保证一个线程中业务使用的都是一个 SqlSession 对象，从而保证事务安全
        SqlSession sqlSession = threadLocal.get();
        if (sqlSession == null) {
            sqlSession = sqlSessionFactory.openSession();
            threadLocal.set(sqlSession);
        }
        return sqlSession;
    }

    // 关闭 SqlSession
    public static void closeSqlSession(SqlSession sqlSession) {
        if (sqlSession != null) {
            sqlSession.close();
            // 将 sqlSession 和当前线程断开联系，保证当前线程以干净的形态进入线程池
            threadLocal.remove();
        }
    }
}
