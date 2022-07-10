drop schema if exists studentmanagement;
create schema studentmanagement;
use studentmanagement;
create table setting (
setting_id INT not null AUTO_INCREMENT PRIMARY KEY,
type_id int not null,
setting_title varchar(255) not null,
setting_value int not null,
display_order int default 1,
description text null,
status bit default 1
)
ENGINE=InnoDB
AUTO_INCREMENT=0;
create table user (
user_id INT not null AUTO_INCREMENT PRIMARY KEY,
roll_number varchar(10) null,
full_name varchar(255) not null,
gender bit default 1,
date_of_birth datetime null,
email VARCHAR(50) not null,
password varchar(255) null,
mobile varchar(20) null,
avatar_link text null,
facebook_link text null,
role_id int not null,
status bit default 1,
uuid varchar(50) null,
FOREIGN KEY (role_id) REFERENCES setting(setting_id)
)
ENGINE=InnoDB
AUTO_INCREMENT=0;
create table subject(
subject_id INT not null AUTO_INCREMENT PRIMARY KEY,
subject_code varchar(10) not null,
subject_name varchar(255) not null,
author_id int not null,
description text null,
status bit default 1,
FOREIGN KEY (author_id) REFERENCES user(user_id)
)
ENGINE=InnoDB
AUTO_INCREMENT=0;
create table subject_setting(
setting_id INT not null AUTO_INCREMENT PRIMARY KEY,
subject_id int not null,
type_id int not null,
setting_title varchar(50),
setting_value int not null,
display_order int default 1,
description text null,
status bit default 1,
FOREIGN KEY (subject_id) REFERENCES subject(subject_id),
FOREIGN KEY (type_id) REFERENCES setting(setting_id)
)
ENGINE=InnoDB
AUTO_INCREMENT=0;
create table class(
class_id INT not null AUTO_INCREMENT PRIMARY KEY,
class_code varchar(10) not null,
trainer_id int not null,
subject_id int not null,
class_year int ,
class_term int not null,
block5_class bit default 0,
description text null,
status bit default 1,
gitlab_url varchar(255) null,
apiToken varchar(255) null,
FOREIGN KEY (subject_id) REFERENCES subject(subject_id),
FOREIGN KEY (trainer_id) REFERENCES user(user_id),
FOREIGN KEY (class_term) REFERENCES setting(setting_id)
)
ENGINE=InnoDB
AUTO_INCREMENT=0;
create table class_setting(
setting_id INT not null AUTO_INCREMENT PRIMARY KEY,
class_id int not null,
type_id int not null,
setting_title varchar(50),
setting_value int not null,
display_order int default 1,
description text null,
status bit default 1,
gitlab_url varchar(255) null,
apiToken varchar(255) null,
FOREIGN KEY (class_id) REFERENCES class(class_id),
FOREIGN KEY (type_id) REFERENCES setting(setting_id)
)
ENGINE=InnoDB
AUTO_INCREMENT=0;
create table team(
team_id INT not null AUTO_INCREMENT PRIMARY KEY,
class_id int not null,
team_name varchar(50) not null,
topic_code varchar(10) null,
topic_name varchar(50) null ,
gitlab_url varchar(255) null,
status bit default 1,
apiToken varchar(255) null,
FOREIGN KEY (class_id) REFERENCES class(class_id)
)
ENGINE=InnoDB
AUTO_INCREMENT=0;
create table class_user(
class_id int not null,
team_id int not null,
user_id int not null,
team_leader bit default 0,
dropout_date datetime null,
user_notes text null,
ongoing_eval double default 0,
final_pres_eval double default 0,
final_topic_eval double default 0,
status bit default 0,
FOREIGN KEY (team_id) REFERENCES team(team_id),
FOREIGN KEY (class_id) REFERENCES class(class_id),
FOREIGN KEY (user_id) REFERENCES user(user_id)
)
ENGINE=InnoDB
AUTO_INCREMENT=0;
create table feature(
feature_id INT not null AUTO_INCREMENT PRIMARY KEY,
team_id int not null,
feature_name varchar(50) not null ,
status bit default 1,
description text null,
FOREIGN KEY (team_id) REFERENCES team(team_id)
)
ENGINE=InnoDB
AUTO_INCREMENT=0;
create table `function`(
function_id INT not null AUTO_INCREMENT PRIMARY KEY,
team_id int not null,
function_name varchar(50) not null ,
feature_id int not null,
access_roles varchar(50) default '1' ,
description text null,
complexity_id int not null,
owner_id int not null,
priority int default 1,
status int,
FOREIGN KEY (status) REFERENCES class_setting(setting_id),
FOREIGN KEY (team_id) REFERENCES team(team_id),
FOREIGN KEY (feature_id) REFERENCES feature(feature_id),
FOREIGN KEY (owner_id) REFERENCES user(user_id),
FOREIGN KEY (complexity_id) REFERENCES subject_setting(setting_id)
)
ENGINE=InnoDB
AUTO_INCREMENT=0;
create table iteration(
iteration_id INT not null AUTO_INCREMENT PRIMARY KEY,
subject_id int not null,
iteration_name varchar(50) not null ,
duration int null,
description text null,
status bit default 1,
FOREIGN KEY (subject_id) REFERENCES subject(subject_id)
)
ENGINE=InnoDB
AUTO_INCREMENT=0;
create table milestone(
milestone_id INT not null AUTO_INCREMENT PRIMARY KEY,
milestone_name varchar(50) not null,
iteration_id int null,
class_id int not null,
from_date datetime default now(),
to_date datetime null,
status int,
FOREIGN KEY (status) REFERENCES class_setting(setting_id),
FOREIGN KEY (iteration_id) REFERENCES iteration(iteration_id),
FOREIGN KEY (class_id) REFERENCES class(class_id)
)
ENGINE=InnoDB
AUTO_INCREMENT=0;
create table tracking(
tracking_id INT not null AUTO_INCREMENT PRIMARY KEY,
milestone_id int not null,
function_id int not null,
assigner_id int not null,
assignee_id int not null,
tracking_note text null,
status int,
FOREIGN KEY (status) REFERENCES class_setting(setting_id),
FOREIGN KEY (milestone_id) REFERENCES milestone(milestone_id),
FOREIGN KEY (function_id) REFERENCES `function`(function_id),
FOREIGN KEY (assigner_id) REFERENCES user(user_id),
FOREIGN KEY (assignee_id) REFERENCES user(user_id)
)
ENGINE=InnoDB
AUTO_INCREMENT=0;
create table update_tracking(
update_id INT not null AUTO_INCREMENT PRIMARY KEY,
tracking_id int not null,
update_date datetime default now(),
milestone_id int not null,
update_note text null,
FOREIGN KEY (milestone_id) REFERENCES milestone(milestone_id),
FOREIGN KEY (tracking_id) REFERENCES tracking(tracking_id)
)
ENGINE=InnoDB
AUTO_INCREMENT=0;
create table loc_evaluation(
evaluation_id INT not null AUTO_INCREMENT PRIMARY KEY,
evaluation_time datetime default now(),
evaluation_note text null,
complexity_id int not null,
quality_id int not null,
tracking_id int not null,
FOREIGN KEY (tracking_id) REFERENCES tracking(tracking_id),
FOREIGN KEY (complexity_id) REFERENCES subject_setting(setting_id),
FOREIGN KEY (quality_id) REFERENCES subject_setting(setting_id)
)
ENGINE=InnoDB
AUTO_INCREMENT=0;
create table iteration_evaluation(
evaluation_id INT not null AUTO_INCREMENT PRIMARY KEY,
iteration_id int not null,
class_id int not null,
team_id int not null,
user_id int not null,
bonus int default 0,
grade int default 0,
note text null,
FOREIGN KEY (iteration_id) REFERENCES iteration(iteration_id),
FOREIGN KEY (class_id) REFERENCES class(class_id),
FOREIGN KEY (team_id) REFERENCES team(team_id),
FOREIGN KEY (user_id) REFERENCES user(user_id)
)
ENGINE=InnoDB
AUTO_INCREMENT=0;
create table issue(
issue_id INT not null AUTO_INCREMENT PRIMARY KEY,
assignee_id int not null,
issue_title varchar(50) not null null,
description text null,
gitlab_id int null,
gitlab_url varchar(255) null,
created_at datetime default now(),
due_date datetime null,
team_id int not null,
milestone_id int not null,
function_id int not null,
status int not null,
label int null,
FOREIGN KEY (assignee_id) REFERENCES user(user_id),
FOREIGN KEY (team_id) REFERENCES team(team_id),
FOREIGN KEY (function_id) REFERENCES `function`(function_id),
FOREIGN KEY (milestone_id) REFERENCES milestone(milestone_id),
FOREIGN KEY (label) REFERENCES class_setting(setting_id),
FOREIGN KEY (status) REFERENCES class_setting(setting_id)
)
ENGINE=InnoDB
AUTO_INCREMENT=0;
create table evaluation_criteria(
criteria_id INT not null AUTO_INCREMENT PRIMARY KEY,
iteration_id int not null,
criteria_title nvarchar(60) null,
criteria_description TEXT null,
evaluation_weight double null,
team_evaluation int default 1,
criteria_order int default 1,
max_loc int not null,
status int default 1,
FOREIGN KEY (iteration_id) REFERENCES iteration(iteration_id)
)
ENGINE=InnoDB
AUTO_INCREMENT=0;
create table member_evaluation(
member_eva_id INT not null AUTO_INCREMENT PRIMARY KEY,
evaluation_id int not null,
criteria_id int not null,
converted_loc int not null,
grade int default 0,
note text null,
FOREIGN KEY (evaluation_id) REFERENCES iteration_evaluation(evaluation_id),
FOREIGN KEY (criteria_id) REFERENCES evaluation_criteria(criteria_id)
)
ENGINE=InnoDB
AUTO_INCREMENT=0;
create table team_evaluation(
team_eva_id INT not null AUTO_INCREMENT PRIMARY KEY,
evaluation_id int not null,
criteria_id int not null,
team_id int not null,
grade int default 0,
note text null,
FOREIGN KEY (evaluation_id) REFERENCES iteration_evaluation(evaluation_id),
FOREIGN KEY (criteria_id) REFERENCES evaluation_criteria(criteria_id),
FOREIGN KEY (team_id) REFERENCES team(team_id)
)
ENGINE=InnoDB
AUTO_INCREMENT=0;
DELIMITER $$
CREATE PROCEDURE `getUserByEmail`(IN email varchar(50))
BEGIN
  SELECT * FROM user
  WHERE user.email = email;
