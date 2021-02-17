
global sub task_modbus()			'485���� modbusЭ���д
	modbus_status = 0
	wheel_cmd = 0 
	brush_cmd = 0
	while 1  
		if modbus_status = 0 THEN  '��챿���  ����ָ��
			if wheel_cmd = 0 THEN	'��ȡ���������״̬ �Զ���ȡ
				
				modbus_status = 1
			elseif wheel_cmd = 1 then '��ǰ
				move_front()
				wheel_cmd = 0
			elseif wheel_cmd = 2 then'���
				move_back()
				wheel_cmd = 0
			elseif wheel_cmd = 3 then'����
				move_left()
				wheel_cmd = 0
			elseif wheel_cmd = 4 then'����
				move_right()
				wheel_cmd = 0
			elseif wheel_cmd = 5 then'ֹͣ
				move_stop()
				wheel_cmd = 0
			ELSE
				wheel_cmd = 0	
			end if
			modbus_status = 1
		elseif modbus_status = 1 then '��ˢ����  ����ָ��
			if brush_cmd = 0 THEN '��ȡ��ˢ������״̬ �Զ���ȡ
				
				modbus_status = 2
			elseif brush_cmd = 1 then
				brush_100A_start() '������ˢ
				brush_cmd = 0
			elseif brush_cmd = 2 then
				brush_100A_stop() 'ֹͣ��ˢ
				brush_cmd = 0
			ELSE
				brush_cmd = 0
			end if
			modbus_status = 2
		elseif modbus_status = 2 then  '��ض�ȡ����  �Զ���ȡ
			Read_battery()
			modbus_status = 3
		elseif modbus_status = 3 then 'ѹ����ȡ����  �Զ���ȡ
			Read_sensor()
			modbus_status = 0
		else
			modbus_status = 0
		end if
		delay 100	
	wend
end sub


global sub SET_Modbus_wheel_addr() '�Ķ���Ч
	setcom(115200,8,1,0,1,14,2,1000)	'���ô���1Ϊmodbus��  ���115200 
	MODBUSM_des(1,1)'���öԷ� port Ϊ1
	delay 10
	modbus_reg(0) = 3	'��ַ
	MODBUSM_regset($2001,1,0)'���ظ��Ƶ�Զ��
	?"Modbus��ַ�޸ĳɹ�:" modbus_reg(0)
	
end sub



global sub SET_Modbus_brush_addr()
	setcom(38400,8,1,0,1,14,2,1000)	'���ô���1Ϊmodbus��  ˢ��38400 
	MODBUSM_des(1,1)'���öԷ� port Ϊ1
	delay 10
	modbus_reg(0) = 4	'��ַ
	MODBUSM_regset($0000,1,0)'���ظ��Ƶ�Զ��
	?"Modbus��ַ�޸ĳɹ�:" 
	
end sub

global sub SET_Modbus_baudrate()
	MODBUSM_des(1,1)'���öԷ�address  port Ϊ1
	delay 10
	modbus_reg(0) = 9600	'������
	MODBUSM_regset($0000,1,0)'���ظ��Ƶ�Զ��
	
end sub


global sub Read_battery()
	setcom(9600,8,1,0,1,14,2,1000)	'���ô���1Ϊmodbus��  ���9600
	MODBUSM_des(1,1)'���öԷ�address=1 port Ϊ1
	delay 10
	MODBUSM_REGGET($0000,30,10)
	Battery_V = MODBUS_REG(10)
	Battery_W = MODBUS_REG(12)
	Battery_I = MODBUS_REG(14)
	Battery_Temp =  MODBUS_REG(16)
	?"�����Ϣ:"MODBUS_REG(10), MODBUS_REG(11),MODBUS_REG(12), MODBUS_REG(12)
	
end sub

global sub Read_sensor()
	'setcom(9600,8,1,0,1,14,2,2000)	'���ô���1Ϊmodbus��  ѹ��19200 
	MODBUSM_des(2,1)'���öԷ�address=2 port Ϊ1 
	delay 10
		MODBUSM_REGGET($0050,2,10)'��ȡѹ����������	
		if(MODBUS_REG(11) >= 0  )  then    '�н��ܵ�����
			MODBUS_REG(13) = MODBUS_REG(10)
			MODBUS_REG(12) = MODBUS_REG(11)
			Pressure_value = MODBUS_LONG(12)
			?"ѹ��",Pressure_value '��ʾ����
		endif	
end sub

