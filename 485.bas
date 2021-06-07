
global sub task_modbus()			'485���� modbusЭ���д
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
		
			'��챿���
			wheel_cmd_process()
			 
			'��ˢ����
			brush_cmd_process()
			
			Read_distance()
			
			'��������ȡ����		
			if cnt = read_sensor_time THEN		
				'Read_sensor()
				
				cnt = 0			
			end if
			'��ض�ȡ����				
			if cnt2 = read_battery_time THEN	
				'Read_battery()							
				cnt2 = 0
			end if
		cnt = cnt + 1
		cnt2 = cnt2 + 1
		delay 10
	wend
end sub


'modbus���������� ���
global sub SET_W_baudrate()
	setcom(9600,8,1,0,1,14,2,1000)
	MODBUSM_des(8,1)'���öԷ�address  port Ϊ1
	delay 10
	modbus_reg(0) = 2	'������115200
	MODBUSM_regset($2002,1,0)'���ظ��Ƶ�Զ��
	
	modbus_reg(0) = $0001' 
	MODBUSM_regset($2010,1,0)'���ظ��Ƶ�Զ��
end sub


'modbus ��ַ���� ���
global sub mod_W_addr()
	setcom(115200,8,1,0,1,14,2,1000)
	MODBUSM_des(1,1)'���öԷ�address  port Ϊ1
	delay 10
	modbus_reg(0) = 7	'������115200
	MODBUSM_regset($2001,1,0)'���ظ��Ƶ�Զ��
	
	modbus_reg(0) = $0001' 
	MODBUSM_regset($2010,1,0)'���ظ��Ƶ�Զ��
end sub

global sub mod_dis_addr()
	setcom(9600,8,1,0,1,14,2,1000)

		MODBUSM_des(1,1)'���öԷ�address

		delay 10
		modbus_reg(0) = $0009	' ��ַ
		MODBUSM_regset($0005,1,0)'���ظ��Ƶ�Զ��
		'delay 10
		'modbus_reg(0) = $0005'  ������ 38400
		'MODBUSM_regset($0006,1,0)'���ظ��Ƶ�Զ��
		'delay 10
	NEXT
end sub

global sub SET_battery_addr() '
	setcom(9600,8,1,0,1,14,2,1000)	'���ô���1Ϊmodbus��
	MODBUSM_des(1,1)'���� ��ַ1	
end sub

global sub SET_sensor_addr() ' 
	setcom(38400,8,1,0,1,14,2,1000)	'���ô���1Ϊmodbus��
	MODBUSM_des(2,1)'���� ��ַ2	
end sub
	
global sub SET_wheel_addr() ' ǰ��
	setcom(115200,8,1,0,1,14,2,1000)	'���ô���1Ϊmodbus��
	MODBUSM_des(1,1)'���� ��ַ3	
end sub

global sub SET_brush_addr()
	setcom(38400,8,1,0,1,14,2,1000)	'���ô���1Ϊmodbus��
	MODBUSM_des(4,1)'���� ��ַ4
end sub

global sub SET_dis_f_addr() ' 
	setcom(38400,8,1,0,1,14,2,1000)	'���ô���1Ϊmodbus��
	MODBUSM_des(5,1)'���� ��ַ 5
end sub

global sub SET_sensor2_addr() ' 
	setcom(38400,8,1,0,1,14,2,1000)	'���ô���1Ϊmodbus��
	MODBUSM_des(6,1)'���� ��ַ6	
end sub

global sub SET_wheel2_addr() ' ����
	setcom(115200,8,1,0,1,14,2,1000)	'���ô���1Ϊmodbus��
	MODBUSM_des(7,1)'���� ��ַ7	
end sub

global sub SET_dis_b_addr() ' 
	setcom(38400,8,1,0,1,14,2,1000)	'���ô���1Ϊmodbus��
	MODBUSM_des(8,1)'���� ��ַ 8
end sub

global sub SET_dis_l_addr() ' 
	setcom(38400,8,1,0,1,14,2,1000)	'���ô���1Ϊmodbus��
	MODBUSM_des(9,1)'���� ��ַ 9
end sub


global sub SET_dis_r_addr() ' 
	setcom(38400,8,1,0,1,14,2,1000)	'���ô���1Ϊmodbus��
	MODBUSM_des(10,1)'���� ��ַ 10
end sub



