
global sub task_modbus()			'485���� modbusЭ���д
	modbus_status = 0
	wheel_cmd = 0 
	brush_cmd = 0
	DIM cnt
	cnt=0
	'SET_W_baudrate()
	move_init()
	while 1  
			
		'��챿���
		' wheel_cmd_process()
			
		'��ˢ����
		'brush_cmd_process()
		'��������ȡ����
		delay 10
		if cnt = 8 THEN
			Read_sensor()			
		end if				
		'��ض�ȡ����
		delay 10
		if cnt = 8 THEN
			Read_battery()	
			cnt = 0
		end if
		cnt = cnt + 1
		delay 10
	wend
end sub

'���ָ���������
global sub wheel_cmd_process() ' 
			if wheel_cmd = 0 THEN	'��ȡ���������״̬ �Զ���ȡ  ���ֹͣ
				move_stop()
				delay 3
				Read_wheel_status()
				wheel_cmd = 0
			elseif wheel_cmd = 1 then '�˶�
				vacuum_stop()
				delay 3
				brush_100A_stop()
				delay 3
				move_rt()
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
					brush_100A_start() '������ˢ
				end if
				'brush_cmd = 0
			ELSE
				vacuum_stop()
				delay 3	
				brush_100A_stop() 'ֹͣ��ˢ
				brush_cmd = 0
			end if
end sub

'modbus��ַ�Ͳ��������� 
global sub SET_battery_addr() '
	setcom(9600,8,1,0,1,14,2,1000)	'���ô���1Ϊmodbus��
	MODBUSM_des(1,1)'���öԷ� port Ϊ1	
end sub

global sub SET_sensor_addr() ' 
	setcom(9600,8,1,0,1,14,2,1000)	'���ô���1Ϊmodbus��
	MODBUSM_des(2,1)'���öԷ� port Ϊ2	
end sub
	
global sub SET_wheel_addr() ' 
	setcom(115200,8,1,0,1,14,2,1000)	'���ô���1Ϊmodbus��
	MODBUSM_des(3,1)'���öԷ� port Ϊ3	
end sub

global sub SET_brush_addr()
	setcom(38400,8,1,0,1,14,2,1000)	'���ô���1Ϊmodbus��
	MODBUSM_des(4,1)'���öԷ� port Ϊ4
end sub

'modbus���������� ���
global sub SET_W_baudrate()
	setcom(9600,8,1,0,1,14,2,1000)
	MODBUSM_des(3,1)'���öԷ�address  port Ϊ1
	delay 10
	modbus_reg(0) = 2	'������115200
	MODBUSM_regset($2002,1,0)'���ظ��Ƶ�Զ��
	
	modbus_reg(0) = $0001' 
	MODBUSM_regset($2010,1,0)'���ظ��Ƶ�Զ��
end sub

'��ض�ȡ
global sub Read_battery()
	if brush_start_flag = 0 and move_start_flag = 0 then
		SET_battery_addr()
		'delay 120								
		MODBUSM_REGGET($0000,7,20)'�����Ϣ  ������ȡ��������100ms
		delay 120
		'MODBUSM_REGGET($0000,7,20)
		'delay 30
		Battery_V = MODBUS_REG(20)/100
		Battery_P = MODBUS_REG(22)
		Battery_I = MODBUS_REG(24)/100
		Battery_Temp =  MODBUS_REG(26)
		?"�����Ϣ:", "��ѹ" Battery_V, "����"Battery_P ,"����"Battery_I, "�¶�"Battery_Temp
	end if
end sub


'��������ȡ
global sub Read_sensor()
	if brush_start_flag = 0 and move_start_flag = 0 then
		SET_sensor_addr()
		delay 10
		MODBUSM_REGGET($0050,2,30)'��ȡѹ����������
		delay 10
		MODBUSM_REGGET($0050,2,30)'��ȡѹ����������	
		'if(MODBUS_REG(31) >= 0  )  then    '�н��ܵ�����
			MODBUS_REG(33) = MODBUS_REG(30)
			MODBUS_REG(32) = MODBUS_REG(31)
			Pressure_value = MODBUS_LONG(32)
			?"ѹ��",Pressure_value '��ʾ����
		'endif
		
	end if
end sub