global sub move_front()			'

	'���
	setcom(115200,8,1,0,1,14,2,1000)	'���ô���1Ϊmodbus��  ���115200 
	MODBUSM_des(1,1)'���öԷ�address=1 port Ϊ1
	delay 10
		modbus_reg(0) = $0003	'�ٶȿ���
		MODBUSM_regset($200D,1,0)'���ظ��Ƶ�Զ��
		modbus_reg(0) = $01F4' ����Ӽ���ʱ��
		MODBUSM_regset($2080,1,0)'���ظ��Ƶ�Զ�� �����
		MODBUSM_regset($2081,1,0)'���ظ��Ƶ�Զ�� �Ҽ���
		MODBUSM_regset($2082,1,0)'���ظ��Ƶ�Զ�� �����
		MODBUSM_regset($2083,1,0)'���ظ��Ƶ�Զ�� �Ҽ���
		modbus_reg(0) = $0008' 
		MODBUSM_regset($200E,1,0)'���ظ��Ƶ�Զ�� ʹ��
		modbus_reg(0) = $0082 ' 
		MODBUSM_regset($2088,1,0)'���ظ��Ƶ�Զ�� �����ٶ�
		MODBUSM_regset($2089,1,0)'���ظ��Ƶ�Զ�� �����ٶ�
end sub
global sub move_back()			'
	'���
	setcom(115200,8,1,0,1,14,2,1000)	'���ô���1Ϊmodbus��  ���115200 
	MODBUSM_des(1,1)'���öԷ�address=1 port Ϊ1
	delay 10
		modbus_reg(0) = $0003	'�ٶȿ���
		MODBUSM_regset($200D,1,0)'���ظ��Ƶ�Զ��
		modbus_reg(0) = $01F4' ����Ӽ���ʱ��
		MODBUSM_regset($2080,1,0)'���ظ��Ƶ�Զ�� �����
		MODBUSM_regset($2081,1,0)'���ظ��Ƶ�Զ�� �Ҽ���
		MODBUSM_regset($2082,1,0)'���ظ��Ƶ�Զ�� �����
		MODBUSM_regset($2083,1,0)'���ظ��Ƶ�Զ�� �Ҽ���
		modbus_reg(0) = $0008' 
		MODBUSM_regset($200E,1,0)'���ظ��Ƶ�Զ�� ʹ��
		modbus_reg(0) = $0082 ' 
		MODBUSM_regset($2088,1,0)'���ظ��Ƶ�Զ�� �����ٶ�
		MODBUSM_regset($2089,1,0)'���ظ��Ƶ�Զ�� �����ٶ�
end sub

global sub move_left()

end sub

global sub move_right()

end sub


global sub move_stop()	
		setcom(115200,8,1,0,1,14,2,1000)	'���ô���1Ϊmodbus��  ���115200 
		MODBUSM_des(1,1)'���öԷ�address=1 port Ϊ1
		delay 10
		modbus_reg(0) = $0007' ֹͣ
		MODBUSM_regset($200E,1,0)'���ظ��Ƶ�Զ��
		
		end sub 
global sub brush_50A_start()			'
	
	'50A
	setcom(38400,8,1,0,1,14,2,1000)	'���ô���1Ϊmodbus��  ˢ��38400 
	MODBUSM_des(4,1)'���öԷ�address=4 port Ϊ1
	delay 10
		modbus_reg(0) = $0001	'
		MODBUSM_regset($00B6,1,0)'���ظ��Ƶ�Զ��
		modbus_reg(0) = $0258	'
		MODBUSM_regset($0056,1,0)'���ظ��Ƶ�Զ��
		modbus_reg(0) = $0001	'
		MODBUSM_regset($0066,1,0)'���ظ��Ƶ�Զ��
end sub

global sub brush_50A_stop()			'
	
	'50A
	setcom(38400,8,1,0,1,14,2,1000)	'���ô���1Ϊmodbus��  ˢ��38400 
	MODBUSM_des(4,1)'���öԷ�address=4 port Ϊ1
	delay 10
	modbus_reg(0) = $0000	'
	MODBUSM_regset($0066,1,0)'���ظ��Ƶ�Զ��
end sub

global sub brush_100A_start()
	'100A  ÿ��ָ�������ʱ10ms
	setcom(38400,8,1,0,1,14,2,1000)	'���ô���1Ϊmodbus��  ˢ��38400 
	MODBUSM_des(4,1)'���öԷ�address=4 port Ϊ1
	delay 10
		modbus_reg(0) = $0000	'
		MODBUSM_regset($0005,1,0)'���ظ��Ƶ�Զ��
		delay 10
		modbus_reg(0) = $0001	'
		MODBUSM_regset($0025,1,0)'���ظ��Ƶ�Զ��
		delay 10
		modbus_reg(0) = $00ff	'
		MODBUSM_regset($0006,1,0)'���ظ��Ƶ�Զ��
		delay 10
		modbus_reg(0) = $0000	'
		MODBUSM_regset($0023,1,0)'���ظ��Ƶ�Զ��
		delay 10
		modbus_reg(0) = $0001	'
		MODBUSM_regset($0022,1,0)'���ظ��Ƶ�Զ��
		delay 10
end sub


global sub brush_100A_stop()
	setcom(38400,8,1,0,1,14,2,1000)	'���ô���1Ϊmodbus��  ˢ��38400
	MODBUSM_des(4,1)'���öԷ�address=4 port Ϊ1
	delay 10
	modbus_reg(0) = $0000	'
	MODBUSM_regset($0022,1,0)'���ظ��Ƶ�Զ��
end sub