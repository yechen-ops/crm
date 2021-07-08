<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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

	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

	<script type="text/javascript">

		$(function(){

			// 展示市场活动，默认展现第一页，每页两条数据
			pageList(1, 2);

			// 为创建按钮绑定事件，打开添加操作的模态窗口
			$("#addBtn").click(function () {
				// 取得用户名称，为模态窗口中的所有者赋值
				$.ajax({
					url : "workbench/activity/getUserList.do",
					type : "GET",
					dataType : "json",
					success : function (data) {
						var html = "<option>请选择所有者</option>";
						$.each(data, function (i, n) {
							if (n.name === "${user.getName()}") {
								html += "<option value='"+n.id+"' selected='selected'>"+n.name+"</option>"
							} else {
								html += "<option value='"+n.id+"'>"+n.name+"</option>"
							}
						})
						// 清空添加操作模态窗口中的数据
						$("#activityAddForm")[0].reset();
						// 清空提示信息
						$("#addMsg").html("");
						// 所有者下拉框赋值
						$("#create-marketActivityOwner").html(html);
						// 打开模态窗口
						$("#createActivityModal").modal("show");
					}
				})
			});

			// 时间控件 time 类设置
			$(".time").datetimepicker({
				language : "zh-CN",
				format : "yyyy-mm-dd",
				minView : "month",
				autoclose : true,
				todayBtn : true,
				pickerPosition : "bottom-left"
			});

			// 为保存按钮绑定事件，执行添加操作
			$("#saveBtn").click(function () {

				let owner = $.trim($("#create-marketActivityOwner").val());
				let name = $.trim($("#create-marketActivityName").val());
				let startDate = $.trim($("#create-startTime").val());
				let endDate = $.trim($("#create-endTime").val());
				let cost = $.trim($("#create-cost").val());
				let description = $.trim($("#create-describe").val());

				if (name === "" || startDate === "" || endDate === "" || cost === "") {
					$("#addMsg").html("请将活动信息输入完整");
					return false;
				} else {
					$.ajax({
						url: "workbench/activity/saveActivity.do",
						data: {
							"owner" : owner,
							"name" : name,
							"startDate" : startDate,
							"endDate" : endDate,
							"cost" : cost,
							"description" : description
						},
						type: "POST",
						dataType: "json",
						success: function (data) {
							// 如果添加成功
							if (data.success) {
								// 1. 刷新市场活动信息列表（局部刷新）
								pageList(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));

								// 2. 清空添加操作模态窗口中的数据
								/*
                                     注意：对于 form 表单的 jquery 对象，不存在 reset() 方法
                                           应该将 jquery 对象转换为 dom 对象，使用原生 js 进行数据清空
                                */
								// $("#activityAddForm")[0].reset();

								// 3. 关闭模态窗口
								$("#createActivityModal").modal("hide");
							} else {
								// 1. 提示添加失败
								alert("添加市场活动失败");
								// 2. 关闭模态窗口
								$("#createActivityModal").modal("hide");
							}
						}
					})
				}
			})

			// 为查询按钮添加事件，调用 pageList 方法
			$("#searchBtn").click(function () {
				// 将查询信息保存到隐藏域中
				$("#hidden-name").val($.trim($("#search-name").val()));
				$("#hidden-owner").val($.trim($("#search-owner").val()));
				$("#hidden-startDate").val($.trim($("#search-startDate").val()));
				$("#hidden-endDate").val($.trim($("#search-endDate").val()));
				// 分页查询
				pageList(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
			})

			// 为全选复选框添加事件，按下后将市场活动全选
			$("#selectAll").click(function () {
				$("input[name='selectOne']").prop("checked", this.checked);
			})

			/*
				为每条记录添加事件
                因为动态生成的元素，是不能够以普通绑定事件的形式来进行操作的
                动态生成的元素，我们要以 on 方法的形式来触发事件
                语法：
                    $(需要绑定元素的有效的外层元素).on(绑定事件的方式,需要绑定的元素的jquery对象,回调函数)
             */
			$("#activityList").on("click", $("input[name='selectOne']"), function () {
				// 判断 复选框数量 和 复选框已选中的数量
				var allNum = $("input[name='selectOne']").length;
				var checkedNum = $("input[name='selectOne']:checked").length;
				var flag = false;
				if (allNum === checkedNum) {
					flag = true;
				}
				// 为全选复选框赋值
				$("#selectAll").prop("checked", flag);
			})

			// 为删除按钮添加事件
			$("#deleteBtn").click(function () {
				// 找到复选框中所有选中的复选框的 jquery 对象
				var $selectOne = $("input[name='selectOne']:checked");
				// 判断选中的复选框
				if ($selectOne.length === 0) {
					// 没选中
					alert("请选择需要删除的记录");
				} else {
					// 选中了一条及以上的记录，先来一个提醒
					if (confirm("您确定要上删除这"+$selectOne.length+"条数据吗？")) {
						// 拼接参数
						var param = "";
						// 编历 jquery 对象
						$.each($selectOne, function (index, element) {
							param += "id=" + element.value;
							// 不是最后一个，都要在后面加一个 &
							if (index !== $selectOne.length - 1) {
								param += "&";
							}
						})

						$.ajax({
							url : "workbench/activity/deleteActivities.do",
							data : param,
							type : "POST",
							dataType : "json",
							success : function (data) {
								if (data.success) {
									// 删除成功
									// alert("您选择的"+$selectOne.length+"条数据删除成功");
									// 刷新列表
									pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
								} else {
									alert("您选择的"+$selectOne.length+"条数据删除失败");
								}
							}
						})
					}
				}

			})

			// 为修改按钮添加事件，打开修改操作的模态窗口
			$("#editBtn").click(function () {
				// 找到复选框中所有选中的复选框的 jquery 对象
				var $selectOne = $("input[name='selectOne']:checked");
				// 判断选中的复选框
				if ($selectOne.length === 0) {
					// 没选中
					alert("请选择需要修改的记录");
				} else if ($selectOne.length > 1) {
					// 选多了
					alert("只能选择一条记录进行修改")
				}else {
					// 选中了一条记录
					// 获取当前用户列表
					$.ajax({
						url : "workbench/activity/getUserListAndActivity.do",
						data : {
							"id" : $selectOne.val()
						},
						type : "GET",
						dataType : "json",
						success : function (data) {
							// data:{"userList":{{用户1},{用户2}...},"activity":市场活动}
							// 拼接所有者列表
							var html = "<option>请选择用户</option>";
							$.each(data.userList,function (index, element) {
								if (data.activity.owner === element.name) {
									html += "<option value='"+element.id+"' selected='selected'>"+element.name+"</option>";
								} else {
									html += "<option value='"+element.id+"'>"+element.name+"</option>";
								}
							})

							// 清空提示信息
							$("#editMsg").html("");

							// 给所有者赋值
							$("#edit-marketActivityOwner").html(html);
							// $("#edit-marketActivityOwner").val(data.activity.owner);

							// 给活动信息赋值
							$("#edit-id").val(data.activity.id);
							$("#edit-marketActivityName").val(data.activity.name);
							$("#edit-startTime").val(data.activity.startDate);
							$("#edit-endTime").val(data.activity.endDate);
							$("#edit-cost").val(data.activity.cost);
							$("#edit-describe").val(data.activity.description);

							// 打开模态窗口
							$("#editActivityModal").modal("show");
						}
					})
				}
			})

			// 为更新按钮添加事件，进行市场活动的修改操作
			$("#updateBtn").click(function () {
				if (confirm("您确定要修改这条市场活动吗？")) {
					var id = $("#edit-id").val();
					var owner = $.trim($("#edit-marketActivityOwner").val());
					var name = $.trim($("#edit-marketActivityName").val());
					var startDate = $.trim($("#edit-startTime").val());
					var endDate = $.trim($("#edit-endTime").val());
					var cost = $.trim($("#edit-cost").val());
					var description = $.trim($("#edit-describe").val());

					$.ajax({
						url : "workbench/activity/updateActivity.do",
						data : {
							"id" : id,
							"owner" : owner,
							"name" : name,
							"startDate" : startDate,
							"endDate" : endDate,
							"cost" : cost,
							"description" : description
						},
						type : "POST",
						dataType : "json",
						success : function (data) {
							if (data.success) {
								pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
										,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
								// 关闭修改模态窗口
								$("#editActivityModal").modal("hide");
							} else {
								alert("市场活动更新失败");
								// 关闭修改模态窗口
								$("#editActivityModal").modal("hide");
							}
						}
					})

				}
			})
		});

		/**
		 * 方法发出 ajax 请求到后台，根据 pageNo 和 pageSize 取出相应的信息列表数据通过相应回来的数据，局部刷新市场活动信息列表
		 * @param pageNo 表示当前页码（第几页）
		 * @param pageSize 表示每页展现的记录个数
		 * 调用时机：
		 * 1、点击左侧菜单中的 “市场活动” 时
		 * 2、添加按钮
		 * 3、修改按钮
		 * 4、删除按钮
		 * 5、点击查询按钮的时候
		 * 6、点击分页组件的时候
		 */
		function pageList(pageNo, pageSize) {

			// 每次进行分页查询前，取消所有复选框的选择
			$("#selectAll").prop("checked", false);

			// 将隐藏域中的值保存到查询框中
			$("#search-name").val($("#hidden-name").val());
			$("#search-owner").val($("#hidden-owner").val());
			$("#search-startDate").val($("#hidden-startDate").val());
			$("#search-endDate").val($("#hidden-endData").val());

			$.ajax({
				url : "workbench/activity/pageList.do",
				data : {
					"pageNo" : pageNo,
					"pageSize" : pageSize,
					"name" : $.trim($("#search-name").val()),
					"owner" : $.trim($("#search-owner").val()),
					"startDate" : $.trim($("#search-startDate").val()),
					"endDate" : $.trim($("#search-endDate").val()),
				},
				type : "GET",
				dataType : "json",
				success : function (data) {
					/*
						data 中应该包含：
                        1、符合条件的市场活动信息列表
                        2、符合条件的市场活动信息的个数，这是分页插件所需要的
                       	 data ：{"totalCount":符合查询条件的信息个数, "dataList":[{市场活动1},{市场活动2},...]}
					 */
					var html = "";
					$.each(data.dataList, function (i, n) {
						if(i % 2 === 0) {
							html += '<tr>';
							html += '<td><input type="checkbox" value="'+n.id+'" name="selectOne"/></td>';
							html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/getDetail.do?id='+n.id+'\';">'+n.name+'</a></td>';
							html += '<td>'+n.owner+'</td>';
							html += '<td>'+n.startDate+'</td>';
							html += '<td>'+n.endDate+'</td>';
							html += '</tr>';
						} else {
							html += '<tr class="active">';
							html += '<td><input type="checkbox" value="'+n.id+'" name="selectOne"/></td>';
							html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/getDetail.do?id='+n.id+'\';">'+n.name+'</a></td>';
							html += '<td>'+n.owner+'</td>';
							html += '<td>'+n.startDate+'</td>';
							html += '<td>'+n.endDate+'</td>';
							html += '</tr>';
						}
					})
					$("#activityList").html(html);

					// 数据刷刷新后，进行分页
					var totalRows = data.totalCount;
					var totalPages = totalRows%pageSize===0 ? (totalRows/pageSize) : parseInt(totalRows/pageSize) + 1;
					$("#activityPage").bs_pagination({
						currentPage: pageNo, // 页码
						rowsPerPage: pageSize, // 每页显示的记录条数
						maxRowsPerPage: 20, // 每页最多显示的记录条数
						totalPages: totalPages, // 总页数
						totalRows: totalRows, // 总记录条数

						visiblePageLinks: 3, // 显示几个卡片

						showGoToPage: true,
						showRowsPerPage: true,
						showRowsInfo: true,
						showRowsDefaultInfo: true,

						onChangePage : function(event, data){
							pageList(data.currentPage , data.rowsPerPage);
						}
					});
				}
			})
		}

	</script>
	<title></title>
</head>
<body>

	<%-- 隐藏域，保存在查询按钮按下后文本框中的内容 --%>
	<input type="hidden" id="hidden-name">
	<input type="hidden" id="hidden-owner">
	<input type="hidden" id="hidden-startDate">
	<input type="hidden" id="hidden-endDate">

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form" id="activityAddForm">
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-marketActivityOwner">
								  <%--<option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>--%>
								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-marketActivityName">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-startTime" >
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-endTime" >
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<span id="addMsg" style="color: red"></span>
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
				</div>
			</div>
		</div>
	</div>

	<%-- 隐藏域，保存市场活动 id --%>
	<input type="hidden" id="edit-id">
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form" id="activityEditForm">
					
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-marketActivityOwner">

								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-startTime">
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-endTime">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost" value="5,000">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<span id="editMsg" style="color: red"></span>
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateBtn">更新</button>
				</div>
			</div>
		</div>
	</div>

	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>

	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control time" type="text" id="search-startDate" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control time" type="text" id="search-endDate" >
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="searchBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="selectAll"/></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="activityList">

					</tbody>
				</table>
			</div>
			
			<div style="height: 70px; position: relative;top: 30px;" id="activityPage">

			</div>
			
		</div>
		
	</div>
</body>
</html>