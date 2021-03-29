
global sub task_modbus()			'485总线 modbus协议读写
	modbus_status = 0
	wheel_cmd = 0 
	brush_cmd = 0
	DIM cnt
	cnt=0
	move_init()
	while 1  
			
		'轮毂控制
		 wheel_cmd_process()
			
		'钢刷驱动
		brush_cmd_process()
		'传感器读取控制
		delay 10
		if cnt = 8 THEN
			Read_sensor()			
		end if				
		'电池读取控制
		delay 10
		if cnt = 8 THEN				
				Read_battery()	
			cnt = 0
		end if
		cnt = cnt + 1
		delay 10
	wend
end sub

'轮毂指令解析流程
global sub wheel_cmd_process() ' 
			if wheel_cmd = 0 THEN	'读取轮毂驱动器状态 自动读取  电机停止
				move_stop()
				delay 3
				Read_wheel_status()
				wheel_cmd = 0
			elseif wheel_cmd = 1 then '运动
				vacuum_stop()
				delay 3
				brush_100A_stop()
				delay 3
				move_rt()
			elseif wheel_cmd = 2 then'向前
				move_front()
				wheel_cmd = 0
			elseif wheel_cmd = 3 then'向后
				move_back()
				wheel_cmd = 0
			elseif wheel_cmd = 4 then'向左
				move_left()
				wheel_cmd = 0
			elseif wheel_cmd = 5 then'向右
				move_right()
				wheel_cmd = 0
			ELSE
				move_stop()
				wheel_cmd = 0	
			end if	
end sub

'钢刷指令解析流程
global sub brush_cmd_process()
	if brush_cmd = 0 THEN 
				vacuum_stop()
				delay 3	
				brush_100A_stop()
				'delay 3
				'Read_brush_100A()
				modbus_status = 2
			elseif brush_cmd = 1 then
				if wheel_cmd = 0 THEN
					move_stop()
					delay 3	
					vacuum_start() 
					delay 3
					brush_100A_start() '启动钢刷
				end if
				'brush_cmd = 0
			ELSE
				vacuum_stop()
				delay 3	
				brush_100A_stop() '停止钢刷
				brush_cmd = 0
			end if
end sub

'modbus地址配置
global sub SET_battery_addr() ' 
	MODBUSM_des(1,1)'设置对方 port 为1	
end sub

global sub SET_sensor_addr() ' 
	MODBUSM_des(2,1)'设置对方 port 为2	
end sub
	
global sub SET_wheel_addr() '改动无效
	MODBUSM_des(3,1)'设置对方 port 为3	
end sub

global sub SET_brush_addr()
	MODBUSM_des(4,1)'设置对方 port 为4
end sub

'modbus波特率配置
global sub SET_Modbus_baudrate()
	MODBUSM_des(1,1)'设置对方address  port 为1
	delay 10
	modbus_reg(0) = 9600	'波特率
	MODBUSM_regset($0000,1,0)'本地复制到远端
	
end sub

'电池读取
global sub Read_battery()

	SET_battery_addr()
	delay 120								
	MODBUSM_REGGET($0000,7,20)'电池信息  连续读取间隔需大于100ms
	delay 120
	MODBUSM_REGGET($0000,7,20)
	delay 30
	Battery_V = MODBUS_REG(20)/100
	Battery_P = MODBUS_REG(22)
	Battery_I = MODBUS_REG(24)/100
	Battery_Temp =  MODBUS_REG(26)
	?"电池信息:", "电压" Battery_V, "电量"Battery_P ,"电流"Battery_I, "温度"Battery_Temp
	
end sub


'传感器读取
global sub Read_sensor()

	SET_sensor_addr()
	delay 30
		MODBUSM_REGGET($0050,2,30)'读取压力传感数据	
		'if(MODBUS_REG(31) >= 0  )  then    '有接受到数据
			MODBUS_REG(33) = MODBUS_REG(30)
			MODBUS_REG(32) = MODBUS_REG(31)
			Pressure_value = MODBUS_LONG(32)
			?"压力",Pressure_value '显示数据
		'endif	
end sub

