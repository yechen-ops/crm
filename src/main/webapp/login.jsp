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
		$(function () {

			if (window.top !== window) {
				window.top.location = window.location;
			}

			/*
				页面加载完成之后
				1. 将用户文本框中的内容清空
				2. 让用户的文本框自动获取焦点
			 */
			$("#loginAct").val("");
			$("#loginPwd").val("");
			$("#loginAct").focus();

			/*
			 	登录操作（两种方式）
			 	1. 点击登录按钮
			 	2. 按回车键
			 */
			$("#loginBtn").click(function () {
				login();
			})
			$(window).keydown(function (event) {
				// 码值为 13，表示敲的是回车键
				if (event.keyCode === 13) {
					login();
				}
			})

		})

		/**
		 * 验证登录方法
		 */
		function login() {
			// 取得账号密码
			var loginAct = $.trim($("#loginAct").val());
			var loginPwd = $.trim($("#loginPwd").val());
			// 判空
			if (loginAct === "" || loginPwd === "") {
				$("#msg").html("账号密码不能为空~");
				// 之后强制停止该方法，不再继续访问后台
				return false;
			}

			// 后台验证登录
			$.ajax({
				url : "setting/user/login.do",
				data : {
					"loginAct" : loginAct,
					"loginPwd" : loginPwd
				},
				type : "POST",
				dataType : "json",
				success : function (data) {
					/*
						data:{"success":true/false,","msg":XXX}
					 */
					if (data.success) {
						// 登录成功，跳转到工作台
						window.location.href = "workbench/index.jsp";
					} else {
						// 显示登录错误信息
						$("#msg").html(data.msg);
					}
				}
			})
		}
	</script>
	<title></title>
</head>
<body>
	<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
		<img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
	</div>
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;2021&nbsp;叶尘</span></div>
	</div>
	
	<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
		<div style="position: absolute; top: 0px; right: 60px;">
			<div class="page-header">
				<h1>登录</h1>
			</div>
			<form action="workbench/index.jsp" class="form-horizontal" role="form">
				<div class="form-group form-group-lg">
					<div style="width: 350px;">
						<input class="form-control" type="text" placeholder="用户名" id="loginAct">
					</div>
					<div style="width: 350px; position: relative;top: 20px;">
						<input class="form-control" type="password" placeholder="密码" id="loginPwd">
					</div>
					<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">
						
							<span id="msg" style="color: red"></span>
						
					</div>
					<button type="button" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;" id="loginBtn">登录</button>
				</div>
			</form>
		</div>
	</div>
</body>
</html>