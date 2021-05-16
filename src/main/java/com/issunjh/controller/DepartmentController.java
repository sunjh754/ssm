package com.issunjh.controller;

import com.issunjh.bean.Department;
import com.issunjh.bean.Msg;
import com.issunjh.service.DepartmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * @Description 处理和部门有关的请求
 * @Author Sunjh
 * @Date 2021/4/24 18:57
 */

@Controller
public class DepartmentController {

    @Autowired
    DepartmentService departmentService;

    /**
     * 返回所有的部门信息
     */
    @RequestMapping("/depts")
    @ResponseBody
    public Msg getDepts(){
        //查出的所有部门信息
        List<Department> list = departmentService.getDepts();
        return Msg.success().add("depts", list);
    }

}
