package cn.yechen.crm.workbench.mapper;

import cn.yechen.crm.workbench.domain.TranHistory;

import java.util.List;

public interface TranHistoryMapper {

    int save(TranHistory tranHistory);

    List<TranHistory> getTranHistoryListByTranId(String tranId);
}