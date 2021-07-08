<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + 	request.getServerPort() + request.getContextPath() + "/";

	/*String id = request.getParameter("id");
	String fullName = request.getParameter("fullName");
	String appellation = request.getParameter("appellation");
	String company = request.getParameter("company");
	String owner = request.getParameter("owner");*/
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
	<meta charset="UTF-8">

	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>


	<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

	<script type="text/javascript">
		$(function(){

			// 时间控件 time 类设置
			$(".time").datetimepicker({
				language : "zh-CN",
				format : "yyyy-mm-dd",
				minView : "month",
				autoclose : true,
				todayBtn : true,
				pickerPosition : "top-left"
			});

			$("#isCreateTransaction").click(function(){
				if(this.checked){
					$("#create-transaction2").show(200);
				}else{
					$("#create-transaction2").hide(200);
				}
			});

			// 为放大镜图标绑定事件，打开搜索市场活动的模态窗口
			$("#openSearchModalBtn").click(function () {
				// 清空查询条件
				$("#activityName").val("");
				// 获取焦点
				$("#activityName").focus();
				// 查询并展现市场活动列表
				showActivityListByName();
				// 打开打开搜索市场活动的模态窗口
				$("#searchActivityModal").modal("show");
			})

			// 键盘监听事件，执行市场活动查询
			$("#activityName").keydown(function (event) {
				// 如果是回车键，查询并展现市场活动列表
				if (event.keyCode === 13) {
					// 查询并展现市场活动列表
					showActivityListByName();
					// 由于当在模态窗口中有回车行为，会自动刷新页面，并清理数据，因此这里需要将该行为禁用
					return false;
				}
			})

			// 为提交市场活动按钮绑定事件，填充市场活动源
			$("#submitActivityBtn").click(function () {
				// 取得选中的市场活动的 id 和 name
				var $activity = $("input[name=activity]:checked");
				var id = $activity.val();
				var name = $("#n"+id).html();
				// 将以上两项信息填写到交易的表单中
				$("#activity").val(name);
				$("#activityId").val(id);
				// 关闭模态窗口
				$("#searchActivityModal").modal("hide");
			})

			// 为转换按钮绑定事件，执行线索的转换操作
			$("#convertBtn").click(function () {
				/*
					提交请求到后台，执行线索转换的操作，应该发出传统请求，
					请求结束后，最终响应会线索列表页上
					同时根据 “为客户创建交易” 的复选框有没有选中，来判断是否需要创建交易
				 */
				if ($("#isCreateTransaction").prop("checked")) {
					// 需要创建交易
					// 提交表单
					$("#tranForm").submit();
				} else {
					// 不需要创建交易
					window.location.href = "workbench/clue/convert.do?clueId=${param.id}"
				}

			})
		});

		/**
		 * 通过市场活动名称模糊查询，并展现
		 */
		function showActivityListByName() {
			var name = $.trim($("#activityName").val());
			$.ajax({
				url : "workbench/clue/getActivityListByName.do",
				data : {
					"name" : name,
				},
				type : "GET",
				dataType : "json",
				success : function (data) {
					// data:[{市场活动1},{市场活动2}...]
					var html = "";
					$.each(data, function (index, element) {
						html += '<tr onclick="select(\''+element.id+'\')">';
						html += '<td><input type="radio" name="activity" id="'+element.id+'" value="'+element.id+'"/></td>';
						html += '<td id="n'+element.id+'">'+element.name+'</td>';
						html += '<td>'+element.startDate+'</td>';
						html += '<td>'+element.endDate+'</td>';
						html += '<td>'+element.owner+'</td>';
						html += '</tr>';
					})
					$("#activityList").html(html);
				}
			})
		}

		/**
		 * 点击真个市场活动都能选中
		 * @param id tr标签的 id
		 */
		function select(id) {
			$("#"+id).prop("checked", true);
		}
	</script>

</head>
<body>
	
	<!-- 搜索市场活动的模态窗口 -->
	<div class="modal fade" id="searchActivityModal" role="dialog" >
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">搜索市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" style="width: 300px;" id="activityName" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="activityList">
							<%--<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>--%>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="submitActivityBtn">提交</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>

	<%--<div id="title" class="page-header" style="position: relative; left: 20px;">


	</div>--%>

	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>转换线索 <small>${param.fullName}${param.appellation}-${param.company}</small></h3>
		</div>
	</div>
	<div id="create-customer" style="position: relative; left: 40px; height: 35px;">
		新建客户：${param.company}
	</div>
	<div id="create-contact" style="position: relative; left: 40px; height: 35px;">
		新建联系人：${param.fullName}${param.appellation}
	</div>
	<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
		<input type="checkbox" id="isCreateTransaction"/>
		为客户创建交易
	</div>
	<div id="create-transaction2" style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;" >
	
		<form id="tranForm" action="workbench/clue/convert.do" method="post">
		  <div class="form-group" style="width: 400px; position: relative; left: 20px;">
		    <label for="amountOfMoney">金额</label>
		    <input type="text" class="form-control" id="amountOfMoney" name="money">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="tradeName">交易名称</label>
		    <input type="text" class="form-control" id="tradeName" placeholder="请填写交易名称" name="name">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="expectedClosingDate">预计成交日期</label>
		    <input type="text" class="form-control time" id="expectedClosingDate" name="expectedDate">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="stage">阶段</label>
		    <select id="stage"  class="form-control" name="stage">
				<option>请选择</option>
				<c:forEach items="${stageList}" var="a">
					<option value="${a.value}">${a.text}</option>
				</c:forEach>
		    </select>
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
			  <label for="activity">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="openSearchModalBtn" style="text-decoration: none;"><span class="glyphicon glyphicon-search"></span></a></label>
			  <input type="text" class="form-control" id="activity" placeholder="点击上面搜索" readonly>
			  <input type="hidden" id="activityId" name="activityId">
			  <input type="hidden" name="clueId" value="${param.id}">
			  <%-- 为后端提供的一个标志位，有值代表要创建交易 --%>
			  <input type="hidden" name="flag" value="true">
		  </div>
		</form>
		
	</div>
	
	<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
		记录的所有者：<br>
		<b>${param.owner}</b>
	</div>
	<div id="operation" style="position: relative; left: 40px; height: 35px; top: 100px;">
		<input class="btn btn-primary" type="button" value="转换" id="convertBtn">
		&nbsp;&nbsp;&nbsp;&nbsp;
		<input class="btn btn-default" type="button" value="取消">
	</div>
</body>
</html>