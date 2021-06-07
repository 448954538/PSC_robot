
global sub task_modbus()			'485总线 modbus协议读写
	modbus_status = 0
	wheel_cmd = 0 
	brush_cmd = 0
	DIM cnt,cnt2
	cnt=0
	cnt2 = 0
	'SET_W_baudrate()
	'mod_W_addr()
	
	move1_init()
	move2_init()
	while 1  
		
			'轮毂控制
			wheel_cmd_process()
			 
			'钢刷驱动
			brush_cmd_process()
			
			Read_distance()
			
			'传感器读取控制		
			if cnt = read_sensor_time THEN		
				'Read_sensor()
				
				cnt = 0			
			end if
			'电池读取控制				
			if cnt2 = read_battery_time THEN	
				'Read_battery()							
				cnt2 = 0
			end if
		cnt = cnt + 1
		cnt2 = cnt2 + 1
		delay 10
	wend
end sub


'modbus波特率配置 轮毂
global sub SET_W_baudrate()
	setcom(9600,8,1,0,1,14,2,1000)
	MODBUSM_des(8,1)'设置对方address  port 为1
	delay 10
	modbus_reg(0) = 2	'波特率115200
	MODBUSM_regset($2002,1,0)'本地复制到远端
	
	modbus_reg(0) = $0001' 
	MODBUSM_regset($2010,1,0)'本地复制到远端
end sub


'modbus 地址配置 轮毂
global sub mod_W_addr()
	setcom(115200,8,1,0,1,14,2,1000)
	MODBUSM_des(1,1)'设置对方address  port 为1
	delay 10
	modbus_reg(0) = 7	'波特率115200
	MODBUSM_regset($2001,1,0)'本地复制到远端
	
	modbus_reg(0) = $0001' 
	MODBUSM_regset($2010,1,0)'本地复制到远端
end sub

global sub mod_dis_addr()
	setcom(9600,8,1,0,1,14,2,1000)

		MODBUSM_des(1,1)'设置对方address

		delay 10
		modbus_reg(0) = $0009	' 地址
		MODBUSM_regset($0005,1,0)'本地复制到远端
		'delay 10
		'modbus_reg(0) = $0005'  波特率 38400
		'MODBUSM_regset($0006,1,0)'本地复制到远端
		'delay 10
	NEXT
end sub

global sub SET_battery_addr() '
	setcom(9600,8,1,0,1,14,2,1000)	'设置串口1为modbus主
	MODBUSM_des(1,1)'设置 地址1	
end sub

global sub SET_sensor_addr() ' 
	setcom(38400,8,1,0,1,14,2,1000)	'设置串口1为modbus主
	MODBUSM_des(2,1)'设置 地址2	
end sub
	
global sub SET_wheel_addr() ' 前轮
	setcom(115200,8,1,0,1,14,2,1000)	'设置串口1为modbus主
	MODBUSM_des(1,1)'设置 地址3	
end sub

global sub SET_brush_addr()
	setcom(38400,8,1,0,1,14,2,1000)	'设置串口1为modbus主
	MODBUSM_des(4,1)'设置 地址4
end sub

global sub SET_dis_f_addr() ' 
	setcom(38400,8,1,0,1,14,2,1000)	'设置串口1为modbus主
	MODBUSM_des(5,1)'设置 地址 5
end sub

global sub SET_sensor2_addr() ' 
	setcom(38400,8,1,0,1,14,2,1000)	'设置串口1为modbus主
	MODBUSM_des(6,1)'设置 地址6	
end sub

global sub SET_wheel2_addr() ' 后轮
	setcom(115200,8,1,0,1,14,2,1000)	'设置串口1为modbus主
	MODBUSM_des(7,1)'设置 地址7	
end sub

global sub SET_dis_b_addr() ' 
	setcom(38400,8,1,0,1,14,2,1000)	'设置串口1为modbus主
	MODBUSM_des(8,1)'设置 地址 8
end sub

global sub SET_dis_l_addr() ' 
	setcom(38400,8,1,0,1,14,2,1000)	'设置串口1为modbus主
	MODBUSM_des(9,1)'设置 地址 9
end sub


global sub SET_dis_r_addr() ' 
	setcom(38400,8,1,0,1,14,2,1000)	'设置串口1为modbus主
	MODBUSM_des(10,1)'设置 地址 10
end sub