'���ָ���������
global sub wheel_cmd_process() ' 
			CLR_COM1_115200()
			if wheel_cmd = 0 THEN	'��ȡ���������״̬ �Զ���ȡ  ���ֹͣ
				move_stop()
				delay 3
				Read_wheel_status()
				wheel_cmd = 0
			elseif wheel_cmd = 1 then '�˶�
				'vacuum_stop()
				delay 3
				'brush_100A_stop()
				delay 3
				move_rt()
				Read_wheel_status()
			elseif wheel_cmd = 2 then'��ǰ
				move_front()
				wheel_cmd = 0
			elseif wheel_cmd = 3 then'���
				move_back()
				wheel_cmd = 0
			elseif wheel_cmd = 4 then'����
				move_left()
				wheel_cmd = 0
			elseif wheel_cmd = 5 then'����
				move_right()
				wheel_cmd = 0
			ELSE
				move_stop()
				wheel_cmd = 0	
			end if	
end sub

'��ˢָ���������
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
				brush_100A_start() '������ˢ
				
			ELSE
				vacuum_stop()
				delay 3	
				brush_100A_stop() 'ֹͣ��ˢ
				brush_cmd = 0
			end if
end sub

'modbus��ַ�Ͳ��������� 
global sub CLR_COM1_RAW38400() '
	setcom(38400,8,1,0,1,0,0,1000)	'���ô���1ΪRAW����ģʽ
	FOR i=0 TO 20                      '
		putchar #1,$ff		 
	NEXT
	delay 10
end sub

global sub GET_battery_RAW() '
	DIM tmp
	setcom(9600,8,1,0,1,0,0,1000)	'���ô���1ΪRAW����ģʽ
	
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
	setcom(115200,8,1,0,1,0,0,1000)	'���ô���1ΪRAW����ģʽ
	FOR i=0 TO 20                      '
		putchar #1,$ff		 
	NEXT
	delay 2
end sub


'��ض�ȡ
global sub Read_battery()
	if brush_start_flag = 0 and move_start_flag = 0 then
	'GET_battery_RAW()
		Read_battery_m()
		delay 50
		?"�����Ϣ:", "��ѹ" Battery_V, "����"Battery_P ,"����"Battery_I, "�¶�"Battery_Temp
	end if
end sub

global sub Read_battery_m()
	SET_battery_addr()
		delay 120								
		MODBUSM_REGGET($0000,7,20)'�����Ϣ  ������ȡ��������100ms			
		Battery_V = MODBUS_REG(20)/100
		Battery_P = MODBUS_REG(22)
		Battery_I = MODBUS_REG(24)/100
		Battery_Temp =  MODBUS_REG(26)
end sub

'��������ȡ
global sub Read_sensor()
	if brush_start_flag = 0 and move_start_flag = 0 then
		CLR_COM1_RAW38400()
		SET_sensor_addr()
		delay 3
		MODBUSM_REGGET($0050,2,30)'��ȡѹ����������
		
		'if(MODBUS_REG(31) >= 0  )  then    '�н��ܵ�����
			MODBUS_REG(33) = MODBUS_REG(30)
			MODBUS_REG(32) = MODBUS_REG(31)
			Pressure_value1 = MODBUS_LONG(32)
			'? MODBUS_REG(30),MODBUS_REG(31),MODBUS_LONG(32)
			'?"ѹ��1",Pressure_value1 '��ʾ����
		'endif
		
		SET_sensor2_addr()
		delay 3
		MODBUSM_REGGET($0050,2,35)'��ȡѹ����������
		
		'if(MODBUS_REG(31) >= 0  )  then    '�н��ܵ�����
			MODBUS_REG(38) = MODBUS_REG(35)
			MODBUS_REG(37) = MODBUS_REG(36)
			Pressure_value2 = MODBUS_LONG(37)
			'? MODBUS_REG(35),MODBUS_REG(36),MODBUS_LONG(37)
			?"ѹ��2",Pressure_value2 '��ʾ����
		'endif
		'Pressure_value = (Pressure_value1 + Pressure_value2)
		Pressure_value = Pressure_value2
		?"ѹ��",Pressure_value '��ʾ����
	end if
end sub


'��������ȡ
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
		MODBUSM_REGGET($0000,3,40)'��ȡ��������
		'MODBUSM_REGGET($00002,40)'��ȡ��������	
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
		?"����f",distance_f '��ʾ����
		'? MODBUS_REG(40),MODBUS_REG(41),MODBUS_REG(42)
		?arry(0) ,arry(1),arry(2),arry(3),arry(4),arry(5)

