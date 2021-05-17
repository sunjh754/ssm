package com.issunjh.service;

import com.issunjh.bean.Employee;
import com.issunjh.bean.EmployeeExample;
import com.issunjh.dao.EmployeeMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @Description
 * @Author Sunjh
 * @Date 2021/4/21 16:01
 */
@Service
public class EmployeeService {
    //service层返回数据需要调用dao
    //@Autowired 自动注入
    @Autowired
    EmployeeMapper employeeMapper;

    /*
    * 按照员工id查询员工
    */
    public Employee getEmp(Integer id)
    {
        Employee employee = employeeMapper.selectByPrimaryKey(id);
        return employee;
    }


    /*
    查询员工数据
     */
    public List<Employee> getAll() {
        return employeeMapper.selectByExampleWithDept(null);
    }

    /*
    员工保存
     */
    public void saveEmp(Employee employee) {
        employeeMapper.insertSelective(employee);
    }

    /*
    检验用户名是否可用 true:当前用户名可用
    */
    public boolean checkUser(String empName) {
        EmployeeExample example = new EmployeeExample();
        EmployeeExample.Criteria criteria = example.createCriteria();
        criteria.andEmpNameEqualTo(empName);
        long count = employeeMapper.countByExample(example);
        return count == 0;
    }

    public void updateEmp(Employee employee) {
        employeeMapper.updateByPrimaryKeySelective(employee);
    }

    public void deleteEmp(Integer id) {
        employeeMapper.deleteByPrimaryKey(id);
    }

    public void deleteBatch(List<Integer> ids) {
        EmployeeExample example=new EmployeeExample();
        EmployeeExample.Criteria criteria = example.createCriteria();
        //delete from xxx where emp_id in(ids)
        criteria.andEmpIdIn(ids);
        employeeMapper.deleteByExample(example);
    }

    /**
     * 根据姓名或id搜索员工
     */
    public List<Employee> getEmpByVague(String empName){
        return employeeMapper.selectByVague(empName);
    }
}