'轮毂指令解析流程
global sub wheel_cmd_process() ' 
			CLR_COM1_115200()
			if wheel_cmd = 0 THEN	'读取轮毂驱动器状态 自动读取  电机停止
				move_stop()
				delay 3
				Read_wheel_status()
				wheel_cmd = 0
			elseif wheel_cmd = 1 then '运动
				'vacuum_stop()
				delay 3
				'brush_100A_stop()
				delay 3
				move_rt()
				Read_wheel_status()
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
			'CLR_COM1_RAW38400()
			'? "brush_cmd process "
			
			if brush_cmd = 0 THEN 
				vacuum_stop()
				delay 3	
				brush_100A_stop()
				'delay 3
				'Read_brush_100A()
				'? "brush_cmd  = 0 "
			elseif brush_cmd = 1 then
				'? "brush_cmd  = 1 "	
				'move_stop()
				delay 3	
				vacuum_start() 
				delay 3
				brush_100A_start() '启动钢刷
				
			ELSE
				vacuum_stop()
				delay 3	
				brush_100A_stop() '停止钢刷
				brush_cmd = 0
			end if
end sub

'modbus地址和波特率配置 
global sub CLR_COM1_RAW38400() '
	setcom(38400,8,1,0,1,0,0,1000)	'设置串口1为RAW数据模式
	FOR i=0 TO 20                      '
		putchar #1,$ff		 
	NEXT
	delay 10
end sub

global sub GET_battery_RAW() '
	DIM tmp
	setcom(9600,8,1,0,1,0,0,1000)	'设置串口1为RAW数据模式
	
	putchar #1,$01
	putchar #1,$03
	putchar #1,$00
	putchar #1,$00
	putchar #1,$00
	putchar #1,$07
	putchar #1,$04
	putchar #1,$08

	delay 30
	putchar #1,$01
	putchar #1,$03
	putchar #1,$00
	putchar #1,$00
	putchar #1,$00
	putchar #1,$07
	putchar #1,$04
	putchar #1,$08
	
	delay 30
	putchar #1,$01
	putchar #1,$03
	putchar #1,$00
	putchar #1,$00
	putchar #1,$00
	putchar #1,$07
	putchar #1,$04
	putchar #1,$08

	dim search_head
	search_head = 0
	FOR i=0 TO 18                  '
		get #1,tmp
		
		if search_head = 0 THEN
			if tmp = 1 THEN
				battery_rx(0) = tmp
				search_head = 1
			end if					
		elseif search_head = 1 THEN
			if tmp = 3 THEN
				battery_rx(1) = tmp
				search_head = 2
			ELSE
				search_head = 0
			end if							
		elseif search_head = 2 THEN
			if tmp = 14 THEN
				battery_rx(2) = tmp
				'? 0,battery_rx(0)
				'? 1,battery_rx(1)
				'? 2,battery_rx(2)
				FOR j=3 TO 18 
					get #1,tmp
					battery_rx(j) = tmp
					'? j,battery_rx(j)	
				NEXT
				dim battery_crc,battery_crc_r
				battery_crc = CRC16(battery_rx,0,17)				
				battery_crc_r=battery_rx(17)*256+battery_rx(18)
				?battery_crc,battery_crc_r
				'if battery_crc = battery_crc_r then
					Battery_V = (battery_rx(3)*256+battery_rx(4))/100
					Battery_P = (battery_rx(7)*256+battery_rx(8))
					Battery_I = (battery_rx(11)*256+battery_rx(12))/100
					Battery_Temp =  (battery_rx(15)*256+battery_rx(16))
				'end if
				search_head = 0
				exit for				
			end if
			search_head = 0										
		end if
			 
	NEXT
	delay 100
end sub

global sub CLR_COM1_115200() '
	setcom(115200,8,1,0,1,0,0,1000)	'设置串口1为RAW数据模式
	FOR i=0 TO 20                      '
		putchar #1,$ff		 
	NEXT
	delay 2
end sub


'电池读取
global sub Read_battery()
	if brush_start_flag = 0 and move_start_flag = 0 then
	'GET_battery_RAW()
		Read_battery_m()
		delay 50
		?"电池信息:", "电压" Battery_V, "电量"Battery_P ,"电流"Battery_I, "温度"Battery_Temp
	end if
end sub

global sub Read_battery_m()
	SET_battery_addr()
		delay 120								
		MODBUSM_REGGET($0000,7,20)'电池信息  连续读取间隔需大于100ms			
		Battery_V = MODBUS_REG(20)/100
		Battery_P = MODBUS_REG(22)
		Battery_I = MODBUS_REG(24)/100
		Battery_Temp =  MODBUS_REG(26)
