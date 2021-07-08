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

			// 为编辑按钮添加事件
			$("#editBtn").click(function () {
				$.ajax({
					url : "workbench/activity/getUserListAndActivity.do",
					data : {
						"id" : $("#edit-id").val()
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
						$("#edit-marketActivityName").val(data.activity.name);
						$("#edit-startTime").val(data.activity.startDate);
						$("#edit-endTime").val(data.activity.endDate);
						$("#edit-cost").val(data.activity.cost);
						$("#edit-describe").val(data.activity.description);

						// 打开模态窗口
						$("#editActivityModal").modal("show");
					}
				})
			})

			// 为更新按钮添加事件，更新市场活动
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
							// data:{"success":true/false,"activity":{...}}
							if (data.success) {

								var html = "市场活动-"+data.activity.name+"<small>"+data.activity.startDate+" ~ "+data.activity.endDate+"</small>";
								$("#activityTitle").html(html);
								$("#activityName").html(data.activity.name);
								$("#activityStartDate").html(data.activity.startDate);
								$("#activityEndDate").html(data.activity.endDate);
								$("#activityOwner").html(data.activity.owner);
								$("#activityCreateTime").html(data.activity.createTime);
								$("#activityCreateBy").html(data.activity.createBy);
								$("#activityEditTime").html(data.activity.editTime);
								$("#activityEditBy").html(data.activity.editBy);
								$("#activityCost").html(data.activity.cost);
								$("#activityDescription").html(data.activity.description);

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

			// 为删除按钮添加事件，删除市场活动
			$("#deleteBtn").click(function () {
				if (confirm("您确定要上删除这条数据吗？")) {
					$.ajax({
						url: "workbench/activity/deleteActivities.do",
						data: {
							"id" : $("#edit-id").val()
						},
						type: "POST",
						dataType: "json",
						success: function (data) {
							if (data.success) {
								alert("删除成功")
								location.href = "workbench/activity/index.jsp";
							} else {
								alert("删除失败");
							}
						}
					})
				}
			})

			// 展现备注
			showRemarkList();

			// 关于市场活动的修改和删除按钮的出现方式
			$("#remarkBody").on("mouseover", ".remarkDiv", function () {
				$(this).children("div").children("div").show();
			})
			$("#remarkBody").on("mouseout", ".remarkDiv", function () {
				$(this).children("div").children("div").hide();
			})

			// 为更新按钮绑定事件，执行备注的更新操作
			$("#updateRemarkBtn").click(function () {
				if (confirm("您确定要修改这条备注吗？")) {
					// 从隐藏域中获取备注 id
					let id = $.trim($("#remarkId").val());
					$.ajax({
						url: "workbench/activity/updateRemark.do",
						data: {
							"noteContent" : $.trim($("#noteContent").val()),
							"id" : id
						},
						type: "POST",
						dataType: "json",
						success: function (data) {
							// data:{"success":true/false,"remark":{"noteContent":?,"editTime":?,...}}
							if (data.success) {
								// 更新相应信息
								$("#e"+id).html(data.remark.noteContent);
								$("#s"+id).html(data.remark.editTime+" 由 "+data.remark.editBy);
								// 关闭模态窗口
								$("#editRemarkModal").modal("hide");
							} else {
								alert("备注信息修改失败");
							}
						}
					})
				}
			})

			// 为添加按钮绑定事件，执行备注添加的操作
			$("#savaRemarkBtn").click(function () {
				$.ajax({
					url: "workbench/activity/saveRemark.do",
					data: {
						"noteContent" : $.trim($("#remark").val()),
						"activityId" : "${activity.id}"
					},
					type: "POST",
					dataType: "json",
					success: function (data) {
						// data:{"success":true/false,"remark":{"noteContent":?,"editTime":?,...}}
						// 如果添加备注成功
						if (data.success) {
							// 在文本域上方追加一个 div，来展现备注信息
							let html = "";
							html += '<div id="'+data.remark.id+'" class="remarkDiv" style="height: 60px;">';
							html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
							html += '<div style="position: relative; top: -40px; left: 40px;" >';
							html += '<h5 id="e'+data.remark.id+'">'+data.remark.noteContent+'</h5>';
							html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>${activity.name}</b> <small style="color: gray;" id="s'+data.remark.id+'"> '+data.remark.createTime+' 由 '+data.remark.createBy+'</small>';
							html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
							html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\''+data.remark.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #C75450;"></span></a>';
							html += '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';
							html += '<a class="myHref" href="javascript:void(0);" onclick="removeRemark(\''+data.remark.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #C75450;"></span></a>';
							html += '</div>';
							html += '</div>';
							html += '</div>';

							$("#remarkDiv").before(html);
							// 清除文本
							$("#remark").val("");
						} else {
							alert("添加备注失败")
						}
					}
				})
			})

		});

		/**
		 * 展现备注信息列表的方法
		 * 在 进入市场活动详细页面、添加、修改、删除备注信息的时候调用
		 */
		function showRemarkList() {
			$.ajax({
				url: "workbench/activity/getRemarkListByAId.do",
				data: {
					"activityId" : "${activity.id}"
				},
				type: "GET",
				dataType: "json",
				success: function (data) {
					let html = "";
					$.each(data, function (index, element) {
						html += '<div id="'+element.id+'" class="remarkDiv" style="height: 60px;">';
						html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
						html += '<div style="position: relative; top: -40px; left: 40px;" >';
						html += '<h5 id="e'+element.id+'">'+element.noteContent+'</h5>';
						html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>${activity.name}</b> <small style="color: gray;" id="s'+element.id+'"> '+(element.editFlag==0?element.createTime:element.editTime)+' 由 '+(element.editFlag==0?element.createBy:element.editBy)+'</small>';
						html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
						html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\''+element.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #C75450;"></span></a>';
						html += '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';
						html += '<a class="myHref" href="javascript:void(0);" onclick="removeRemark(\''+element.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #C75450;"></span></a>';
						html += '</div>';
						html += '</div>';
						html += '</div>';
					})
					$("#remarkDiv").before(html);
				}
			})
		}

		/**
		 * 删除备注信息方法
		 * @param id 备注信息 id
		 */
		function removeRemark(id) {
			if (confirm("您确定要删除这条备注吗？")) {
				$.ajax({
					url: "workbench/activity/deleteRemarkById.do",
					data: {
						"id" : id
					},
					type: "POST",
					dataType: "json",
					success: function (data) {
						// 如果删除成功
						if (data.success) {
							// 更新备注列表
							// showRemarkList();
							$("#"+id).remove();
						} else {
							alert("删除备注失败！");
						}
					}
				})
			}
		}

		/**
		 * 打开修改市场活动备注的模态窗口
		 * @param id 备注的 id
		 */
		function editRemark(id) {
			// 获得备注信息
			var noteContent = $("#e"+id).html();
			$("#noteContent").val(noteContent);
			// 隐藏域保存备注 id
			$("#remarkId").val(id);
			// 打开修改备注的模态窗口
			$("#editRemarkModal").modal("show");
		}
	</script>

