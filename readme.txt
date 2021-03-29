1、PSCrobot项目基于zmotion basic语言开发，实现功能为智能除锈机器人的控制，包括轮毂运动控制，手柄遥控指令解析，相机数据采集及显示，钢刷运动控制，传感器数据采集，电池数据采集。
包含以下文件：PSCrobot.zpj , Hmi1.hmi, main.bas, global_var.bas, ps2.bas, 485.bas, view.bas 

2、文件夹img中存放界面开发用到的图片数据。

3、文档说明
PSCrobot.zpj：为项目文件，可以用ZDevelop.exe软件打开，在ZDevelop.exe软件的菜单帮助栏，可打开编程手册ZBasic.chm ，ZDevelop.chm，ZHmi.chm，ZPlc.chm，编程手册中有详细介绍zmotion basic相关语法。
zmotion 公司官网：http://www.zmotionglobal.com/
		http://www.zmotion.com.cn/


Hmi1.hmi：组态文件，包含显示界面的开发，需要用ZDevelop.exe软件打开。

main.bas：程序主线程，主要包括配置初始化、子线程的启动、控制IO口输入输出。

global_var.bas：定义了程序全局变量。

ps2.bas：包含PS2手柄读写线程task_Ps2read()，以及相关子函数：手柄配置初始化，手柄数据读写，手柄指令解码。

485.bas：包含485总线读写线程task_modbus()，以及相关子函数：轮毂指令解析流程，钢刷指令解析流程，modbus地址配置，电池读取，传感器读取，轮毂初始化及运动控制，钢刷初始化及运动控制，吸尘器控制。

view.bas：包含图像显示线程task_view()，以及相关子函数：相机扫描，相机初始化，相机数据采集。

4、485总线说明
接入485总线设备包括：轮毂控制器、钢刷控制器、电池、压力传感器，通信方式基于modbus协议，波特率为9600。
modbus地址分别为：1：电池，2：压力传感器，3：轮毂控制器；4：钢刷控制器。
软件调试前请分别设置好每个设备的波特率和地址。




