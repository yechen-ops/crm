package cn.yechen.crm.workbench.mapper;

import cn.yechen.crm.workbench.domain.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationMapper {
    int deleteRelationById(String relationId);

    List<String> getAIdsByClueId(String clueId);

    int saveRelation(ClueActivityRelation relation);

    int deleteRelationByClueId(String clueId);

    int getNumByClueId(String clueId);
}