end sub

'传感器读取
global sub Read_sensor()
	if brush_start_flag = 0 and move_start_flag = 0 then
		CLR_COM1_RAW38400()
		SET_sensor_addr()
		delay 3
		MODBUSM_REGGET($0050,2,30)'读取压力传感数据
		
		'if(MODBUS_REG(31) >= 0  )  then    '有接受到数据
			MODBUS_REG(33) = MODBUS_REG(30)
			MODBUS_REG(32) = MODBUS_REG(31)
			Pressure_value1 = MODBUS_LONG(32)
			'? MODBUS_REG(30),MODBUS_REG(31),MODBUS_LONG(32)
			'?"压力1",Pressure_value1 '显示数据
		'endif
		
		SET_sensor2_addr()
		delay 3
		MODBUSM_REGGET($0050,2,35)'读取压力传感数据
		
		'if(MODBUS_REG(31) >= 0  )  then    '有接受到数据
			MODBUS_REG(38) = MODBUS_REG(35)
			MODBUS_REG(37) = MODBUS_REG(36)
			Pressure_value2 = MODBUS_LONG(37)
			'? MODBUS_REG(35),MODBUS_REG(36),MODBUS_LONG(37)
			?"压力2",Pressure_value2 '显示数据
		'endif
		'Pressure_value = (Pressure_value1 + Pressure_value2)
		Pressure_value = Pressure_value2
		?"压力",Pressure_value '显示数据
	end if
end sub


'超声波读取
global sub Read_distance()
	
		'CLR_COM1_RAW38400()
		read_distance_f()
		Read_distance_b()
		'Read_distance_l()
		'Read_distance_r()
	
end sub

global sub Read_distance_f()
		SET_dis_f_addr()
		
		delay 10
		MODBUSM_REGGET($0000,3,40)'读取距离数据
		'MODBUSM_REGGET($00002,40)'读取距离数据	
		delay 1'
		dim arry(6)
		'arry=MODBUS_STRING(40,6)
		arry(0)= (MODBUS_REG(40)>>8) and $00ff
		arry(1)=  MODBUS_REG(40) and $00ff 
		arry(2)=  (MODBUS_REG(41)>>8) and $00ff
		arry(3)=  MODBUS_REG(41) and $00ff
		arry(4)= (MODBUS_REG(42)>> 8) and $00ff
		arry(5)= MODBUS_REG(42) and $00ff 
		dim flag1,flag2,flag3
		flag1 = 0 
		flag2 = 0 
		flag3 = 0
		if arry(1)  <safe_distance and arry(1) >0 THEN
			flag1 = 1
		end if
		if arry(2)  <safe_distance and arry(2) >0 THEN
			flag2 = 1
		end if
		if arry(3)  <safe_distance and arry(3) >0 THEN
			flag3 = 1
		end if
		if flag1 = 1 or flag2 = 1 or  flag3 = 1 THEN
			'distance_f = (arry(1)+arry(2)+arry(3))/3
			distance_f = 1
		ELSE
			distance_f = 0
		end if
		?"距离f",distance_f '显示数据
		'? MODBUS_REG(40),MODBUS_REG(41),MODBUS_REG(42)
		?arry(0) ,arry(1),arry(2),arry(3),arry(4),arry(5)

end sub
global sub Read_distance_b()
		SET_dis_b_addr()
		delay 10
		MODBUSM_REGGET($0000,3,45)'读取距离数据
		'MODBUSM_REGGET($0000,2,40)'读取距离数据	45
		
		dim arry(6)
		arry(0)= (MODBUS_REG(45)>>8) and $00ff
		arry(1)=  MODBUS_REG(45) and $00ff 
		arry(2)=  (MODBUS_REG(46)>>8) and $00ff
		arry(3)=  MODBUS_REG(46) and $00ff
		arry(4)= (MODBUS_REG(47)>> 8) and $00ff
		arry(5)= MODBUS_REG(47) and $00ff 
		dim flag0,flag1,flag2,flag3,flag4
		flag0 = 0 
		flag1 = 0 
		flag2 = 0 
		flag3 = 0
		flag4 = 0 
		if arry(0)  < safe_distance and arry(0) >0 THEN
			flag0 = 1
		end if
		if arry(1)  <safe_distance and arry(1) >0 THEN
			flag1 = 1
		end if
		if arry(2)  <safe_distance and arry(2) >0 THEN
			flag2 = 1
		end if
		if arry(3)  <safe_distance and arry(3) >0 THEN
			flag3 = 1
		end if
		if arry(4)  <safe_distance and arry(4) >0 THEN
			flag4 = 1
		end if
		if flag0 = 1 or flag1 = 1 or flag2 = 1 or  flag3 = 1 or  flag4 = 1 THEN
			distance_b = 1
		ELSE
			distance_b = 0
		end if
		?"距离b",distance_b '显示数据
		'? MODBUS_REG(45),MODBUS_REG(46),MODBUS_REG(47)
		?arry(0) ,arry(1),arry(2),arry(3),arry(4),arry(5)
		
		
