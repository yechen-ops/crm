package cn.yechen.crm.workbench.vo;

import java.util.List;

/**
 * @author yechen
 * @create 2021-07-01 21:32
 */
public class PaginationVo<T> {
    private int totalCount;
    private List<T> dataList;

    public int getTotalCount() {
        return totalCount;
    }

    public void setTotalCount(int totalCount) {
        this.totalCount = totalCount;
    }

    public List<T> getDataList() {
        return dataList;
    }

    public void setDataList(List<T> dataList) {
        this.dataList = dataList;
    }
}
