<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--引入c:foreach核心库--%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core"  prefix="c"%>
<html>
<head>
  <title>员工列表页面</title>
  <%
    pageContext.setAttribute("APP_PATH",request.getContextPath());
  %>
  <%--
  ----web路径：不以 / 开始的相对路径，找资源，以当前资源的路径为基准，经常容易出问题
  ----         以 / 开始的相对路径，找资源，以服务器的路径为标准（http://localhoast:3306):需要加上项目名
  --%>
  <%--引入jquery--%>
  <script type="text/javascript" src="${APP_PATH}/static/js/jquery-3.6.0.js"></script>
  <%--引入bootstarp--%>
  <link href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.css" rel="stylesheet">
  <script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.js"></script>

</head>

<body>

<%--员工修改模态框--%>
<!-- 模态框（Modal） -->
<div class="modal fade" id="empUpdateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" >员工修改</h4>
      </div>
      <div class="modal-body">
        <form class="form-horizontal">
          <div class="form-group">
            <label class="col-sm-2 control-label">empName</label>
            <div class="col-sm-10">
              <%--  静态显示员工姓名 --%>
              <p class="form-control-static" id="empName-update_static"></p>
            </div>
          </div>
          <div class="form-group">
            <label class="col-sm-2 control-label">email</label>
            <div class="col-sm-10">
              <input type="email" name="email" class="form-control" id="email_update_input" placeholder="请输入你的邮箱">
              <span class="help-block"></span>
            </div>
          </div>
          <div class="form-group">
            <label class="col-sm-2 control-label">gender</label>
            <div class="col-sm-10">
              <label class="radio-inline">
                <input type="radio" name="gender" id="gender2_update_input" value="F" checked="checked"> 女
              </label>
              <label class="radio-inline">
                <input type="radio" name="gender" id="gender1_update_input" value="M"> 男
              </label>
            </div>
          </div>
          <div class="form-group">
            <label class="col-sm-2 control-label">deptName</label>
            <div class="col-sm-4">
              <%-- 部门提交部门ID即可 --%>
              <select class="form-control" name="dId" id="dept_update_select"></select>
            </div>
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
        <button type="button" class="btn btn-primary" id="emp_update_btn">更新</button>
      </div>
    </div><!-- /.modal-content -->
  </div><!-- /.modal -->
</div>

<%--员工添加模态框--%>
<!-- 模态框（Modal） -->
<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="myModalLabel">员工添加</h4>
      </div>
      <div class="modal-body">
        <form class="form-horizontal">
          <div class="form-group">
            <label class="col-sm-2 control-label">empName</label>
            <div class="col-sm-10">

              <%--为了springmvc封装方便，表单项里的name要和javabean里的属性一致--%>

              <input type="text" name="empName" class="form-control" id="empName_add_input" placeholder="请输入你的姓名">
                <span class="help-block"></span>
            </div>
          </div>
          <div class="form-group">
            <label class="col-sm-2 control-label">email</label>
            <div class="col-sm-10">
              <input type="email" name="email" class="form-control" id="email_add_input" placeholder="请输入你的邮箱">
              <span class="help-block"></span>
            </div>
          </div>
          <div class="form-group">
            <label class="col-sm-2 control-label">gender</label>
            <div class="col-sm-10">
              <label class="radio-inline">
                <input type="radio" name="gender" id="gender2_add_input" value="F" checked="checked"> 女
              </label>
              <label class="radio-inline">
                <input type="radio" name="gender" id="gender1_add_input" value="M"> 男
              </label>
            </div>
          </div>
          <div class="form-group">
            <label class="col-sm-2 control-label">deptName</label>
            <div class="col-sm-4">
              <%-- 部门提交部门ID即可 --%>
              <select class="form-control" name="dId" id="dept_add_select"></select>
            </div>
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
        <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
      </div>
    </div><!-- /.modal-content -->
  </div><!-- /.modal -->
