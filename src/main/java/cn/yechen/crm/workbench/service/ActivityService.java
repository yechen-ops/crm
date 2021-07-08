package cn.yechen.crm.workbench.service;

import cn.yechen.crm.workbench.domain.Activity;
import cn.yechen.crm.workbench.domain.ActivityRemark;
import cn.yechen.crm.workbench.exception.ConvertException;
import cn.yechen.crm.workbench.vo.PaginationVo;

import java.util.List;
import java.util.Map;

/**
 * @author yechen
 * @create 2021-07-01 12:34
 */
public interface ActivityService {

    boolean saveActivity(Activity activity);

    PaginationVo<Activity> pageList(Map<String, Object> map);

    boolean deleteActivitiesByIds(String[] ids);

    Activity getActivityById(String id);

    boolean updateActivity(Activity activity);

    Activity getDetailById(String id);

    List<ActivityRemark> getRemarkListByAId(String activityId);

    boolean deleteRemarkById(String id);

    boolean updateRemark(ActivityRemark activityRemark);

    boolean saveRemark(ActivityRemark remark);

    List<Activity> getActivityListByClueId(String clueId);

    List<Activity> getActivityListByNameAndAIds(String name, List<String> activityIds);

    List<Activity> getActivityListByName(String name);
}
