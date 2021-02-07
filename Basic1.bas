ERRSWITCH = 3'��ӡ����
 
set_xplcterm=1
grap_switch=0
grab_task_id=5
 d_cam_expostime = 500000

setcom(115200,8,1,0,0,0,0,1000)	'���ô���0ΪRAW����ģʽ
setcom(9600,8,1,0,1,14,2,1000)	'���ô���1Ϊmodbus��  ���115200 ˢ��38400 ѹ��19200 ���9600
'setcom(9600,8,1,0,1,0,0,1000)	'���ô���1ΪRAW ��ض�д 

MODBUSM_des(1,1)'���öԷ�address=1 port Ϊ1 

	'RUNTASK 2,task_sensor		'������������
   'RUNTASK 3,task_view		'������������
    'RUNTASK 4,task_cmd
   
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

global sub task_sensor()			'��������
	while 1
		
		PS2_Read()
		delay 100	
	wend
end sub

global sub vacuum_start()	 '		
		MOVE_PWM(1, 0.6, 1000) ' 0.8�������� 0.6���� ��ֵ3A����	
end sub

global sub vacuum_stop()			'
		MOVE_PWM(1, 0.95, 1000) 	
end sub

global sub PS2_init()

	'����SPIģʽ 03  �ٶ�100K(200K�����)
	putchar #0,PS2_SPI
	
	'ɨ��
	putchar #0, PS2_scan
	get #0, RS232_rx,9
	
	putchar #0,PS2_lx1'��������ģʽ
	putchar #0,PS2_lx2' ����ģʽ
	putchar #0,PS2_lx3' �����ֽڳ���
	putchar #0,PS2_lx4'�˳�����ģʽ
	
	'ɨ��
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
			
	?"ң��ָ�" PS2_FunBtn
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
			?"ѹ��",MODBUS_LONG(12) '��ʾ����
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


'���ɲɼ�����
GLOBAL SUB grab_task()
	'CAM_START(1)

	while(1)
		if (0 = grap_switch) then
			exit while
		endif
		
		CAM_GRAB(image)       '���ɲɼ�ģʽ�£��ɼ�һ֡ͼ��
		'CAM_SETPARAM("TriggerSoftware", 0)		
		'CAM_GET(image,0)
		ZV_LATCH(image,0)     '���ɼ�ͼ����ʾ��ͼƬԪ����
	wend
	
	'CAM_STOP()
END

	
'HMI���水��ɨ�������ť��Ӧ�ĺ���
GLOBAL SUB scan_all_cams()

	
	'ɨ�����
	CAM_SCAN("mvision")     'ɨ�躣�������
	                         'ɨ�����Ͱ���"mvision","basler","mindvision","huaray","aravis"��tis���ȶ�������
	
	cam_num = CAM_COUNT()
	                         '��ӡɨ�����״̬���
	if (0 = cam_num) then
		? "δ�ҵ����"	
		return
	endif
	
	    ?"���������" cam_num
		'*************��ʼ���������*********************
	    CAM_SEL(0)              'ѡ���һ�����
		
		
	'*************������ʼ�����*********************

END SUB

'HMI���水�����ɲɼ���ť��Ӧ�ĺ���
GLOBAL SUB btn_con_grap()
  if(grap_switch=1) then   '����Ѿ������ɲɼ�״̬����ӡ��ʾ��Ϣ
    ?"�������ɲɼ��У������ظ�����"
    return     
  endif
  
  if (cam_num=0) then        '���û��ɨ���������ʾ��ɨ�����
     ?"����ɨ�����"
     return
  endif
    
  '*************��ʼ���������*********************
	
    CAM_SEL(0)           'ѡ���һ�����
   ?"ѡ���һ�����"
   
    CAM_SETMODE(-1)      'ѡ�����Ϊ���ɲɼ�ģʽ
	'CAM_SETMODE(0)      'ѡ�����Ϊ�����ɼ�ģʽ
	?"���ɲɼ�ģʽ"
   CAM_SETEXPOSURE(d_cam_expostime)				 '�����ع�ʱ��
   CAM_SETPARAM("Width", "1920")
   CAM_SETPARAM("Height", "1080")
   ?"�����ع�ʱ��"
   
  '*************������ʼ�����*********************
    
    grap_switch=1          '���ɲɼ�״̬��1������ѭ���ɼ�����
    
    if (1 = grap_switch) then
	  
      if (0 = PROC_STATUS(grab_task_id)) then
        RUNTASK grab_task_id,grab_task		'������������
      endif
    endif    
END SUB



'HMI���水��ֹͣ�ɼ���ťʱ��Ӧ�ĺ���
GLOBAL SUB btn_stop_grab()

     if(grap_switch = 0)then 
	 ?"δ���������ɼ�"
	 return 
	 endif
	 
	 grap_switch = 0
	 
END SUB

'HMI���水�����������ťʱ��Ӧ�ĺ���
GLOBAL SUB btn_softtrigger()

   
	
	if (0 = cam_num) then
		? "δ�ҵ����"
		return
	endif
	
	CAM_SEL(0)				             'ѡ�����id����ʵ��ʹ����ֻ��Ҫ��ʼ��һ�� 
	
    CAM_SETMODE(0)				         '�������Ϊ�����ɼ�ģʽ����ʵ��ʹ����ֻ��Ҫ��ʼ��һ��
    CAM_START(0)				         '�����������ʵ��ʹ����ֻ��Ҫ��ʼ��һ��
	
    CAM_SETPARAM("TriggerSoftware", 0)	 '���������ź�
    CAM_GET(image, 0)			         '��ȡ���������ָ�� id ���Ϊ 0 ��ͼ��
    ZV_LATCH(image, 0)			         '��ʾͼ��

END SUB

'HMI���水��Ӳ��������ťʱ��Ӧ�ĺ���
GLOBAL SUB btn_line0trigger()
    
	
	if (0 = cam_num) then
		? "δ�ҵ����"
		return
	endif
	
	CAM_SEL(0)				               'ѡ�����id ����ʵ��ʹ����ֻ��Ҫ��ʼ��һ��
    CAM_SETMODE(1)				           '�������ΪӲ�������ɼ�ģʽ����ʵ��ʹ����ֻ��Ҫ��ʼ��һ��
	CAM_SETPARAM("TriggerActivation",1)   '������������½��ش����ź���Ч����ʵ��ʹ����ֻ��Ҫ��ʼ��һ��
    CAM_START(0)				           '�����������ʵ��ʹ����ֻ��Ҫ��ʼ��һ��
    

    MOVE_OP(0,ON)   
    MOVE_OP(0,OFF)                        '������OUT0����½����ź�

    CAM_GET(image, 0)			           '��ȡ���������ָ�� id ���Ϊ 0 ��ͼ��
    ZV_LATCH(image, 0)			           '��ʾͼ��

END SUB

'HMI���水��������ð�ťʱ��Ӧ�ĺ���
GLOBAL SUB btn_set_expostime()

   if (grap_switch=1) then               '�����������ǰ��Ҫֹͣ����ɼ�
        ?"����ֹͣ����ɼ�"
		return 
	endif
	
   HMI_SHOWWINDOW(11)                     '���������ع�ʱ�䴰��
   
END SUB

'�����ع�ʱ����水��ȷ����ť
GLOBAL SUB btn_confirm()

   CAM_SETEXPOSURE(d_cam_expostime)        '�����ع�ֵ
   HMI_CLOSEWINDOW(11)                     '�ر����ô���
   
   ?"�ع�ʱ��"d_cam_expostime
   
   '***********��ʾ���ú��Ч��************************
  btn_con_grap
  
   
END SUB