<%@ page import="cn.yechen.crm.settings.domain.DicValue" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Dictionary" %>
<%@ page import="cn.yechen.crm.workbench.domain.Tran" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + 	request.getServerPort() + request.getContextPath() + "/";

	// 准备阶段（stage）的字典值列表
	List<DicValue> dicValueList = (List<DicValue>) application.getAttribute("stageList");
	// 获取阶段和可能性的对应 map
	Map<String, String> possibilityMap = (Map<String, String>) application.getAttribute("possibilityMap");
	// 标志：正常阶段和丢失阶段的分界点下标
	int point = 0;
	// 准备编历 dicValueList，寻找分界点（第一个可能性为 0 的阶段的下标）
	for (int i = 0; i < dicValueList.size(); i++) {
		// 获取阶段对象
		DicValue dicValue = dicValueList.get(i);
		// 获取阶段值
		String stage = dicValue.getValue();
		// 寻找对应的可能性
		String possibility = possibilityMap.get(stage);
		if ("0".equals(possibility)) {
			point = i;
			break;
		}
	}
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
	<meta charset="UTF-8">

	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />

	<style type="text/css">
	.mystage{
		font-size: 20px;
		vertical-align: middle;
		cursor: pointer;
	}
	.closingDate{
		font-size : 15px;
		cursor: pointer;
		vertical-align: middle;
	}
	</style>

	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

	<script type="text/javascript">

		//默认情况下取消和保存按钮是隐藏的
		var cancelAndSaveBtnDefault = true;

		$(function(){
			$("#remark").focus(function(){
				if(cancelAndSaveBtnDefault){
					//设置remarkDiv的高度为130px
					$("#remarkDiv").css("height","130px");
					//显示
					$("#cancelAndSaveBtn").show("2000");
					cancelAndSaveBtnDefault = false;
				}
			});

			$("#cancelBtn").click(function(){
				//显示
				$("#cancelAndSaveBtn").hide();
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","90px");
				cancelAndSaveBtnDefault = true;
			});

			$(".remarkDiv").mouseover(function(){
				$(this).children("div").children("div").show();
			});

			$(".remarkDiv").mouseout(function(){
				$(this).children("div").children("div").hide();
			});

			$(".myHref").mouseover(function(){
				$(this).children("span").css("color","red");
			});

			$(".myHref").mouseout(function(){
				$(this).children("span").css("color","#E6E6E6");
			});


			//阶段提示框
			$(".mystage").popover({
				trigger:'manual',
				placement : 'bottom',
				html: 'true',
				animation: false
			}).on("mouseenter", function () {
						var _this = this;
						$(this).popover("show");
						$(this).siblings(".popover").on("mouseleave", function () {
							$(_this).popover('hide');
						});
					}).on("mouseleave", function () {
						var _this = this;
						setTimeout(function () {
							if (!$(".popover:hover").length) {
								$(_this).popover("hide")
							}
						}, 100);
					});

			// 展示交易历史列表
			showTranHistoryList();
		});

		/**
		 * 展示交易历史列表
		 */
		function showTranHistoryList() {
			var tranId = "${tran.id}";
			$.ajax({
				url : "workbench/transaction/getTranHistoryListByTranId.do",
				data : {
					"tranId" : tranId
				},
				type : "GET",
				dataType : "json",
				success : function (data) {
					// data:[{历史1}，{历史2}...]
					var html = "";
					$.each(data, function (index, element) {
						html += '<tr>';
						html += '<td>'+element.stage+'</td>';
						html += '<td>'+element.money+'</td>';
						html += '<td>'+element.possibility+'</td>';
						html += '<td>'+element.expectedDate+'</td>';
						html += '<td>'+element.createTime+'</td>';
						html += '<td>'+element.createBy+'</td>';
						html += '</tr>';
					})
					$("#tranHistoryList").html(html);
				}
			})
		}

		/**
		 * 更改交易阶段
		 * @param stage 当前选中的交易阶段
		 * @param i 当前交易阶段的下标
		 */
		function changeStage(stage, i) {
			if (confirm("您确定要更改当前交易阶段吗，该操作会改变当前交易的阶段并增加一条交易历史")) {
				$.ajax({
					url : "workbench/transaction/changeStage.do",
					data : {
						"tranId" : "${tran.id}",
						"stage" : stage,
						"money" : ${tran.money},// 生成交易历史用
						"expectedDate":"${tran.expectedDate}"	// 生成交易历史用
					},
					type : "POST",
					dataType : "json",
					success : function (data) {
						// data:{"success":true/false,"tran":{"stage":?,"money":?,...}}
						if (data.success) {
							// 改变成功，局部刷新当前交易页面数据
							$("#stage").html(data.tran.stage);
							$("#possibility").html(data.tran.possibility);
							$("#editBy").html(data.tran.editBy+"&nbsp;&nbsp;");
							$("#editTime").html(data.tran.editTime);
							// 改变阶段成功后，刷新阶段显示图标
							changeIcon(stage, i);
							// 刷新交易历史列表
							showTranHistoryList();
						} else {
							alert("阶段改变失败！");
						}
					}
				})
			}
		}

		/**
		 * 更改显示图标
		 * @param stage
		 * @param i
		 */
		function changeIcon(stage, i) {
			// 当前阶段
			var currentStage = stage;
			// 当前可能性
			var currentPossibility = $("#possibility").html();
			// 当前阶段的下标
			var index = i;
			// alert("index="+index);
			// 前面正常阶段和后面丢失阶段分界点的下标
			var divideIndex = "<%=point%>";
			// 如果当前阶段的可能性为 0
			if (currentPossibility === "0") {
				// 分界点下标之前
				for (var i = 0; i < divideIndex; i++) {
					// ===黑圈===
					// 移除样式
					$("#"+i).removeClass();
					// 赋上新样式
					$("#"+i).addClass("glyphicon glyphicon-record mystage");
					//为新样式赋予颜色
					$("#"+i).css("color","#000000");
				}
				// 分界点之后的当前===红叉===，其他===黑叉===
				for (var i = divideIndex; i < "<%=dicValueList.size()%>"; i++) {
					if (index == i) {
						// ===红叉===
						// 移除样式
						$("#"+i).removeClass();
						// 赋上新样式
						$("#"+i).addClass("glyphicon glyphicon-remove mystage");
						//为新样式赋予颜色
						$("#"+i).css("color","#FF0000");
					} else {
						// ===黑叉===
						// 移除样式
						$("#"+i).removeClass();
						// 赋上新样式
						$("#"+i).addClass("glyphicon glyphicon-remove mystage");
						//为新样式赋予颜色
						$("#"+i).css("color","#000000");
					}
				}
			} else {
				// 分界点之前
				for (var i = 0; i < divideIndex; i++) {
					if (i < index) {
						// ===绿勾===
						// 移除样式
						$("#"+i).removeClass();
						// 赋上新样式
						$("#"+i).addClass("glyphicon glyphicon-ok-circle mystage");
						//为新样式赋予颜色
						$("#"+i).css("color","#90F790");
					} else if (i == index) {
						// ===绿色定位===
						// 移除样式
						$("#"+i).removeClass();
						// 赋上新样式
						$("#"+i).addClass("glyphicon glyphicon-map-marker mystage");
						//为新样式赋予颜色
						$("#"+i).css("color","#90F790");
					} else if (i > index) {
						// ===黑圈===
						$("#"+i).removeClass();
						// 赋上新样式
						$("#"+i).addClass("glyphicon glyphicon-record mystage");
						//为新样式赋予颜色
						$("#"+i).css("color","#000000");
					}
				}
				// 分界点之后
				for (var i = divideIndex; i < "<%=dicValueList.size()%>"; i++) {
					// ===黑叉===
					// 移除样式
					$("#"+i).removeClass();
					// 赋上新样式
					$("#"+i).addClass("glyphicon glyphicon-remove mystage");
					//为新样式赋予颜色
					$("#"+i).css("color","#000000");
				}
			}
		}
	</script>