'轮毂初始化
global sub move_init() '

	SET_wheel_addr()
	delay 10
	modbus_reg(0) = $0003	'速度控制
		MODBUSM_regset($200D,1,0)'本地复制到远端
		modbus_reg(0) = $01F4' 电机加减速时间
		MODBUSM_regset($2080,1,0)'本地复制到远端 左加速
		MODBUSM_regset($2081,1,0)'本地复制到远端 右加速
		MODBUSM_regset($2082,1,0)'本地复制到远端 左减速
		MODBUSM_regset($2083,1,0)'本地复制到远端 右减速
				
		modbus_reg(0) = $000A' 电机极对数 10
		MODBUSM_regset($2075,1,0)'本地复制到远端 
		modbus_reg(0) = $000A' 电机极对数 10
		MODBUSM_regset($2045,1,0)'本地复制到远端
		
		
		'速度环配置
		modbus_reg(0) = $01F4' 1F4
		MODBUSM_regset($203C,1,0)'本地复制到远端 
		modbus_reg(0) = $03E8' 
		MODBUSM_regset($203D,1,0)'本地复制到远端
		modbus_reg(0) = $03E8' 
		MODBUSM_regset($203E,1,0)'本地复制到远端
		
		modbus_reg(0) = $01F4' 
		MODBUSM_regset($206C,1,0)'本地复制到远端 
		modbus_reg(0) = $03E8' 
		MODBUSM_regset($206D,1,0)'本地复制到远端
		modbus_reg(0) = $03E8' 
		MODBUSM_regset($206E,1,0)'本地复制到远端
		
		'超差报警阈值
		modbus_reg(0) = $0666' 
		MODBUSM_regset($2036,1,0)'本地复制到远端
		modbus_reg(0) = $0666' 
		MODBUSM_regset($2066,1,0)'本地复制到远端
		
		'速度平滑系数
		modbus_reg(0) = $0032' 
		MODBUSM_regset($2037,1,0)'本地复制到远端
		modbus_reg(0) = $0032' 
		MODBUSM_regset($2067,1,0)'本地复制到远端
		
		'电流环
		modbus_reg(0) = $0258' 
		MODBUSM_regset($2038,1,0)'本地复制到远端
		modbus_reg(0) = $012C' 
		MODBUSM_regset($2039,1,0)'本地复制到远端		
		modbus_reg(0) = $0258' 
		MODBUSM_regset($2068,1,0)'本地复制到远端
		
		modbus_reg(0) = $012C' 
		MODBUSM_regset($2069,1,0)'本地复制到远端
		
		delay 100
		
		modbus_reg(0) = $0001' 
		MODBUSM_regset($2010,1,0)'本地复制到远端
	
end sub

'轮毂状态读取
global sub Read_wheel_status()
	
	SET_wheel_addr()
	delay 30	
		MODBUSM_REGGET($20A5,2,10)'读取轮毂故障信息	
		?"轮毂信息$20A5：",MODBUS_REG(10) ,MODBUS_REG(11) '轮毂信息
		'MODBUSM_REGGET($2030,2,10)'读取轮毂故障信息	
		'?"$2030线数：",MODBUS_REG(10) '线数
		'MODBUSM_REGGET($2075,2,10)'读取轮毂故障信息	
		'?"$2075极对数：",MODBUS_REG(10)'轮毂信息
		'MODBUSM_REGGET($2061,2,10)'读取轮毂故障信息	
		'?"$2061偏移角度：",MODBUS_REG(10) '轮毂信息
		'MODBUSM_REGGET($2064,2,10)'读取轮毂故障信息	
		'?"$2064信息：",MODBUS_REG(10) '轮毂信息
		'MODBUSM_REGGET($2033,2,10)'读取轮毂故障信息	
		'?"$2033信息：",MODBUS_REG(10) '轮毂信息
		'MODBUSM_REGGET($2036,2,10)'读取轮毂故障信息	
		'?"$2036信息：",MODBUS_REG(10) '轮毂信息
		'MODBUSM_REGGET($203C,2,10)'读取轮毂故障信息	
		'?"$203C信息：",MODBUS_REG(10) '轮毂信息
		'MODBUSM_REGGET($203D,2,10)'读取轮毂故障信息	
		'?"$203D信息：",MODBUS_REG(10) '轮毂信息
		'MODBUSM_REGGET($203E,2,10)'读取轮毂故障信息	
		'?"$203E信息：",MODBUS_REG(10) '轮毂信息
		
		'MODBUSM_REGGET($2067,2,10)'读取轮毂故障信息	
		'?"$2067信息：",MODBUS_REG(10) '轮毂信息	
		'MODBUSM_REGGET($2068,2,10)'读取轮毂故障信息	
		'?"$2068信息：",MODBUS_REG(10) '轮毂信息	
		'MODBUSM_REGGET($2069,2,10)'读取轮毂故障信息	
		'?"$2069信息：",MODBUS_REG(10) '轮毂信息
		'MODBUSM_REGGET($206A,2,10)'读取轮毂故障信息	
		'?"$206A信息：",MODBUS_REG(10) '轮毂信息
		'MODBUSM_REGGET($206B,2,10)'读取轮毂故障信息	
		'?"$206B信息：",MODBUS_REG(10) '轮毂信息
		
		'MODBUSM_REGGET($2010,2,10)'读取轮毂故障信息	
		'?"$2010信息：",MODBUS_REG(10) '轮毂信息
	
