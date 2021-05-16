import com.issunjh.bean.Department;
import com.issunjh.bean.Employee;
import com.issunjh.dao.DepartmentMapper;
import com.issunjh.dao.EmployeeMapper;
import org.apache.ibatis.session.SqlSession;
import org.junit.jupiter.api.extension.ExtendWith;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import java.util.UUID;


/**
 * @Description
 * @Author Sunjh
 * @Date 2021/4/19 17:29
 */
//@RunWith(SpringJUnit4ClassRunner.class)
@ExtendWith(SpringExtension.class)

@ContextConfiguration(locations = "classpath:applicationContext.xml")
/*
* @RunWith：指定哪个单元测试运行
* ContextConfiguration：指定Spring配置文件的位置
* 直接autowired要使用的组件即可
*/
public class MapperTest {
    @Autowired
    DepartmentMapper departmentMapper;

    @Autowired
    EmployeeMapper employeeMapper;

    @Autowired
    SqlSession sqlSession;

    @Test
    public void testCRUD(){

       // 1.配置SpringIOC容器
//        ApplicationContext ioc=new ClassPathXmlApplicationContext("applicationContext.xml");
        //2.从容器中获取mapper
//        DepartmentMapper bean = ioc.getBean(DepartmentMapper.class);
//        departmentMapper.insertSelective(new Department(null,"开发部"));
//        departmentMapper.insertSelective(new Department(null,"测试部"));

        employeeMapper.insertSelective(new Employee(null,"Jerry","M","Jerry@gmail.com",1));

        //批量插入多个员工：使用可以执行批量操作的sqlSession
         EmployeeMapper mapper=sqlSession.getMapper(EmployeeMapper.class);
         for (int i=0 ;i<1000;i++){
             String uid = UUID.randomUUID().toString().substring(0, 5)+i;
             mapper.insertSelective(new Employee(null,uid,"M",uid+"xxxx@gmail.com",1));
         }
        System.out.println("批量执行完成！");
    }
}
