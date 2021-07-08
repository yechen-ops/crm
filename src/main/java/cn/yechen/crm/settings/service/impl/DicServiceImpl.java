package cn.yechen.crm.settings.service.impl;

import cn.yechen.crm.settings.domain.DicType;
import cn.yechen.crm.settings.domain.DicValue;
import cn.yechen.crm.settings.mapper.DicTypeMapper;
import cn.yechen.crm.settings.mapper.DicValueMapper;
import cn.yechen.crm.settings.service.DicService;
import cn.yechen.crm.utils.SqlSessionUtil;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author yechen
 * @create 2021-07-03 12:45
 */
public class DicServiceImpl implements DicService {
    private DicTypeMapper dicTypeMapper = SqlSessionUtil.getSqlSession().getMapper(DicTypeMapper.class);
    private DicValueMapper dicValueMapper = SqlSessionUtil.getSqlSession().getMapper(DicValueMapper.class);

    @Override
    public Map<String, List<DicValue>> getDicValueMap() {
        List<DicType> dicTypeList = dicTypeMapper.getDicType();
        /*
        map："appellationList",dvList1
             "clueList",dvList2
             "stageList",dvList3
             ...
         */
        Map<String, List<DicValue>> map = new HashMap<>();
        for (DicType dicType : dicTypeList) {
            String typeCode = dicType.getCode();
            List<DicValue> dicValueList = dicValueMapper.getListByTypeCode(typeCode);
            map.put(typeCode+"List", dicValueList);
        }
        return map;
    }
}
