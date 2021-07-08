package cn.yechen.crm.workbench.mapper;


import cn.yechen.crm.workbench.domain.ActivityRemark;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ActivityRemarkMapper {

    int getCountByIds(String[] ids);

    int deleteByActivityIds(String[] ids);

    List<ActivityRemark> getRemarkListByAId(String activityId);

    int deleteRemarkById(String id);

    int updateRemark(ActivityRemark activityRemark);

    int saveRemark(ActivityRemark remark);

}