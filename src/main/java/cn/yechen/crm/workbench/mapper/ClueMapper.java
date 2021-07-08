package cn.yechen.crm.workbench.mapper;

import cn.yechen.crm.workbench.domain.Activity;
import cn.yechen.crm.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueMapper {
    int saveClue(Clue clue);

    int getTotalCountByConditions(Map<String, Object> map);

    List<Clue> getCluesByConditions(Map<String, Object> map);

    Clue getDetailById(String id);

    Clue getCLueById(String clueId);

    int deleteById(String clueId);

    Clue getClueById(String clueId);
}