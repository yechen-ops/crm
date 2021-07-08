# CRM

crm客户管理系统，仿自[动力节点](https://www.bilibili.com/video/BV1fT4y1E7a6?p=1)

### 系统设置模块 setting

- [x] 用户模块：登录操作
- [x] 涉及到数字字典模块信息的查询



### 工作台（核心业务） workbench



#### 一、市场活动模块 activity

- [x] 点击创建按钮，打开创建市场活动的模态窗口
- [x] 添加操作
- [x] 展现市场活动信息列表（结合条件查询 + 分页查询）
- [x] 全选 / 反选
- [x] 执行删除操作
- [x] 点击修改按钮打开修改操作的模态窗口（并填充数据）
- [x] 执行修改操作
- [x] 点击市场活动名称跳转到详细信息页，展现详细信息
- [x] 详细信息页加载完毕后，展现备注信息列表
- [x] 备注的添加、修改、删除

#### 二、线索模块 clue

- [x] 点击创建按钮，打开添加线索的模态窗口（窗口中对于下拉框的处理由服务器缓存（application）中的数据字典来填充）
- [x] 添加线索操作
- [x] 展现线索信息列表（结合条件查询 + 分页查询）
- [x] 全选 / 反选
- [ ] 执行删除操作
- [x] 点击修改按钮打开修改操作的模态窗口（并填充数据）
- [ ] 执行修改操作
- [x] 点击线索名称进入到详细信息页，展现线索的详细信息
- [ ] ~~详细信息页加载完毕后，展现备注信息列表~~
- [ ] ~~备注的添加、修改、删除~~
- [x] 详细信息页加载完毕后，展现关联的市场活动列表
- [x] 解除当前线索和市场活动的关联操作
- [x] 点击关联市场活动按钮，查询并展现当前线索没有关联的市场活动列表（并支持市场活动名称模糊查询）
- [x] 关联市场活动的操作
- [x] 点击转换按钮跳转到线索转换页面
- [x] 执行线索转换的操作（可同时添加交易）

#### 三、客户模块 customer

- [ ] ~~点击创建按钮，打开创建客户的模态窗口~~
- [ ] ~~添加操作~~
- [ ] ~~展现客户信息列表（结合条件查询 + 分页查询）~~
- [ ] ~~全选 / 反选~~
- [ ] ~~执行删除操作~~
- [ ] ~~点击修改按钮打开修改操作的模态窗口（并填充数据）~~
- [ ] ~~执行修改操作~~
- [ ] ~~点击客户名称跳转到详细信息页，展现详细信息~~
- [ ] ~~详细信息页加载完毕后，展现备注信息列表~~
- [ ] ~~备注的添加、修改、删除~~
- [ ] ~~详细信息页加载完毕后，展现与当前客户相关的交易列表~~
- [ ] ~~执行删除交易的操作~~
- [ ] ~~新建交易（跳转到交易模块的保存信息界面）~~
- [ ] ~~详细信息页加载完毕后，展现当前客户的联系人列表~~
- [ ] ~~执行删除联系人的操作~~
- [ ] ~~新建联系人~~

#### 四、联系人模块 contacts

- [ ] ~~点击创建按钮，打开创建联系人的模态窗口~~
- [ ] ~~添加操作~~
- [ ] ~~展现联系人信息列表（结合条件查询 + 分页查询）~~
- [ ] ~~全选 / 反选~~
- [ ] ~~执行删除操作~~
- [ ] ~~点击修改按钮打开修改操作的模态窗口（并填充数据）~~
- [ ] ~~执行修改操作~~
- [ ] ~~点击联系人姓名跳转到详细信息页，展现详细信息~~
- [ ] ~~详细信息页加载完毕后，展现备注信息列表~~
- [ ] ~~备注的添加、修改、删除~~
- [ ] ~~详细信息页加载完毕后，展现与当前联系人相关的交易列表~~
- [ ] ~~执行删除交易的操作~~
- [ ] ~~新建交易（跳转到交易模块的保存信息界面）~~
- [ ] ~~详细信息页加载完毕后，展现与当前联系人相关的市场活动~~
- [ ] ~~执行解除与市场活动关联的操作~~
- [ ] ~~关联市场活动~~

#### 五、交易模块 tran

- [x] 点击创建按钮，打开创建交易的模态窗口
- [x] 添加操作
- [x] 展现交易信息列表（结合条件查询 + 分页查询）
- [ ] 全选 / 反选
- [ ] ~~执行删除操作~~
- [ ] ~~点击修改按钮打开修改操作的模态窗口（并填充数据）~~
- [ ] ~~执行修改操作~~
- [ ] 点击交易名称跳转到详细信息页，展现详细信息
- [ ] ~~详细信息页加载完毕后，展现备注信息列表~~
- [ ] ~~备注的添加、修改、删除~~
- [x] 在页面加载完毕后，展现交易历史列表
- [x] 动态展现交易节点内容及图标
- [x] 点击阶段图标，更改交易阶段

#### 六、统计图表

- [x] 交易阶段统计图 ECharts




