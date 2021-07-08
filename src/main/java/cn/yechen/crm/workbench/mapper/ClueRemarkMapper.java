package cn.yechen.crm.workbench.mapper;

import cn.yechen.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkMapper {

    List<ClueRemark> getRemarkListByClueId(String clueId);

    int deleteByClueId(String clueId);

    int getNumByClueId(String clueId);
}