package cn.yechen.crm.workbench.service;

import cn.yechen.crm.workbench.domain.Clue;
import cn.yechen.crm.workbench.domain.Tran;
import cn.yechen.crm.workbench.exception.ConvertException;
import cn.yechen.crm.workbench.vo.PaginationVo;

import java.util.List;
import java.util.Map;

/**
 * @author yechen
 * @create 2021-07-03 12:36
 */
public interface ClueService {
    boolean saveClue(Clue clue);

    PaginationVo<Clue> pageList(Map<String, Object> map);

    Clue getDetailById(String id);

    boolean deleteRelationById(String relationId);

    List<String> getAIdsByClueId(String clueId);

    boolean saveRelation(String clueId, String[] activityIds);

    boolean convert(String clueId, Tran tran, String createBy) throws ConvertException;

    Clue getClueById(String clueId);

}
