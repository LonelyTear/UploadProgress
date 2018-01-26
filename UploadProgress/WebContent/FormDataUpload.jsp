<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.9.1.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		$('#submitBtn').bind("click", function() {
			//每次上传都要初始化
			$("#processInfo").html("开始上传...");
			$("#proBar").css("width","1%");
			
			$("#uploadForm").submit();
			var rate = 0;
			var progressFunc = function() {
				$.ajax({
					type : 'GET',
					url : '${pageContext.request.contextPath}/getBar',
					data : {},
					dataType : 'json',
					success : function(data) {
						$("#processInfo").html("上传中" + data.pBytesRead + "/" + data.pContentLength + " byte ," + rate + "%");
						rate = Math.ceil( 100 * data.pBytesRead / data.pContentLength);
						if(data.pBytesRead != 0){//后台服务器设置的在未读数据前默认返回0
							if (data.pBytesRead % data.pContentLength == 0) {
								window.clearInterval(progressInterval);
								$("#processInfo").html("上传完成:" + data.pBytesRead + "/" + data.pContentLength + " byte , " + rate +"%");
								$("#file").val();
							}
							console.log(rate+"%");
							$("#proBar").css("width",rate+"%");
						}
					},
					error: function (data) {
						window.clearInterval(progressInterval);
				        alert("error: " + data.responseText);
				    }
				});
			};
			var progressInterval = window.setInterval(progressFunc, 80);
		});
	});
	
	
</script>
<title>文件上传</title>
</head>
<body>
	<form id="uploadForm" action="./upload" enctype="multipart/form-data" method="post" target="uploadFrame">
		<div>
			<hr/>
			<div>
				<input type="file" name="file" style="width: 550">
			</div>

			<label id="processInfo" style="background-color: #EEEEEE">上传详情</label>
			<div>
				<div id="proBar" style="width: 0%; background-color: green">&nbsp;</div>
			</div>
			<div>
				<button type="button" id="submitBtn">submit</button>
			</div>
		</div>
	</form>
	<div>
		<hr />
		<label>主要使用jquery-1.9.1.js,commons-fileupload-1.3.1.jar,commons-io-2.4.jar实现.</label>
		<hr />
		参考链接:
		<a href="http://blog.csdn.net/lian_zhihui1984/article/details/6822201" target="_blank">http://blog.csdn.net/lian_zhihui1984/article/details/6822201</a>
	</div>
	<iframe id="uploadFrame" name="uploadFrame" style="display: none"></iframe>
	<%-- <code class="hljs xml"><span class="hljs-tag"><span class="hljs-tag"><</span><span class="hljs-name"><span class="hljs-tag"><span class="hljs-name">script</span></span></span><span class="hljs-tag"> </span><span class="hljs-attr"><span class="hljs-tag"><span class="hljs-attr">src</span></span></span><span class="hljs-tag">=</span><span class="hljs-string"><span class="hljs-tag"><span class="hljs-string">"1.js?ver=1"</span></span></span><span class="hljs-tag">></span></span><span class="undefined"></span><span class="hljs-tag"><span class="undefined"></span><span class="hljs-tag"></</span><span class="hljs-name"><span class="hljs-tag"><span class="hljs-name">script</span></span></span><span class="hljs-tag">></span></span></code> --%>  
</body>
</html>
