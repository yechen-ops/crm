package cn.yechen.crm.workbench.mapper;

import cn.yechen.crm.workbench.domain.Tran;
import cn.yechen.crm.workbench.vo.Charts;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface TranMapper {

    int getTotalCount();

    int save(Tran tran);

    List<Tran> getTranList(@Param("skipCount") int skipCount, @Param("pageSize") int pageSize);

    Tran getDetailById(String id);

    int updateStageByTranId(Tran editTran);

    List<Charts> getStageAndCount();

}