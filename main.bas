ERRSWITCH = 3'��ӡ����
' RUN "global_var.bas",10
 
set_xplcterm=1 'hdmi
'set_xplcterm=0  'pc
grap_switch=0
grab_task_id=5

 
DIM char1 flag485
DIM BAT_ARRAY(14)
DIM char232(4) char_rx(3)
flag485= 0

setcom(115200,8,1,0,0,0,0,1000)	'���ô���0ΪRAW����ģʽ
setcom(9600,8,1,0,1,14,2,1000)	'���ô���1Ϊmodbus��  ���115200 ˢ��38400 ѹ��38400 ���9600
 
 
MODBUSM_des(1,1)'���öԷ�address=1 port Ϊ1 

	delay 500
	RUNTASK task_modbus_id,task_modbus		'����485�����߳� modbus��д
   ' RUNTASK grab_task_id,task_view		'������ʾ�߳�
   RUNTASK task_Ps2read_id,task_Ps2read		'�����ֱ���ȡ�߳�
   RUNTASK task_deamon_id,task_deamon		' �����߳�
   
'ָ���б�
vacuum_stop()
'OP(4,ON)'
alarm_off()	


while 1	'ѭ��'
	
	MOVE_speed = wheel_speed_l * 10 '�˶��ٶȻ���
	
	if PS2_ems = 1 or  in(3) = on	THEN
		global_ems = 1
		EMC_stop()
	ELSE
		global_ems = 0
		alarm_off()
	end if 
	
	
	if PS2_run = 1 THEN
		global_run = 1
	ELSE
		global_run = 0
	end if 

	 if Pressure_value > Pressure_th THEN
		alarm_on()
		delay   500
		alarm_off()
		delay   500
	 ELSE
		'alarm_off()
	 end if
	 
	if scan_event(in(0)) = on then '����0��Ч���˶� 							
		'SET_Modbus_wheel_addr()
		'SET_Modbus_brush_addr()		
		'Read_battery()		
		'Read_battery()
		'delay 1000
		'brush_100A_stop()
		'vacuum_stop()
		'move_front()
		'scan_all_cams()
		'PS2_init()
		
		? "in0"
		
		'OP(0,ON)
		
	elseif scan_event(in(1)) = on then '����1��Ч���˶� 
		'OP(0,OFF) 
		? "in1" 	
		'move_back()
		'Read_wheel_status()
		'brush_100A_start()
		'vacuum_start()
		
		'Read_sensor()		
		'btn_con_grap()
		'btn_softtrigger
		'PS2_Read()
		
	elseif scan_event(in(2)) = on then '����1��Ч���˶�	
		'move_stop()
		'btn_stop_grab()
		'move_stop()
		'brush_100A_stop()
		'vacuum_stop()
		
		'Read_sensor()		
		'Read_battery()
		'
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
	
	
	delay 100
wend

end

global sub EMC_stop()			'
		M_stop()
		B_stop()	
		alarm_on()
		light_off()
		'�ϵ�io	
end sub

global sub EMS_on()			'
	OP(4,ON) 	  	
end sub

global sub EMS_off()			'
	OP(4,Off) 	  	
end sub

global sub alarm_on()			'
	OP(3,ON)
	'? "out3 on"	 	  	
end sub

global sub alarm_off()			'
	OP(3,OFF) 
	'? "out3 off"	  	
end sub

global sub light_on()			'
	OP(5,ON)	  	
end sub

global sub light_off()			'
	OP(5,OFF)	  	
end sub

global sub task_deamon()			'��������
	
	while 1
		'�ֱ�ң�ض�д�ػ�����
		task_Ps2read_flag = 0
		delay 500
		if 	task_Ps2read_flag = 0  THEN
			EMC_stop()
			STOPTASK task_Ps2read_id		'�����ֱ���ȡ�߳�
			delay 10
			RUNTASK task_Ps2read_id,task_Ps2read		'�����ֱ���ȡ�߳�
		end if
	wend
end sub



