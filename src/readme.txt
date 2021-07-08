一、登录
    select * from tbl_user where loginAct=? and loginPwd=?
        如果 user 对象为 null，说明密码错误
        如果 user 对象不为 null，说明账号密码正确
            开始验证其他字段（从 user 对象中 get 到各个字段值）
            1. expireTime 验证失效时间
            2. lockTime 验证锁定状态
            3. allowIps 验证浏览器端的地址是否有效
            只有 expireTime 大于访问时间，lockTime 为 1，登录 IP 存在于 allowIps 中才能最终登录成功

            使用自定义异常向前端传递登录异常信息

    字符编码过滤器
    恶意登录拦截器

二、创建市场活动

三、分页查询/显示

四、选择市场活动并删除（一条或多条）

五、选择市场活动并修改（只能一条）

六、市场活动详细页展示（包含了备注信息）

七、备注信息的删除、添加、修改


