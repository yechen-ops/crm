package cn.yechen.crm.workbench.service.impl;

import cn.yechen.crm.utils.SqlSessionUtil;
import cn.yechen.crm.workbench.domain.Activity;
import cn.yechen.crm.workbench.domain.ActivityRemark;
import cn.yechen.crm.workbench.exception.ConvertException;
import cn.yechen.crm.workbench.mapper.ActivityMapper;
import cn.yechen.crm.workbench.mapper.ActivityRemarkMapper;
import cn.yechen.crm.workbench.service.ActivityService;
import cn.yechen.crm.workbench.vo.PaginationVo;

import java.sql.Connection;
import java.util.List;
import java.util.Map;

/**
 * @author yechen
 * @create 2021-07-01 12:34
 */
public class ActivityServiceImpl implements ActivityService {

    private ActivityMapper activityMapper = SqlSessionUtil.getSqlSession().getMapper(ActivityMapper.class);
    private ActivityRemarkMapper activityRemarkMapper = SqlSessionUtil.getSqlSession().getMapper(ActivityRemarkMapper.class);

    @Override
    public boolean saveActivity(Activity activity){
        boolean flag = false;
        int count = activityMapper.saveActivity(activity);
        if (count == 1) {
            flag = true;
        }
        return flag;
    }

    @Override
    public PaginationVo<Activity> pageList(Map<String, Object> map) {
        // 查询符合条件的个数
        int totalCount = activityMapper.getTotalCountByConditions(map);
        // 查询符合条件并通过分页数据获取市场活动列表
        List<Activity> activityList = activityMapper.getActivitiesByConditions(map);
        PaginationVo<Activity> paginationVo = new PaginationVo<>();
        paginationVo.setTotalCount(totalCount);
        paginationVo.setDataList(activityList);
        return paginationVo;
    }

    @Override
    public boolean deleteActivitiesByIds(String[] ids) {
        // 获取市场活动备注表中符合的记录的数量
        int count1 = activityRemarkMapper.getCountByIds(ids);
        // 删除市场活动备注表中符合的记录
        int count2 = activityRemarkMapper.deleteByActivityIds(ids);
        if (count1 != count2) {
            return false;
        }

        // 获取市场活动表中符合的记录的数量
        int count3 = activityMapper.getCountByIds(ids);
        // 删除市场活动表中符合的记录
        int count4 = activityMapper.deleteByActivities(ids);
        return count3 == count4;
    }

    @Override
    public Activity getActivityById(String id) {
        return activityMapper.getActivityById(id);
    }

    @Override
    public boolean updateActivity(Activity activity) {
        boolean flag = false;
        int count = activityMapper.updateActivity(activity);
        if (count == 1) {
            flag = true;
        }
        return flag;
    }

    @Override
    public Activity getDetailById(String id) {
        return activityMapper.getDetailById(id);
    }

    @Override
    public List<ActivityRemark> getRemarkListByAId(String activityId) {
        return activityRemarkMapper.getRemarkListByAId(activityId);
    }

    @Override
    public boolean deleteRemarkById(String id) {
        boolean flag = false;
        int count = activityRemarkMapper.deleteRemarkById(id);
        if (count == 1) {
            flag = true;
        }
        return flag;
    }

    @Override
    public boolean updateRemark(ActivityRemark activityRemark) {
        boolean flag = false;
        int count = activityRemarkMapper.updateRemark(activityRemark);
        if (count == 1) {
            flag = true;
        }
        return flag;
    }

    @Override
    public boolean saveRemark(ActivityRemark remark) {
        boolean flag = false;
        int count = activityRemarkMapper.saveRemark(remark);
        if (count == 1) {
            flag = true;
        }
        return flag;
    }

    @Override
    public List<Activity> getActivityListByClueId(String clueId) {
        return activityMapper.getActivityListByClueId(clueId);
    }

    @Override
    public List<Activity> getActivityListByNameAndAIds(String name, List<String> activityIds) {
        return activityMapper.getActivityListByNameAndAIds(name, activityIds, activityIds.size());
    }

    @Override
    public List<Activity> getActivityListByName(String name) {
        return activityMapper.getActivityListByName(name);
    }


}
