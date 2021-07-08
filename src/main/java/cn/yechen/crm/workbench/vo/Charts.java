package cn.yechen.crm.workbench.vo;

/**
 * @author yechen
 * @create 2021-07-07 20:34
 */
public class Charts {
    private String value;
    private String name;

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public String toString() {
        return "Charts{" +
                "value='" + value + '\'' +
                ", name='" + name + '\'' +
                '}';
    }
}