END$$
DELIMITER ;
INSERT INTO `studentmanagement`.`setting` (`type_id`, `setting_title`, `setting_value`, `display_order`, `status`,`description`) 
VALUES (1, 'Admin', 1, 1, 1,'/class,/profile,/classUser,/dashBoard,/feature,/tracking,/team,/iteration,/subjectSetting,/feature,/criteria,/setting,/subject,/user'),
(1, 'Subject Manager', 2, 2, 1,'/class,/profile,/classUser,/dashBoard,/feature,/tracking,/team,/iteration,/subjectSetting,/feature,/criteria,/setting,/subject,/user'),
(1, 'Teacher', 3, 3, 1,'/class,/profile,/classUser,/dashBoard,/feature,/tracking,/team,/iteration,/subjectSetting,/feature,/criteria'),
(1, 'Student', 4, 4, 1,'/class,/profile,/classUser,/dashBoard,/feature,/tracking'),
(2, 'SPR', 1, 1, 1,null),
(2, 'SUM', 2, 2, 1,null),
(2, 'FALL', 3, 3, 1,null),
(3, 'Issue Type',1,1,1,null),
(3,'Issue Status',2,2,1,null),
(3,'Function Status',3,3,1,null),
(4, 'Complexity', 1, 1, 1,null),
(4, 'Quality', 2, 2, 1,null);

INSERT INTO `studentmanagement`.`user` (`full_name`, `email`, `password`, `role_id`) VALUES ('Admin', 'admin@fu.edu.vn', '$2a$05$f7YNEb/WlRmKkAtNI/wcvOA5d7OKr9cgsmsifpb3wVoempJXn7ME6', 1);

INSERT INTO `studentmanagement`.`user` (`full_name`, `email`, `password`, `role_id`) VALUES ('Author1', 'author1@fu.edu.vn', '$2a$05$f7YNEb/WlRmKkAtNI/wcvOA5d7OKr9cgsmsifpb3wVoempJXn7ME6', 2);
INSERT INTO `studentmanagement`.`user` (`full_name`, `email`, `password`, `role_id`) VALUES ('Author2', 'author2@fu.edu.vn', '$2a$05$f7YNEb/WlRmKkAtNI/wcvOA5d7OKr9cgsmsifpb3wVoempJXn7ME6', 2);
INSERT INTO `studentmanagement`.`user` (`full_name`, `email`, `password`, `role_id`) VALUES ('Author3', 'author3@fu.edu.vn', '$2a$05$f7YNEb/WlRmKkAtNI/wcvOA5d7OKr9cgsmsifpb3wVoempJXn7ME6', 2);
INSERT INTO `studentmanagement`.`user` (`full_name`, `email`, `password`, `role_id`) VALUES ('Author4', 'author4@fu.edu.vn', '$2a$05$f7YNEb/WlRmKkAtNI/wcvOA5d7OKr9cgsmsifpb3wVoempJXn7ME6', 2);
INSERT INTO `studentmanagement`.`user` (`full_name`, `email`, `password`, `role_id`) VALUES ('Author5', 'author5@fu.edu.vn', '$2a$05$f7YNEb/WlRmKkAtNI/wcvOA5d7OKr9cgsmsifpb3wVoempJXn7ME6', 2);
INSERT INTO `studentmanagement`.`user` (`full_name`, `email`, `password`, `role_id`) VALUES ('Author6', 'author6@fu.edu.vn', '$2a$05$f7YNEb/WlRmKkAtNI/wcvOA5d7OKr9cgsmsifpb3wVoempJXn7ME6', 2);
INSERT INTO `studentmanagement`.`user` (`full_name`, `email`, `password`, `role_id`) VALUES ('Author7', 'author7@fu.edu.vn', '$2a$05$f7YNEb/WlRmKkAtNI/wcvOA5d7OKr9cgsmsifpb3wVoempJXn7ME6', 2);