end sub
global sub Read_distance_b()
		SET_dis_b_addr()
		delay 10
		MODBUSM_REGGET($0000,3,45)'��ȡ��������
		'MODBUSM_REGGET($0000,2,40)'��ȡ��������	45
		
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
		?"����b",distance_b '��ʾ����
		'? MODBUS_REG(45),MODBUS_REG(46),MODBUS_REG(47)
		?arry(0) ,arry(1),arry(2),arry(3),arry(4),arry(5)
		
		
end sub

global sub Read_distance_l()
		SET_dis_l_addr()
		delay 10
		MODBUSM_REGGET($0000,3,50)'��ȡ��������
		'MODBUSM_REGGET($0000,2,40)'��ȡ��������
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
		
		
			?"����l",distance_l '��ʾ����
			?arry(0) ,arry(1),arry(2),arry(3),arry(4),arry(5)
end sub

global sub Read_distance_r()
		SET_dis_r_addr()
		delay 10
		MODBUSM_REGGET($0000,3,55)'��ȡ��������
		'MODBUSM_REGGET($0000,2,40)'��ȡ��������
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
		?"����r",distance_r '��ʾ����
		
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

'��챳�ʼ��
global sub move_init() '
	delay 10
		modbus_reg(0) = $0003	'�ٶȿ���
		MODBUSM_regset($200D,1,0)'���ظ��Ƶ�Զ��
		modbus_reg(0) = $1F4' ����Ӽ���ʱ�� $03E8 1000  1F4 500
		MODBUSM_regset($2080,1,0)'���ظ��Ƶ�Զ�� �����
		MODBUSM_regset($2081,1,0)'���ظ��Ƶ�Զ�� �Ҽ���
		MODBUSM_regset($2082,1,0)'���ظ��Ƶ�Զ�� �����
		MODBUSM_regset($2083,1,0)'���ظ��Ƶ�Զ�� �Ҽ���
				
		modbus_reg(0) = $000F' ��������� 10
		MODBUSM_regset($2075,1,0)'���ظ��Ƶ�Զ�� 
		modbus_reg(0) = $000F' ��������� 10
		MODBUSM_regset($2045,1,0)'���ظ��Ƶ�Զ��
		
		
		'�ٶȻ�����
		modbus_reg(0) = $01F4' 1F4
		MODBUSM_regset($203C,1,0)'���ظ��Ƶ�Զ�� 
		modbus_reg(0) = $03E8' 
		MODBUSM_regset($203D,1,0)'���ظ��Ƶ�Զ��
		modbus_reg(0) = $03E8' 
		MODBUSM_regset($203E,1,0)'���ظ��Ƶ�Զ��
		
		modbus_reg(0) = $01F4' 
		MODBUSM_regset($206C,1,0)'���ظ��Ƶ�Զ�� 
		modbus_reg(0) = $03E8' 
		MODBUSM_regset($206D,1,0)'���ظ��Ƶ�Զ��
		modbus_reg(0) = $03E8' 
		MODBUSM_regset($206E,1,0)'���ظ��Ƶ�Զ��
		
		'�������ֵ
		modbus_reg(0) = $0666' 
		MODBUSM_regset($2036,1,0)'���ظ��Ƶ�Զ��
		modbus_reg(0) = $0666' 
		MODBUSM_regset($2066,1,0)'���ظ��Ƶ�Զ��
		
		'�ٶ�ƽ��ϵ��
		modbus_reg(0) = $0032' 
		MODBUSM_regset($2037,1,0)'���ظ��Ƶ�Զ��
		modbus_reg(0) = $0032' 
		MODBUSM_regset($2067,1,0)'���ظ��Ƶ�Զ��
		
		'������
		modbus_reg(0) = $0258' 
		MODBUSM_regset($2038,1,0)'���ظ��Ƶ�Զ��
		modbus_reg(0) = $012C' 
		MODBUSM_regset($2039,1,0)'���ظ��Ƶ�Զ��		
		modbus_reg(0) = $0258' 
		MODBUSM_regset($2068,1,0)'���ظ��Ƶ�Զ��
		
		modbus_reg(0) = $012C' 
		MODBUSM_regset($2069,1,0)'���ظ��Ƶ�Զ��
		
		delay 100
		
		modbus_reg(0) = $0001' 
		MODBUSM_regset($2010,1,0)'���ظ��Ƶ�Զ��
	