</head>
<body>
	
	<!-- 修改市场活动备注的模态窗口 -->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<%-- 备注的id --%>
		<input type="hidden" id="remarkId">
        <div class="modal-dialog" role="document" style="width: 40%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">修改备注</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal" role="form">
                        <div class="form-group">
                            <label for="edit-describe" class="col-sm-2 control-label">内容</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="noteContent"></textarea>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
                </div>
            </div>
        </div>
    </div>

	<%-- 隐藏域，保存市场活动 id --%>
	<input type="hidden" id="edit-id" value="${activity.id}">
    <!-- 修改市场活动的模态窗口 -->
    <div class="modal fade" id="editActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">修改市场活动</h4>
                </div>
                <div class="modal-body">

                    <form class="form-horizontal" role="form">

                        <div class="form-group">
                            <label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-marketActivityOwner">

                                </select>
                            </div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName" >
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control time" id="edit-startTime" >
                            </div>
                            <label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control time" id="edit-endTime" >
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-cost" >
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
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="updateBtn">更新</button>
                </div>
            </div>
        </div>
    </div>

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header" >
			<h3 id="activityTitle">市场活动-${activity.name}<small>${activity.startDate} ~ ${activity.endDate}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="activityOwner">${activity.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="activityName">${activity.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>

		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">开始日期</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="activityStartDate">${activity.startDate}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="activityEndDate">${activity.endDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">成本</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="activityCost">${activity.cost}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="activityCreateBy">${activity.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;" id="activityCreateTime">${activity.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="activityEditBy">${activity.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;" id="activityEditTime">${activity.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b id="activityDescription">
					${activity.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div id="remarkBody" style="position: relative; top: 30px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button id="savaRemarkBtn" type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	<div style="height: 200px;"></div>
</body>
</html>