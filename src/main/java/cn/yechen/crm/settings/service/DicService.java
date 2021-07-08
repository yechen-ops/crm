package cn.yechen.crm.settings.service;

import cn.yechen.crm.settings.domain.DicValue;

import java.util.List;
import java.util.Map;

/**
 * @author yechen
 * @create 2021-07-03 12:45
 */
public interface DicService {
    Map<String, List<DicValue>> getDicValueMap();

}