</div>
<%--搭建显示页面--%>
<div class="container">
  <%--标题--%>
  <div class="row">
    <div class="col-md-12" style="margin-bottom: 20px">
      <h1>SSM-CRUD</h1>
    </div>
  </div>

  <div class="row">

    <%--按钮--%>
    <div class="col-md-4">
      <button class="btn btn-primary" id="emp_add_modal_btn">新增</button>
      <button class="btn btn-danger" id="emp_delete_all_btn">删除</button>
    </div>
      <%--回到主页面--%>
      <button type="button" class="btn btn-default btn-lg" id="gohome" style="font-size: 15px;margin-left: 50px">
        <span class="glyphicon glyphicon-home" aria-hidden="true"></span>
      </button>
   <%--搜索框--%>
    <div class="input-group col-lg-3 col-md-offset-8" style="margin-top: -40px;margin-bottom: 30px">
        <input type="text" id="select_input" class="form-control" placeholder="Search for...">
        <span class="input-group-btn">
        <button class="btn btn-default" id="select_button" type="button">Go!</button>
        </span>
    </div>
  </div>
  <%--显示表格数据--%>
  <div class="row"></div>
  <div class="col-md-12">
    <table class="table table-hover" id="emps_table">
      <thead>
      <tr>
        <%--批量删除的选择框--%>
        <th>
            <input type="checkbox" id="check_all"/>
        </th>
        <th>#</th>
        <th>empName</th>
        <th>gender</th>
        <th>email</th>
        <th>deptName</th>
        <th>操作</th>
      </tr>
      </thead>
      <tbody>

      </tbody>
    </table>
  </div>
  <%--显示分页信息--%>
  <div class="row">
    <%--分页文字信息--%>
    <div class="col-md-6 "  id="page_info_area" >
    </div>
    <!-- 分页条信息 -->
    <div class="col-md-6 col-md-offset-6"  id="page_nav_area" >

    </div>
  </div>


  <script type="text/javascript">

    var totalRecord,currentPage;

    //1.页面加载完成以后，直接去发送ajax请求，要到分页数据
    $(function (){
      //去首页
      to_page(1);
    })

    function to_page(pn){
        $.ajax({
            url:"${APP_PATH}/emps",
            data:"pn="+pn,
            type:"GET",
            success:function (result) {
                // console.log(result);
              // 请求成功后，①解析并显示数据、
              build_emps_table(result);
              // ②解析并显示分页信息、
              build_page_info(result);
              //③解析显示分页条数据
              build_page_nav(result);
            }
        })
    }
    function build_emps_table(result) {
      //清空table表格
      $("#emps_table tbody").empty();
      var emps = result.extend.pageInfo.list;
      $.each(emps, function (index, item) {
        // alert(item, empsName);
        var checkBoxTd=$("<td><input type='checkbox' class='check_item'/></td>")
        var empIdTd = $("<td></td>").append(item.empId);
        var empNameTd = $("<td></td>").append(item.empName);
        var genderTd = $("<td></td>").append(item.gender == 'M' ? "男" : "女");
        var emailTd = $("<td></td>").append(item.email);
        var deptNameTd = $("<td></td>").append(item.department.deptName);

        var editBtn=$("<button></button>").addClass("btn btn-primary btn-sm edit_btn")
                      .append($("<span></span>").addClass("glyphicon glyphicon-pencil"))
                      .append("编辑");
        /*
        *为编辑按钮添加一个自定义的属性，来表示当前员工id
        */
        editBtn.attr("edit-id",item.empId);

        var delBtn=$("<button></button>").addClass("btn btn-danger btn-sm delete_btn")
                .append($("<span></span>").addClass("glyphicon glyphicon-trash"))
                .append("删除");

        //为删除按钮添加一个自定义的属性来表示当前删除员工的id
        delBtn.attr("del-id",item.empId);

        var btnTd=$("<td></td>").append(editBtn).append(" ").append(delBtn)
        //append方法执行完成以后还是返回原来的元素
        $("<tr></tr>").append(checkBoxTd)
                .append(empIdTd)
                .append(empNameTd)
                .append(genderTd)
                .append(emailTd)
                .append(deptNameTd)
                .append(btnTd)
                .appendTo("#emps_table tbody");
      })
    }

    //解析显示分页信息
    function build_page_info(result) {
      //清空分页信息
      $("#page_info_area").empty();
      $("#page_info_area").addClass("").append("当前" + result.extend.pageInfo.pageNum + "页，总"
              + result.extend.pageInfo.pages + "页，总"
              + result.extend.pageInfo.total + "条记录")
      totalRecord=result.extend.pageInfo.total;
      currentPage=result.extend.pageInfo.pageNum;
    }

    //解析显示分页条
    function build_page_nav(result) {
      //清空分页条信息
      $("#page_nav_area").empty();
      var ul = $("<ul></ul>").addClass("pagination");

      //构建元素
      //attr()方法：设置或返回被选元素的属性和值
      var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href", "#"));
      var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));
      if (result.extend.pageInfo.hasPreviousPage == false) {
        firstPageLi.addClass("disabled");
        prePageLi.addClass("disabled");
      } else {
        //为元素添加点击翻页
        firstPageLi.click(function () {
          to_page(1);
        })
        prePageLi.click(function () {
          to_page(result.extend.pageInfo.pageNum - 1);
        })
      }

      var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
      var lastPageLi = $("<li></li>").append($("<a></a>").append("末页").attr("href", "#"));
      if (result.extend.pageInfo.hasNextPage == false) {
        nextPageLi.addClass("disabled");
        lastPageLi.addClass("disabled");
      } else {

        nextPageLi.click(function () {
          to_page(result.extend.pageInfo.pageNum + 1);
        })
        lastPageLi.click(function () {
          to_page(result.extend.pageInfo.pages);
        })
      }
      //添加首页和前一页的提示
      ul.append(firstPageLi).append(prePageLi);
      $.each(result.extend.pageInfo.navigatepageNums, function (index, item) {
        var numli = $("<li></li>").append($("<a></a>").append(item))
        if (result.extend.pageInfo.pageNum == item) {
          numli.addClass("active")
        }
        numli.click(function () {
          to_page(item);
        })
        ul.append(numli);
      })
      //添加下一页和末页的提示
      ul.append(nextPageLi).append(lastPageLi);
      //把ul加入到nav
      var navEle = $("<nav></nav>").append(ul);
      navEle.appendTo("#page_nav_area");

    }
    function reset_form(ele){
      $(ele)[0].reset();
      //清空表单样式
      $(ele).find("*").removeClass("has-success has-error");
      $(ele).find(".help-block").text("");
    }
    /* 点击新增按钮弹出模态框 */
    $("#emp_add_modal_btn").click(function () {
      //清除表单数据（表单完整重置（表单的数据，表单的样式））
      reset_form("#empAddModal form");
      //  $("#empAddModal form")[0].reset();
      //发送ajax请求，查出部门信息，显示在下拉列表中
      getDepts("#empAddModal select");

      //弹出模态框
      $("#empAddModal").modal({
        backdrop: "static" //点击背景模态框不消失
      })
    })

    //查出所有的部门信息并显示在下拉列表中
    function getDepts(ele) {
      $(ele).empty();
        $.ajax({
          url:"${APP_PATH}/depts",
          type: "GET",
          success:function (result){
            // console.log(result);
            // $("#dept_add_select").append("")
            $.each(result.extend.depts,function (){
                var optionEle=$("<option></option>").append(this.deptName)
                        .attr("value",this.deptId);
                optionEle.appendTo(ele)
            })
          }
        })
    }



    //校验表单数据
    function validate_add_form() {
      // $("input").focus();
        //1. 拿到要校验的数据，使用正则表达式进行校验
        var empName = $("#empName_add_input").val();
        var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;

        if (!regName.test(empName)) {
          //alert("用户名可以是2-5位中文或者6-16位英文和数字的组合");
          show_validate_msg("#empName_add_input", "error", "用户名可以是2-5位中文或者6-16位英文和数字的组合");
          return false;
        } else {
          show_validate_msg("#empName_add_input", "success", "");
        }
        ;
        //2、校验邮箱信息
        var email = $("#email_add_input").val();
        var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
        if (!regEmail.test(email)) {
          //alert("邮箱格式不正确");
          //应该清空这个元素之前的样式
          show_validate_msg("#email_add_input", "error", "邮箱格式不正确");
          /* $("#email_add_input").parent().addClass("has-error");
          $("#email_add_input").next("span").text("邮箱格式不正确"); */
          return false;
        } else {
          show_validate_msg("#email_add_input", "success", "");
        }
        return true;

    }
    //显示校验结果的提示信息
    function show_validate_msg(ele,status,msg){
      //清除当前元素的校验状态
      $(ele).parent().removeClass("has-success has-error");
      $(ele).next("span").text("");
      if("success"==status){
        $(ele).parent().addClass("has-success");
        $(ele).next("span").text(msg);
      }else if("error" == status){
        $(ele).parent().addClass("has-error");
        $(ele).next("span").text(msg);
      }
    }
    //检验用户名是否可用
    $("#empName_add_input").change(function(){
      //发送ajax请求校验用户名是否可用
      var empName = this.value;
      $.ajax({
        url:"${APP_PATH}/checkuser",
        data:"empName="+empName,
        type:"POST",
        success:function(result){
          if(result.code==100){
            show_validate_msg("#empName_add_input","success","用户名可用");
            $("#emp_save_btn").attr("ajax-va","success");
          }else{
            show_validate_msg("#empName_add_input","error",result.extend.va_msg);
            $("#emp_save_btn").attr("ajax-va","error");
          }
        }
      });
    })

    /*
    *点击保存 ，保存员工
    */
    $("#emp_save_btn").click(function (){
      //1. 模态框中填写的表单数据提交给服务器进行保存
      //2. 先对要提交给服务器的数据进行校验
      if(!validate_add_form()){
        return false;
      }
      //判断之前的ajax用户名校验是否成功。如果成功。
     if($(this).attr("ajax-va")=="error"){
       return false;
     }
      //3. 发送ajax请求保存员工
      // alert($("#empAddModal form").serialize());
      $.ajax({
        url:"${APP_PATH}/emp",
        type:"POST",
        //serialize()：序列化表格中的字符串，用于ajax请求
        data: $("#empAddModal form").serialize(),
        success:function (result){
          //console.log(result)
           if (result.code==100) {
            //员工保存成功：
            //1. 关闭模态框
            $("#empAddModal").modal('hide');
            //2. 来到最后一页，显示刚才保存过的数据
            //发送ajax请求显示最后一页数据
            //将
            to_page(totalRecord);
          }else{
          //   //显示失败信息
          //   console.log(result)
             //有哪个字段的错误信息就显示哪个字段的；
             if (undefined != result.extend.errorFields.email) {
               //显示邮箱错误信息
               show_validate_msg("#email_add_input", "error", result.extend.errorFields.email);
             }
             if (undefined != result.extend.errorFields.empName) {
               //显示员工名字的错误信息
               show_validate_msg("#empName_add_input", "error", result.extend.errorFields.empName);
             }
          }
         }

      })
    })

    /*   为员工列表中的编辑绑事件
          1. 我们是按钮创建之前，就绑定了click
         2.同 on() 方法：on(events,[selector],[data],fn)
         在选择元素上绑定一个或多个事件的事件处理函数。
   */
    $(document).on("click",".edit_btn",function(){
      // alert("edit");
      /*1. 查出员工信息，显示员工信息
      *2. 查出部门信息，显示部门列表
      * 3. 弹出模态框
      */
      //1.查出部门信息，并显示部门列表
      getDepts("#empUpdateModal select");
      // 2. 查出员工信息，显示员工信息
      getEmp($(this).attr("edit-id"))
      // 3. 把员工的id传递给模态框的更新按钮

      //3、把员工的id传递给模态框的更新按钮
      $("#emp_update_btn").attr("edit-id",$(this).attr("edit-id"));
      $("#empUpdateModal").modal({
        backdrop:"static"
      });
    })
    function getEmp(id){
      $.ajax({
        url: "${APP_PATH}/emp/"+id,
        type: "GET",
        success:function(result){
          var empData=result.extend.emp;
          $("#empName-update_static").text(empData.empName);
          $("#email_update_input").val(empData.email);
          $("#empUpdateModal input[name=gender]").val([empData.gender]);
          $("#empUpdateModal select").val([empData.dId]);
        }
      })
    }
    /*
    * 点击更新，更新员工信息*/
    $("#emp_update_btn").click(function(){
      //1. 验证邮箱是否合法
      var email = $("#email_update_input").val();
      var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
      if(!regEmail.test(email)){
        show_validate_msg("#email_update_input", "error", "邮箱格式不正确");
        return false;
      }else{
        show_validate_msg("#email_update_input", "success", "");
      }

      //2. 发送ajax请求保存更新的员工数据
      $.ajax({
        url:"${APP_PATH}/emp/"+$(this).attr("edit-id"),
        type:"PUT",
        //serialize():序列化
        data:$("#empUpdateModal form").serialize(),
        success:function (result){

          //关闭模态框
          $("#empUpdateModal").modal("hide");
          //回到本页面
          to_page(currentPage);
        }
      })
    })
    //单个删除
    $(document).on("click",".delete_btn",function(){
      //1. 弹出是否确认删除的对话框
     // alert($(this).parents("tr").find("td:eq(1)").text());
      var empName=$(this).parents("tr").find(("td:eq(2)")).text();
      //this:表示当前被点击的按钮
      var empId=$(this).attr("del-id");
      //confirm：确认框
      if (confirm("确认删除【"+empName+"】吗?")){
        //点击确认，发送AJAX请求删除即可
        $.ajax({
          url:"${APP_PATH}/emp/"+empId,
          type:"DELETE",
          success:function (result){
            // alert(result.msg);
            to_page(currentPage);
          }
        })
      }
    })
    //完成全选、全不选功能
    $("#check_all").click(function (){
      //attr获取checked是undefined；原因：定义input框时没有checked属性
      //用dom原生的属性；attr获取自定义属性的值
      //用prop修改和读取原生属性的值
      $(this).prop("checked");
      $(".check_item").prop("checked",$(this).prop("checked"));
    })
    //当一组check_item全选择时：check_all也是选择状态
    $(document).on("click",".check_item",function (){
      //判断当前选择的元素是否等于表单中input框的总元素
      var flag=$(".check_item:checked").length==$(".check_item").length;
      $("#check_all").prop("checked",flag);
    })
    //点击全部删除，就批量删除
    $("#emp_delete_all_btn").click(function (){
      var empNames="";
      var del_idstr="";
      $.each($(".check_item:checked"),function(){
        empNames+=$(this).parents("tr").find("td:eq(2)").text()+",";
        del_idstr+=$(this).parents("tr").find("td:eq(1)").text()+"-";
       // alert($(this).parents("tr").find("td:eq(2)").text());

      })
      //去除empNames,del_idstr多余的，
      empNames=empNames.substring(0,empNames.length-1);
      del_idstr=del_idstr.substring(0,del_idstr.length-1);
      if (confirm("确认删除【"+empNames+"】吗")){
        //发送Ajax请求删除
        $.ajax({
          url:"${APP_PATH}/emp/"+del_idstr,
          type:"DELETE",
          success:function (result){
            alert(result.msg);
            //回到当前页面
            to_page(currentPage);
          }
        })
      }
    })
    $("#select_button").click(function (){
      //为搜索按钮绑定单击事件
        //清空tbody，如果不清空，当页面刷新的时候新的数据不会覆盖旧数据，造成页面混乱
        $("#emps_table tbody").empty();
        //将搜索框中的内容保存到searchContent中
        var searchContent = $("#select_input").val();
        console.log(searchContent);
        $("#page_nav_area").empty();
        //如果输入框中的内容为空的话，用to_page回到原本显示的界面。
        if(searchContent == ""){
          to_page(1);
        }else{
          //如果不为空的话，发送ajax请求
          $.ajax({
            url:"${APP_PATH}/empSearch",
            type:"GET",
            data:"content=" + searchContent,
            success:function (res) {
              //显示搜索到的员工
              search_emps_table(res);
              //显示搜索页面的分页信息
              build_search_page_info(res);
            }
          });
        }
      })
      // 解析并显示查询到的员工数据
      function search_emps_table(res) {
        //清空table表格，如果不清空，当页面刷新的时候新的数据不会覆盖旧数据，造成页面混乱
        $("#emps_table tbody").empty();
        //将查找出来的员工数据保存在empSearched中
        var empSearched = res.extend.pageInfo.list;
        //如果empSearch中的数据为空的话，就提示未找到
        if(empSearched.length == 0){
          $("<h5></h5>").append("").append("NOT FOUND")
                  .appendTo("#emps_table tbody");//将tr添加到tbody标签中
        }else {
          //遍历所有查询到的员工
          $.each(empSearched, function (i, val) {
            //在员工数据的最左边加上多选框
            var checkBoxTd = $("<td><input type='checkbox' class='check_item'/></td>");
            var empIdTd = $("<td></td>").append(empSearched[i].empId);
            var empNameTd = $("<td></td>").append(empSearched[i].empName);
            var genderTd = $("<td></td>").append(empSearched[i].gender == 'M' ? "男" : "女");
            var emailTd = $("<td></td>").append(empSearched[i].email);
            var deptNameTd = $("<td></td>").append(empSearched[i].department.deptName);
            //编辑按钮
            var editBtn=$("<button></button>").addClass("btn btn-primary btn-sm edit_btn")
                    .append($("<span></span>").addClass("glyphicon glyphicon-pencil"))
                    .append("编辑");
            //为编辑按钮添加一个自定义的属性，来表示当前员工id
            editBtn.attr("edit-id", empSearched[i].empId);
            //删除按钮
            var delBtn=$("<button></button>").addClass("btn btn-danger btn-sm delete_btn")
                    .append($("<span></span>").addClass("glyphicon glyphicon-trash"))
                    .append("删除");
            //为删除按钮添加一个自定义的属性，来表示当前员工id
            //为删除按钮添加一个自定义的属性，来表示当前员工id
            delBtn.attr("del-id", empSearched[i].empId);
            //把两个按钮放到一个单元格中，并且按钮之间留点空隙
            var btnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);
            //append方法执行完成以后还是会返回原来的元素，所以可以一直.append添加元素，
            //将上面的td添加到同一个tr里
            $("<tr></tr>").append(checkBoxTd)
                    .append(empIdTd)
                    .append(empNameTd)
                    .append(genderTd)
                    .append(emailTd)
                    .append(deptNameTd)
                    .append(btnTd)
                    .appendTo("#emps_table tbody");//将tr添加到tbody标签中
          })
        }
      }
      // 解析并显示搜索页面的分页信息
      function build_search_page_info(res) {
        //清空分页文字信息，如果不清空，当页面刷新的时候新的数据不会覆盖旧数据，造成页面混乱
        $("#page_info_area").empty();
        //显示共几条记录
        $("#page_info_area").append("已查询到" + res.extend.pageInfo.total +"条记录。");
      }

      $("#gohome").click(function (){
        window.location="index.jsp";
      })
  </script>
</div>
</body>
</html>

