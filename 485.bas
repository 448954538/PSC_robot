
global sub task_modbus()			'485总线 modbus协议读写
	modbus_status = 0
	wheel_cmd = 0 
	brush_cmd = 0
	while 1  
		if modbus_status = 0 THEN  '轮毂控制  解析指令
			if wheel_cmd = 0 THEN	'读取轮毂驱动器状态 自动读取
				
				modbus_status = 1
			elseif wheel_cmd = 1 then '向前
				move_front()
				wheel_cmd = 0
			elseif wheel_cmd = 2 then'向后
				move_back()
				wheel_cmd = 0
			elseif wheel_cmd = 3 then'向左
				move_left()
				wheel_cmd = 0
			elseif wheel_cmd = 4 then'向右
				move_right()
				wheel_cmd = 0
			elseif wheel_cmd = 5 then'停止
				move_stop()
				wheel_cmd = 0
			ELSE
				wheel_cmd = 0	
			end if
			modbus_status = 1
		elseif modbus_status = 1 then '钢刷控制  解析指令
			if brush_cmd = 0 THEN '读取钢刷驱动器状态 自动读取
				
				modbus_status = 2
			elseif brush_cmd = 1 then
				brush_100A_start() '启动钢刷
				brush_cmd = 0
			elseif brush_cmd = 2 then
				brush_100A_stop() '停止钢刷
				brush_cmd = 0
			ELSE
				brush_cmd = 0
			end if
			modbus_status = 2
		elseif modbus_status = 2 then  '电池读取控制  自动读取
			Read_battery()
			modbus_status = 3
		elseif modbus_status = 3 then '压力读取控制  自动读取
			Read_sensor()
			modbus_status = 0
		else
			modbus_status = 0
		end if
		delay 100	
	wend
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
	Battery_V = MODBUS_REG(10)
	Battery_W = MODBUS_REG(12)
	Battery_I = MODBUS_REG(14)
	Battery_Temp =  MODBUS_REG(16)
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
			Pressure_value = MODBUS_LONG(12)
			?"压力",Pressure_value '显示数据
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
global sub move_back()			'
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

global sub move_left()

end sub

global sub move_right()

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