end sub

global sub Read_distance_l()
		SET_dis_l_addr()
		delay 10
		MODBUSM_REGGET($0000,3,50)'读取距离数据
		'MODBUSM_REGGET($0000,2,40)'读取距离数据
		dim arry(6)
		arry(0)= (MODBUS_REG(50)>>8) and $00ff
		arry(1)=  MODBUS_REG(50) and $00ff 
		arry(2)=  (MODBUS_REG(51)>>8) and $00ff
		arry(3)=  MODBUS_REG(51) and $00ff
		arry(4)= (MODBUS_REG(52)>> 8) and $00ff
		arry(5)= MODBUS_REG(52) and $00ff 
		dim flag1,flag2,flag3
		flag1 = 0 
		flag2 = 0 
		flag3 = 0
		if arry(1)  <safe_distance and arry(1) >0 THEN
			flag1 = 1
		end if
		if arry(2)  <safe_distance and arry(2) >0 THEN
			flag2 = 1
		end if
		if arry(3)  <safe_distance and arry(3) >0 THEN
			flag3 = 1
		end if
		if flag1 = 1 or flag2 = 1 or  flag3 = 1 THEN
			distance_l = 1
		ELSE
			distance_l = 0
		end if
		
		
			?"距离l",distance_l '显示数据
			?arry(0) ,arry(1),arry(2),arry(3),arry(4),arry(5)
end sub

global sub Read_distance_r()
		SET_dis_r_addr()
		delay 10
		MODBUSM_REGGET($0000,3,55)'读取距离数据
		'MODBUSM_REGGET($0000,2,40)'读取距离数据
		dim arry(6)
		arry(0)= (MODBUS_REG(55)>>8) and $00ff
		arry(1)=  MODBUS_REG(55) and $00ff 
		arry(2)=  (MODBUS_REG(56)>>8) and $00ff
		arry(3)=  MODBUS_REG(56) and $00ff
		arry(4)= (MODBUS_REG(57)>> 8) and $00ff
		arry(5)= MODBUS_REG(57) and $00ff 
		dim flag1,flag2,flag3
		flag1 = 0 
		flag2 = 0 
		flag3 = 0
		if arry(1)  <safe_distance and arry(1) >0 THEN
			flag1 = 1
		end if
		if arry(2)  <safe_distance and arry(2) >0 THEN
			flag2 = 1
		end if
		if arry(3)  <safe_distance and arry(3) >0 THEN
			flag3 = 1
		end if
		if flag1 = 1 or flag2 = 1 or  flag3 = 1 THEN
			distance_r = 1
		ELSE
			distance_r = 0
		end if	
		?"距离r",distance_r '显示数据
		
		?arry(0) ,arry(1),arry(2),arry(3),arry(4),arry(5)
end sub


global sub move1_init() '
	SET_wheel_addr()
	move_init() '
end sub

global sub move2_init() '
	SET_wheel2_addr()
	move_init() '
end sub

'轮毂初始化
global sub move_init() '
	delay 10
		modbus_reg(0) = $0003	'速度控制
		MODBUSM_regset($200D,1,0)'本地复制到远端
		modbus_reg(0) = $1F4' 电机加减速时间 $03E8 1000  1F4 500
		MODBUSM_regset($2080,1,0)'本地复制到远端 左加速
		MODBUSM_regset($2081,1,0)'本地复制到远端 右加速
		MODBUSM_regset($2082,1,0)'本地复制到远端 左减速
		MODBUSM_regset($2083,1,0)'本地复制到远端 右减速
				
		modbus_reg(0) = $000F' 电机极对数 10
		MODBUSM_regset($2075,1,0)'本地复制到远端 
		modbus_reg(0) = $000F' 电机极对数 10
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
		delay 3	
		MODBUSM_REGGET($20A5,2,10)'读取轮毂故障信息	
		?"轮毂1信息$20A5：",MODBUS_REG(10) ,MODBUS_REG(11) '轮毂信息
		'Read_wheel_debug()
		SET_wheel2_addr()
		delay 3	
		mODBUSM_REGGET($20A5,2,10)'读取轮毂故障信息	
		?"轮毂2信息$20A5：",MODBUS_REG(10) ,MODBUS_REG(11) '轮毂信息
		'Read_wheel_debug()	
