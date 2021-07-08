package cn.yechen.crm.settings.mapper;

import cn.yechen.crm.settings.domain.DicValue;

import java.util.List;

public interface DicValueMapper {

    List<DicValue> getListByTypeCode(String typeCode);
}