ERRSWITCH = 3'��ӡ����
 
set_xplcterm=1
grap_switch=0
grab_task_id=5
 d_cam_expostime = 500000

setcom(115200,8,1,0,0,0,0,1000)	'���ô���0ΪRAW����ģʽ
setcom(9600,8,1,0,1,14,2,1000)	'���ô���1Ϊmodbus��  ���115200 ˢ��38400 ѹ��19200 ���9600
'setcom(9600,8,1,0,1,0,0,1000)	'���ô���1ΪRAW ��ض�д 

MODBUSM_des(1,1)'���öԷ�address=1 port Ϊ1 

	'RUNTASK 2,task_modbus		'����485�����߳� modbus��д
   'RUNTASK 3,task_view		'������ʾ�߳�
   'RUNTASK 4,task_Ps2read		'�����ֱ���ȡ�߳�
    'RUNTASK 5,task_cmd		' �����߳�
   
'ָ���б�
MOVE_PWM(1, 0.95, 1000)
 
DIM char1 flag485
DIM BAT_ARRAY(14)
DIM char232(4) char_rx(3)
flag485= 0
while 1	'ѭ���˶�
	
	
	if scan_event(in(0)) = on then '����0��Ч���˶� 							
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
	elseif scan_event(in(1)) = on then '����1��Ч���˶� 
		OP(0,OFF) 
		? "in1" 		
		'move_stop()
		'brush_100A_start()
		'vacuum_start()
		
		'Read_sensor()		
		btn_con_grap()
		'btn_softtrigger
		'PS2_Read()
		
	elseif scan_event(in(2)) = on then '����1��Ч���˶�	
	
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




global sub vacuum_start()	 '		
		MOVE_PWM(1, 0.6, 1000) ' 0.8�������� 0.6���� ��ֵ3A����	
end sub

global sub vacuum_stop()			'
		MOVE_PWM(1, 0.95, 1000) 	
end sub


global sub task_cmd()			'��������
	
	while 1
		'MODBUSM_REGGET($0050,2,10)'��ȡѹ����������	
		'if(MODBUS_REG(11) >= 0  )  then    '�н��ܵ�����
		'	MODBUS_REG(13) = MODBUS_REG(10)
		'	MODBUS_REG(12) = MODBUS_REG(11)
		'	?"ѹ��",MODBUS_LONG(12)
		'endif	
		'MODBUSM_REGGET($0000,30,10)
		'?"�����Ϣ:"MODBUS_REG(10), MODBUS_REG(11),MODBUS_REG(12), MODBUS_REG(12)		
		
		delay 100
	wend
end sub
