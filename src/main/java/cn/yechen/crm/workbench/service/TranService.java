package cn.yechen.crm.workbench.service;

import cn.yechen.crm.workbench.domain.Tran;
import cn.yechen.crm.workbench.domain.TranHistory;
import cn.yechen.crm.workbench.exception.TranSaveException;
import cn.yechen.crm.workbench.vo.Charts;
import cn.yechen.crm.workbench.vo.PaginationVo;

import java.util.List;
import java.util.Map;

/**
 * @author yechen
 * @create 2021-07-06 10:43
 */
public interface TranService {
    boolean saveTransaction(Tran tran, String customerName) throws TranSaveException;

    PaginationVo<Tran> pageList(int skipCount, int pageSize);

    Tran getDetailById(String id);

    List<TranHistory> getTranHistoryListByTranId(String tranId);

    boolean changeStage(Tran tran);

    List<Charts> getCharts();

}