INSERT INTO `studentmanagement`.`user` (`full_name`, `email`, `password`, `role_id`) VALUES ('Teacher1', 'teacher1@fu.edu.vn', '$2a$05$f7YNEb/WlRmKkAtNI/wcvOA5d7OKr9cgsmsifpb3wVoempJXn7ME6', 3);
INSERT INTO `studentmanagement`.`user` (`full_name`, `email`, `password`, `role_id`) VALUES ('Teacher2', 'teacher2@fu.edu.vn', '$2a$05$f7YNEb/WlRmKkAtNI/wcvOA5d7OKr9cgsmsifpb3wVoempJXn7ME6', 3);
INSERT INTO `studentmanagement`.`user` (`full_name`, `email`, `password`, `role_id`) VALUES ('Teacher3', 'teacher3@fu.edu.vn', '$2a$05$f7YNEb/WlRmKkAtNI/wcvOA5d7OKr9cgsmsifpb3wVoempJXn7ME6', 3);
INSERT INTO `studentmanagement`.`user` (`full_name`, `email`, `password`, `role_id`) VALUES ('Teacher4', 'teacher4@fu.edu.vn', '$2a$05$f7YNEb/WlRmKkAtNI/wcvOA5d7OKr9cgsmsifpb3wVoempJXn7ME6', 3);
INSERT INTO `studentmanagement`.`user` (`full_name`, `email`, `password`, `role_id`) VALUES ('Teacher5', 'teacher5@fu.edu.vn', '$2a$05$f7YNEb/WlRmKkAtNI/wcvOA5d7OKr9cgsmsifpb3wVoempJXn7ME6', 3);
INSERT INTO `studentmanagement`.`user` (`full_name`, `email`, `password`, `role_id`) VALUES ('Teacher6', 'teacher6@fu.edu.vn', '$2a$05$f7YNEb/WlRmKkAtNI/wcvOA5d7OKr9cgsmsifpb3wVoempJXn7ME6', 3);


