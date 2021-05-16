package com.issunjh.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.issunjh.bean.Employee;
import com.issunjh.bean.Msg;
import com.issunjh.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

/**
 * @Description 处理员工的CRUD
 * @Author Sunjh
 * @Date 2021/4/21 15:55
 */
@Controller
public class EmployeeController {
    //调用Service层
    //@Autowired自动装配service层组件
    @Autowired
    EmployeeService employeeService;

    /**
     *  查询功能
     *  可以根据搜索框（content）中的内容查询与之有关的员工，包括员工姓名，员工id。
     */
    @ResponseBody
    @RequestMapping("/empSearch")
    public Msg searchEmpsByVague(@RequestParam("content") String content){

//        引入pageHelper分页查询，
//        在查询之前只需要调用PageHelper.startPage()，传入页码，以及每一页显示的数量
        PageHelper.startPage(1, 1000000);
//        分页完之后的查询就是分页查询

//        模糊查询，姓名中包含content的或者id为content的都会被搜索出来
        List<Employee> employees = employeeService.getEmpByVague(content);

        System.out.println(employees);
//        分页查询完之后，可以使用pageInfo来包装查询后的结果，
//        只需要将pageInfo交给页面就行
//        pageInfo封装了详细的分页信息，包括我们查询出来的数据
//        比如总共有多少页，当前是第几页等。。。
//        想要连续显示5页，就加上参数5即可
        PageInfo pageInfo = new PageInfo(employees,5);

        return Msg.success().add("pageInfo", pageInfo);
    }





    /*
    *批量单个删除二合一
    * 批量删除：1-2-3
    * 单个删除：1
    */

    @ResponseBody
    @RequestMapping(value = "/emp/{ids}",method = RequestMethod.DELETE)
    public Msg deleteEmp(@PathVariable("ids")String ids)
    {
        //批量删除
        if (ids.contains("-")){
            List<Integer> del_ids=new ArrayList<>();
            String[] str_ids = ids.split("-");
            for (String string:str_ids
                 ) {
                del_ids.add(Integer.parseInt(string));
                //组装id的集合
            }
            employeeService.deleteBatch(del_ids);
//            单个删除
        }else{
            Integer id=Integer.parseInt(ids);
            employeeService.deleteEmp(id);
        }
        return Msg.success();
    }




    //单个删除
//    @ResponseBody
//    @RequestMapping(value = "/emp/{id}",method = RequestMethod.DELETE)
//    public Msg deleteEmpById(@PathVariable("id")Integer id)
//    {
//        employeeService.deleteEmp(id);
//        return null;
//    }



    //员工保存请求
    @ResponseBody
    @RequestMapping(value="/emp/{empId}",method=RequestMethod.PUT)
    public Msg updateEmp(Employee employee) {
//        System.out.println("请求体中的值："+request.getParameter("gender"));
        System.out.println("将要更新的员工数据："+employee);
        employeeService.updateEmp(employee);
        return Msg.success()	;
    }



//    显示员工信息
    @RequestMapping(value = "/emp/{id}",method = RequestMethod.GET)
    @ResponseBody
    public Msg getEmp(@PathVariable("id")Integer id){
        Employee employee=employeeService.getEmp(id);
        return Msg.success().add("emp",employee);
    }



//    检查用户名是否可用
    @ResponseBody
    @RequestMapping("/checkuser")
    public Msg checkuser(@RequestParam("empName")String empName){
        //先判断用户名是否是合法的表达式;
        String regx = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})";
        if(!empName.matches(regx)){
            return Msg.fail().add("va_msg", "用户名必须是6-16位数字和字母的组合或者2-5位中文");
        }

        //数据库用户名重复校验
        boolean b = employeeService.checkUser(empName);
        if(b){
            return Msg.success();
        }else{
            return Msg.fail().add("va_msg", "用户名不可用");
        }
    }


    /*
    *员工保存
    * */
    @RequestMapping(value = "emp", method = RequestMethod.POST)
    @ResponseBody
//    BindingResult:封装校验的结果
    public Msg saveEmp( Employee employee){
//       if (result.hasErrors())
//       {
//           //校验失败，返回失败，在模态框中显示校验失败的错误信息
//           Map<String,Object> map=new HashMap<>();
//           List<FieldError> errors = result.getFieldErrors();
//           for (FieldError fieldError:errors
//                ) {
//               System.out.println("错误的字段名："+fieldError.getField());
//               System.out.println("错误信息："+ fieldError.getDefaultMessage());
//               map.put(fieldError.getField(), fieldError.getDefaultMessage());
//           }
//           //把所有的错误字段的提示信息交给浏览器
//           return Msg.fail().add("errorFields",map);
//
//       }else {
           employeeService.saveEmp(employee);
           return Msg.success();
//       }
    }



    @RequestMapping("/emps")
    //需导入JSon包
    @ResponseBody
    public Msg getEmpsWithJson(@RequestParam(value = "pn",defaultValue = "1")Integer pn , Model model){
        //这不是一个分页查询
        //需要用到插件引入PageHelper分页插件
        //调用PageHelper，传入页码，以及每页的大小
        PageHelper.startPage(pn,5);
        //startPage后面紧跟的这个查询就是一个分页查询
        List<Employee> emps =employeeService.getAll();
        //使用pageInfo包装查询后的结果，只需要将pageInfo交给页面就行。
        //封装了详细的分页信息，包括我们查询出来的数据，传入连续显示的页数
        PageInfo page=new PageInfo(emps,5);
        return Msg.success().add("pageInfo",page);
    }


    /*
     *查询员工数据（分页查询）
     */

    //@RequestMapping("/emps")
//    public String getEmps(@RequestParam(value = "pn",defaultValue = "1")Integer pn ,Model model){
//
//        //这不是一个分页查询
//        //需要用到插件引入PageHelper分页插件
//        //调用PageHelper，传入页码，以及每页的大小
//        PageHelper.startPage(pn,5);
//        //startPage后面紧跟的这个查询就是一个分页查询
//        List<Employee> emps =employeeService.getAll();
//        //使用pageInfo包装查询后的结果，只需要将pageInfo交给页面就行。
//        //封装了详细的分页信息，包括我们查询出来的数据，传入连续显示的页数
//        PageInfo page=new PageInfo(emps,5);
//        model.addAttribute("pageInfo",page);
//        return "list";
//
//    }
}
