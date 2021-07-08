<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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

			pageList(1, 2);

			// 时间控件 time 类设置
			$(".time").datetimepicker({
				language : "zh-CN",
				format : "yyyy-mm-dd",
				minView : "month",
				autoclose : true,
				todayBtn : true,
				pickerPosition : "top-left"
			});

			// 为创建按钮添加事件，打开创建线索的模态窗口
			$("#addBtn").click(function () {
				$.ajax({
					url : "workbench/clue/getUserList.do",
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
						$("#clueAddForm")[0].reset();
						// 清空提示信息
						$("#addMsg").html("");
						// 所有者下拉框赋值
						$("#create-clueOwner").html(html);
						// 打开模态窗口
						$("#createClueModal").modal("show");
					}
				})
			})

			// 为保存按钮绑定事件，执行线索的创建操作
			$("#saveBtn").click(function () {
				$.ajax({
					url: "workbench/clue/saveClue.do",
					data: {
						"fullName" : $.trim($("#create-fullName").val()),
						"appellation" : $.trim($("#create-appellation").val()),
						"owner" : $.trim($("#create-clueOwner").val()),
						"company" : $.trim($("#create-company").val()),
						"job" : $.trim($("#create-job").val()),
						"email" : $.trim($("#create-email").val()),
						"phone" : $.trim($("#create-phone").val()),
						"website" : $.trim($("#create-website").val()),
						"mphone" : $.trim($("#create-mphone").val()),
						"state" : $.trim($("#create-state").val()),
						"source" : $.trim($("#create-source").val()),
						"description" : $.trim($("#create-description").val()),
						"contactSummary" : $.trim($("#create-contactSummary").val()),
						"nextContactTime" : $.trim($("#create-nextContactTime").val()),
						"address" : $.trim($("#create-address").val())
					},
					type: "POST",
					dataType: "json",
					success: function (data) {
						if (data.success) {
							// 刷新列表
							pageList(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
							// 关闭模态窗口
							$("#createClueModal").modal("hide");
						} else {
							alert("线索添加失败")
						}
					}
				})
			})

			// 为查询按钮绑定事假，执行线索的查询并展现
			$("#searchBtn").click(function () {

				// 将隐藏域中的值保存到查询框中
				$("#hidden-fullName").val($("#search-fullName").val());
				$("#hidden-company").val($("#search-company").val());
				$("#hidden-phone").val($("#search-phone").val());
				$("#hidden-source").val($("#search-source").val());
				$("#hidden-owner").val($("#search-owner").val());
				$("#hidden-mphone").val($("#search-mphone").val());
				$("#hidden-state").val($("#search-state").val());

				// 分页查询
				pageList(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
			})

			// 为全选复选框添加事件，按下后将市场活动全选
			$("#selectAll").click(function () {
				$("input[name='selectOne']").prop("checked", this.checked);
			})

			// 为每条记录添加事件
			$("#clueList").on("click", $("input[name='selectOne']"), function () {
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

			// 为修改按钮绑定事件
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
					$.ajax({
						url : "workbench/clue/getUserListAndClue.do",
						data : {
							"id" : $selectOne.val()
						},
						type : "GET",
						dataType : "json",
						success : function (data) {
							// data:{"userList":{{用户1},{用户2}...},"clue":线索}
							// 拼接所有者列表
							var html = "<option>请选择用户</option>";
							$.each(data.userList,function (index, element) {
								html += "<option value='"+element.id+"'>"+element.name+"</option>";
							})

							// 给所有者赋值
							$("#edit-clueOwner").html(html);
							$("#edit-clueOwner").val(data.clue.owner);

							// 给线索信息赋值
							$("#edit-company").val(data.clue.company);
							$("#edit-appellation").val(data.clue.appellation);
							$("#edit-fullName").val(data.clue.fullName);
							$("#edit-job").val(data.clue.job);
							$("#edit-email").val(data.clue.email);
							$("#edit-phone").val(data.clue.phone);
							$("#edit-website").val(data.clue.website);
							$("#edit-mphone").val(data.clue.mphone);
							$("#edit-state").val(data.clue.state);
							$("#edit-source").val(data.clue.source);
							$("#edit-description").html(data.clue.description);
							$("#edit-contactSummary").html(data.clue.contactSummary);
							$("#edit-nextContactTime").val(data.clue.nextContactTime);
							$("#edit-address").html(data.clue.address);

							// 打开模态窗口
							$("#editClueModal").modal("show");
						}
					})
				}
			})

		});

		/**
		 * 分页查询
		 * @param pageNo
		 * @param pageSize
		 */
		function pageList(pageNo, pageSize) {

			// 每次进行分页查询前，取消所有复选框的选择
			$("#selectAll").prop("checked", false);

			// 将隐藏域中的值保存到查询框中
			$("#search-fullName").val($("#hidden-fullName").val());
			$("#search-company").val($("#hidden-company").val());
			$("#search-phone").val($("#hidden-phone").val());
			$("#search-source").val($("#hidden-source").val());
			$("#search-owner").val($("#hidden-owner").val());
			$("#search-mphone").val($("#hidden-mphone").val());
			$("#search-state").val($("#hidden-state").val());

			$.ajax({
				url : "workbench/clue/pageList.do",
				data : {
					"pageNo" : pageNo,
					"pageSize" : pageSize,
					"fullName" : $.trim($("#search-fullName").val()),
					"company" : $.trim($("#search-company").val()),
					"phone" : $.trim($("#search-phone").val()),
					"source" : $.trim($("#search-source").val()),
					"owner" : $.trim($("#search-clueOwner").val()),
					"mphone" : $.trim($("#search-mphone").val()),
					"state" : $.trim($("#search-state").val())
				},
				type : "GET",
				dataType : "json",
				success : function (data) {
					// data ：{"totalCount":符合查询条件的信息个数, "dataList":[{线索1},{线索2},...]}
					var html = "";
					$.each(data.dataList, function (index, element) {
						if (index % 2 === 0) {
							html += '<tr>';
							html += '<td><input type="checkbox" value="'+element.id+'" name="selectOne"/></td>';
							html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/clue/detail.do?id='+element.id+'\';">'+element.fullName+element.appellation+'</a></td>';
							html += '<td>'+element.company+'</td>';
							html += '<td>'+element.phone+'</td>';
							html += '<td>'+element.mphone+'</td>';
							html += '<td>'+element.source+'</td>';
							html += '<td>'+element.owner+'</td>';
							html += '<td>'+element.state+'</td>';
							html += '</tr>';
						} else {
							html += '<tr class="active">';
							html += '<td><input type="checkbox" value="'+element.id+'" name="selectOne"/></td>';
							html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/clue/detail.do?id='+element.id+'\';">'+element.fullName+element.appellation+'</a></td>';
							html += '<td>'+element.company+'</td>';
							html += '<td>'+element.phone+'</td>';
							html += '<td>'+element.mphone+'</td>';
							html += '<td>'+element.source+'</td>';
							html += '<td>'+element.owner+'</td>';
							html += '<td>'+element.state+'</td>';
							html += '</tr>';
						}
					})
					$("#clueList").html(html);

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
</head>
<body>

	<%-- 隐藏域，保存在查询按钮按下后文本框中的内容 --%>
	<input type="hidden" id="hidden-fullName">
	<input type="hidden" id="hidden-company">
	<input type="hidden" id="hidden-phone">
	<input type="hidden" id="hidden-source">
	<input type="hidden" id="hidden-owner">
	<input type="hidden" id="hidden-mphone">
	<input type="hidden" id="hidden-state">

	<!-- 创建线索的模态窗口 -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="clueAddForm">
					
						<div class="form-group">
							<label for="create-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-clueOwner">

								</select>
							</div>
							<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation">
								  <option>请选择</option>
								  <c:forEach items="${appellationList}" var="a">
									  <option value="${a.value}">${a.text}</option>
								  </c:forEach>
								</select>
							</div>
							<label for="create-fullName" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullName">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
							<label for="create-state" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-state">
								  	<option>请选择</option>
									<c:forEach items="${clueStateList}" var="c">
										<option value="${c.value}">${c.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
									<option>请选择</option>
									<c:forEach items="${sourceList}" var="s">
										<option value="${s.value}">${s.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						

						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">线索描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time" id="create-nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
						
						<div style="position: relative;top: 20px;">
							<div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
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
	
	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-clueOwner">
								 <%-- <option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>--%>
								</select>
							</div>
							<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company" value="动力节点">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-appellation">
									<option>请选择</option>
									<c:forEach items="${appellationList}" var="a">
										<option value="${a.value}">${a.text}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-fullName" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-fullName" value="李四">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" value="CTO">
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" value="010-84846003">
							</div>
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website" value="http://www.bjpowernode.com">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" value="12345678901">
							</div>
							<label for="edit-state" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-state">
									<option>请选择</option>
									<c:forEach items="${clueStateList}" var="c">
										<option value="${c.value}">${c.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
									<option>请选择</option>
									<c:forEach items="${sourceList}" var="s">
										<option value="${s.value}">${s.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description">这是一条线索的描述信息</textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary">这个线索即将被转换</textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time" id="edit-nextContactTime" value="2017-05-01">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address">北京大兴区大族企业湾</textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateBtn">更新</button>
				</div>
			</div>
		</div>
	</div>

	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>线索列表</h3>
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
						<input class="form-control" type="text" id="search-fullName">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司</div>
				      <input class="form-control" type="text" id="search-company">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input class="form-control" type="text" id="search-phone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索来源</div>
					  <select class="form-control" id="search_source">
						  <option>请选择</option>
						  <c:forEach items="${sourceList}" var="s">
							  <option value="${s.value}">${s.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search_owner">
				    </div>
				  </div>
				  
				  
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">手机</div>
				      <input class="form-control" type="text" id="search_mphone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索状态</div>
					  <select class="form-control" id="search_state">
						  <option>请选择</option>
						  <c:forEach items="${clueStateList}" var="c">
							  <option value="${c.value}">${c.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>

				  <button type="button" class="btn btn-default" id="searchBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="selectAll"/></td>
							<td>名称</td>
							<td>公司</td>
							<td>公司座机</td>
							<td>手机</td>
							<td>线索来源</td>
							<td>所有者</td>
							<td>线索状态</td>
						</tr>
					</thead>
					<tbody id="clueList">

					</tbody>
				</table>
			</div>
			
			<div style="height: 70px; position: relative;top: 60px;" id="activityPage">

			</div>
			
		</div>
		
	</div>
</body>
</html>