'��챳�ʼ��
global sub move_init() '

	SET_wheel_addr()
	delay 10
	modbus_reg(0) = $0003	'�ٶȿ���
		MODBUSM_regset($200D,1,0)'���ظ��Ƶ�Զ��
		modbus_reg(0) = $01F4' ����Ӽ���ʱ��
		MODBUSM_regset($2080,1,0)'���ظ��Ƶ�Զ�� �����
		MODBUSM_regset($2081,1,0)'���ظ��Ƶ�Զ�� �Ҽ���
		MODBUSM_regset($2082,1,0)'���ظ��Ƶ�Զ�� �����
		MODBUSM_regset($2083,1,0)'���ظ��Ƶ�Զ�� �Ҽ���
				
		modbus_reg(0) = $000A' ��������� 10
		MODBUSM_regset($2075,1,0)'���ظ��Ƶ�Զ�� 
		modbus_reg(0) = $000A' ��������� 10
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
			?"�����Ϣ$20A5��",MODBUS_REG(10) ,MODBUS_REG(11) '�����Ϣ
			'MODBUSM_REGGET($2002,2,10)'��ȡ��챹�����Ϣ	
			'?"2002��",MODBUS_REG(10) '
			'MODBUSM_REGGET($2030,2,10)'��ȡ��챹�����Ϣ	
			'?"$2030������",MODBUS_REG(10) '����
			'MODBUSM_REGGET($2075,2,10)'��ȡ��챹�����Ϣ	
			'?"$2075��������",MODBUS_REG(10)'�����Ϣ
			'MODBUSM_REGGET($2061,2,10)'��ȡ��챹�����Ϣ	
			'?"$2061ƫ�ƽǶȣ�",MODBUS_REG(10) '�����Ϣ
			'MODBUSM_REGGET($2064,2,10)'��ȡ��챹�����Ϣ	
			'?"$2064��Ϣ��",MODBUS_REG(10) '�����Ϣ
			'MODBUSM_REGGET($2033,2,10)'��ȡ��챹�����Ϣ	
			'?"$2033��Ϣ��",MODBUS_REG(10) '�����Ϣ
			'MODBUSM_REGGET($2036,2,10)'��ȡ��챹�����Ϣ	
			'?"$2036��Ϣ��",MODBUS_REG(10) '�����Ϣ
			'MODBUSM_REGGET($203C,2,10)'��ȡ��챹�����Ϣ	
			'?"$203C��Ϣ��",MODBUS_REG(10) '�����Ϣ
			'MODBUSM_REGGET($203D,2,10)'��ȡ��챹�����Ϣ	
			'?"$203D��Ϣ��",MODBUS_REG(10) '�����Ϣ
			'MODBUSM_REGGET($203E,2,10)'��ȡ��챹�����Ϣ	
			'?"$203E��Ϣ��",MODBUS_REG(10) '�����Ϣ
			
			'MODBUSM_REGGET($2067,2,10)'��ȡ��챹�����Ϣ	
			'?"$2067��Ϣ��",MODBUS_REG(10) '�����Ϣ	
			'MODBUSM_REGGET($2068,2,10)'��ȡ��챹�����Ϣ	
			'?"$2068��Ϣ��",MODBUS_REG(10) '�����Ϣ	
			'MODBUSM_REGGET($2069,2,10)'��ȡ��챹�����Ϣ	
			'?"$2069��Ϣ��",MODBUS_REG(10) '�����Ϣ
			'MODBUSM_REGGET($206A,2,10)'��ȡ��챹�����Ϣ	
			'?"$206A��Ϣ��",MODBUS_REG(10) '�����Ϣ
			'MODBUSM_REGGET($206B,2,10)'��ȡ��챹�����Ϣ	
			'?"$206B��Ϣ��",MODBUS_REG(10) '�����Ϣ
			
			'MODBUSM_REGGET($2010,2,10)'��ȡ��챹�����Ϣ	
			'?"$2010��Ϣ��",MODBUS_REG(10) '�����Ϣ
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

	move_start_flag = 1
	SET_wheel_addr()
	
	delay 3	
	modbus_reg(0) = wheel_speed_l ' 
	MODBUSM_regset($2088,1,0)'���ظ��Ƶ�Զ�� �����ٶ�
	delay 3
	modbus_reg(0) = wheel_speed_r '		
	MODBUSM_regset($2089,1,0)'���ظ��Ƶ�Զ�� �����ٶ�
	
	delay 3	
	modbus_reg(0) = wheel_speed_l ' 
	MODBUSM_regset($2088,1,0)'���ظ��Ƶ�Զ�� �����ٶ�
	delay 3
	modbus_reg(0) = wheel_speed_r '		
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
		modbus_reg(0) = $00ff	'
		MODBUSM_regset($0006,1,0)'���ظ��Ƶ�Զ��  ת��
		delay 10
		modbus_reg(0) = $0000	'
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

'���� ���� 
global sub vacuum_start()	 '	
	vacuum_start_flag = 1
	MOVE_PWM(1, 0, 1000) ' 0.8���������� 0.6���� ��ֵ3A����	
end sub
'���� ֹͣ
global sub vacuum_stop()
	'if vacuum_start_flag = 1 then'
		MOVE_PWM(1, 0.95, 1000) 
		vacuum_start_flag = 0
	'end if	
end sub