INSERT INTO `studentmanagement`.`user` (`full_name`,`gender`,`roll_number`, `email`, `password`, `role_id`) VALUES ('Trần Thùy Trang',0,'he163009', 'trangtthe163009@fpt.edu.vn', '$2a$05$f7YNEb/WlRmKkAtNI/wcvOA5d7OKr9cgsmsifpb3wVoempJXn7ME6', 4);
INSERT INTO `studentmanagement`.`user` (`full_name`,`gender`,`roll_number`, `email`, `password`, `role_id`) VALUES ('Lê Thành Đạt',1,'he163394', 'datlthe163394@fpt.edu.vn', '$2a$05$f7YNEb/WlRmKkAtNI/wcvOA5d7OKr9cgsmsifpb3wVoempJXn7ME6', 4);
INSERT INTO `studentmanagement`.`user` (`full_name`,`gender`,`roll_number`, `email`, `password`, `role_id`) VALUES ('Nguyễn Thái Dương',1, 'HE163033','duongnthe163033@fpt.edu.vn', '$2a$05$f7YNEb/WlRmKkAtNI/wcvOA5d7OKr9cgsmsifpb3wVoempJXn7ME6', 4);
INSERT INTO `studentmanagement`.`user` (`full_name`,`gender`,`roll_number`, `email`, `password`, `role_id`) VALUES ('Lương Ngọc Ánh',0,'he163541', 'anhlnhe163541@fpt.edu.vn', '$2a$05$f7YNEb/WlRmKkAtNI/wcvOA5d7OKr9cgsmsifpb3wVoempJXn7ME6', 4);
INSERT INTO `studentmanagement`.`user` (`full_name`,`gender`,`roll_number`, `email`, `password`, `role_id`) VALUES ('Lê Bảo Duy',1,'HE163097', 'duylbhe163097@fpt.edu.vn', '$2a$05$f7YNEb/WlRmKkAtNI/wcvOA5d7OKr9cgsmsifpb3wVoempJXn7ME6', 4);
/*
-- Query: SELECT * FROM studentmanagement.subject
-- Date: 2022-06-10 10:27
*/
INSERT INTO `studentmanagement`.`subject` (`subject_id`,`subject_code`,`subject_name`,`author_id`,`description`,`status`) VALUES (1,'CEA201','Computer Organization and Architecture_Tổ chức và Kiến trúc máy tính',3,'This course in an introduction to computer architecture and organization. It will cover topics in both the physical design of the computer (organization) and the logical design of the computer (architecture). The main contents include the organization of a simple stored-program computer: CPU, busses and memory; Instruction sets, machine code, and assembly language; Conventions for assembly language generated by compilers; Floating-point number representation; Hardware organization of simple processors; Address translation and virtual memory; Very introductory examples of input/output devices, interrupt handling and multi-tasking systems.',1);
INSERT INTO `studentmanagement`.`subject` (`subject_id`,`subject_code`,`subject_name`,`author_id`,`description`,`status`) VALUES (2,'CSD201','Data Structures and Algorithm_Cấu trúc dữ liệu và giải thuật',3,'  Knowledge: Understand (ABET e)\r\n- the connection between data structures and their algorithms, including an analysis of algorithms\' complexity;\r\n- data structurre in the context of object-oriented program design;\r\n- how data structure are implemented in an OO programming language such as Java',1);
INSERT INTO `studentmanagement`.`subject` (`subject_id`,`subject_code`,`subject_name`,`author_id`,`description`,`status`) VALUES (3,'CSI104','Introduction to Computer Science_Nhập môn khoa học máy tính',2,'	This course provides an overview of computer Fundamentals. Topics cover all areas of computer science in breadth such as computer organization, network, operating system, data structure , file structure, social and ethical issues.',1);
INSERT INTO `studentmanagement`.`subject` (`subject_id`,`subject_code`,`subject_name`,`author_id`,`description`,`status`) VALUES (4,'DBI202','Database Systems_Các hệ cơ sở dữ liệu',3,'- Knowledge about database systems has become an essential part of an education in computer science because database management has evolved from a specialized computer application to a central component of a modern computing environment. - The content of this course includes aspects of database management basic concepts, database design, database languages, and database-system implementation. Basing on these contents, the course emphasizes on how to organize, maintain and retrieve efficiently data and information from a DBMS.',1);
INSERT INTO `studentmanagement`.`subject` (`subject_id`,`subject_code`,`subject_name`,`author_id`,`description`,`status`) VALUES (5,'IOT102','Internet of Things_Internet vạn vật',2,'The content includes basic concepts and applications of IoT, practical exercises on the learning KIT.',1);
INSERT INTO `studentmanagement`.`subject` (`subject_id`,`subject_code`,`subject_name`,`author_id`,`description`,`status`) VALUES (6,'JPD113','Tiếng Nhật sơ cấp 1-A1.1 (Elementary Japanese 1- A1.1)',2,'Nội dung học bao gồm: 1) Nhập môn tiếng Nhật: Chữ cái; chào hỏi cơ bản...- Chữ mềm (hiragana)',1);
INSERT INTO `studentmanagement`.`subject` (`subject_id`,`subject_code`,`subject_name`,`author_id`,`description`,`status`) VALUES (7,'JPD123','Tiếng Nhật sơ cấp 1-A1.2 (Elementary Japanese 1-A1.2)',3,'Các bài học chính (bài 4 đến 7) (giáo trình Dekiru Nihongo - Beginner)',1);
INSERT INTO `studentmanagement`.`subject` (`subject_id`,`subject_code`,`subject_name`,`author_id`,`description`,`status`) VALUES (8,'LAB211','OOP with Java Lab_Thực hành OOP với Java',4,'This course focuses on basic problems related to Java programming skills. Students are required to implement all assignments by him/her self in lab rooms.',1);
INSERT INTO `studentmanagement`.`subject` (`subject_id`,`subject_code`,`subject_name`,`author_id`,`description`,`status`) VALUES (9,'MAD101','Discrete mathematics_Toán rời rạc',2,'Concepts of logical expressions & predicate logic. The method of induction and recursive definition.  Concepts of algorithms, recursive algorithms, the complexity. Recurrence relations and divide-and-conquer algorithms. Application of integers and congruence in information technology.  Set structure and map, counting principles and combinatorics concepts.',1);
INSERT INTO `studentmanagement`.`subject` (`subject_id`,`subject_code`,`subject_name`,`author_id`,`description`,`status`) VALUES (10,'MAE101','Mathematics for Engineering_Toán cho ngành kỹ thuật',6,'  ',1);
INSERT INTO `studentmanagement`.`subject` (`subject_id`,`subject_code`,`subject_name`,`author_id`,`description`,`status`) VALUES (11,'MAS291','Statistics & Probability_Xác suất thống kê',5,'The frequently used probability distributions. The basics of descriptive statistics The fundamental principles of probability and their applications',1);
INSERT INTO `studentmanagement`.`subject` (`subject_id`,`subject_code`,`subject_name`,`author_id`,`description`,`status`) VALUES (12,'NWC203C','Computer Networking_Mạng máy tính',2,'  This specialization is developed for seniors and fresh graduate students to understand fundamental network architecture concepts and their impacts on cyber security, to develop skills and techniques required for network protocol design, and prepare for a future of constant change through exposure to network design alternatives. Students will require a prior knowledge of C programming, an understanding of math probability and a computer science background is a plus.\r\n\r\nFinal Exam is included of Final Theory Exam (TE) & Final Practical Exam (PE): 100%\r\nStudent gets 0.25 bonus points for each course completed on time. The total bonus point is not greater than 1.\r\nCompletion Criteria: Final TE Score >=4 & Final PE Score >=4 & ((Final TE Score + Final PE Score)/2 + bonus) >= 5\r\nIn the case: (5 > Final TE Score >=4) & (5 > Final PE Score >=4) & ((Final TE Score + Final PE Score)/2 + bonus) < 5, the student can choose to take the resit of both TE & PE OR just either TE or PE.',1);
INSERT INTO `studentmanagement`.`subject` (`subject_id`,`subject_code`,`subject_name`,`author_id`,`description`,`status`) VALUES (13,'OSG202','Operating System_Hệ điều hành',5,'  At the end of this course, students will be able to perceive:\r\n1) Background knowledge: (ABET e)\r\n-The role of operating system,\r\n- important OS concepts,\r\n- the mechanism of operating system, and\r\n- main problems of Operating system.\r\n2) Practice skills: (ABET k)\r\n- Using basic shell command in Linux system fluently.\r\n- Fundamental of shell, C language on Linux.\r\n- Main problems of Operating system through some simulative exercises.\r\n3) Information searching, reading and selection skills (ABET i)\r\n4) Working in group, documenting and presenation skills (ABET g)',1);
INSERT INTO `studentmanagement`.`subject` (`subject_id`,`subject_code`,`subject_name`,`author_id`,`description`,`status`) VALUES (14,'PRF192','Programming Fundamentals_Cơ sở lập trình',3,'  Understand basics of information theory, computer system and methods of software development, focus on function-oriented programming design, coding, testing and discipline in programming.\r\nExplain basic concepts of programming, function-oriented programming design, modularity, understand and coding programs using C\r\nUpon completing the course, student should have:\r\n1. Knowledge: (ABET e)\r\n- Explain the way to solve a real problem using computer .\r\n- Understand the basic concepts of information theory, computer system, and software development.\r\n- Understand the basic concepts of programming, focus on procedure programming, testing and debugging, unit testing\r\n2. Skills in programming: (ABET k)\r\n- Read and understand the simple C programs;\r\n- Solve real problems using C\r\n3. Apply learning methods effectively: (ABET i)\r\n- academic reading\r\n- individual and team work behaviors',1);
INSERT INTO `studentmanagement`.`subject` (`subject_id`,`subject_code`,`subject_name`,`author_id`,`description`,`status`) VALUES (15,'PRJ301','Java Web Application Development_Phát triển ứng dụng Java we',4,'  By the end of this course Students will be able to:\r\na) Knowledge: (what will students know?)\r\n• Understand the core technologies of Java web programming:\r\n- Servlet and JSP\r\n- Scope of sharing state (session, application, request,page)\r\n- JSP Tags, JSTL, Customtags\r\n- Filtering\r\n• Know how to develop and deploy your own websites using Java\r\n• Understand and be able to apply MVC architecture for the web\r\nb) Skills: (what will students be able to do?)\r\n• Basic Web application development applying MVC Design Pattern using Servlet/Filter as Controller',1);
INSERT INTO `studentmanagement`.`subject` (`subject_id`,`subject_code`,`subject_name`,`author_id`,`description`,`status`) VALUES (16,'PRO192','Object-Oriented Programming_Lập trình hướng đối tượng',6,'  -This subject introduces the student to object-oriented programming. The student learns to build reusable objects, encapsulate data and logic within a class, inherit one class from another and implement polymorphism.\r\n- Compose technical documentation of a Java program using internal comments\r\n- Adhere to object-oriented programming principles including encapsulation, polymorphism and inheritance when writing program code\r\n- Trace the execution of Java program logic to determine what a program does or to validate the correctness of a program  ',1);
INSERT INTO `studentmanagement`.`subject` (`subject_id`,`subject_code`,`subject_name`,`author_id`,`description`,`status`) VALUES (17,'SSG104','Communication and In-Group Working Skills_Kỹ năng giao tiếp và cộng tác',4,'This course covers both working in groups and communication skills. The course covers theories of communication, working in group, and activities for students to practice applying the theories in academic and working contexts.',1);
INSERT INTO `studentmanagement`.`subject` (`subject_id`,`subject_code`,`subject_name`,`author_id`,`description`,`status`) VALUES (18,'SSL101C','Academic Skills for University Success_Kỹ năng học tập ở Đại học',2,'  Upon finishing the course, students can:\r\n1) Knowledge: Understand\r\n- Method to develop your Information & Digital Literacy Skills\r\n- Method to develop your Problem Solving and Creativity Skills\r\n- How to develop your Critical Thinking Skills\r\n- How to develop your Communication Skills\r\n2) Able to (ABET)\r\n- Access, search, filter, manage and organize Information by using a variety of digital tools, from wide variety of source for use in academic study.\r\n- Critically evaluate the reliability of sources and use digital tools for referencing in order to avoid plagiarism.\r\n- Demonstrate awareness of ethical issues related to academic integrity surrounding the access and use of information\r\n- Develop a toolkit to be able to identify real problems and goals within ill-defined problem & Recognize and apply analytical & creative problem solving technique\r\n- Use a variety of thinking tools to improve critical thinking\r\n- Identify types of argument, and bias within arguments\r\n- Demonstrate, negotiate, and further understanding through spoken, written, visual, and conversational modes\r\n- Effectively formulate arguments and communicate research findings through the process of researching, composing, and editing\r\n3) Others: (ABET)\r\n- Improve study skills (academic reading, information searching, ...)',1);
INSERT INTO `studentmanagement`.`subject` (`subject_id`,`subject_code`,`subject_name`,`author_id`,`description`,`status`) VALUES (19,'SWE201C','Introduction to Software Engineering_Nhập môn kỹ thuật phần mềm',5,' SWE201c is for people who are new to software engineering. It\'s also for those who have already developed software, but wish to gain a deeper understanding of the underlying context and theory of software development practices.\r\n\r\nAt the end of this course, we expect learners to be able to:\r\n\r\n1.) Build high-quality and secure software using SDLC methodologies such as agile, lean, and traditional/waterfall.\r\n\r\n2.) Analyze a software development team\'s SDLC methodology and make recommendations for improvements.\r\n\r\n3.) Compare and contrast software development methodologies with respect to environmental, organizational, and product constraints.',1);
INSERT INTO `studentmanagement`.`subject` (`subject_id`,`subject_code`,`subject_name`,`author_id`,`description`,`status`) VALUES (20,'SWP391','Software development project_Dự án phát triển phần mềm',8,'  This course focuses on basic problems related to Java or .NET web programming skills (just based on the basic Java or .NET technologies to build MVC code framework, using the available MVC frameworks is not allowed). Students are required to implement the project in the lab rooms as assigned by the teacher (mentor). The team size limits at 3-4 students, appointed by the teacher (mentor)\r\nAfter 30 slots in SWP391, students will be able to achieve Java or .NET web programing proficiency with the following skills by practicing with other members in the assigned team\r\n- Proficiency in common web techniques and basic Java Web skills (JSP, Servlet, JDBC) or .NET Web skills (ASP.NET, ADO.NET)\r\n- Proficiency in front end skills (HTML, CSS, JS) require for industry\r\n- Proficiency in SQL skills require for industry\r\n- Analyze & design the solution following the object oriented models\r\n- Co-ordinate with the team to complete the works in the form of a project\r\nDetails could be found in the \"Appendix 2\" sheet (Course Learning Outcomes)',1);
INSERT INTO `studentmanagement`.`subject` (`subject_id`,`subject_code`,`subject_name`,`author_id`,`description`,`status`) VALUES (21,'SWR302','Software Requirement_Yêu cầu phần mềm',7,' This course is a model-based introduction to RE, providing the conceptual background and terminology on RE, addressing a variety of techniques for requirements development including Analysis and Requirements Elicitation; Requirements Evaluation; Requirements Specification and Documentation; Requirements Quality Assurance. To implement these frameworks, student will be learnt how to find appropriate customer representatives, elicit requirements from them, and document user requirements, business rules, functional requirements, data requirements, and nonfunctional requirements.\r\nThe numerous visual models that will be represented to illustrate the requirements from various perspectives to supplement natural-language text. Other contents recommend the most effective requirements approaches for various specific classes of projects: agile projects developing products of any type, enhancement and replacement projects, projects that incorporate packaged solutions, outsourced projects, business process automation projects, business analytics projects, and embedded and other real-time systems.',1);
INSERT INTO `studentmanagement`.`subject` (`subject_id`,`subject_code`,`subject_name`,`author_id`,`description`,`status`) VALUES (22,'SWT301','Software Testing_Kiểm thử phần mềm',7,'  • General concepts about software testing\r\n• Testing techniques aimed at assuring that appropriate functionality has been implemented correctly in the software system or product, including: a) black box or functional testing, b) clear box or structural testing, c) usage-based statistical testing.\r\nThese testing techniques are organized by their underlying models, including lists, partitions and equivalent classes, finite-state machines.\r\n• Test activities, management, and related issues, such as testing sub-phases, team organization, testing process, people\'s roles and responsibilities, test automation, etc., will also be discussed.\r\n• Other testing, verification and validation techniques…',1);
INSERT INTO `studentmanagement`.`subject` (`subject_id`,`subject_code`,`subject_name`,`author_id`,`description`,`status`) VALUES (23,'WED201C','Web Design_Thiết kế we',4,'  	Upon finishing the course, students can:\r\n1) Knowledge: Understand (ABET e)\r\n- The concepts of HTML, CSS3, JavaScript, Interactivity with JavaScript, Advanced Styling with Responsive Design\r\n- Web page structure.\r\n- Web site structure.\r\n- Demonstrate the ability to design and implement a responsive site for three platforms.\r\n- The way a web page is presented in browsers.\r\n\r\n2) Able to (ABET k)\r\n- Add interacitivity to web pages with Javascript\r\n- Apply responsive design to enable page to be viewed by various devices\r\n- Describe the basics of Cascading Style Sheets (CSS3)\r\n- Use the Document Object Model (DOM) to modify pages\r\n3) Others: (ABET i)\r\n- Improve study skills (academic reading, information searching, ...)',1);


