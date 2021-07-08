<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + 	request.getServerPort() + request.getContextPath() + "/";
%>
<html>
<head>
    <base href="<%=basePath%>">
    <title>Title</title>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/echarts@5.1.2/dist/echarts.min.js"></script>
    <script type="text/javascript">

        $(function () {
            // 基于准备好的dom，初始化echarts实例
            var myChart1 = echarts.init(document.getElementById('main1'));
            var myChart2 = echarts.init(document.getElementById('main2'));

            $.ajax({
                url : "workbench/transaction/getCharts.do",
                type : "GET",
                dataType : "json",
                success : function (data) {
                    // date:[{"value":?,"name":?},{...}]
                    // 指定图表的配置项和数据
                    var option1 = {
                        title: {
                            text: '交易阶段统计饼状图',
                            subtext: '根据正式数据'
                        },
                        legend: {
                            top: 'bottom'
                        },
                        toolbox: {
                            show: true,
                            feature: {
                                mark: {show: true},
                                dataView: {show: true, readOnly: false},
                                restore: {show: true},
                                saveAsImage: {show: true}
                            }
                        },
                        series: [
                            {
                                name: '面积模式',
                                type: 'pie',
                                radius: [50, 250],
                                center: ['50%', '50%'],
                                roseType: 'area',
                                itemStyle: {
                                    borderRadius: 8
                                },
                                data: data/*[
                                    {value: 40, name: 'rose 1'},
                                    {value: 38, name: 'rose 2'},
                                    {value: 32, name: 'rose 3'},
                                    {value: 30, name: 'rose 4'},
                                    {value: 28, name: 'rose 5'},
                                    {value: 26, name: 'rose 6'},
                                    {value: 22, name: 'rose 7'},
                                    {value: 18, name: 'rose 8'}
                                ]*/
                            }
                        ]
                    };

                    var name = [];
                    var value = [];
                    for (let i = 0; i < data.length; i++) {
                        name.push(data[i].name);
                        value.push(data[i].value);
                    }

                    var option2 = {
                        xAxis: {
                            type: 'category',
                            data:  name/*['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']*/
                        },
                        yAxis: {
                            type: 'value'
                        },
                        series: [{
                            data: value/*[120, 200, 150, 80, 70, 110, 130]*/,
                            type: 'bar',
                            showBackground: true,
                            backgroundStyle: {
                                color: 'rgba(180, 180, 180, 0.2)'
                            }
                        }]
                    };

                    // 使用刚指定的配置项和数据显示图表。
                    myChart1.setOption(option1);
                    myChart2.setOption(option2);
                }
            })


        })
    </script>
    <style type="text/css">
        *{margin: 0; padding: 0;}
        .con{width: 1500px;height: 700px;margin: 0 auto;}
        .con div{width: 50%; height: 100%}
        .l{float: left}
        .r{float: right}
    </style>
</head>
<body>

    <!-- 为 ECharts 准备一个具备大小（宽高）的 DOM -->
    <div class="con">
        <div class="l" id="main1"></div>
        <div class="r" id="main2"></div>
    </div>

</body>
</html>