<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + 	request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
	<meta charset="UTF-8">

	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

	<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>

	<script type="text/javascript">
		$(function () {

			// 时间控件 time 类设置，显示在文本框上面
			$(".time_top").datetimepicker({
				language : "zh-CN",
				format : "yyyy-mm-dd",
				minView : "month",
				autoclose : true,
				todayBtn : true,
				pickerPosition : "top-left"
			});

			// 时间控件 time 类设置，显示在文本框下面
			$(".time_bottom").datetimepicker({
				language : "zh-CN",
				format : "yyyy-mm-dd",
				minView : "month",
				autoclose : true,
				todayBtn : true,
				pickerPosition : "bottom-left"
			});

			// 联系人名称选择绑定事件，打开查找联系人模态窗口，同时列出全部联系人
			$("#findContactsBtn").click(function () {
				// 清空查询条件
				$("#contactsFullName").val("");
				// 查询并展现符合条件的联系人
				showContactsListByFullName();
				// 打开模态窗口
				$("#findContacts").modal("show");
			})

			// 键盘监听事件，执行联系人列表查询
			$("#contactsFullName").keydown(function (event) {
				// 如果是回车键，查询并展现市场活动列表
				if (event.keyCode === 13) {
					// 查询并展现联系人列表
					showContactsListByFullName();
					// 由于当在模态窗口中有回车行为，会自动刷新页面，并清理数据，因此这里需要将该行为禁用
					return false;
				}
			})

			// 为提交按钮绑定事件，将联系人信息保存到页面
			$("#submitContactsBtn").click(function () {
				var $contacts = $("input[name=activity]:checked");
				var id = $contacts.val();
				var contactsFullName = $("#n"+id).html();
				// 将以上两项信息填写到创建的表单中
				$("#create-contactsFullName").val(contactsFullName);
				$("#create-contactsId").val(id);
				// 关闭模态窗口
				$("#findContacts").modal("hide");
			})

			// 为放大镜图标绑定事件，打开搜索市场活动的模态窗口
			$("#findMarketActivityBtn").click(function () {
				// 清空查询条件
				$("#activityName").val("");
				// 查询并展现市场活动列表
				showActivityListByName();
				// 打开打开搜索市场活动的模态窗口
				$("#findMarketActivity").modal("show");
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
				$("#create-activityName").val(name);
				$("#create-activityId").val(id);
				// 关闭模态窗口
				$("#findMarketActivity").modal("hide");
			})

			// 客户名称自动补全
			$("#create-customerName").typeahead({
				source: function (query, process) {
					$.get(
							"workbench/transaction/getCustomerName.do",
							{ "name" : query },
							function (data) {
								// data:[{客户名称1},{客户名称2},{客户名称3}...]
								//alert(data);
								process(data);
							},
							"json"
					);
				},
				delay: 500
			});

			// 当阶段选择发生改变时，通过一一对应关系，为可能性赋值
			$("#create-transactionStage").change(function () {
				// 获取阶段值
				var stage = $("#create-transactionStage").val();
				// 取出关系字符串转为 JSON
				var jsonObj = eval("("+$("#possibility").val()+")")
				// 给可能性赋值
				$("#create-possibility").val(jsonObj[stage]);
			})

			// 为保存按钮绑定事件，保存当前交易
			$("#submitTranBtn").click(function () {
				// 提交表单
				$("#tranFrom").submit();
			})
		});

		/**
		 * 查询并展现符合条件的联系人
		 */
		function showContactsListByFullName() {
			var fullName = $.trim($("#contactsFullName").val());
			$.ajax({
				url : "workbench/transaction/getContactsListByFullName.do",
				data : {
					"fullName" : fullName
				},
				type : "GET",
				dataType : "json",
				success : function (data) {
					var html = "";
					$.each(data, function (index, element) {
						html += '<tr onclick="select(\''+element.id+'\')">';
						html += '<td><input type="radio" name="activity" id="'+element.id+'" value="'+element.id+'"/></td>';
						html += '<td id="n'+element.id+'">'+element.fullName+'</td>';
						html += '<td>'+element.email+'</td>';
						html += '<td>'+element.mphone+'</td>';
						html += '</tr>';
					})
					$("#contactsList").html(html);
				}
			})
		}

		/**
		 * 通过市场活动名称模糊查询，并展现
		 */
		function showActivityListByName() {
			var name = $.trim($("#activityName").val());
			$.ajax({
				url : "workbench/transaction/getActivityListByName.do",
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

	<!-- 查找市场活动 -->	
	<div class="modal fade" id="findMarketActivity" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找市场活动</h4>
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
					<table id="activityTable3" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
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

	<!-- 查找联系人 -->	
	<div class="modal fade" id="findContacts" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找联系人</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" style="width: 300px;" id="contactsFullName" placeholder="请输入联系人姓名，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback" id="contactsFullName"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>姓名</td>
								<td>邮箱</td>
								<td>手机</td>
							</tr>
						</thead>
						<tbody id="contactsList">
							<%--<tr>
								<td><input type="radio" name="activity"/></td>
								<td>李四</td>
								<td>lisi@bjpowernode.com</td>
								<td>12345678901</td>
							</tr>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>李四</td>
								<td>lisi@bjpowernode.com</td>
								<td>12345678901</td>
							</tr>--%>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="submitContactsBtn">提交</button>
				</div>
			</div>
		</div>
	</div>

	<div style="position:  relative; left: 30px;">
		<h3>创建交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="submitTranBtn">保存</button>
			<button type="button" class="btn btn-default">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" action="workbench/transaction/saveTransaction.do" method="post" id="tranFrom" role="form" style="position: relative; top: -30px;">
		<div class="form-group">
			<label for="create-transactionOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionOwner" name="owner">
					<option>请选择</option>
					<c:forEach items="${userList}" var="u">
						<option value="${u.id}" ${user.id eq u.id ? "selected" : ""}>${u.name}</option>
					</c:forEach>
				</select>
			</div>
			<label for="create-amountOfMoney" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-amountOfMoney" name="money">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-transactionName" name="name">
			</div>
			<label for="create-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control time_bottom" id="create-expectedClosingDate" name="expectedDate">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-customerName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-customerName" placeholder="支持自动补全，输入客户不存在则新建" name="customerName">
			</div>
			<label for="create-transactionStage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="create-transactionStage" name="stage">
				  <option>请选择</option>
				  <c:forEach items="${stageList}" var="s">
					  <option value="${s.value}">${s.text}</option>
				  </c:forEach>
			  </select>
				<input type="hidden" id="possibility" value='${possibility}'>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionType" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionType" name="type">
					<option>请选择</option>
					<c:forEach items="${transactionTypeList}" var="t">
					<option value="${t.value}">${t.text}</option>
					</c:forEach>
				</select>
			</div>
			<label for="create-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-possibility" >
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-clueSource" name="source">
					<option>请选择</option>
					<c:forEach items="${sourceList}" var="s">
						<option value="${s.value}">${s.text}</option>
					</c:forEach>
				</select>
			</div>
			<label for="create-activityName" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="findMarketActivityBtn"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-activityName">
				<input type="hidden" id="create-activityId" name="activityId">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactsFullName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" id="findContactsBtn"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-contactsFullName">
				<input type="hidden" id="create-contactsId" name="contactsId">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-describe" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-describe" name="description"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-contactSummary" name="contactSummary"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control time_top" id="create-nextContactTime" name="nextContactTime">
			</div>
		</div>
		
	</form>
</body>
</html>