INSERT INTO `studentmanagement`.`subject_setting` (`subject_id`, `type_id`, `setting_title`, `setting_value`, `display_order`, `description`, `status`) VALUES ('1', '11', 'Complex', '1', '1', '', 1);
INSERT INTO `studentmanagement`.`subject_setting` (`subject_id`, `type_id`, `setting_title`, `setting_value`, `display_order`, `description`, `status`) VALUES ('1', '11', 'Medium', '2', '2', '', 1);
INSERT INTO `studentmanagement`.`subject_setting` (`subject_id`, `type_id`, `setting_title`, `setting_value`, `display_order`, `description`, `status`) VALUES ('1', '11', 'Simple', '3', '3', '', 1);
INSERT INTO `studentmanagement`.`subject_setting` (`subject_id`, `type_id`, `setting_title`, `setting_value`, `display_order`, `description`, `status`) VALUES ('1', '11', 'Zero', '0', '0', '', 1);
INSERT INTO `studentmanagement`.`subject_setting` (`subject_id`, `type_id`, `setting_title`, `setting_value`, `display_order`, `description`, `status`) VALUES ('1', '12', 'Low', '1', '1', '', 1);
INSERT INTO `studentmanagement`.`subject_setting` (`subject_id`, `type_id`, `setting_title`, `setting_value`, `display_order`, `description`, `status`) VALUES ('1', '12', 'Medium', '2', '2', '', 1);
INSERT INTO `studentmanagement`.`subject_setting` (`subject_id`, `type_id`, `setting_title`, `setting_value`, `display_order`, `description`, `status`) VALUES ('1', '12', 'High', '3', '3', '', 1);

