import cn.yechen.crm.utils.DateTimeUtil;
import cn.yechen.crm.utils.MD5Util;
import cn.yechen.crm.utils.ServiceFactory;
import cn.yechen.crm.utils.UUIDUtil;
import cn.yechen.crm.workbench.domain.Activity;
import cn.yechen.crm.workbench.service.ActivityService;
import cn.yechen.crm.workbench.service.impl.ActivityServiceImpl;
import org.junit.Test;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * @author yechen
 * @create 2021-06-30 16:03
 */
public class Test01 {
    @Test
    public void test1() {
        // 验证失效时间
        String expireTime = "2021-06-30 16:08:59";
        // System.out.println(expireTime.length());
        String nowTime = DateTimeUtil.getSystemTime();
        int i = expireTime.compareTo(nowTime);
        if (i>=0) {
            System.out.println("未失效");
        } else {
            System.out.println("失效");
        }
    }

    @Test
    public void test2() {
        // 验证 IP
        String ips = "aa,bb,cc,dd,ee,ff";
        String ip = "cc ";
        if (ips.contains(ip)) {
            System.out.println("验证通过");
        } else {
            System.out.println("验证不通过");
        }
    }

    @Test
    public void Test3() {
        for (int i = 0; i < 5; i++) {
            String uuid = UUIDUtil.getUUID();
            System.out.println(uuid);
        }
    }

    @Test
    public void Test4() {
        String name = "bilibili";
        List<String> activityIds = new ArrayList<>();
        activityIds.add("66e15e548a0a4e719ef34659f68657b9");
        activityIds.add("781fb5d6745846b79a77d0a36f22df13");
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        List<Activity> activityList = activityService.getActivityListByNameAndAIds(name, activityIds);

        System.out.println(activityList);
    }
}