end sub

'���״̬��ȡ
global sub Read_wheel_status()
		
		SET_wheel_addr()
		delay 3	
		MODBUSM_REGGET($20A5,2,10)'��ȡ��챹�����Ϣ	
		?"���1��Ϣ$20A5��",MODBUS_REG(10) ,MODBUS_REG(11) '�����Ϣ
		'Read_wheel_debug()
		SET_wheel2_addr()
		delay 3	
		mODBUSM_REGGET($20A5,2,10)'��ȡ��챹�����Ϣ	
		?"���2��Ϣ$20A5��",MODBUS_REG(10) ,MODBUS_REG(11) '�����Ϣ
		'Read_wheel_debug()	
end sub

'���״̬��ȡ
global sub Read_wheel_debug()
			MODBUSM_REGGET($2002,2,10)'��ȡ��챹�����Ϣ	
			?"$2002��Ϣ��",MODBUS_REG(10) '
			MODBUSM_REGGET($2030,2,10)'��ȡ��챹�����Ϣ	
			?"$2030������",MODBUS_REG(10) '����
			MODBUSM_REGGET($2075,2,10)'��ȡ��챹�����Ϣ	
			?"$2075��������",MODBUS_REG(10)'�����Ϣ
			MODBUSM_REGGET($2061,2,10)'��ȡ��챹�����Ϣ	
			?"$2061ƫ�ƽǶȣ�",MODBUS_REG(10) '�����Ϣ
			MODBUSM_REGGET($2064,2,10)'��ȡ��챹�����Ϣ	
			?"$2064��Ϣ��",MODBUS_REG(10) '�����Ϣ
			MODBUSM_REGGET($2033,2,10)'��ȡ��챹�����Ϣ	
			?"$2033��Ϣ��",MODBUS_REG(10) '�����Ϣ
			mODBUSM_REGGET($2036,2,10)'��ȡ��챹�����Ϣ	
			?"$2036��Ϣ��",MODBUS_REG(10) '�����Ϣ
			MODBUSM_REGGET($203C,2,10)'��ȡ��챹�����Ϣ	
			?"$203C��Ϣ��",MODBUS_REG(10) '�����Ϣ
			MODBUSM_REGGET($203D,2,10)'��ȡ��챹�����Ϣ	
			?"$203D��Ϣ��",MODBUS_REG(10) '�����Ϣ
			MODBUSM_REGGET($203E,2,10)'��ȡ��챹�����Ϣ	
			?"$203E��Ϣ��",MODBUS_REG(10) '�����Ϣ
			
			MODBUSM_REGGET($2067,2,10)'��ȡ��챹�����Ϣ	
			?"$2067��Ϣ��",MODBUS_REG(10) '�����Ϣ	
			MODBUSM_REGGET($2068,2,10)'��ȡ��챹�����Ϣ	
			?"$2068��Ϣ��",MODBUS_REG(10) '�����Ϣ	
			MODBUSM_REGGET($2069,2,10)'��ȡ��챹�����Ϣ	
			?"$2069��Ϣ��",MODBUS_REG(10) '�����Ϣ
			MODBUSM_REGGET($206A,2,10)'��ȡ��챹�����Ϣ	
			?"$206A��Ϣ��",MODBUS_REG(10) '�����Ϣ
			MODBUSM_REGGET($206B,2,10)'��ȡ��챹�����Ϣ	
			?"$206B��Ϣ��",MODBUS_REG(10) '�����Ϣ
			
			MODBUSM_REGGET($2010,2,10)'��ȡ��챹�����Ϣ	
			?"$2010��Ϣ��",MODBUS_REG(10) '�����Ϣ
end sub

'��챱������
global sub Clear_wheel_alarm() '

	SET_wheel_addr()
	delay 3	
	modbus_reg(0) = $0006' 
	MODBUSM_regset($200E,1,0)'���������Ϣ
	
end sub

'��챼�ͣ����
global sub move_EMS() '

	SET_wheel_addr()
	delay 3	
	modbus_reg(0) = $0005' 
	MODBUSM_regset($200E,1,0)'��챼�ͣ
	
end sub