end sub

'轮毂状态读取
global sub Read_wheel_debug()
			MODBUSM_REGGET($2002,2,10)'读取轮毂故障信息	
			?"$2002信息：",MODBUS_REG(10) '
			MODBUSM_REGGET($2030,2,10)'读取轮毂故障信息	
			?"$2030线数：",MODBUS_REG(10) '线数
			MODBUSM_REGGET($2075,2,10)'读取轮毂故障信息	
			?"$2075极对数：",MODBUS_REG(10)'轮毂信息
			MODBUSM_REGGET($2061,2,10)'读取轮毂故障信息	
			?"$2061偏移角度：",MODBUS_REG(10) '轮毂信息
			MODBUSM_REGGET($2064,2,10)'读取轮毂故障信息	
			?"$2064信息：",MODBUS_REG(10) '轮毂信息
			MODBUSM_REGGET($2033,2,10)'读取轮毂故障信息	
			?"$2033信息：",MODBUS_REG(10) '轮毂信息
			mODBUSM_REGGET($2036,2,10)'读取轮毂故障信息	
			?"$2036信息：",MODBUS_REG(10) '轮毂信息
			MODBUSM_REGGET($203C,2,10)'读取轮毂故障信息	
			?"$203C信息：",MODBUS_REG(10) '轮毂信息
			MODBUSM_REGGET($203D,2,10)'读取轮毂故障信息	
			?"$203D信息：",MODBUS_REG(10) '轮毂信息
			MODBUSM_REGGET($203E,2,10)'读取轮毂故障信息	
			?"$203E信息：",MODBUS_REG(10) '轮毂信息
			
			MODBUSM_REGGET($2067,2,10)'读取轮毂故障信息	
			?"$2067信息：",MODBUS_REG(10) '轮毂信息	
			MODBUSM_REGGET($2068,2,10)'读取轮毂故障信息	
			?"$2068信息：",MODBUS_REG(10) '轮毂信息	
			MODBUSM_REGGET($2069,2,10)'读取轮毂故障信息	
			?"$2069信息：",MODBUS_REG(10) '轮毂信息
			MODBUSM_REGGET($206A,2,10)'读取轮毂故障信息	
			?"$206A信息：",MODBUS_REG(10) '轮毂信息
			MODBUSM_REGGET($206B,2,10)'读取轮毂故障信息	
			?"$206B信息：",MODBUS_REG(10) '轮毂信息
			
			MODBUSM_REGGET($2010,2,10)'读取轮毂故障信息	
			?"$2010信息：",MODBUS_REG(10) '轮毂信息
end sub

'轮毂报警清除
global sub Clear_wheel_alarm() '

	SET_wheel_addr()
	delay 3	
	modbus_reg(0) = $0006' 
	MODBUSM_regset($200E,1,0)'清除报警信息
	
end sub

'轮毂急停控制
global sub move_EMS() '

	SET_wheel_addr()
	delay 3	
	modbus_reg(0) = $0005' 
	MODBUSM_regset($200E,1,0)'轮毂急停
	
end sub

'轮毂实时运动
global sub move_rt() '
	? "move_rt"
	move_start_flag = 1
	sET_wheel_addr()
	
	delay 3	
	modbus_reg(0) = wheel_speed_l ' 前右
	MODBUSM_regset($2088,1,0)'本地复制到远端 启动速度
	delay 3
	modbus_reg(0) = -wheel_speed_r '前左		
	MODBUSM_regset($2089,1,0)'本地复制到远端 启动速度
	
	modbus_reg(0) = $0008' 
	MODBUSM_regset($200E,1,0)'本地复制到远端 使能
	'
	SET_wheel2_addr()
	delay 3	
	modbus_reg(0) = - wheel_speed_r' 后左
	MODBUSM_regset($2088,1,0)'本地复制到远端 启动速度
	delay 3
	modbus_reg(0) = wheel_speed_l  ' 后右		
	MODBUSM_regset($2089,1,0)'本地复制到远端 启动速度
	
	modbus_reg(0) = $0008' 
	MODBUSM_regset($200E,1,0)'本地复制到远端 使能
	