end sub

'轮毂报警清除
global sub Clear_wheel_alarm() '

	SET_wheel_addr()
	delay 10	
	modbus_reg(0) = $0006' 
	MODBUSM_regset($200E,1,0)'清除报警信息
	
end sub

'轮毂急停控制
global sub move_EMS() '

	SET_wheel_addr()
	delay 10	
	modbus_reg(0) = $0005' 
	MODBUSM_regset($200E,1,0)'轮毂急停
	
end sub

'轮毂实时运动
global sub move_rt() '

	SET_wheel_addr()
	
	delay 10	
	modbus_reg(0) = wheel_speed_l ' 
	MODBUSM_regset($2088,1,0)'本地复制到远端 启动速度
	delay 10
	modbus_reg(0) = wheel_speed_r '		
	MODBUSM_regset($2089,1,0)'本地复制到远端 启动速度
	
	delay 10	
	modbus_reg(0) = wheel_speed_l ' 
	MODBUSM_regset($2088,1,0)'本地复制到远端 启动速度
	delay 10
	modbus_reg(0) = wheel_speed_r '		
	MODBUSM_regset($2089,1,0)'本地复制到远端 启动速度
	
	modbus_reg(0) = $0008' 
	MODBUSM_regset($200E,1,0)'本地复制到远端 使能
	
end sub
	
'轮毂旋转
global sub move_rotate()			'speed =100

	'轮毂
	SET_wheel_addr()
	delay 10
	move_init()	
		
		delay 100
		
		modbus_reg(0) = $FFFF - $0028 + 1' 
		MODBUSM_regset($2088,1,0)'本地复制到远端 启动速度		200-- 1.46  100-- 0.72m/s		
		modbus_reg(0) = $FFFF - $0028 + 1
		MODBUSM_regset($2089,1,0)'本地复制到远端 启动速度
		
		modbus_reg(0) = $0008' 
		MODBUSM_regset($200E,1,0)'本地复制到远端 使能
end sub

'轮毂向前
global sub move_front()			'speed =100

	'轮毂
	SET_wheel_addr()
	delay 10
	
	move_init()	
		
		delay 100
		
		modbus_reg(0) = $FFFF - $0028 + 1' 
		MODBUSM_regset($2088,1,0)'本地复制到远端 启动速度		200-- 1.46  100-- 0.72m/s		
		modbus_reg(0) = $0028 
		MODBUSM_regset($2089,1,0)'本地复制到远端 启动速度
		
		modbus_reg(0) = $0008' 
		MODBUSM_regset($200E,1,0)'本地复制到远端 使能
end sub

'轮毂后退
global sub move_back()			'speed =100
	'轮毂
	SET_wheel_addr()
	delay 10
	move_init()
		
		modbus_reg(0) = $0032 ' 
		MODBUSM_regset($2088,1,0)'本地复制到远端 启动速度
		modbus_reg(0) = $FFFF - $0032 + 1' 
		MODBUSM_regset($2089,1,0)'本地复制到远端 启动速度
		
	'	modbus_reg(0) = $0008' 
	'	MODBUSM_regset($200E,1,0)'本地复制到远端 使能
