<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.9.1.js"></script>
<!-- https://github.com/jquery-form/form -->
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.form.min.js"></script>

<script type="text/javascript">


	$(document).ready(function() {
		var options = {
			target : "#uploadFrame", // 用服务器返回的数据 更新 id为output1的内容.
			dataType:  "text",        // 期望的返回类型'text','xml', 'script', or 'json',以下为遇到bug
			//如果选了json而服务端返回了不标准的json,比如带了换行符,
			//如果选了xml,而服务端返回了不标准的xml,比如<name><name>没有用</name>封尾,有可能
			//将不会进入success指定的success方法体中
			beforeSubmit : beforSubmit, // 提交前执行的方法,不能这样写:beforSubmit()
			uploadProgress: uploadProgress,//上传进度检测
			success : success, // 提交后执行的方法,不能这样写:success()
			//url:       url         // 默认是form的action，如果写的话，会覆盖from的action
			//type:      type        // 默认是form的method，如果写的话，会覆盖from的method.('get' or 'post')
			//clearForm: true        // 成功提交后，清除所有的表单元素的值
			//resetForm : true		// 成功提交后，重置所有的表单元素的值
			timeout:   30000 		//超时时间,30秒
		};
		
		//$("#uploadForm").ajaxForm(options);//ajaxForm不会提交,只会在submit按钮点击时触发提交事件
		
		//ajaxSubmit方法同ajaxForm,最大差异在于它可以触发提交事件
		 $("#uploadForm").submit(function() {
			$(this).ajaxSubmit(options);
			return false; //来阻止浏览器提交.
		});

	});
	
	// 提交前
	function beforSubmit(formData, jqForm, options) { 
		//formdata是表单的数组对象,形如[ { name: 'username', value: 'jresig' }, { name: 'password', value: 'secret' } ]
		//在这里，我们使用$.param()方法把他转化为字符串

		var queryString = $.param(formData); //组装数据，插件会自动提交数据
		console.log(queryString); //类似 ： name=1&add=2
		
		//jqForm是整个<form>标签的jquery对象
		//console.log( jqForm.find("#desc").val() );
		console.log( jqForm.html() );
		
		var formElement = jqForm[0];//将jqForm转换为DOM对象
		var desc = formElement.desc.value; //访问jqForm的DOM元素
		console.log(desc);

		return true;//如果为false可以屏蔽提交事件
	}

	 function uploadProgress(event, position, total, percentComplete) {//上传的过程
         //position 已上传了多少
         //total 总大小
         //已上传的百分数
         var percentVal = percentComplete + '%';
         $("#proBar").width(percentVal);
         $("#proBar").html(percentVal);
         //console.log(percentVal, position, total);
     }
     
	//  提交后
	function success(responseText, statusText) {
		$("#ret").text('状态: ' + statusText + '\n 返回的内容是: \n' + responseText);
	}
	
	
</script>
<title>ajaxSubmitUpload上传下载</title>
</head>
<body>

	<a href="/poiDemo/DownloadExcel">下载excel样例</a>

	<form id="uploadForm" action="./upload" enctype="multipart/form-data" method="post" target="uploadFrame">
		<div>

			<hr />
			<div>
				<input id="desc" type="text" name="desc" style="width: 550" value="描述" /> <br/>
				<input type="file" name="file" style="width: 550">
			</div>

			<label id="processInfo" style="background-color: #EEEEEE">上传详情</label>
			<div>
				<div id="proBar" style="width: 0%; background-color: yellow">&nbsp;</div>
			</div>
			<div>
				<button type="submit" id="submitBtn">submit</button>
			</div>
			<div>
				<div>
					<br />
					<textarea id="ret" rows="10" cols="100"></textarea>
				</div>
			</div>
		</div>
	</form>
	<div>
		jquery form IE8无bug,全浏览器兼容<hr/>
		官网地址:<a href="http://jquery.malsup.com/form/#download" target="_BLANK">http://jquery.malsup.com/form/#download</a> <br/>
		但在研究过程中发现一个bug,只有压缩版的<a href="http://malsup.github.io/min/jquery.form.min.js">http://malsup.github.io/min/jquery.form.min.js</a>在IE8下才兼容.
		如果用<a href="http://malsup.github.io/jquery.form.js">http://malsup.github.io/jquery.form.js</a>有IE8下会报"无法获取未定义的 null"错<br/>
		重要参考:<a href="http://blog.csdn.net/qq_28602957/article/details/53612885">http://blog.csdn.net/qq_28602957/article/details/53612885</a> <br/>
		其它参考:<a href="http://blog.csdn.net/rinsmelody/article/details/71214535?utm_source=itdadao&utm_medium=referral" target="_BLANK">http://blog.csdn.net/rinsmelody/article/details/71214535?utm_source=itdadao&utm_medium=referral</a> <br/>
	</div>
	<iframe id="uploadFrame" name="uploadFrame" style="display: none"></iframe>
</body>
</html>