end sub
	
'轮毂旋转
global sub move_rotate()			'speed =100

	move_start_flag = 1
	'轮毂
	SET_wheel_addr()
	delay 3
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

	move_start_flag = 1
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
	move_start_flag = 1
	'轮毂
	SET_wheel_addr()
	delay 3
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
	move_start_flag = 1
	'轮毂 
	SET_wheel_addr()
	delay 3
		
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
	move_start_flag = 1
	'轮毂
	SET_wheel_addr()
	delay 3
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
	if move_start_flag = 1 then
						
		SET_wheel_addr()
		delay 3
		modbus_reg(0) = $0007' 停止
		MODBUSM_regset($200E,1,0)'本地复制到远端
		delay 3
		modbus_reg(0) = $0007' 停止
		MODBUSM_regset($200E,1,0)'本地复制到远端
		
		SET_wheel2_addr()
		delay 3
		modbus_reg(0) = $0007' 停止
		MODBUSM_regset($200E,1,0)'本地复制到远端
		delay 3
		modbus_reg(0) = $0007' 停止
		MODBUSM_regset($200E,1,0)'本地复制到远端
		move_start_flag = 0
	end if
end sub 


'钢刷控制 启动 50A
global sub brush_50A_start()			'
	brush_start_flag = 1
	'50A
	MODBUSM_des(4,1)'设置对方address=4 port 为1
	delay 3
		modbus_reg(0) = $0001	'
		MODBUSM_regset($00B6,1,0)'本地复制到远端
		modbus_reg(0) = $0258	'
		MODBUSM_regset($0056,1,0)'本地复制到远端
		modbus_reg(0) = $0001	'
		MODBUSM_regset($0066,1,0)'本地复制到远端
end sub

'钢刷控制 停止 50A
global sub brush_50A_stop()			'
	
	if brush_start_flag = 1 then
		'50A
		MODBUSM_des(4,1)'设置对方address=4 port 为1
		delay 3
		modbus_reg(0) = $0000	'
		MODBUSM_regset($0066,1,0)'本地复制到远端
		brush_start_flag = 0
	end if
end sub

'钢刷控制 读取状态 100A
global sub Read_brush_100A()
	'100A  每个指令间需延时10ms
	SET_brush_addr()
	delay 3
	modbus_reg(0) = $0001	'
	MODBUSM_regget($0111,1,10)'本地复制到远端 启动 
	delay 3
	?"钢刷电机信息：",MODBUS_REG(10) '轮毂钢刷电机
end sub

'钢刷控制 启动 100A
global sub brush_100A_start()
	brush_start_flag = 1
	'100A  每个指令间需延时10ms
	SET_brush_addr()
	delay 3
	modbus_reg(0) = $0000	'
	MODBUSM_regset($0005,1,0)'本地复制到远端 设置模式
	delay 10
	modbus_reg(0) = $0001	'
	MODBUSM_regset($0025,1,0)'本地复制到远端 485指令控制
	delay 10
	modbus_reg(0) = brush_speed '
	MODBUSM_regset($0006,1,0)'本地复制到远端  转速
	delay 10
	modbus_reg(0) = $0001	'
	MODBUSM_regset($0023,1,0)'本地复制到远端 方向
	delay 10
	modbus_reg(0) = $0001	'
	MODBUSM_regset($0022,1,0)'本地复制到远端 启动 
	delay 10
end sub

'钢刷控制 停止 100A
global sub brush_100A_stop()
	if brush_start_flag = 1 then
		SET_brush_addr() 
		delay 3
		modbus_reg(0) = $0000	'
		MODBUSM_regset($0022,1,0)'本地复制到远端  停止
		brush_start_flag = 0
	end if
end sub

'吸尘 启动 vacuum_start
global sub vacuum_start()	 '	
	vacuum_start_flag = 1
	'MOVE_PWM(0, 0, 1000) ' 0.8脉宽不启动 0.6脉宽 峰值3A电流	
	MOVE_PWM(1, 0, 1000) 

	?"vacumm start..."
end sub
'吸尘 停止
global sub vacuum_stop()
	'if vacuum_start_flag = 1 then'
		'MOVE_PWM(0, 0.95, 1000) 
		MOVE_PWM(1, 0.95, 1000) 
		 
		vacuum_start_flag = 0
	'end if	
end sub