drop procedure if exists `studentmanagement`.`search`
DELIMITER $$
CREATE PROCEDURE `studentmanagement`.`search` (IN search text,schemaName text, tableName text, conditionString text,startNum int,record int, columnName text,isAsc bit)
BEGIN

   select @q := concat("select * from `",schemaName,"`.`",tableName,"` ",
                   "where concat(", group_concat("`",column_name,"`"),  ", ' ') like ", search, " ",conditionString," ORDER BY ",columnName,IF(isAsc, " ASC", " DESC"), " LIMIT ",startNum,", ",record
                   )
   from information_schema.columns c
   where table_name = tableName
   AND table_schema = schemaName
   AND DATA_TYPE IN ('char','nchar','nvarchar','varchar','int')
   AND IS_NULLABLE = "NO";
   prepare st from @q;
   execute st;

   deallocate prepare st;
END$$
DELIMITER ;

drop procedure if exists `studentmanagement`.`countRows`
DELIMITER $$
CREATE PROCEDURE `studentmanagement`.`countRows` (IN search text,schemaName text, tableName text, conditionString text)
BEGIN
   select @q := concat("select count(*) as T from `",schemaName,"`.`",tableName,"` ",
                   "where concat(", group_concat("`",column_name,"`"),  ", ' ') like ", search, " ",conditionString
                   )
   from information_schema.columns c
   where table_name = tableName
   AND table_schema = schemaName
   AND DATA_TYPE IN ('char','nchar','nvarchar','varchar','int')
   AND IS_NULLABLE = "NO";
   prepare st from @q;
   execute st;

   deallocate prepare st;
END$$
DELIMITER ;

drop procedure if exists `studentmanagement`.`updateCriteria`
DELIMITER $$
CREATE PROCEDURE `updateCriteria`(IN criteriaid int, crit_title text, crit_description text, crit_weight double , team_eval bit, crit_order int,crit_loc int , status bit, crit_iterid int)
BEGIN
DECLARE total int ;
declare result int;
declare oldWeight int;
set total = ( SELECT sum(evaluation_weight) FROM studentmanagement.evaluation_criteria where  iteration_id =   crit_iterid  );
set oldWeight = ( SELECT evaluation_weight FROM studentmanagement.evaluation_criteria where  criteria_id = criteriaid );
IF (total - oldWeight + crit_weight)  > 100  THEN
   set result = -1;
ELSE
UPDATE `studentmanagement`.`evaluation_criteria`
SET
`criteria_title` = crit_title,
`criteria_description` =crit_description,
`evaluation_weight` = crit_weight,
`team_evaluation` = team_eval,
`criteria_order` = crit_order,
`max_loc` = crit_loc,
`status` = status
WHERE `criteria_id` = criteriaid ;


 set result = ( SELECT sum(evaluation_weight) FROM studentmanagement.evaluation_criteria where  iteration_id = crit_iterid) ;
END IF;

select result;

END$$
DELIMITER ;

drop procedure if exists `studentmanagement`.`addCriteria`
DELIMITER $$
CREATE PROCEDURE `addCriteria`(IN crit_iterid int, crit_title text, crit_description text, crit_weight double, team_eval bit, crit_order int,crit_loc int , status bit)
BEGIN
DECLARE total int ;
declare result int;
set total =( SELECT sum(evaluation_weight) FROM studentmanagement.evaluation_criteria where  iteration_id = crit_iterid );

IF (total + crit_weight)  > 100  THEN
   set result = -1;
ELSE
INSERT INTO `studentmanagement`.`evaluation_criteria`
(`iteration_id`,
`criteria_title`,
`criteria_description`,
`evaluation_weight`,
`team_evaluation`,
`criteria_order`,
`max_loc`,
`status`)
VALUES
(crit_iterid,crit_title,crit_description,crit_weight,team_eval,crit_order,crit_loc, status);

 set result = ( SELECT sum(evaluation_weight) FROM studentmanagement.evaluation_criteria where  iteration_id = crit_iterid) ;
END IF;

select result;

END$$
DELIMITER ;


 drop procedure if exists `studentmanagement`.`updateCriteriaStatus`
DELIMITER $$
Create PROCEDURE `updateCriteriaStatus`(IN criteriaid int, statusUpdate bit)
BEGIN
DECLARE iter_id int ;
DECLARE total int ;
DECLARE currWeight int ;
declare result int;
set iter_id = (select iteration_id from studentmanagement.evaluation_criteria where criteria_id = criteriaid limit 1);
set currWeight = (select evaluation_weight from studentmanagement.evaluation_criteria where criteria_id = criteriaid limit 1);
set total = (SELECT sum(evaluation_weight) FROM studentmanagement.evaluation_criteria where iteration_id = iter_id and status = 1);
IF statusUpdate = 1 then
IF (total + currWeight) > 100  THEN
   set result = -1;
ELSE

UPDATE `studentmanagement`.`evaluation_criteria` SET `status` = statusUpdate WHERE (`criteria_id` = criteriaid );
set result = ( SELECT sum(evaluation_weight) FROM studentmanagement.evaluation_criteria where iteration_id = crit_iterid and status =1 ) ;
END IF;

else
UPDATE `studentmanagement`.`evaluation_criteria` SET `status` = statusUpdate WHERE (`criteria_id` = criteriaid );
set result = ( SELECT sum(evaluation_weight) FROM studentmanagement.evaluation_criteria where iteration_id =  crit_iterid and status =1 ) ;

End if;
select result;