'���ʵʱ�˶�
global sub move_rt() '
	? "move_rt"
	move_start_flag = 1
	sET_wheel_addr()
	
	delay 3	
	modbus_reg(0) = wheel_speed_l ' ǰ��
	MODBUSM_regset($2088,1,0)'���ظ��Ƶ�Զ�� �����ٶ�
	delay 3
	modbus_reg(0) = -wheel_speed_r 'ǰ��		
	MODBUSM_regset($2089,1,0)'���ظ��Ƶ�Զ�� �����ٶ�
	
	modbus_reg(0) = $0008' 
	MODBUSM_regset($200E,1,0)'���ظ��Ƶ�Զ�� ʹ��
	'
	SET_wheel2_addr()
	delay 3	
	modbus_reg(0) = - wheel_speed_r' ����
	MODBUSM_regset($2088,1,0)'���ظ��Ƶ�Զ�� �����ٶ�
	delay 3
	modbus_reg(0) = wheel_speed_l  ' ����		
	MODBUSM_regset($2089,1,0)'���ظ��Ƶ�Զ�� �����ٶ�
	
	modbus_reg(0) = $0008' 
	MODBUSM_regset($200E,1,0)'���ظ��Ƶ�Զ�� ʹ��
	
end sub
	
'�����ת
global sub move_rotate()			'speed =100

	move_start_flag = 1
	'���
	SET_wheel_addr()
	delay 3
	move_init()	
		
		delay 100
		
		modbus_reg(0) = $FFFF - $0028 + 1' 
		MODBUSM_regset($2088,1,0)'���ظ��Ƶ�Զ�� �����ٶ�		200-- 1.46  100-- 0.72m/s		
		modbus_reg(0) = $FFFF - $0028 + 1
		MODBUSM_regset($2089,1,0)'���ظ��Ƶ�Զ�� �����ٶ�
		
		modbus_reg(0) = $0008' 
		MODBUSM_regset($200E,1,0)'���ظ��Ƶ�Զ�� ʹ��
end sub

'�����ǰ
global sub move_front()			'speed =100

	move_start_flag = 1
	'���
	SET_wheel_addr()
	delay 10
	
	move_init()	
		
		delay 100
		
		modbus_reg(0) = $FFFF - $0028 + 1' 
		MODBUSM_regset($2088,1,0)'���ظ��Ƶ�Զ�� �����ٶ�		200-- 1.46  100-- 0.72m/s		
		modbus_reg(0) = $0028 
		MODBUSM_regset($2089,1,0)'���ظ��Ƶ�Զ�� �����ٶ�
		
		modbus_reg(0) = $0008' 
		MODBUSM_regset($200E,1,0)'���ظ��Ƶ�Զ�� ʹ��
end sub

'��챺���
global sub move_back()			'speed =100
	move_start_flag = 1
	'���
	SET_wheel_addr()
	delay 3
	move_init()
		
		modbus_reg(0) = $0032 ' 
		MODBUSM_regset($2088,1,0)'���ظ��Ƶ�Զ�� �����ٶ�
		modbus_reg(0) = $FFFF - $0032 + 1' 
		MODBUSM_regset($2089,1,0)'���ظ��Ƶ�Զ�� �����ٶ�
		
	'	modbus_reg(0) = $0008' 
	'	MODBUSM_regset($200E,1,0)'���ظ��Ƶ�Զ�� ʹ��
end sub

'�������
global sub move_left()'speed =100
	move_start_flag = 1
	'��� 
	SET_wheel_addr()
	delay 3
		
		move_init()
		
		
		modbus_reg(0) = $0008' 
		MODBUSM_regset($200E,1,0)'���ظ��Ƶ�Զ�� ʹ��
		modbus_reg(0) = $FF9C ' 
		MODBUSM_regset($2088,1,0)'���ظ��Ƶ�Զ�� �����ٶ�
		modbus_reg(0) = $0064 '
		MODBUSM_regset($2089,1,0)'���ظ��Ƶ�Զ�� �����ٶ�
end sub

'�������
global sub move_right()'speed =100
	move_start_flag = 1
	'���
	SET_wheel_addr()
	delay 3
		move_init()
		
		modbus_reg(0) = $0008' 
		MODBUSM_regset($200E,1,0)'���ظ��Ƶ�Զ�� ʹ��
		modbus_reg(0) = $0064 ' 
		MODBUSM_regset($2088,1,0)'���ظ��Ƶ�Զ�� �����ٶ�
		modbus_reg(0) = $FF9C '
		MODBUSM_regset($2089,1,0)'���ظ��Ƶ�Զ�� �����ٶ�
