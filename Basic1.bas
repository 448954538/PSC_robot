ERRSWITCH = 3'打印开关
 
set_xplcterm=1
grap_switch=0
grab_task_id=5
 d_cam_expostime = 500000

setcom(115200,8,1,0,0,0,0,1000)	'设置串口0为RAW数据模式
setcom(9600,8,1,0,1,14,2,1000)	'设置串口1为modbus主  轮毂115200 刷子38400 压力19200 电池9600
'setcom(9600,8,1,0,1,0,0,1000)	'设置串口1为RAW 电池读写 

MODBUSM_des(1,1)'设置对方address=1 port 为1 

	'RUNTASK 2,task_sensor		'启动接受任务
   'RUNTASK 3,task_view		'启动接受任务
    'RUNTASK 4,task_cmd
   
'指令列表
MOVE_PWM(1, 0.95, 1000)
 
DIM char1 flag485
DIM BAT_ARRAY(14)
DIM char232(4) char_rx(3)
flag485= 0
while 1	'循环运动
	
	
	if scan_event(in(0)) = on then '输入0有效左运动 							
		'SET_Modbus_wheel_addr()
		'SET_Modbus_brush_addr()		
		'Read_battery()		
		
		'delay 1000
		'brush_100A_stop()
		'vacuum_stop()
		'move_front()
		scan_all_cams()
		'PS2_init()
		
		OP(0,ON)
		? "in0"
	elseif scan_event(in(1)) = on then '输入1有效右运动 
		OP(0,OFF) 
		? "in1" 		
		'move_stop()
		'brush_100A_start()
		'vacuum_start()
		
		'Read_sensor()		
		btn_con_grap()
		'btn_softtrigger
		'PS2_Read()
		
	elseif scan_event(in(2)) = on then '输入1有效右运动	
	
		btn_stop_grab()
		'move_stop()
		'brush_100A_stop()
		'vacuum_stop()
		
		'Read_sensor()		
		'Read_battery()
		
		if flag485 = 1 THEN
			flag485 = 0
			'OP(0,OFF) 
			'
		ELSE
			flag485 = 1
			'OP(0,ON) 
		end if
		
		? "in2" 
	elseif (not idle) then
		
		cancel
	end if
	
	
	delay 20
wend

end

global sub task_sensor()			'接受任务
	while 1
		
		PS2_Read()
		delay 100	
	wend
end sub

global sub vacuum_start()	 '		
		MOVE_PWM(1, 0.6, 1000) ' 0.8脉宽不启动 0.6脉宽 峰值3A电流	
end sub

global sub vacuum_stop()			'
		MOVE_PWM(1, 0.95, 1000) 	
end sub

global sub PS2_init()

	'配置SPI模式 03  速度100K(200K会出错)
	putchar #0,PS2_SPI
	
	'扫描
	putchar #0, PS2_scan
	get #0, RS232_rx,9
	
	putchar #0,PS2_lx1'进入配置模式
	putchar #0,PS2_lx2' 设置模式
	putchar #0,PS2_lx3' 设置字节长度
	putchar #0,PS2_lx4'退出配置模式
	
	'扫描
	putchar #0, PS2_scan
	get #0, RS232_rx,9
end sub

global sub PS2_Read()		
	DIM funbtn
	putchar #0, PS2_scan
	get #0, RS232_rx,9
	
	funbtn = (RS232_rx(4) << 8) | RS232_rx(3);

	PS2_FunBtn = funbtn;
	PS2_X1 = RS232_rx(7);
	PS2_Y1 =RS232_rx(8);
	PS2_X2 = RS232_rx(5);
	PS2_Y2 = RS232_rx(6);
			
	?"遥控指令：" PS2_FunBtn
end sub

global sub SET_Modbus_wheel_addr() '改动无效
	setcom(115200,8,1,0,1,14,2,1000)	'设置串口1为modbus主  轮毂115200 
	MODBUSM_des(1,1)'设置对方 port 为1
	delay 10
	modbus_reg(0) = 3	'地址
	MODBUSM_regset($2001,1,0)'本地复制到远端
	?"Modbus地址修改成功:" modbus_reg(0)
	
end sub

global sub SET_Modbus_brush_addr()
	setcom(38400,8,1,0,1,14,2,1000)	'设置串口1为modbus主  刷子38400 
	MODBUSM_des(1,1)'设置对方 port 为1
	delay 10
	modbus_reg(0) = 4	'地址
	MODBUSM_regset($0000,1,0)'本地复制到远端
	?"Modbus地址修改成功:" 
	
end sub

global sub SET_Modbus_baudrate()
	MODBUSM_des(1,1)'设置对方address  port 为1
	delay 10
	modbus_reg(0) = 9600	'波特率
	MODBUSM_regset($0000,1,0)'本地复制到远端
	
end sub


global sub Read_battery()
	setcom(9600,8,1,0,1,14,2,1000)	'设置串口1为modbus主  电池9600
	MODBUSM_des(1,1)'设置对方address=1 port 为1
	delay 10
	MODBUSM_REGGET($0000,30,10)

	?"电池信息:"MODBUS_REG(10), MODBUS_REG(11),MODBUS_REG(12), MODBUS_REG(12)
	