END$$
DELIMITER ;
INSERT INTO `studentmanagement`.`iteration` (`subject_id`, `iteration_name`, `duration`, `status`) VALUES ('20', 'Iteration 1', '14', 1);
INSERT INTO `studentmanagement`.`iteration` (`subject_id`, `iteration_name`, `duration`, `status`) VALUES ('20', 'Iteration 2', '14', 1);
INSERT INTO `studentmanagement`.`iteration` (`subject_id`, `iteration_name`, `duration`, `status`) VALUES ('20', 'Iteration 3', '14', 1);
INSERT INTO `studentmanagement`.`iteration` (`subject_id`, `iteration_name`, `duration`, `status`) VALUES ('20', 'Iteration 4', '14', 1);
INSERT INTO `studentmanagement`.`iteration` (`subject_id`, `iteration_name`, `duration`, `status`) VALUES ('20', 'Iteration 5', '14', 1);
INSERT INTO `studentmanagement`.`iteration` (`subject_id`, `iteration_name`, `duration`, `status`) VALUES ('19', 'Iteration 1', '14', 1);
INSERT INTO `studentmanagement`.`iteration` (`subject_id`, `iteration_name`, `duration`, `status`) VALUES ('19', 'Iteration 2', '14', 1);
INSERT INTO `studentmanagement`.`iteration` (`subject_id`, `iteration_name`, `duration`, `status`) VALUES ('19', 'Iteration 3', '14', 1);
INSERT INTO `studentmanagement`.`iteration` (`subject_id`, `iteration_name`, `duration`, `status`) VALUES ('19', 'Iteration 4', '14', 1);
INSERT INTO `studentmanagement`.`iteration` (`subject_id`, `iteration_name`, `duration`, `status`) VALUES ('19', 'Iteration 5', '14', 1);



INSERT INTO `studentmanagement`.`evaluation_criteria` (`criteria_id`, `iteration_id`, `criteria_title`, `criteria_description`, `evaluation_weight`, `criteria_order`, `max_loc`, `status`) VALUES ('1', '1', 'Analyze & Design', 'Analyze and design project implementation plans', '15', '1', '180', 1);
INSERT INTO `studentmanagement`.`evaluation_criteria` (`criteria_id`, `iteration_id`, `criteria_title`, `criteria_description`, `evaluation_weight`, `criteria_order`, `max_loc`, `status`) VALUES ('2', '2', 'Coding Practice', 'Coding', '15', '2', '180', 1);
INSERT INTO `studentmanagement`.`evaluation_criteria` (`criteria_id`, `iteration_id`, `criteria_title`, `criteria_description`, `evaluation_weight`, `criteria_order`, `max_loc`, `status`) VALUES ('3', '3', 'Coding Practice', 'Coding', '15', '3', '180', 1);
INSERT INTO `studentmanagement`.`evaluation_criteria` (`criteria_id`, `iteration_id`, `criteria_title`, `criteria_description`, `evaluation_weight`, `criteria_order`, `max_loc`, `status`) VALUES ('4', '4', 'Coding Practice', 'Coding', '15', '4', '180', 1);
INSERT INTO `studentmanagement`.`evaluation_criteria` (`criteria_id`, `iteration_id`, `criteria_title`, `criteria_description`, `evaluation_weight`, `criteria_order`, `max_loc`, `status`) VALUES ('5', '5', 'Integrated Software Product', 'Incorporates applications (typically word processing, database management, spreadsheet, graphics and communications) into one product, allowing data sharing between all or most modules', '20', '5', '180', 1);
INSERT INTO `studentmanagement`.`evaluation_criteria` (`criteria_id`, `iteration_id`, `criteria_title`, `criteria_description`, `evaluation_weight`, `criteria_order`, `max_loc`, `status`) VALUES ('6', '5', 'Mastery of assigned works', 'Experience gained during project completion', '10', '6', '180', 1);
INSERT INTO `studentmanagement`.`evaluation_criteria` (`criteria_id`, `iteration_id`, `criteria_title`, `criteria_description`, `evaluation_weight`, `criteria_order`, `max_loc`, `status`) VALUES ('7', '5', 'Soft Skills & Working Attitudes', 'Gain experience and attitude when working in groups', '10', '7', '180', 1);

INSERT INTO `studentmanagement`.`class` (`class_code`, `trainer_id`, `subject_id`, `class_year`, `class_term`, `block5_class`, `status`,`gitlab_url`,`apiToken`) VALUES ('SE1609', '10', '20', '2021', 5, 0, 1,'gitlab.com/swp-test-api/se1619-net','glpat-1kopqJ-wzELKnhguY1ZW');
INSERT INTO `studentmanagement`.`class` (`class_code`, `trainer_id`, `subject_id`, `class_year`, `class_term`, `block5_class`, `status`) VALUES ('SE1619', '9', '19', '2022', 5, 0, 1);

INSERT INTO `studentmanagement`.`class_setting` (`class_id`, `type_id`, `setting_title`, `setting_value`, `display_order`, `description`, `status`) values
(1, 8, 'WP', 1, 1, '', 1),
(1, 8, 'Q&A', 2, 2, '', 1),
(1, 8, 'Task', 3, 3, '', 1),
(1, 8, 'Defect', 4, 4, '', 1),
(1, 8, 'Leakage', 5, 5, '', 1),
(1, 9, 'Open', 1, 1, '', 1),
(1, 9, 'To_Do', 2, 2, '', 1),
(1, 9, 'Doing', 3, 3, '', 1),
(1, 9, 'Done', 4, 4, '', 1),
(1, 9, 'Closed', 5, 5, '', 1),
(1, 10, 'To_Do', 1, 1, '', 1),
(1, 10, 'Analyzed', 2, 2, '', 1),
(1, 10, 'Designed', 3, 3, '', 1),
(1, 10, 'Coded', 4, 4, '', 1),
(1, 10, 'Tested', 5, 5, '', 1),
(1, 10, 'Done', 6, 6, '', 1),
(1, 10, 'Closed', 7, 7, '', 1);

drop trigger if exists `studentmanagement`.`afterInsertMilestone`
DELIMITER $$
CREATE TRIGGER afterInsertMilestone
BEFORE INSERT
ON `studentmanagement`.`milestone` FOR EACH ROW
BEGIN
DECLARE time_add int;
SET @time_add := (SELECT duration from `studentmanagement`.`iteration` WHERE iteration_id = NEW.iteration_id);
	if (NEW.to_date is null AND @time_add is not null) THEN SET new.to_date = date_add(NEW.from_date, interval @time_add day);
	END IF;
	if (NEW.to_date < now() and new.status!=0) THEN SET new.status=2;
	END IF;
END$$
DELIMITER ;
drop trigger if exists `studentmanagement`.`updateClassUser`
DELIMITER $$
CREATE TRIGGER updateClassUser
BEFORE UPDATE
ON `studentmanagement`.`class_user` FOR EACH ROW
BEGIN
	set new.dropout_date=If(new.status,null,now());
END$$
DELIMITER ;
drop trigger if exists `studentmanagement`.`afterUpdateMilestone`
DELIMITER $$
CREATE TRIGGER afterUpdateMilestone
BEFORE UPDATE
ON `studentmanagement`.`milestone` FOR EACH ROW
BEGIN
DECLARE time_add int;
	if (NEW.to_date < now() and new.status!=0) THEN SET new.status=2;
	END IF;