</head>
<body>
	
	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${tran.customerId}-${tran.name} <small>￥${tran.money}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" onclick="window.location.href='edit.jsp';"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>

	<!-- 阶段状态 -->
	<div style="position: relative; left: 40px; top: -50px;">
		阶段&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<%
			// 获取当前交易的阶段和可能性
			Tran tran = (Tran) request.getAttribute("tran");
			String currentStage = tran.getStage();
			String currentPossibility = possibilityMap.get(currentStage);
			// 判断当前阶段的可能性来
			if ("0".equals(currentPossibility)) {
				// 当前交易的可能性为 0，编历所有阶段，判断后确定显示内容，此时需要显示的有 红叉、黑叉、黑圈
				for (int i = 0; i < dicValueList.size(); i++) {
					DicValue dicValue = dicValueList.get(i);
					String stage = dicValue.getValue();
					String possibility = possibilityMap.get(stage);
					// 判断编历出来的阶段可能性是否为 0
					if ("0".equals(possibility)) {
						// 可能性为 0
						// 判断是否是当前阶段
						if (stage.equals(currentStage)) {
							// 是当前阶段，显示===红叉===
		%>
							<span id="<%=i%>" onclick="changeStage('<%=stage%>','<%=i%>')"
								  class="glyphicon glyphicon-remove mystage"
								  data-toggle="popover" data-placement="bottom"
								  data-content="<%=dicValue.getText()%>" style="color: #FF0000;"></span>
							----------
		<%
						} else {
							// 不是当前阶段，显示===黑叉===
		%>
							<span id="<%=i%>" onclick="changeStage('<%=stage%>','<%=i%>')"
								  class="glyphicon glyphicon-remove mystage"
								  data-toggle="popover" data-placement="bottom"
								  data-content="<%=dicValue.getText()%>" style="color: #000000;"></span>
							----------
		<%
						}
					} else {
						// 可能性不为 0，全部显示===黑圈===
		%>
						<span id="<%=i%>" onclick="changeStage('<%=stage%>','<%=i%>')"
							  class="glyphicon glyphicon-record mystage"
							  data-toggle="popover" data-placement="bottom"
							  data-content="<%=dicValue.getText()%>" style="color: #000000;"></span>
						----------
		<%
					}
				}
			} else {
				// 获取当前阶段的下标 index
				int index = 0;
				for (int i = 0; i < dicValueList.size(); i++) {
					DicValue dicValue = dicValueList.get(i);
					String stage = dicValue.getValue();
					if (stage.equals(currentStage)) {
						index = i;
						break;
					}
				}
				// 当前交易的可能性不为 0，编历所有阶段，判断后确定显示内容，此时需要显示的有 绿勾、定位、黑圈、黑叉
				for (int i = 0; i < dicValueList.size(); i++) {
					DicValue dicValue = dicValueList.get(i);
					String stage = dicValue.getValue();
					String possibility = possibilityMap.get(stage);
					// 判断编历出来的阶段可能性是否为 0
					if ("0".equals(possibility)) {
						// 可能性为 0，显示===黑叉===
		%>
						<span id="<%=i%>" onclick="changeStage('<%=stage%>','<%=i%>')"
							  class="glyphicon glyphicon-remove mystage"
							  data-toggle="popover" data-placement="bottom"
							  data-content="<%=dicValue.getText()%>" style="color: #000000;"></span>
						----------
		<%
					} else {
						if (i < index) {
							// 显示===绿勾===
		%>
							<span id="<%=i%>" onclick="changeStage('<%=stage%>','<%=i%>')"
								  class="glyphicon glyphicon-ok-circle mystage"
								  data-toggle="popover" data-placement="bottom"
								  data-content="<%=dicValue.getText()%>" style="color: #90F790;"></span>
							----------
		<%
						} else if (i == index) {
							// 显示===定位===
		%>
							<span id="<%=i%>" onclick="changeStage('<%=stage%>','<%=i%>')"
								  class="glyphicon glyphicon-map-marker mystage"
								  data-toggle="popover" data-placement="bottom"
								  data-content="<%=dicValue.getText()%>" style="color: #90F790;"></span>
							----------
		<%
						} else if (i > index) {
							// 显示===黑圈===
		%>
							<span id="<%=i%>" onclick="changeStage('<%=stage%>','<%=i%>')"
								  class="glyphicon glyphicon-record mystage"
								  data-toggle="popover" data-placement="bottom"
								  data-content="<%=dicValue.getText()%>" style="color: #000000;"></span>
							----------
		<%
						}
					}
				}
			}
		%>
		<%--<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="资质审查" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="需求分析" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="价值建议" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="确定决策者" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-map-marker mystage" data-toggle="popover" data-placement="bottom" data-content="提案/报价" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="谈判/复审"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="成交"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="丢失的线索"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="因竞争丢失关闭"></span>
		-------------%>
		<span class="closingDate">${tran.expectedDate}</span>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: 0px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">金额</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${tran.money}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.name}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">预计成交日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${tran.expectedDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">客户名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.customerId}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">阶段</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="stage">${tran.stage}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">类型</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.type}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">可能性</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="possibility">${possibility}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">来源</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.source}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">市场活动源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${tran.activityId}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">联系人名称</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${tran.contactsId}</b></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${tran.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${tran.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="editBy">${tran.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;" id="editTime">${tran.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${tran.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					&nbsp;${tran.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 100px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>&nbsp;${tran.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div style="position: relative; top: 100px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		
		<!-- 备注1 -->
		<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>哎呦！</h5>
				<font color="gray">交易</font> <font color="gray">-</font> <b>动力节点-交易01</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>
		
		<!-- 备注2 -->
		<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>呵呵！</h5>
				<font color="gray">交易</font> <font color="gray">-</font> <b>动力节点-交易01</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>
		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 阶段历史 -->
	<div>
		<div style="position: relative; top: 100px; left: 40px;">
			<div class="page-header">
				<h4>阶段历史</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>阶段</td>
							<td>金额</td>
							<td>可能性</td>
							<td>预计成交日期</td>
							<td>创建时间</td>
							<td>创建人</td>
						</tr>
					</thead>
					<tbody id="tranHistoryList">
						<%--<tr>
							<td>资质审查</td>
							<td>5,000</td>
							<td>10</td>
							<td>2017-02-07</td>
							<td>2016-10-10 10:10:10</td>
							<td>zhangsan</td>
						</tr>
						<tr>
							<td>需求分析</td>
							<td>5,000</td>
							<td>20</td>
							<td>2017-02-07</td>
							<td>2016-10-20 10:10:10</td>
							<td>zhangsan</td>
						</tr>
						<tr>
							<td>谈判/复审</td>
							<td>5,000</td>
							<td>90</td>
							<td>2017-02-07</td>
							<td>2017-02-09 10:10:10</td>
							<td>zhangsan</td>
						</tr>--%>
					</tbody>
				</table>
			</div>
			
		</div>
	</div>
	
	<div style="height: 200px;"></div>
	
</body>
</html>