end sub

global sub Read_sensor()
	'setcom(9600,8,1,0,1,14,2,2000)	'设置串口1为modbus主  压力19200 
	MODBUSM_des(2,1)'设置对方address=2 port 为1 
	delay 10
		MODBUSM_REGGET($0050,2,10)'读取压力传感数据	
		if(MODBUS_REG(11) >= 0  )  then    '有接受到数据
			MODBUS_REG(13) = MODBUS_REG(10)
			MODBUS_REG(12) = MODBUS_REG(11)
			?"压力",MODBUS_LONG(12) '显示数据
		endif	
end sub

global sub move_front()			'

	'轮毂
	setcom(115200,8,1,0,1,14,2,1000)	'设置串口1为modbus主  轮毂115200 
	MODBUSM_des(1,1)'设置对方address=1 port 为1
	delay 10
		modbus_reg(0) = $0003	'速度控制
		MODBUSM_regset($200D,1,0)'本地复制到远端
		modbus_reg(0) = $01F4' 电机加减速时间
		MODBUSM_regset($2080,1,0)'本地复制到远端 左加速
		MODBUSM_regset($2081,1,0)'本地复制到远端 右加速
		MODBUSM_regset($2082,1,0)'本地复制到远端 左减速
		MODBUSM_regset($2083,1,0)'本地复制到远端 右减速
		modbus_reg(0) = $0008' 
		MODBUSM_regset($200E,1,0)'本地复制到远端 使能
		modbus_reg(0) = $0082 ' 
		MODBUSM_regset($2088,1,0)'本地复制到远端 启动速度
		MODBUSM_regset($2089,1,0)'本地复制到远端 启动速度
end sub

global sub move_stop()	
		setcom(115200,8,1,0,1,14,2,1000)	'设置串口1为modbus主  轮毂115200 
		MODBUSM_des(1,1)'设置对方address=1 port 为1
		delay 10
		modbus_reg(0) = $0007' 停止
		MODBUSM_regset($200E,1,0)'本地复制到远端
		
		end sub 
global sub brush_50A_start()			'
	
	'50A
	setcom(38400,8,1,0,1,14,2,1000)	'设置串口1为modbus主  刷子38400 
	MODBUSM_des(4,1)'设置对方address=4 port 为1
	delay 10
		modbus_reg(0) = $0001	'
		MODBUSM_regset($00B6,1,0)'本地复制到远端
		modbus_reg(0) = $0258	'
		MODBUSM_regset($0056,1,0)'本地复制到远端
		modbus_reg(0) = $0001	'
		MODBUSM_regset($0066,1,0)'本地复制到远端
end sub

global sub brush_50A_stop()			'
	
	'50A
	setcom(38400,8,1,0,1,14,2,1000)	'设置串口1为modbus主  刷子38400 
	MODBUSM_des(4,1)'设置对方address=4 port 为1
	delay 10
	modbus_reg(0) = $0000	'
	MODBUSM_regset($0066,1,0)'本地复制到远端
end sub

global sub brush_100A_start()
	'100A  每个指令间需延时10ms
	setcom(38400,8,1,0,1,14,2,1000)	'设置串口1为modbus主  刷子38400 
	MODBUSM_des(4,1)'设置对方address=4 port 为1
	delay 10
		modbus_reg(0) = $0000	'
		MODBUSM_regset($0005,1,0)'本地复制到远端
		delay 10
		modbus_reg(0) = $0001	'
		MODBUSM_regset($0025,1,0)'本地复制到远端
		delay 10
		modbus_reg(0) = $00ff	'
		MODBUSM_regset($0006,1,0)'本地复制到远端
		delay 10
		modbus_reg(0) = $0000	'
		MODBUSM_regset($0023,1,0)'本地复制到远端
		delay 10
		modbus_reg(0) = $0001	'
		MODBUSM_regset($0022,1,0)'本地复制到远端
		delay 10
end sub


global sub brush_100A_stop()
	setcom(38400,8,1,0,1,14,2,1000)	'设置串口1为modbus主  刷子38400
	MODBUSM_des(4,1)'设置对方address=4 port 为1
	delay 10
	modbus_reg(0) = $0000	'
	MODBUSM_regset($0022,1,0)'本地复制到远端
end sub

global sub task_cmd()			'接受任务
	
	while 1
		'MODBUSM_REGGET($0050,2,10)'读取压力传感数据	
		'if(MODBUS_REG(11) >= 0  )  then    '有接受到数据
		'	MODBUS_REG(13) = MODBUS_REG(10)
		'	MODBUS_REG(12) = MODBUS_REG(11)
		'	?"压力",MODBUS_LONG(12)
		'endif	
		'MODBUSM_REGGET($0000,30,10)
		'?"电池信息:"MODBUS_REG(10), MODBUS_REG(11),MODBUS_REG(12), MODBUS_REG(12)		
		
		delay 100
	wend
