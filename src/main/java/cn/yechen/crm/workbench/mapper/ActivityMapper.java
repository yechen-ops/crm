package cn.yechen.crm.workbench.mapper;

import cn.yechen.crm.workbench.domain.Activity;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface ActivityMapper {
    int saveActivity(Activity activity);

    int getTotalCountByConditions(Map<String, Object> map);

    List<Activity> getActivitiesByConditions(Map<String, Object> map);

    int getCountByIds(String[] ids);

    int deleteByActivities(String[] ids);

    Activity getActivityById(String id);

    int updateActivity(Activity activity);

    Activity getDetailById(String id);

    List<Activity> getActivityListByClueId(String clueId);

    List<Activity> getActivityListByNameAndAIds(@Param("name") String name, @Param("activityIds") List<String> activityIds, @Param("size") int size);

    List<Activity> getActivityListByName(@Param("name") String name);
}