end sub

'轮毂向左
global sub move_left()'speed =100
	'轮毂 
	SET_wheel_addr()
	delay 10
		
		move_init()
		
		
		modbus_reg(0) = $0008' 
		MODBUSM_regset($200E,1,0)'本地复制到远端 使能
		modbus_reg(0) = $FF9C ' 
		MODBUSM_regset($2088,1,0)'本地复制到远端 启动速度
		modbus_reg(0) = $0064 '
		MODBUSM_regset($2089,1,0)'本地复制到远端 启动速度
end sub

'轮毂向右
global sub move_right()'speed =100
	'轮毂
	SET_wheel_addr()
	delay 10
		move_init()
		
		modbus_reg(0) = $0008' 
		MODBUSM_regset($200E,1,0)'本地复制到远端 使能
		modbus_reg(0) = $0064 ' 
		MODBUSM_regset($2088,1,0)'本地复制到远端 启动速度
		modbus_reg(0) = $FF9C '
		MODBUSM_regset($2089,1,0)'本地复制到远端 启动速度
end sub

'轮毂停止
global sub move_stop()	
		SET_wheel_addr()
		delay 10
		modbus_reg(0) = $0007' 停止
		MODBUSM_regset($200E,1,0)'本地复制到远端
		delay 3
		modbus_reg(0) = $0007' 停止
		MODBUSM_regset($200E,1,0)'本地复制到远端
		
end sub 


'钢刷控制 启动 50A
global sub brush_50A_start()			'

	'50A
	MODBUSM_des(4,1)'设置对方address=4 port 为1
	delay 10
		modbus_reg(0) = $0001	'
		MODBUSM_regset($00B6,1,0)'本地复制到远端
		modbus_reg(0) = $0258	'
		MODBUSM_regset($0056,1,0)'本地复制到远端
		modbus_reg(0) = $0001	'
		MODBUSM_regset($0066,1,0)'本地复制到远端
end sub

'钢刷控制 停止 50A
global sub brush_50A_stop()			'
	
	'50A
	MODBUSM_des(4,1)'设置对方address=4 port 为1
	delay 30
	modbus_reg(0) = $0000	'
	MODBUSM_regset($0066,1,0)'本地复制到远端
end sub

'钢刷控制 读取状态 100A
global sub Read_brush_100A()
	'100A  每个指令间需延时10ms
	SET_brush_addr()
	delay 10
	modbus_reg(0) = $0001	'
	MODBUSM_regget($0111,1,10)'本地复制到远端 启动 
	delay 10
	?"钢刷电机信息：",MODBUS_REG(10) '轮毂钢刷电机
end sub

'钢刷控制 启动 100A
global sub brush_100A_start()
	'100A  每个指令间需延时10ms
	SET_brush_addr()
	delay 10
		modbus_reg(0) = $0000	'
		MODBUSM_regset($0005,1,0)'本地复制到远端 设置模式
		delay 10
		modbus_reg(0) = $0001	'
		MODBUSM_regset($0025,1,0)'本地复制到远端 485指令控制
		delay 10
		modbus_reg(0) = $00ff	'
		MODBUSM_regset($0006,1,0)'本地复制到远端  转速
		delay 10
		modbus_reg(0) = $0000	'
		MODBUSM_regset($0023,1,0)'本地复制到远端 方向
		delay 10
		modbus_reg(0) = $0001	'
		MODBUSM_regset($0022,1,0)'本地复制到远端 启动 
		delay 10
end sub

'钢刷控制 停止 100A
global sub brush_100A_stop()
	SET_brush_addr() 
	delay 10
	modbus_reg(0) = $0000	'
	MODBUSM_regset($0022,1,0)'本地复制到远端  停止
end sub

'吸尘 启动 
global sub vacuum_start()	 '		
	MOVE_PWM(1, 0, 1000) ' 0.8脉宽不启动 0.6脉宽 峰值3A电流	
end sub
'吸尘 停止
global sub vacuum_stop()			'
	MOVE_PWM(1, 0.95, 1000) 	
end sub