end sub


'自由采集任务
GLOBAL SUB grab_task()
	'CAM_START(1)

	while(1)
		if (0 = grap_switch) then
			exit while
		endif
		
		CAM_GRAB(image)       '自由采集模式下，采集一帧图像
		'CAM_SETPARAM("TriggerSoftware", 0)		
		'CAM_GET(image,0)
		ZV_LATCH(image,0)     '将采集图像显示到图片元件中
	wend
	
	'CAM_STOP()
END

	
'HMI界面按下扫描相机按钮响应的函数
GLOBAL SUB scan_all_cams()

	
	'扫描相机
	CAM_SCAN("mvision")     '扫描海康相机，
	                         '扫描类型包括"mvision","basler","mindvision","huaray","aravis"“tis”等多种类型
	
	cam_num = CAM_COUNT()
	                         '打印扫描相机状态结果
	if (0 = cam_num) then
		? "未找到相机"	
		return
	endif
	
	    ?"相机数量：" cam_num
		'*************初始化相机操作*********************
	    CAM_SEL(0)              '选择第一个相机
		
		
	'*************结束初始化相机*********************

END SUB

'HMI界面按下自由采集按钮响应的函数
GLOBAL SUB btn_con_grap()
  if(grap_switch=1) then   '如果已经在自由采集状态，打印提示信息
    ?"正在自由采集中，请勿重复操作"
    return     
  endif
  
  if (cam_num=0) then        '如果没有扫描相机，提示先扫描相机
     ?"请先扫描相机"
     return
  endif
    
  '*************初始化相机操作*********************
	
    CAM_SEL(0)           '选择第一个相机
   ?"选择第一个相机"
   
    CAM_SETMODE(-1)      '选择相机为自由采集模式
	'CAM_SETMODE(0)      '选择相机为软触发采集模式
	?"自由采集模式"
   CAM_SETEXPOSURE(d_cam_expostime)				 '设置曝光时间
   CAM_SETPARAM("Width", "1920")
   CAM_SETPARAM("Height", "1080")
   ?"设置曝光时间"
   
  '*************结束初始化相机*********************
    
    grap_switch=1          '自由采集状态置1，开启循环采集任务
    
    if (1 = grap_switch) then
	  
      if (0 = PROC_STATUS(grab_task_id)) then
        RUNTASK grab_task_id,grab_task		'启动接受任务
      endif
    endif    
END SUB



'HMI界面按下停止采集按钮时响应的函数
GLOBAL SUB btn_stop_grab()

     if(grap_switch = 0)then 
	 ?"未开启连续采集"
	 return 
	 endif
	 
	 grap_switch = 0
	 
END SUB

'HMI界面按下软件触发按钮时响应的函数
GLOBAL SUB btn_softtrigger()

   
	
	if (0 = cam_num) then
		? "未找到相机"
		return
	endif
	
	CAM_SEL(0)				             '选择相机id，在实际使用中只需要初始化一次 
	
    CAM_SETMODE(0)				         '设置相机为软触发采集模式，在实际使用中只需要初始化一次
    CAM_START(0)				         '开启相机，在实际使用中只需要初始化一次
	
    CAM_SETPARAM("TriggerSoftware", 0)	 '发送软触发信号
    CAM_GET(image, 0)			         '获取相机缓存中指定 id 序号为 0 的图像
    ZV_LATCH(image, 0)			         '显示图像

END SUB

'HMI界面按下硬件触发按钮时响应的函数
GLOBAL SUB btn_line0trigger()
    
	
	if (0 = cam_num) then
		? "未找到相机"
		return
	endif
	
	CAM_SEL(0)				               '选择相机id ，在实际使用中只需要初始化一次
    CAM_SETMODE(1)				           '设置相机为硬件触发采集模式，在实际使用中只需要初始化一次
	CAM_SETPARAM("TriggerActivation",1)   '设置相机接收下降沿触发信号有效，在实际使用中只需要初始化一次
    CAM_START(0)				           '开启相机，在实际使用中只需要初始化一次
    

    MOVE_OP(0,ON)   
    MOVE_OP(0,OFF)                        '控制器OUT0输出下降沿信号

    CAM_GET(image, 0)			           '获取相机缓存中指定 id 序号为 0 的图像
    ZV_LATCH(image, 0)			           '显示图像

END SUB

'HMI界面按下相机设置按钮时响应的函数
GLOBAL SUB btn_set_expostime()

   if (grap_switch=1) then               '设置相机参数前需要停止相机采集
        ?"请先停止相机采集"
		return 
	endif
	
   HMI_SHOWWINDOW(11)                     '弹出设置曝光时间窗口
   
END SUB

'设置曝光时间界面按下确定按钮
GLOBAL SUB btn_confirm()

   CAM_SETEXPOSURE(d_cam_expostime)        '设置曝光值
   HMI_CLOSEWINDOW(11)                     '关闭设置窗口
   
   ?"曝光时间"d_cam_expostime
   
   '***********显示设置后的效果************************
  btn_con_grap
  
   
END SUB