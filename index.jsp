<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page isELIgnored="false"%>
<%
	String basePath = request.getScheme() + "://" + request.getServerName() 
	+ ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html >
<html lang="zh-CN">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<base href="<%=basePath%>">
<title>listAll page</title>

<link rel="stylesheet" href="css/bootstrap.min.css" />
<link rel="stylesheet" href="css/pagination.css" />

<script src="js/jquery-3.3.1.min.js"></script>
<script src="js/bootstrap.min.js"></script> 
<script src="js/jquery.pagination.js"></script> 

<style type="text/css">
	table{
		width:100%;
		margin:0 auto;
		border-collapse:collapse;
		color:#424242;
		cellspacing:10px;
		cellpadding:12px;}
	thead,td{
		border:2px solid #ccc;
		padding:10px;
		text-align:left;}

	.right{
		position:absolute;
		right:0;
		width:15%;
		margin-left:2%;
		margin-top:1%;
		/* height:100px; 
		background-color:pink;*/
		opacity:1;}
	
	.left{
		/* height:50px; */
		margin-right:15%;
		margin-left:2%;
		margin-top:1%; 
		/*background-color:pink;
		 transparent:50% */}
		 
	.nav{
		list-style:none;
		margin:0;
		font-size:16px;
		/*width:200px;
		height:200px;
		background-color:#999;
		border:1px solid #f40;*/}
	.nav .list-item{
		/* float:left; */
		margin:10px 5px;
		height:40px;
		line-height:30px;
		/* border:1px solid black; */}
	
	a{
		text-decoration:none;}
	
	.nav .list-item a{
		padding:0 10px;
		color:#f40;
		font-weight:bold;
		height:30px;
		display:inline-block;
		border-radius:15px;}
		
	.nav .list-item a:hover{
		color:#fff;
		background-color:#f40;}	 
</style>

<script type="text/javascript">

	$(function(){
		//0显示所有元素至body; 
		listAll("#tBody");
		
		$("#saveBtn").click(function(){
			//alert(1111);
			$("#myForm").submit();
		})
		
		//input标签方式链接转 发；
		$("#addBtn").click(function(){
			
			window.location.href="${pageContext.request.contextPath}/jsp/student/add.jsp";
		})
		
		//a标签方式链接转发；
		$("#clickStud").click(function(){
			
			window.location.href="${pageContext.request.contextPath}/jsp/student/add.jsp";
		})
		
		$("#doLogout").click(function(){
			//0访问LogoutServlet注销当前登录的用户
			//1接收来自 return "r:"+request.getParameter("goToUrl")+"?username="+username;
		var username="${param.username}";
			if(confirm("确认要离开吗？"))
			window.location.href="${pageContext.request.contextPath}/user/login.do?method=logoutUser";
		})
		
		//1多条删除操作
		$("#delItems").click(function(){
			
			// 2判断是否至少选择一项 
			var checkedNum = $("input[name='mycc']:checked").length; 
			//var checkedNum = $(":checkbox[name='mycc']:checked").size(); --?
			if(checkedNum == 0) { 
				alert("您一项都没有选哦."); 
				return; 
			}
			if(confirm("确定要删除所选项目？")){
				var arr = new Array();
				$("input[name='mycc']:checked").each(function(i){
					
					arr.push($(this).val());
				});
				
				//console.log(arr);
				//alert("arr:"+arr)
				//将checkbox选中的项通过ajax方式提交并获得反应；
				$.ajax({
					type:"post",
					url:"student.do?method=deleteMultiStuds&username=${username}",
					//1将获得的序号数组传递到后台；
					data:{"delItems":arr.toString()},
					dataType:"text",
					success:function(data){
						//alert(data);
						//$("input[name='mycc']:checked").attr("checked",false);
						window.location.reload();
					},
					error:function(){
						alert("PL check service.");
					}
				})
			}
			else{
				//1确定误操作后，将选中的恢复，并重刷下页面！
				$("input[name='mycc']:checked").attr("checked",false);
				window.location.reload();
			}
		})
		
		//2全部导出excel
		$("#exportAllBtn").click(function(){
			if(confirm("导出全部吗？")){
				var username="${param.username}";
				window.location.href=
					"${pageContext.request.contextPath}/student.do?method=exportAll&username="+username;
				this.disabled=true;
			}
			
		})
		
		//3部分导出excel
		$("#exportCheckedBtn").click(function(){
			
			if($("input[name='mycc']:checked").length==0){
				alert("请选中至少一条吧.");
			}else{
				
				if(confirm("确定导出吗？")){
					var username="${param.username}";
					var sendData="";
					$.each($("input[name='mycc']:checked"),function(i,n){
						
						sendData+="&id="+n.value;
					});
					//1要第一个串上的&去掉;
					sendData = sendData.substr(1);
					//alert(sendData);
					window.location.href=
						"${pageContext.request.contextPath}/student.do?method=exportChecked&username="+username+"&"+sendData;
				}
			}
			
		})
		
		//0上传文件；
		$("#formUpLoadFileBtn").click(function(){
			
			upLoadFile();
			this.disabled=true;
			this.value="刷新再传";
		})
		
		//0向前分页功能
		$("#pagePreId").click(function(){
			
			alert("Previous");
			//window.location.href="${pageContext.request.contextPath}/jsp/student/add.jsp";
		})
		
		//0向后分页功能
		$("#pageNextId").click(function(){
			
			alert("Next");
			//window.location.href="${pageContext.request.contextPath}/jsp/student/add.jsp";
		})
		
		$("#pageAllId").click(function(){
			
			listAll("#tBody");
		
		})
	})
	//确认函数；
	function foo(){
		if(confirm("不可逆转的行为！确定真的要删除吗？")){
			return true;
		}
		return false;
	}
	//显示所有元素信息函数；
	function listAll(bodyId){
		
		$(bodyId).html("");
		//1接收来自 return "r:"+request.getParameter("goToUrl")+"?username="+username;
		var username="${param.username}";
		$("#usernameId").html(username+"_sso");
		$.ajax({
			url:"student.do?method=listAll&username="+username,//2请求路径；
			//data:"random="+Math.random(),	//3参数 
			data:{"p":Math.random()}, //json格式传参给servlet;
			type:"post",	//4请求方式：post/get
			async:true,	//ajax模式;默认异步；
			dataType:"json", 	//5返回值的类型：text:普通文本：json:json文本
			success:function(data){ 	//6回调函数 data:返回值；		
				//$("#msg").html(data.s2.id+data.s2.name+data.s2.age);
				//json取值方式：
				//alert(data);
				var i=1;
 				$(data.sList).each(function(){
					//1每一个json用this来表示；
					$(bodyId).append("<tr><td style='text-align:center;'><input  type='checkbox' style='zoom:150%;' name='mycc' value='"+this.id+"'/></td><td>"
							+(i++)+"</td><td>"+this.id
							+"</td><td>"+this.name
							+"</td><td>"+this.age
							+"</td><td><a href='jsp/student/edit.jsp?username=${username}&id="+this.id
							+"'>修改</a>||<a onclick='return foo();' href='student.do?method=deleteStud&username=${username}&id="+this.id
							+"'>删除</a></td></tr>");
				}) 
				
			},
			error:function(){
				alert("PL check service.");
			}
		})
	}
	
	//1上传文件函数；
	function upLoadFile(){
		var username="${param.username}";
		var formData = new FormData(document.getElementById("formOfUpLoadFile"));
		//alert(formData);
		$.ajax({	
			type:"POST",
			url:"${pageContext.request.contextPath}/student.do?method=upLoadFile&username="+username,
			data:formData,
		    contentType: false,  
	        processData: false,  
			dataType:"text",
			success:function(data){
				//alert(data);
				$("#msgOfuploadfile").html(data);
				//window.location.reload();
			},
			error:function(){
				alert("PL check service.");
			}
		})
	}
</script>

</head>
<body >
	
	<h2 align="center" style="color:green;">学生信息管理系统</h2>

	<div class="right">

	<span > <input type="button" class="btn btn-success" value="点击我离去" id="doLogout" ></span>
	</div>
	<div class="left">
	<h3>欢迎你：<font style="color:#999;"><span id="usernameId"></span></font>
	
	<input type="text" name="title"> <button type="button" onclick="javascript:load(0)" id="search">搜索</button>
	
	</h3>
	</div>

	
<div class="right" style="right:2%;width:88%;">
	<table >
		<tr >
			<td style="text-align:left;">
			<!--  <button id="addBtn">添加学员</button>&nbsp;&nbsp;
			 Button trigger modal -->
			<button type="button" class="btn btn-primary btn-lg" style="width:6%;height:2%;font-size:80%" data-toggle="modal" data-target="#myModal">
			 添加学员
			</button>
			<div style="margin-left:40%; display:inline;">
			  
			<form id="formOfUpLoadFile" style="display:inline; " action="" method="post" enctype="multipart/form-data" >
				<input style="display:inline;" type="file" name="file" value="选择文件" /><span id="msgOfuploadfile"></span>
				<input id="formUpLoadFileBtn" style="display:inline;width:6%;height:2%;font-size:80%" class="btn btn-primary btn-lg" type="button" value="AJAX提交" /> 
			</form>
			
			
			<button type="button" id="exportCheckedBtn" style="width:6%;height:2%;font-size:80%" class="btn btn-primary btn-lg" data-toggle="modal" data-target="" >
			 导出选中
			</button>
			<button type="button" id="exportAllBtn" style="width:6%;height:2%;font-size:80%" class="btn btn-primary btn-lg" data-toggle="modal" data-target="" >
			 导出全部
			</button>
			<button type="button" id="delItems" style="width:6%;height:2%;font-size:80%" class="btn btn-danger btn-lg" data-toggle="modal" data-target="" >
			 多条删除
			</button>
			
			</div>
			</td>
		</tr>
	</table >
	<table class="table table-hover" style="font-size:18px;">
		<thead>
		<tr>
			<!--  <td><input type="checkbox" id="qx" /></td>-->
			<td>海选</td>
			<td>序号</td>
			<td>编号</td>
			<td>姓名</td>
			<td>年龄</td>
			<td>操作</td>
		</tr>
		</thead>
		<tbody id="tBody"></tbody>
	</table>

	<nav aria-label="Page navigation">
	  <ul class="pager">
	    <li><a id="pagePreId" href="javascript:void(0)">Previous</a></li>
	    <li><a id="pageNextId" href="javascript:void(0)">Next</a></li>
	    <li><a id="pageAllId" href="javascript:void(0)">&nbsp;&nbsp;&nbsp;All&nbsp;&nbsp;&nbsp;  </a></li>
	  </ul>
	</nav>	

</div>

<div class="left" style="margin-right:88%;margin-left:2%;">
	<ul class="nav" >
		<li class="list-item"><a id="clickStud" href="javascript:void(0)" >学生信息添加</a></li>
		<li class="list-item"><a id="clickMaterial" href="javascript:void(0)">材料信息添加</a></li>
		<li class="list-item"><a id="clickCourse" href="javascript:void(0)">课程信息添加</a></li>
		<li class="list-item"><a id="clickPart" href="javascript:void(0)">零件信息添加</a></li>
		<li class="list-item"><a id="clickProduct" href="javascript:void(0)">产品信息添加</a></li>
		<li class="list-item"><a id="clickCustom" href="javascript:void(0)">客户信息添加</a></li>
	</ul>	
</div>

<!-- Modal -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">添加学生信息</h4>
      </div>
      
      <div class="modal-body">

		<form action="student.do?method=addStud" method="post" id="myForm">
			
			<p>请输入姓名：<input type="text" name="name" id="nameId" /><span id="msg"></span></p>
			<p>请输入年龄：<input type="text" name="age" class="onlyNum" /></p>
			
			<!--<p><button type="submit" id="submitBtn">提交表单</button></p>
				<p><input type="submit" id="submitBtn" value="提交表单"> </p>-->
		</form>

	 </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
        <button type="button" id="saveBtn" class="btn btn-primary">保存</button>
      </div>
    </div>
  </div>
</div>

</body>
</html>
