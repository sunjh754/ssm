<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--引入c:foreach核心库--%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core"  prefix="c"%>
<html>
<head>
    <title>员工列表页面</title>
    <% pageContext.setAttribute("APP_PATH",request.getContextPath());%>
    <%----web路径：不以 / 开始的相对路径，找资源，以当前资源的路径为基准，经常容易出问题
    ----         以 / 开始的相对路径，找资源，以服务器的路径为标准（http://localhoast:3306):需要加上项目名
    --%>
    <%--引入jquery--%>
    <script type="text/javascript" src="${APP_PATH}/static/js/jquery-3.6.0.js"></script>
    <%--引入bootstarp--%>
    <link href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.css" rel="stylesheet">
    <script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.js"></script>

    <style>
        .container{
           margin-top: 150px;
            margin-left: 50px;
            box-shadow: 10px 10px 5px #888888;
            height: 350px;
        }

        input{
            margin-top: 20px;
        }

        #code_input {
            margin-left: 20px;
            height: 32px;
            width: 100px;
            margin-top: 5px;
            border-radius: 5px;
            border: 2px solid #DCDCDC;

        }
        .btn{
            margin-top: 15px;
        }
        img{

            margin-left: 55px;
            width: 100px;
            height: 32px;
            margin-bottom: 10px;
        }
        a{
            margin-left: 170px;
        }

    </style>
</head>
<body>

<div class="container col-md-3  col-md-push-4" >
    <form class="form-sign">
        <h2 class="form-signin-heading" style="text-align: center">系统登陆</h2>
        <label for="inputName" class="sr-only">用户名</label>
        <input type="text" id="inputName" class="form-control" placeholder="请输入用户名" required autofocus>
        <label for="inputPassword" class="sr-only">密码</label>
        <input type="password" id="inputPassword" class="form-control" placeholder="请输入密码" required style="margin-bottom: 10px">
        <h6 style="font-size: medium">验证码：</h6>
        <div class="form-group has-feedback" id="checkcode_div" style="margin-top: 10px">
        <input type="text" class="form-control col-xs-4" id="code_input" aria-describedby="inputSuccess4Status">
        <span class="glyphicon  form-control-feedback" aria-hidden="true"></span>
        <span id="inputSuccess4Status" class="sr-only">(success)</span>
    </div>
<%--            <input type="text" id="code_input" class="form-control col-xs-4 sr-only" >--%>
            <img id="verificationCode" src="${APP_PATH}/vercode" alt="">
            <a id="changeCode" href="javascript:void(0)">看不清楚，换一张</a>
        <button class="btn btn-lg btn-primary btn-block" type="submit">确 定</button>
    </form>
</div>
<script type="text/javascript">
    $("#verificationCode").click(function () {
    // 在事件响应的 function 函数中有一个 this 对象。这个 this 对象，是当前正在响应事件的 dom 对象
    // src 属性表示验证码 img 标签的 图片路径。它可读，可写
        //alert(this.src);
        this.src = "${APP_PATH}/vercode?time=" + new Date();
    });
    $("#code_input").blur(function(){
        $("#checkcode_div").removeClass("has-success has-error");
        $("#code_input").next("span").removeClass("glyphicon-ok glyphicon-remove")
        var inputCode=this.value;
        //alert(this.value);
        $.ajax(({
            url:"${APP_PATH}/checkcode",
            data:{
                inputCode: inputCode,
            },
            type:"GET",
            xhrFields:{
                withCredentials: true
            },
            success: function(result){
                console.log(result)
                if(result.code==100){
                    $("#checkcode_div").addClass("has-success");
                    $("#code_input").next("span").addClass("glyphicon-ok")
                }else{
                    $("#checkcode_div").addClass("has-error")
                    $("#code_input").next("span").addClass("glyphicon-remove");
                    //验证错误更换图片
                    $("#verificationCode").attr("src","${APP_PATH}/vercode?time=" + new Date());
                }
            }
        }))
    })
    $("#changeCode").click(function () {
        $("#verificationCode").attr("src","${APP_PATH}/vercode?time=" + new Date());
    })

</script>

</body>
</html>