END$$
DELIMITER ;
SET GLOBAL event_scheduler = ON;
DELIMITER $$
CREATE EVENT IF NOT EXIST studentmanagement.`close_milestone`
	ON SCHEDULE EVERY 1 DAY
	STARTS '2022-06-15 00:00:00' -- should be in the future
	ON COMPLETION PRESERVE
    DO
      UPDATE studentmanagement.`milestone` SET status = 2 where to_day<now()
DELIMITER ;
INSERT INTO `studentmanagement`.`milestone` (`milestone_name`, `iteration_id`, `class_id`, `from_date`, `to_date`,`status`) VALUES ('Iteration 1',1,1,'2022-05-09',null,1);
INSERT INTO `studentmanagement`.`milestone` (`milestone_name`, `iteration_id`, `class_id`, `from_date`, `to_date`,`status`) VALUES ('Iteration 2',2,1,'2022-05-23',null,1);
INSERT INTO `studentmanagement`.`milestone` (`milestone_name`, `iteration_id`, `class_id`, `from_date`, `to_date`,`status`) VALUES ('Iteration 3',3,1,'2022-06-04',null,1);
INSERT INTO `studentmanagement`.`milestone` (`milestone_name`, `iteration_id`, `class_id`, `from_date`, `to_date`,`status`) VALUES ('Iteration 4',4,1,'2022-06-18',null,1);
INSERT INTO `studentmanagement`.`milestone` (`milestone_name`, `iteration_id`, `class_id`, `from_date`, `to_date`,`status`) VALUES ('Iteration 5',5,1,'2022-07-11',null,1);

INSERT INTO `studentmanagement`.`team` (`class_id`, `team_name`, `topic_code`, `topic_name`, `gitlab_url`, `apiToken`, `status`) VALUES (1, '1', 'PRJT', 'StudentManagement', 'gitlab.com/swp-test-api/se1619-net/g1', 'glpat-1kopqJ-wzELKnhguY1ZW', 1);
INSERT INTO `studentmanagement`.`team` (`class_id`, `team_name`, `topic_code`, `topic_name`, `gitlab_url`, `apiToken`, `status`) VALUES (1, '2', 'SWP', 'Project Management', 'gitlab.com/fu-kiennt-summer22/se1619-net-swp391/g1', 'glpat-1kopqJ-wzELKnhguY1ZW', 1);
INSERT INTO `studentmanagement`.`team` (`class_id`, `team_name`, `topic_code`, `topic_name`, `gitlab_url`, `apiToken`, `status`) VALUES (2, '1', 'SWP', 'StudentManagement', 'gitlab.com/swp-test-api/se1619-net/g1', 'glpat-1kopqJ-wzELKnhguY1ZW', 1);

INSERT INTO `studentmanagement`.`class_user` (`class_id`,`team_id`,`user_id`,`team_leader`,`user_notes`,`dropout_date`,`status`) values (1,1,15,1,'',null,1);
INSERT INTO `studentmanagement`.`class_user` (`class_id`,`team_id`,`user_id`,`team_leader`,`user_notes`,`dropout_date`,`status`) values (1,1,16,0,'',null,1);
INSERT INTO `studentmanagement`.`class_user` (`class_id`,`team_id`,`user_id`,`team_leader`,`user_notes`,`dropout_date`,`status`) values (1,1,17,0,'',null,1);
INSERT INTO `studentmanagement`.`class_user` (`class_id`,`team_id`,`user_id`,`team_leader`,`user_notes`,`dropout_date`,`status`) values (1,1,18,0,'',null,1);
INSERT INTO `studentmanagement`.`class_user` (`class_id`,`team_id`,`user_id`,`team_leader`,`user_notes`,`dropout_date`,`status`) values (1,1,19,0,'',null,1);

INSERT INTO `studentmanagement`.`feature` ( `team_id`, `feature_name`, `status`) VALUES (1, 'Manage setting', 1);
INSERT INTO `studentmanagement`.`feature` ( `team_id`, `feature_name`, `status`) VALUES (1, 'Manage Class', 1);
INSERT INTO `studentmanagement`.`feature` ( `team_id`, `feature_name`, `status`) VALUES (1, 'Manage User', 1);
INSERT INTO `studentmanagement`.`feature` (`team_id`, `feature_name`, `status`) VALUES (2, 'Home/Dashboard', 1);


insert into `studentmanagement`.`function` (`team_id`,`function_name`,`feature_id`, `access_roles`, `description`, `complexity_id`,`owner_id`,`priority`,`status`)
values (1,'View Setting', 1, 'Admin', 'This gives setting list', 3,15,1,1);
insert into `studentmanagement`.`function` (`team_id`,`function_name`,`feature_id`, `access_roles`, `description`, `complexity_id`,`owner_id`,`priority`,`status`)
values (1,'Update Classroom', 2, 'Admin, Author, Trainer', 'This gives update classroom', 1,16,1,1);
insert into `studentmanagement`.`function` (`team_id`,`function_name`,`feature_id`, `access_roles`, `description`, `complexity_id`,`owner_id`,`priority`,`status`)
values (1,'Delete a Student', 3, 'Admin, Author, Trainer', 'This allows deleteing student', 1,18,1,1);
insert into `studentmanagement`.`function` (`team_id`,`function_name`,`feature_id`, `access_roles`, `description`, `complexity_id`,`owner_id`,`priority`,`status`)
values (1,'Update Setting', 1, 'Admin', 'This updates a setting', 2,17,1,1);

INSERT INTO `studentmanagement`.`issue` (`assignee_id`,`issue_title`,`description`,`gitlab_id`,`gitlab_url`,`due_date`,`team_id`,`milestone_id`,`function_id`,`status`) VALUES (15, 'SRS', 'Software Requirement Specification', '1', 'gitlab.com/fu-kiennt-summer22/se1619-net-swp391/g2', '2022-09-09', 2, 1, 1, 1);
INSERT INTO `studentmanagement`.`issue` (`assignee_id`,`issue_title`,`description`,`gitlab_id`,`gitlab_url`,`due_date`,`team_id`,`milestone_id`,`function_id`,`status`) VALUES (19, 'SDS', 'Software Design Specification', '1', 'gitlab.com/fu-kiennt-summer22/se1619-net-swp391/g2', '2022-09-09', 2, 2, 2, 7);

INSERT INTO `studentmanagement`.`subject_setting` (`subject_id`, `type_id`, `setting_title`, `setting_value`, `display_order`, `description`, `status`) VALUES ('20', '11', 'Complex', '1', '1', '', 1);
INSERT INTO `studentmanagement`.`subject_setting` (`subject_id`, `type_id`, `setting_title`, `setting_value`, `display_order`, `description`, `status`) VALUES ('20', '11', 'Medium', '2', '2', '', 1);
INSERT INTO `studentmanagement`.`subject_setting` (`subject_id`, `type_id`, `setting_title`, `setting_value`, `display_order`, `description`, `status`) VALUES ('20', '11', 'Simple', '3', '3', '', 1);

insert into `studentmanagement`.`tracking` (`milestone_id`,`function_id`,`assigner_id`,`assignee_id`, `tracking_note`,status)
values(1,1,16,17,'',14)