end sub

'���ֹͣ
global sub move_stop()		
	if move_start_flag = 1 then
						
		SET_wheel_addr()
		delay 3
		modbus_reg(0) = $0007' ֹͣ
		MODBUSM_regset($200E,1,0)'���ظ��Ƶ�Զ��
		delay 3
		modbus_reg(0) = $0007' ֹͣ
		MODBUSM_regset($200E,1,0)'���ظ��Ƶ�Զ��
		
		SET_wheel2_addr()
		delay 3
		modbus_reg(0) = $0007' ֹͣ
		MODBUSM_regset($200E,1,0)'���ظ��Ƶ�Զ��
		delay 3
		modbus_reg(0) = $0007' ֹͣ
		MODBUSM_regset($200E,1,0)'���ظ��Ƶ�Զ��
		move_start_flag = 0
	end if
end sub 


'��ˢ���� ���� 50A
global sub brush_50A_start()			'
	brush_start_flag = 1
	'50A
	MODBUSM_des(4,1)'���öԷ�address=4 port Ϊ1
	delay 3
		modbus_reg(0) = $0001	'
		MODBUSM_regset($00B6,1,0)'���ظ��Ƶ�Զ��
		modbus_reg(0) = $0258	'
		MODBUSM_regset($0056,1,0)'���ظ��Ƶ�Զ��
		modbus_reg(0) = $0001	'
		MODBUSM_regset($0066,1,0)'���ظ��Ƶ�Զ��
end sub

'��ˢ���� ֹͣ 50A
global sub brush_50A_stop()			'
	
	if brush_start_flag = 1 then
		'50A
		MODBUSM_des(4,1)'���öԷ�address=4 port Ϊ1
		delay 3
		modbus_reg(0) = $0000	'
		MODBUSM_regset($0066,1,0)'���ظ��Ƶ�Զ��
		brush_start_flag = 0
	end if
end sub

'��ˢ���� ��ȡ״̬ 100A
global sub Read_brush_100A()
	'100A  ÿ��ָ�������ʱ10ms
	SET_brush_addr()
	delay 3
	modbus_reg(0) = $0001	'
	MODBUSM_regget($0111,1,10)'���ظ��Ƶ�Զ�� ���� 
	delay 3
	?"��ˢ�����Ϣ��",MODBUS_REG(10) '��챸�ˢ���
end sub

'��ˢ���� ���� 100A
global sub brush_100A_start()
	brush_start_flag = 1
	'100A  ÿ��ָ�������ʱ10ms
	SET_brush_addr()
	delay 3
	modbus_reg(0) = $0000	'
	MODBUSM_regset($0005,1,0)'���ظ��Ƶ�Զ�� ����ģʽ
	delay 10
	modbus_reg(0) = $0001	'
	MODBUSM_regset($0025,1,0)'���ظ��Ƶ�Զ�� 485ָ�����
	delay 10
	modbus_reg(0) = brush_speed '
	MODBUSM_regset($0006,1,0)'���ظ��Ƶ�Զ��  ת��
	delay 10
	modbus_reg(0) = $0001	'
	MODBUSM_regset($0023,1,0)'���ظ��Ƶ�Զ�� ����
	delay 10
	modbus_reg(0) = $0001	'
	MODBUSM_regset($0022,1,0)'���ظ��Ƶ�Զ�� ���� 
	delay 10
end sub

'��ˢ���� ֹͣ 100A
global sub brush_100A_stop()
	if brush_start_flag = 1 then
		SET_brush_addr() 
		delay 3
		modbus_reg(0) = $0000	'
		MODBUSM_regset($0022,1,0)'���ظ��Ƶ�Զ��  ֹͣ
		brush_start_flag = 0
	end if
end sub

'���� ���� vacuum_start
global sub vacuum_start()	 '	
	vacuum_start_flag = 1
	'MOVE_PWM(0, 0, 1000) ' 0.8�������� 0.6���� ��ֵ3A����	
	MOVE_PWM(1, 0, 1000) 

	?"vacumm start..."
end sub
'���� ֹͣ
global sub vacuum_stop()
	'if vacuum_start_flag = 1 then'
		'MOVE_PWM(0, 0.95, 1000) 
		MOVE_PWM(1, 0.95, 1000) 
		 
		vacuum_start_flag = 0
	'end if	
end sub
