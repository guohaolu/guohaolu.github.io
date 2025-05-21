# 项目规则

## 总体
* 项目使用 jdk17 开发
* 项目使用 maven 管理
* 项目使用 springboot2.7 框架
* 项目使用 springcloud 框架
* 项目使用 springcloud-alibaba 框架
* 项目使用 springcloud-gateway 框架
* 项目使用 springcloud-openfeign 框架
* 项目使用 springcloud-sentinel 框架
* 项目使用 springcloud-nacos 框架
* 项目使用 mybatis-plus 框架
* 项目使用 mapstruct 框架
* 项目使用 lombok 框架

## 业务背景
* 项目是跨境电商erp下的财务系统

## 代码结构
* 项目为四层结构，分别为：
    * 控制层：controller，目录：com.ewayt.erp.finance.controller
    * 服务层：service，目录：com.ewayt.erp.finance.service
    * 数据访问仓储层：repository，目录：com.ewayt.erp.finance.repository
    * 数据访问层：dao，目录：com.ewayt.erp.finance.dao
* 项目分四类实体：
    * 数据库实体：entity，目录：com.ewayt.erp.finance.pojo.entity
    * DTO：dto，目录：com.ewayt.erp.finance.pojo.dto
    * VO：vo，目录：com.ewayt.erp.finance.pojo.vo
    * 业务实体：bo，目录：com.ewayt.erp.finance.pojo.bo
* 类型转换层，使用mapstruct框架，使用spring模式，目录：com.ewayt.erp.finance.converter
* 通用管理层，用于存储通用组件，如adapter，manager，目录：com.ewayt.erp.finance.manager

## 代码规范
* 代码使用 javadoc 注释， 使用 @author 注释作者，作者名为：guohao.lu，使用 @param 注释参数，使用 @return 注释返回值，使用 @throws 注释异常
* 分层调用规范：
    * 控制层调用服务层，服务层调用数据访问仓储层，数据访问仓储层调用数据访问层，数据访问层调用数据库
    * controller -> service -> repository -> dao -> entity
    * 禁止在service中直接写类似SQL的代码，比如：使用mybatis-plus的链式查询
    * mybatis-plus的链式查询应该在repository层使用
    * 复杂sql应该在dao层的mapper文件中使用
* repository层使用mybatis-plus框架，类去实现mybatis-plus的ServiceImpl

## 数据库设计
* 数据库使用mysql，数据库名为：erp_finance
* 数据库使用utf8mb4编码，使用innodb引擎
* 多租户字段：tenant_id
* 审计字段：created_by，created_time，updated_by，updated_time

## 功能需求
### 分摊配置中心的设计
* 简述：
    * 分摊配置中心是一个配置中心，用于存储分摊配置
    * 数据链路是从源端的费用数据，经过分摊配置中心，生成分摊后的费用数据，刷到目标的报表上
* 重要概念：
    * 费用类型：FeeTypeEnum
    * 费用项，每个费用项都会归属于某个费用类型：FeeItemEnum
    * 分摊规则，每个费用项都会有自己对应的几种分摊规则， ApportionStrategyEnum
    * 目标报表，费用数据会刷到目标报表上
    * 差值抹平，由于计算机中的小数精度问题，会存在一些差值，差值抹平就是为了解决这个问题，比如：最后的差值全部分摊给销售额最大的msku上
* 设计要点：
    * 分摊规则是可以配置的
    * 分摊配置中心是一个页面，用户选择完分摊规则后，点击保存，分摊配置中心会将分摊费用按照用户配置的规则进行分摊
    * 用于规则可配置，我们想基于adapter设计，复用代码
    * 源端的费用数据是从源端的报表上获取的，这里的报表是数据库数据，从亚马逊上拉取的，源端的报表类型比较少，只有5类，每个表上会有很多的费用项：如：月度仓储费，长期仓储费，超量仓储费，并仓费，库存移除处置费等等
    * 分摊规则是可以配置的，为枚举值，见：ApportionStrategyEnum
    * 目标报表也比较少，如FBA利润报表，销量监控订单利润报表等等，每个报表上会有很多的费用项的分摊费用，如：销售额，毛利，成本等等
    * 我想基于adapter设计，复用代码，目录：com.ewayt.erp.finance.manager
    * 但是数据库查询和更新的操作比较费时，所以我又想合并部分的adapter，如有10个费用项，数据都是从SC报表到FBA利润报表，那么我可以把SC报表和FBA利润报表的数据获取复用，这样可以减少数据库查询的次数。不过这10个费用项的分摊规则是可以配置的，所以我需要在adapter上增加一个注解，用于判断是否需要合并adapter，这个注解需要标识：源端报表，目标报表。相同源端报表的可以合并源端报表的查询操作，相同目标报表的可以合并目标报表的更新操作。
    * 分摊配置中心的保存会触发一个异步长任务，我们需要设计任务的互斥，可以采用redisson的分布式锁，锁的key为：finance:apportion:config_certer:task_lock:tenant_id:platform:year_month
    * 我写了一版代码adapter在，但是代码的复用我没有设计好，我希望你可以帮我重新设计。代码在：com.ewayt.erp.finance.manager.adapter
