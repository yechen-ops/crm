/*
Navicat MySQL Data Transfer

Source Server         : CentOS7.6_03（192.168.182.133）
Source Server Version : 50718
Source Host           : 192.168.182.133:3306
Source Database       : crmdb

Target Server Type    : MYSQL
Target Server Version : 50718
File Encoding         : 65001

Date: 2021-07-08 00:03:38
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for tbl_activity
-- ----------------------------
DROP TABLE IF EXISTS `tbl_activity`;
CREATE TABLE `tbl_activity` (
  `id` char(32) NOT NULL,
  `owner` char(32) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `startDate` char(10) DEFAULT NULL,
  `endDate` char(10) DEFAULT NULL,
  `cost` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `createTime` char(19) DEFAULT NULL,
  `createBy` varchar(255) DEFAULT NULL,
  `editTime` char(19) DEFAULT NULL,
  `editBy` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_activity
-- ----------------------------
INSERT INTO `tbl_activity` VALUES ('0fd9f9e3cc9f4a00b9526b842332cfb6', '06f5fc056eac41558a964f96daa7f27c', '推广手机', '2021-07-01', '2021-07-10', '30000', '111111111111111111111111', '2021-07-01 20:21:30', '张三', '2021-07-02 14:54:49', '李四');
INSERT INTO `tbl_activity` VALUES ('4c33a084fe044646b631390280033c0d', '40f6cdea0bd34aceb77492a1656d9fb3', '动力节点CRM-P75-10', '2021-01-20', '2021-01-20', '0', '123', '2021-01-20 15:40:47', '张三', '2021-01-20 16:07:45', '张三');
INSERT INTO `tbl_activity` VALUES ('6430a2a1c38c487ba5f323c344ffdd1f', '06f5fc056eac41558a964f96daa7f27c', '动力节点CRM-P755', '2021-01-19', '2021-01-19', '0', '冲冲冲', '2021-01-19 01:10:54', '张三', '2021-01-20 16:21:30', '张三');
INSERT INTO `tbl_activity` VALUES ('66e15e548a0a4e719ef34659f68657b9', '81fd645033d143628c3ee71b36c26968', 'bilibili 推广3', '2021-07-04', '2021-07-31', '5000', 'bilibili 推广3', '2021-07-04 11:14:41', '叶尘', null, null);
INSERT INTO `tbl_activity` VALUES ('781fb5d6745846b79a77d0a36f22df13', '81fd645033d143628c3ee71b36c26968', 'bilibili 推广5', '2021-07-04', '2021-07-31', '8000', 'bilibili 推广5', '2021-07-04 11:15:17', '叶尘', '2021-07-04 16:37:20', '叶尘');
INSERT INTO `tbl_activity` VALUES ('7f0b67dd9dd246c199248fb386cc62c0', '40f6cdea0bd34aceb77492a1656d9fb3', 'bilibili 推广4', '2021-07-04', '2021-07-31', '5000', 'bilibili 推广4', '2021-07-04 11:15:01', '叶尘', null, null);
INSERT INTO `tbl_activity` VALUES ('84c5f525874244b6bd5a7c9bc73d36f9', '06f5fc056eac41558a964f96daa7f27c', '动力节点CRM-P75', '2021-01-19', '2021-01-19', '0', '糖豆', '2021-01-20 16:21:45', '张三', '2021-01-20 17:13:37', '张三');
INSERT INTO `tbl_activity` VALUES ('8f8a2d1dc66845439ef33d4433760892', '40f6cdea0bd34aceb77492a1656d9fb3', '推广手机', '2021-07-01', '2021-07-10', '30000', '111111111111111111111111', '2021-07-01 20:20:31', '张三', null, null);
INSERT INTO `tbl_activity` VALUES ('c132bf7ac38c464899621c0ec0067d0d', '81fd645033d143628c3ee71b36c26968', 'bilibili world(BW) 宣传', '2021-07-14', '2021-07-17', '50000', '宣传 BW789', '2021-07-04 16:25:14', '叶尘', '2021-07-05 11:13:36', '叶尘');
INSERT INTO `tbl_activity` VALUES ('c75c2f95efdb4644983620059cce69e9', '06f5fc056eac41558a964f96daa7f27c', '百度推广123456', '2021-07-02', '2021-07-30', '200000', '百度推广123456789', '2021-07-02 09:43:30', '李四', '2021-07-03 21:31:29', '李四');
INSERT INTO `tbl_activity` VALUES ('c8fe33417b294a938741fa71cc1ae584', '81fd645033d143628c3ee71b36c26968', 'bilibili 推广2', '2021-07-04', '2021-07-31', '5000', 'bilibili 推广2', '2021-07-04 11:12:29', '叶尘', null, null);
INSERT INTO `tbl_activity` VALUES ('da079ca3dc58451882f6574bd91cd7e7', '06f5fc056eac41558a964f96daa7f27c', '运动会招商', '2021-07-06', '2021-07-28', '20000', '嘉兴学院运动会招商', '2021-07-06 16:05:13', '叶尘', null, null);
INSERT INTO `tbl_activity` VALUES ('df207475d161493bbe07a01c4c8864d9', '06f5fc056eac41558a964f96daa7f27c', 'bilibili 推广1', '2021-07-01', '2021-07-30', '200000', 'bilibili 推广1', '2021-07-01 20:25:33', '张三', '2021-07-02 23:31:38', '张三');

-- ----------------------------
-- Table structure for tbl_activity_remark
-- ----------------------------
DROP TABLE IF EXISTS `tbl_activity_remark`;
CREATE TABLE `tbl_activity_remark` (
  `id` char(32) NOT NULL,
  `noteContent` varchar(255) DEFAULT NULL,
  `createTime` char(19) DEFAULT NULL,
  `createBy` varchar(255) DEFAULT NULL,
  `editTime` char(19) DEFAULT NULL,
  `editBy` varchar(255) DEFAULT NULL,
  `editFlag` char(1) DEFAULT NULL COMMENT '0��ʾδ�޸ģ�1��ʾ���޸�',
  `activityId` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_activity_remark
-- ----------------------------
INSERT INTO `tbl_activity_remark` VALUES ('26c4ca787ed44c078f84c6aeeb236076', 'hhh', '2021-07-06 16:39:15', '叶尘', null, null, '0', 'c75c2f95efdb4644983620059cce69e9');
INSERT INTO `tbl_activity_remark` VALUES ('28411eb80f5a44f997cb79dbd161dc94', '好期待啊（张三发布）（李四修改）', '2021-07-04 16:33:08', '叶尘', '2021-07-04 16:35:11', '李四', '1', 'c132bf7ac38c464899621c0ec0067d0d');
INSERT INTO `tbl_activity_remark` VALUES ('6430a2a1c38c487ba5f323c344ffdd33', '备注7', '2021-01-20 18:40:47', '张三', null, null, '0', '0fd9f9e3cc9f4a00b9526b842332cfb6');
INSERT INTO `tbl_activity_remark` VALUES ('69d5dff6816544b2b99f90569d24b889', '哈哈哈123', '2021-07-02 23:28:23', '张三', '2021-07-03 21:31:18', '李四', '1', 'c75c2f95efdb4644983620059cce69e9');
INSERT INTO `tbl_activity_remark` VALUES ('a7d9f4ef5e2a4202bed800026a8095fb', 'bilibili干杯', '2021-07-02 23:10:09', '李四', null, null, '0', 'df207475d161493bbe07a01c4c8864d9');
INSERT INTO `tbl_activity_remark` VALUES ('c10a803c24bc47fbbe54ae6672efe90c', '太好了', '2021-07-02 23:26:18', '张三', null, null, '0', 'c75c2f95efdb4644983620059cce69e9');
INSERT INTO `tbl_activity_remark` VALUES ('e3352d2cf11640369fec6bb074193f3e', '完美', '2021-07-02 23:27:28', '张三', null, null, '0', 'c75c2f95efdb4644983620059cce69e9');
INSERT INTO `tbl_activity_remark` VALUES ('f908d0c058d4427b902aad6068514241', '新备注123456', '2021-07-02 21:49:54', '张三', null, null, '0', 'c75c2f95efdb4644983620059cce69e9');
INSERT INTO `tbl_activity_remark` VALUES ('fa01badeaa1540c78b8c49ccb4942742', '不错不错（叶尘更改）', '2021-07-04 16:26:10', '张三', '2021-07-04 16:30:55', '叶尘', '1', 'c132bf7ac38c464899621c0ec0067d0d');
INSERT INTO `tbl_activity_remark` VALUES ('fbec5dc79d9d4412930acba876913ac5', '新备注新备注123456', '2021-05-15 18:42:01', '张三', '2021-07-02 21:29:24', '张三', '1', '84c5f525874244b6bd5a7c9bc73d36f9');

-- ----------------------------
-- Table structure for tbl_clue
-- ----------------------------
DROP TABLE IF EXISTS `tbl_clue`;
CREATE TABLE `tbl_clue` (
  `id` char(32) NOT NULL,
  `fullName` varchar(255) DEFAULT NULL,
  `appellation` varchar(255) DEFAULT NULL,
  `owner` char(32) DEFAULT NULL,
  `company` varchar(255) DEFAULT NULL,
  `job` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `mphone` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `createBy` varchar(255) DEFAULT NULL,
  `createTime` char(19) DEFAULT NULL,
  `editBy` varchar(255) DEFAULT NULL,
  `editTime` char(19) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `contactSummary` varchar(255) DEFAULT NULL,
  `nextContactTime` char(10) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_clue
-- ----------------------------
INSERT INTO `tbl_clue` VALUES ('47eb5910174a4fa7884e449a3a056cfd', '丁磊', '先生', '40f6cdea0bd34aceb77492a1656d9fb3', '网易', 'CEO', 'dinglei@163.com', '123456789', 'https://www.163.com/', '15715830811', '试图联系', '合作伙伴', '李四', '2021-07-03 21:24:52', null, null, '网易', '网易', '2021-07-07', '广州市天河区科韵路16号广州信息港E栋网易大厦');
INSERT INTO `tbl_clue` VALUES ('93960bbaa6f14197b36c00c65f975810', '马云', '先生', '06f5fc056eac41558a964f96daa7f27c', '阿里巴巴', 'CEO', 'my@alibaba.com', '656564123', 'www.alibaba.com', '13858440433', '将来联系', '员工介绍', '张三', '2021-05-16 16:50:01', null, null, '描述123', '纪要123', '2021-05-22', '杭州');
INSERT INTO `tbl_clue` VALUES ('9735c790c274419eb19da05b524ec1af', '马化腾', '先生', '06f5fc056eac41558a964f96daa7f27c', '腾旭', 'CEO', 'mahuaten@tencent.com', '45646144', 'www.tencent.com', '15715830811', '将来联系', '员工介绍', '李四', '2021-07-03 18:26:21', null, null, '腾讯游戏', '腾讯游戏', '2021-07-05', '深圳市高新科技园南区高新南一道飞亚达高科技大厦3-10层');
INSERT INTO `tbl_clue` VALUES ('9d4bfa41cd354ef5a993a3ac6197e22a', '马化腾', '先生', '06f5fc056eac41558a964f96daa7f27c', '腾旭', 'CEO', 'mahuaten@tencent.com', '45646144', 'www.tencent.com', '15715830811', '试图联系', '员工介绍', '李四', '2021-07-03 18:23:31', null, null, '腾讯游戏', '腾讯游戏', '2021-07-05', '深圳市高新科技园南区高新南一道飞亚达高科技大厦3-10层');
INSERT INTO `tbl_clue` VALUES ('a920b76a871c4de98225c22f92f8aaca', '李旎', '女士', '81fd645033d143628c3ee71b36c26968', 'bilibili', '哔哩哔哩副董事长兼COO', 'lini@gmail.com', '123456', 'www.bilibili.com', '15988248142', '已联系', '聊天', '叶尘', '2021-07-04 11:08:59', null, null, 'bilibili', 'bilibili', '2021-07-05', '上海市杨浦区政立路499号-10号楼');

-- ----------------------------
-- Table structure for tbl_clue_activity_relation
-- ----------------------------
DROP TABLE IF EXISTS `tbl_clue_activity_relation`;
CREATE TABLE `tbl_clue_activity_relation` (
  `id` char(32) NOT NULL,
  `clueId` char(32) DEFAULT NULL,
  `activityId` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_clue_activity_relation
-- ----------------------------
INSERT INTO `tbl_clue_activity_relation` VALUES ('21fc1b557ad142cd8394555203a36c5d', '47eb5910174a4fa7884e449a3a056cfd', '8f8a2d1dc66845439ef33d4433760892');
INSERT INTO `tbl_clue_activity_relation` VALUES ('2b473680896f4d7ca7e1e7dec957a542', 'a920b76a871c4de98225c22f92f8aaca', '7f0b67dd9dd246c199248fb386cc62c0');
INSERT INTO `tbl_clue_activity_relation` VALUES ('2c8c27305151450a81679653342166dd', 'a920b76a871c4de98225c22f92f8aaca', '66e15e548a0a4e719ef34659f68657b9');
INSERT INTO `tbl_clue_activity_relation` VALUES ('2c9eece96a684493a5027b48955e0824', 'a920b76a871c4de98225c22f92f8aaca', '781fb5d6745846b79a77d0a36f22df13');
INSERT INTO `tbl_clue_activity_relation` VALUES ('5328573dde97465c9f85060b06d1aed6', '93960bbaa6f14197b36c00c65f975810', '8f8a2d1dc66845439ef33d4433760892');
INSERT INTO `tbl_clue_activity_relation` VALUES ('bc96456900854868969ecf06af78be9f', '47eb5910174a4fa7884e449a3a056cfd', '0fd9f9e3cc9f4a00b9526b842332cfb6');
INSERT INTO `tbl_clue_activity_relation` VALUES ('c574f67cb5a44d328c9b9f17246c75ef', '47eb5910174a4fa7884e449a3a056cfd', 'c75c2f95efdb4644983620059cce69e9');

-- ----------------------------
-- Table structure for tbl_clue_remark
-- ----------------------------
DROP TABLE IF EXISTS `tbl_clue_remark`;
CREATE TABLE `tbl_clue_remark` (
  `id` char(32) NOT NULL,
  `noteContent` varchar(255) DEFAULT NULL,
  `createBy` varchar(255) DEFAULT NULL,
  `createTime` char(19) DEFAULT NULL,
  `editBy` varchar(255) DEFAULT NULL,
  `editTime` char(19) DEFAULT NULL,
  `editFlag` char(1) DEFAULT NULL,
  `clueId` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_clue_remark
-- ----------------------------
INSERT INTO `tbl_clue_remark` VALUES ('1caff960185d411c87930e64f8cde2d3', '备注一（马云的）', '叶尘', '2021-07-04 11:17:43', null, null, '0', '93960bbaa6f14197b36c00c65f975810');

-- ----------------------------
-- Table structure for tbl_contacts
-- ----------------------------
DROP TABLE IF EXISTS `tbl_contacts`;
CREATE TABLE `tbl_contacts` (
  `id` char(32) NOT NULL,
  `owner` char(32) DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `customerId` char(32) DEFAULT NULL,
  `fullName` varchar(255) DEFAULT NULL,
  `appellation` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `mphone` varchar(255) DEFAULT NULL,
  `job` varchar(255) DEFAULT NULL,
  `birth` char(10) DEFAULT NULL,
  `createBy` varchar(255) DEFAULT NULL,
  `createTime` char(19) DEFAULT NULL,
  `editBy` varchar(255) DEFAULT NULL,
  `editTime` char(19) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `contactSummary` varchar(255) DEFAULT NULL,
  `nextContactTime` char(10) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_contacts
-- ----------------------------
INSERT INTO `tbl_contacts` VALUES ('4cd267353c244328a0b5a8c4737b2fb1', '81fd645033d143628c3ee71b36c26968', '销售邮件', '4d1ffb9ee9284ab5bff90dbe6df71e78', '李旎', '女士', 'lini@gmail.com', '15988248142', '哔哩哔哩副董事长兼COO', null, '叶尘', '2021-07-06 10:37:47', null, null, 'bilibili', 'bilibili', '2021-07-17', '上海市杨浦区政立路499号-10号楼');
INSERT INTO `tbl_contacts` VALUES ('4cd267353c244328a0b5a8c4737b2fbc', '81fd645033d143628c3ee71b36c26968', '内部研讨会', '4d1ffb9ee9284ab5bff90dbe6df71e78', '陈睿', '先生', 'chenrui@gmail.com', '15715830811', 'bilibili董事长兼CEO', null, '叶尘', '2021-07-06 10:37:47', null, null, 'bilibili', 'bilibili', '2021-07-07', '上海市杨浦区政立路499号-10号楼');

-- ----------------------------
-- Table structure for tbl_contacts_activity_relation
-- ----------------------------
DROP TABLE IF EXISTS `tbl_contacts_activity_relation`;
CREATE TABLE `tbl_contacts_activity_relation` (
  `id` char(32) NOT NULL,
  `contactsId` char(32) DEFAULT NULL,
  `activityId` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_contacts_activity_relation
-- ----------------------------
INSERT INTO `tbl_contacts_activity_relation` VALUES ('919807f45a714213a1d63067ce51f319', '4cd267353c244328a0b5a8c4737b2fbc', '781fb5d6745846b79a77d0a36f22df13');
INSERT INTO `tbl_contacts_activity_relation` VALUES ('ab2c9237f5f344b193f1c585e1a53850', '4cd267353c244328a0b5a8c4737b2fbc', '66e15e548a0a4e719ef34659f68657b9');
INSERT INTO `tbl_contacts_activity_relation` VALUES ('c040998f2e7e40579efcb87e37c4a8fb', '4cd267353c244328a0b5a8c4737b2fbc', '7f0b67dd9dd246c199248fb386cc62c0');

-- ----------------------------
-- Table structure for tbl_contacts_remark
-- ----------------------------
DROP TABLE IF EXISTS `tbl_contacts_remark`;
CREATE TABLE `tbl_contacts_remark` (
  `id` char(32) NOT NULL,
  `noteContent` varchar(255) DEFAULT NULL,
  `createBy` varchar(255) DEFAULT NULL,
  `createTime` char(19) DEFAULT NULL,
  `editBy` varchar(255) DEFAULT NULL,
  `editTime` char(19) DEFAULT NULL,
  `editFlag` char(1) DEFAULT NULL,
  `contactsId` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_contacts_remark
-- ----------------------------
INSERT INTO `tbl_contacts_remark` VALUES ('0f44e8e2afdb4f959ea26cfe95d38734', '备注一（陈睿的）', '叶尘', '2021-07-04 11:17:40', null, null, null, '4cd267353c244328a0b5a8c4737b2fbc');
INSERT INTO `tbl_contacts_remark` VALUES ('26172b5f4e484f0cae9f66e5d97bcdeb', '备注三（陈睿的）', '李四', '2021-07-04 11:17:42', null, null, null, '4cd267353c244328a0b5a8c4737b2fbc');
INSERT INTO `tbl_contacts_remark` VALUES ('dfe0398bb22b470ea6764ea59336a030', '备注二（陈睿的）', '张三', '2021-07-04 11:17:41', null, null, null, '4cd267353c244328a0b5a8c4737b2fbc');

-- ----------------------------
-- Table structure for tbl_customer
-- ----------------------------
DROP TABLE IF EXISTS `tbl_customer`;
CREATE TABLE `tbl_customer` (
  `id` char(32) NOT NULL,
  `owner` char(32) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `createBy` varchar(255) DEFAULT NULL,
  `createTime` char(19) DEFAULT NULL,
  `editBy` varchar(255) DEFAULT NULL,
  `editTime` char(19) DEFAULT NULL,
  `contactSummary` varchar(255) DEFAULT NULL,
  `nextContactTime` char(10) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_customer
-- ----------------------------
INSERT INTO `tbl_customer` VALUES ('3aeb8c1414c944e2996c73503ca823e3', '81fd645033d143628c3ee71b36c26968', '嘉兴学院', null, null, '叶尘', '2021-07-06 16:09:41', null, null, '嘉兴学院运动会', '2021-07-31', null, null);
INSERT INTO `tbl_customer` VALUES ('4d1ffb9ee9284ab5bff90dbe6df71e71', '06f5fc056eac41558a964f96daa7f27c', 'bilibili1', null, null, null, null, null, null, null, null, null, null);
INSERT INTO `tbl_customer` VALUES ('4d1ffb9ee9284ab5bff90dbe6df71e72', '40f6cdea0bd34aceb77492a1656d9fb3', 'bilibili12', null, null, null, null, null, null, null, null, null, null);
INSERT INTO `tbl_customer` VALUES ('4d1ffb9ee9284ab5bff90dbe6df71e73', '06f5fc056eac41558a964f96daa7f27c', 'bilibili123', null, null, null, null, null, null, null, null, null, null);
INSERT INTO `tbl_customer` VALUES ('4d1ffb9ee9284ab5bff90dbe6df71e78', '81fd645033d143628c3ee71b36c26968', 'bilibili', 'www.bilibili.com', '123456', '叶尘', '2021-07-06 10:37:47', null, null, 'bilibili', '2021-07-07', 'bilibili', '上海市杨浦区政立路499号-10号楼');

-- ----------------------------
-- Table structure for tbl_customer_remark
-- ----------------------------
DROP TABLE IF EXISTS `tbl_customer_remark`;
CREATE TABLE `tbl_customer_remark` (
  `id` char(32) NOT NULL,
  `noteContent` varchar(255) DEFAULT NULL,
  `createBy` varchar(255) DEFAULT NULL,
  `createTime` char(19) DEFAULT NULL,
  `editBy` varchar(255) DEFAULT NULL,
  `editTime` char(19) DEFAULT NULL,
  `editFlag` char(1) DEFAULT NULL,
  `customerId` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_customer_remark
-- ----------------------------
INSERT INTO `tbl_customer_remark` VALUES ('09060f8061c542d08cb79fbb94c69bb1', '备注三（陈睿的）', '李四', '2021-07-04 11:17:42', null, null, '0', '4d1ffb9ee9284ab5bff90dbe6df71e78');
INSERT INTO `tbl_customer_remark` VALUES ('5dd150cf42474ac38565844181b0c822', '备注一（陈睿的）', '叶尘', '2021-07-04 11:17:40', null, null, '0', '4d1ffb9ee9284ab5bff90dbe6df71e78');
INSERT INTO `tbl_customer_remark` VALUES ('b153f318710340868c419052c2a39c2e', '备注二（陈睿的）', '张三', '2021-07-04 11:17:41', null, null, '0', '4d1ffb9ee9284ab5bff90dbe6df71e78');

-- ----------------------------
-- Table structure for tbl_dic_type
-- ----------------------------
DROP TABLE IF EXISTS `tbl_dic_type`;
CREATE TABLE `tbl_dic_type` (
  `code` varchar(255) NOT NULL COMMENT '����������������Ϊ�գ����ܺ������ġ�',
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_dic_type
-- ----------------------------
INSERT INTO `tbl_dic_type` VALUES ('appellation', '称呼', '');
INSERT INTO `tbl_dic_type` VALUES ('clueState', '线索状态', '');
INSERT INTO `tbl_dic_type` VALUES ('returnPriority', '回访优先级', '');
INSERT INTO `tbl_dic_type` VALUES ('returnState', '回访状态', '');
INSERT INTO `tbl_dic_type` VALUES ('source', '来源', '');
INSERT INTO `tbl_dic_type` VALUES ('stage', '阶段', '');
INSERT INTO `tbl_dic_type` VALUES ('transactionType', '交易类型', '');

-- ----------------------------
-- Table structure for tbl_dic_value
-- ----------------------------
DROP TABLE IF EXISTS `tbl_dic_value`;
CREATE TABLE `tbl_dic_value` (
  `id` char(32) NOT NULL COMMENT '����������UUID',
  `value` varchar(255) DEFAULT NULL COMMENT '����Ϊ�գ�����Ҫ��ͬһ���ֵ��������ֵ�ֵ�����ظ�������Ψһ�ԡ�',
  `text` varchar(255) DEFAULT NULL COMMENT '����Ϊ��',
  `orderNo` int(11) DEFAULT NULL,
  `typeCode` varchar(255) DEFAULT NULL COMMENT '���',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_dic_value
-- ----------------------------
INSERT INTO `tbl_dic_value` VALUES ('06e3cbdf10a44eca8511dddfc6896c55', '虚假线索', '虚假线索', '4', 'clueState');
INSERT INTO `tbl_dic_value` VALUES ('0fe33840c6d84bf78df55d49b169a894', '销售邮件', '销售邮件', '8', 'source');
INSERT INTO `tbl_dic_value` VALUES ('12302fd42bd349c1bb768b19600e6b20', '交易会', '交易会', '11', 'source');
INSERT INTO `tbl_dic_value` VALUES ('1615f0bb3e604552a86cde9a2ad45bea', '最高', '最高', '2', 'returnPriority');
INSERT INTO `tbl_dic_value` VALUES ('176039d2a90e4b1a81c5ab8707268636', '教授', '教授', '5', 'appellation');
INSERT INTO `tbl_dic_value` VALUES ('1e0bd307e6ee425599327447f8387285', '将来联系', '将来联系', '2', 'clueState');
INSERT INTO `tbl_dic_value` VALUES ('2173663b40b949ce928db92607b5fe57', '丢失线索', '丢失线索', '5', 'clueState');
INSERT INTO `tbl_dic_value` VALUES ('2876690b7e744333b7f1867102f91153', '未启动', '未启动', '1', 'returnState');
INSERT INTO `tbl_dic_value` VALUES ('29805c804dd94974b568cfc9017b2e4c', '07成交', '07成交', '7', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('310e6a49bd8a4962b3f95a1d92eb76f4', '试图联系', '试图联系', '1', 'clueState');
INSERT INTO `tbl_dic_value` VALUES ('31539e7ed8c848fc913e1c2c93d76fd1', '博士', '博士', '4', 'appellation');
INSERT INTO `tbl_dic_value` VALUES ('37ef211719134b009e10b7108194cf46', '01资质审查', '01资质审查', '1', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('391807b5324d4f16bd58c882750ee632', '08丢失的线索', '08丢失的线索', '8', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('3a39605d67da48f2a3ef52e19d243953', '聊天', '聊天', '14', 'source');
INSERT INTO `tbl_dic_value` VALUES ('474ab93e2e114816abf3ffc596b19131', '低', '低', '3', 'returnPriority');
INSERT INTO `tbl_dic_value` VALUES ('48512bfed26145d4a38d3616e2d2cf79', '广告', '广告', '1', 'source');
INSERT INTO `tbl_dic_value` VALUES ('4d03a42898684135809d380597ed3268', '合作伙伴研讨会', '合作伙伴研讨会', '9', 'source');
INSERT INTO `tbl_dic_value` VALUES ('59795c49896947e1ab61b7312bd0597c', '先生', '先生', '1', 'appellation');
INSERT INTO `tbl_dic_value` VALUES ('5c6e9e10ca414bd499c07b886f86202a', '高', '高', '1', 'returnPriority');
INSERT INTO `tbl_dic_value` VALUES ('67165c27076e4c8599f42de57850e39c', '夫人', '夫人', '2', 'appellation');
INSERT INTO `tbl_dic_value` VALUES ('68a1b1e814d5497a999b8f1298ace62b', '09因竞争丢失关闭', '09因竞争丢失关闭', '9', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('6b86f215e69f4dbd8a2daa22efccf0cf', 'web调研', 'web调研', '13', 'source');
INSERT INTO `tbl_dic_value` VALUES ('72f13af8f5d34134b5b3f42c5d477510', '合作伙伴', '合作伙伴', '6', 'source');
INSERT INTO `tbl_dic_value` VALUES ('7c07db3146794c60bf975749952176df', '未联系', '未联系', '6', 'clueState');
INSERT INTO `tbl_dic_value` VALUES ('86c56aca9eef49058145ec20d5466c17', '内部研讨会', '内部研讨会', '10', 'source');
INSERT INTO `tbl_dic_value` VALUES ('9095bda1f9c34f098d5b92fb870eba17', '进行中', '进行中', '3', 'returnState');
INSERT INTO `tbl_dic_value` VALUES ('954b410341e7433faa468d3c4f7cf0d2', '已有业务', '已有业务', '1', 'transactionType');
INSERT INTO `tbl_dic_value` VALUES ('966170ead6fa481284b7d21f90364984', '已联系', '已联系', '3', 'clueState');
INSERT INTO `tbl_dic_value` VALUES ('96b03f65dec748caa3f0b6284b19ef2f', '推迟', '推迟', '2', 'returnState');
INSERT INTO `tbl_dic_value` VALUES ('97d1128f70294f0aac49e996ced28c8a', '新业务', '新业务', '2', 'transactionType');
INSERT INTO `tbl_dic_value` VALUES ('9ca96290352c40688de6596596565c12', '完成', '完成', '4', 'returnState');
INSERT INTO `tbl_dic_value` VALUES ('9e6d6e15232549af853e22e703f3e015', '需要条件', '需要条件', '7', 'clueState');
INSERT INTO `tbl_dic_value` VALUES ('9ff57750fac04f15b10ce1bbb5bb8bab', '02需求分析', '02需求分析', '2', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('a70dc4b4523040c696f4421462be8b2f', '等待某人', '等待某人', '5', 'returnState');
INSERT INTO `tbl_dic_value` VALUES ('a83e75ced129421dbf11fab1f05cf8b4', '推销电话', '推销电话', '2', 'source');
INSERT INTO `tbl_dic_value` VALUES ('ab8472aab5de4ae9b388b2f1409441c1', '常规', '常规', '5', 'returnPriority');
INSERT INTO `tbl_dic_value` VALUES ('ab8c2a3dc05f4e3dbc7a0405f721b040', '05提案/报价', '05提案/报价', '5', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('b924d911426f4bc5ae3876038bc7e0ad', 'web下载', 'web下载', '12', 'source');
INSERT INTO `tbl_dic_value` VALUES ('c13ad8f9e2f74d5aa84697bb243be3bb', '03价值建议', '03价值建议', '3', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('c83c0be184bc40708fd7b361b6f36345', '最低', '最低', '4', 'returnPriority');
INSERT INTO `tbl_dic_value` VALUES ('db867ea866bc44678ac20c8a4a8bfefb', '员工介绍', '员工介绍', '3', 'source');
INSERT INTO `tbl_dic_value` VALUES ('e44be1d99158476e8e44778ed36f4355', '04确定决策者', '04确定决策者', '4', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('e5f383d2622b4fc0959f4fe131dafc80', '女士', '女士', '3', 'appellation');
INSERT INTO `tbl_dic_value` VALUES ('e81577d9458f4e4192a44650a3a3692b', '06谈判/复审', '06谈判/复审', '6', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('fb65d7fdb9c6483db02713e6bc05dd19', '在线商场', '在线商场', '5', 'source');
INSERT INTO `tbl_dic_value` VALUES ('fd677cc3b5d047d994e16f6ece4d3d45', '公开媒介', '公开媒介', '7', 'source');
INSERT INTO `tbl_dic_value` VALUES ('ff802a03ccea4ded8731427055681d48', '外部介绍', '外部介绍', '4', 'source');

-- ----------------------------
-- Table structure for tbl_tran
-- ----------------------------
DROP TABLE IF EXISTS `tbl_tran`;
CREATE TABLE `tbl_tran` (
  `id` char(32) NOT NULL,
  `owner` char(32) DEFAULT NULL,
  `money` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `expectedDate` char(10) DEFAULT NULL,
  `customerId` char(32) DEFAULT NULL,
  `stage` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `activityId` char(32) DEFAULT NULL,
  `contactsId` char(32) DEFAULT NULL,
  `createBy` varchar(255) DEFAULT NULL,
  `createTime` char(19) DEFAULT NULL,
  `editBy` varchar(255) DEFAULT NULL,
  `editTime` char(19) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `contactSummary` varchar(255) DEFAULT NULL,
  `nextContactTime` char(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_tran
-- ----------------------------
INSERT INTO `tbl_tran` VALUES ('005a57815a4a4a8a854bebd95a22bf9d', '81fd645033d143628c3ee71b36c26968', '1000', 'bmw', '2021-07-31', '4d1ffb9ee9284ab5bff90dbe6df71e78', '06谈判/复审', '已有业务', '交易会', '66e15e548a0a4e719ef34659f68657b9', '4cd267353c244328a0b5a8c4737b2fb1', '叶尘', '2021-07-06 16:11:48', '李四', '2021-07-07 15:36:54', 'bmw', 'bmw', '2021-07-12');
INSERT INTO `tbl_tran` VALUES ('47ffb63deab64f91a43e2b50cb2d2b84', '81fd645033d143628c3ee71b36c26968', '200000', 'bilibili 2022 最美的夜策划', '2021-08-01', '4d1ffb9ee9284ab5bff90dbe6df71e78', '01资质审查', '新业务', '内部研讨会', '781fb5d6745846b79a77d0a36f22df13', '4cd267353c244328a0b5a8c4737b2fbc', '叶尘', '2021-07-06 10:37:47', '李四', '2021-07-07 15:09:01', 'bilibili', 'bilibili', '2021-07-07');
INSERT INTO `tbl_tran` VALUES ('7a90aff60fef4a8abba39597e991d331', '06f5fc056eac41558a964f96daa7f27c', '10001', '交易一', '2021-08-03', '4d1ffb9ee9284ab5bff90dbe6df71e71', '01资质审查', '已有业务', null, null, null, '叶尘', '2021-07-06 16:09:42', null, null, null, null, null);
INSERT INTO `tbl_tran` VALUES ('7a90aff60fef4a8abba39597e991d332', '06f5fc056eac41558a964f96daa7f27c', '20001', '交易二', '2021-08-04', '4d1ffb9ee9284ab5bff90dbe6df71e73', '03价值建议', '新业务', null, null, null, '叶尘', '2021-07-06 16:09:43', null, null, null, null, null);
INSERT INTO `tbl_tran` VALUES ('7a90aff60fef4a8abba39597e991d333', '06f5fc056eac41558a964f96daa7f27c', '30001', '交易三', '2021-08-05', '4d1ffb9ee9284ab5bff90dbe6df71e71', '03价值建议', '已有业务', null, null, null, '叶尘', '2021-07-06 16:09:44', null, null, null, null, null);
INSERT INTO `tbl_tran` VALUES ('7a90aff60fef4a8abba39597e991d334', '06f5fc056eac41558a964f96daa7f27c', '40001', '交易四', '2021-08-06', '4d1ffb9ee9284ab5bff90dbe6df71e72', '01资质审查', '新业务', null, null, null, '叶尘', '2021-07-06 16:09:45', null, null, null, null, null);
INSERT INTO `tbl_tran` VALUES ('7a90aff60fef4a8abba39597e991d335', '40f6cdea0bd34aceb77492a1656d9fb3', '410000', '交易五', '2021-08-07', '4d1ffb9ee9284ab5bff90dbe6df71e73', '03价值建议', '新业务', null, null, null, '叶尘', '2021-07-06 16:09:46', null, null, null, null, null);
INSERT INTO `tbl_tran` VALUES ('7a90aff60fef4a8abba39597e991d336', '40f6cdea0bd34aceb77492a1656d9fb3', '500000', '交易六', '2021-08-08', '4d1ffb9ee9284ab5bff90dbe6df71e71', '03价值建议', '已有业务', null, null, null, '叶尘', '2021-07-06 16:09:47', null, null, null, null, null);
INSERT INTO `tbl_tran` VALUES ('7a90aff60fef4a8abba39597e991d337', '40f6cdea0bd34aceb77492a1656d9fb3', '1000', '交易七', '2021-08-09', '4d1ffb9ee9284ab5bff90dbe6df71e72', '06谈判/复审', '新业务', null, null, null, '叶尘', '2021-07-06 16:09:48', null, null, null, null, null);
INSERT INTO `tbl_tran` VALUES ('7a90aff60fef4a8abba39597e991d338', '81fd645033d143628c3ee71b36c26968', '200000', '嘉兴学院运动会', '2021-08-02', '3aeb8c1414c944e2996c73503ca823e3', '02需求分析', '新业务', '广告', 'da079ca3dc58451882f6574bd91cd7e7', '4cd267353c244328a0b5a8c4737b2fb1', '叶尘', '2021-07-06 16:09:41', '李四', '2021-07-07 15:47:53', '嘉兴学院运动会', '嘉兴学院运动会', '2021-07-31');

-- ----------------------------
-- Table structure for tbl_tran_history
-- ----------------------------
DROP TABLE IF EXISTS `tbl_tran_history`;
CREATE TABLE `tbl_tran_history` (
  `id` char(32) NOT NULL,
  `stage` varchar(255) DEFAULT NULL,
  `money` varchar(255) DEFAULT NULL,
  `expectedDate` char(10) DEFAULT NULL,
  `createTime` char(19) DEFAULT NULL,
  `createBy` varchar(255) DEFAULT NULL,
  `tranId` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_tran_history
-- ----------------------------
INSERT INTO `tbl_tran_history` VALUES ('084709fd759c496fa829105fb5250a75', '05提案/报价', '200000', '2021-07-31', '2021-07-07 15:02:11', '张三', '47ffb63deab64f91a43e2b50cb2d2b84');
INSERT INTO `tbl_tran_history` VALUES ('0a93fb0d9f1d4c2baabf870a081dc427', '02需求分析', '200000', '2021-07-31', '2021-07-07 15:47:53', '李四', '7a90aff60fef4a8abba39597e991d338');
INSERT INTO `tbl_tran_history` VALUES ('11eee317e9ea4dd087d9dd61ccd650b7', '04确定决策者', '1000', '2021-07-31', '2021-07-07 15:36:48', '李四', '005a57815a4a4a8a854bebd95a22bf9d');
INSERT INTO `tbl_tran_history` VALUES ('25e30033e6324fc4935b41c2ef712a1e', '08丢失的线索', '200000', '2021-07-31', '2021-07-07 15:07:03', '李四', '47ffb63deab64f91a43e2b50cb2d2b84');
INSERT INTO `tbl_tran_history` VALUES ('2b3ac19a948e4917a555086e46b97d79', '06谈判/复审', '200000', '2021-07-31', '2021-07-07 15:02:57', '张三', '47ffb63deab64f91a43e2b50cb2d2b84');
INSERT INTO `tbl_tran_history` VALUES ('431afa248db947b0a275e9ad69e73bd9', '05提案/报价', '200000', '2021-07-31', '2021-07-07 15:38:43', '李四', '7a90aff60fef4a8abba39597e991d338');
INSERT INTO `tbl_tran_history` VALUES ('4db7e6209de1423faa02e166634a87a2', '01资质审查', '200000', '2021-07-31', '2021-07-07 15:00:59', '叶尘', '47ffb63deab64f91a43e2b50cb2d2b84');
INSERT INTO `tbl_tran_history` VALUES ('58283a78e3ca443d87c2cdef7a55032b', '03价值建议', '200000', '2021-07-31', '2021-07-07 15:01:34', '叶尘', '47ffb63deab64f91a43e2b50cb2d2b84');
INSERT INTO `tbl_tran_history` VALUES ('69d30e28c6164aa08018b9a34e10c011', '06谈判/复审', '100000', '2021-07-22', '2021-07-06 10:37:50', '张三', '47ffb63deab64f91a43e2b50cb2d2b84');
INSERT INTO `tbl_tran_history` VALUES ('69d30e28c6164aa08018b9a34e10c012', '07成交', '10000', '2021-07-23', '2021-07-06 10:37:51', '李四', '47ffb63deab64f91a43e2b50cb2d2b84');
INSERT INTO `tbl_tran_history` VALUES ('69d30e28c6164aa08018b9a34e10c013', '01资质审查', '5000', '2021-07-24', '2021-07-06 10:37:52', '叶尘', '7a90aff60fef4a8abba39597e991d338');
INSERT INTO `tbl_tran_history` VALUES ('69d30e28c6164aa08018b9a34e10c01b', '05提案/报价', '200000', '2021-07-31', '2021-07-06 10:37:47', '叶尘', '47ffb63deab64f91a43e2b50cb2d2b84');
INSERT INTO `tbl_tran_history` VALUES ('7fa5a021628b4d5d8004b54fdc0cc9f8', '09因竞争丢失关闭', '200000', '2021-07-31', '2021-07-07 15:46:21', '李四', '7a90aff60fef4a8abba39597e991d338');
INSERT INTO `tbl_tran_history` VALUES ('98562248ca034319a16dccc40ca29859', '07成交', '1000', '2021-07-31', '2021-07-07 15:16:35', '李四', '005a57815a4a4a8a854bebd95a22bf9d');
INSERT INTO `tbl_tran_history` VALUES ('9e4d40d86ed1423dbc27b4aeca8eb83b', '06谈判/复审', '200000', '2021-07-31', '2021-07-07 15:40:44', '李四', '7a90aff60fef4a8abba39597e991d338');
INSERT INTO `tbl_tran_history` VALUES ('9f92d14e6687427e954c44fafec8de8d', '01资质审查', '200000', '2021-07-31', '2021-07-07 15:09:01', '李四', '47ffb63deab64f91a43e2b50cb2d2b84');
INSERT INTO `tbl_tran_history` VALUES ('a5fa4c6fb09d4d7cb537e550511da7ea', '07成交', '200000', '2021-07-31', '2021-07-07 15:05:00', '张三', '47ffb63deab64f91a43e2b50cb2d2b84');
INSERT INTO `tbl_tran_history` VALUES ('a7671f6a39a840a589fe67021e064de3', '08丢失的线索', '200000', '2021-07-31', '2021-07-07 15:47:11', '李四', '7a90aff60fef4a8abba39597e991d338');
INSERT INTO `tbl_tran_history` VALUES ('b41cbbfbaf1b4f63bec967663a5f61cf', '09因竞争丢失关闭', '200000', '2021-07-31', '2021-07-07 15:47:42', '李四', '7a90aff60fef4a8abba39597e991d338');
INSERT INTO `tbl_tran_history` VALUES ('b4379512757a4626a8ce7d32e1a3bdc3', '06谈判/复审', '200000', '2021-07-31', '2021-07-07 15:03:09', '张三', '47ffb63deab64f91a43e2b50cb2d2b84');
INSERT INTO `tbl_tran_history` VALUES ('c7200eab3938437b80e1708deb01cea6', '08丢失的线索', '200000', '2021-07-31', '2021-07-07 15:46:11', '李四', '7a90aff60fef4a8abba39597e991d338');
INSERT INTO `tbl_tran_history` VALUES ('d4d6775bcfde46a090e87c2568c92721', '03价值建议', '200000', '2021-07-31', '2021-07-07 15:41:01', '李四', '7a90aff60fef4a8abba39597e991d338');
INSERT INTO `tbl_tran_history` VALUES ('e16a2cbc0c484ae2849c55bb118b4509', '06谈判/复审', '1000', '2021-07-31', '2021-07-07 15:36:54', '李四', '005a57815a4a4a8a854bebd95a22bf9d');
INSERT INTO `tbl_tran_history` VALUES ('e2ba485c2f9e4fe496aaef2153c4f3ed', '01资质审查', '1000', '2021-07-31', '2021-07-07 15:36:35', '李四', '005a57815a4a4a8a854bebd95a22bf9d');

-- ----------------------------
-- Table structure for tbl_tran_remark
-- ----------------------------
DROP TABLE IF EXISTS `tbl_tran_remark`;
CREATE TABLE `tbl_tran_remark` (
  `id` char(32) NOT NULL,
  `noteContent` varchar(255) DEFAULT NULL,
  `createBy` varchar(255) DEFAULT NULL,
  `createTime` char(19) DEFAULT NULL,
  `editBy` varchar(255) DEFAULT NULL,
  `editTime` char(19) DEFAULT NULL,
  `editFlag` char(1) DEFAULT NULL,
  `tranId` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_tran_remark
-- ----------------------------

-- ----------------------------
-- Table structure for tbl_user
-- ----------------------------
DROP TABLE IF EXISTS `tbl_user`;
CREATE TABLE `tbl_user` (
  `id` char(32) NOT NULL COMMENT 'uuid\r\n            ',
  `loginAct` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `loginPwd` varchar(255) DEFAULT NULL COMMENT '���벻�ܲ������Ĵ洢���������ģ�MD5����֮�������',
  `email` varchar(255) DEFAULT NULL,
  `expireTime` char(19) DEFAULT NULL COMMENT 'ʧЧʱ��Ϊ�յ�ʱ���ʾ����ʧЧ��ʧЧʱ��Ϊ2018-10-10 10:10:10�����ʾ�ڸ�ʱ��֮ǰ���˻����á�',
  `lockState` char(1) DEFAULT NULL COMMENT '����״̬Ϊ��ʱ��ʾ���ã�Ϊ0ʱ��ʾ������Ϊ1ʱ��ʾ���á�',
  `deptno` char(4) DEFAULT NULL,
  `allowIps` varchar(255) DEFAULT NULL COMMENT '������ʵ�IPΪ��ʱ��ʾIP��ַ�������ޣ�������ʵ�IP������һ����Ҳ�����Ƕ���������IP��ַ��ʱ�򣬲��ð�Ƕ��ŷָ������IP��192.168.100.2����ʾ���û�ֻ����IP��ַΪ192.168.100.2�Ļ�����ʹ�á�',
  `createTime` char(19) DEFAULT NULL,
  `createBy` varchar(255) DEFAULT NULL,
  `editTime` char(19) DEFAULT NULL,
  `editBy` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_user
-- ----------------------------
INSERT INTO `tbl_user` VALUES ('06f5fc056eac41558a964f96daa7f27c', 'ls', '李四', '202cb962ac59075b964b07152d234b70', 'ls@163.com', '2021-11-27 21:50:05', '1', 'A001', '192.168.1.127.0.0.1,0:0:0:0:0:0:0:1', '2018-11-22 12:11:40', '李四', null, null);
INSERT INTO `tbl_user` VALUES ('40f6cdea0bd34aceb77492a1656d9fb3', 'zs', '张三', '202cb962ac59075b964b07152d234b70', 'zs@qq.com', '2021-11-30 23:50:55', '1', 'A001', '192.168.1.1,192.168.1.2,127.0.0.1,0:0:0:0:0:0:0:1', '2018-11-22 11:37:34', '张三', null, null);
INSERT INTO `tbl_user` VALUES ('81fd645033d143628c3ee71b36c26968', 'yc', '叶尘', '81dc9bdb52d04dc20036dbd8313ed055', 'yechen@163.com', '2021-11-30 23:50:55', '1', 'A002', '192.168.1.1,192.168.1.2,127.0.0.1,0:0:0:0:0:0:0:1', '2021-07-04 11:04:07', '张三', null, null);
