
'�����ȡ
GLOBAL DIM cam_num
			cam_num=0
			
GLOBAL DIM grap_switch
GLOBAL DIM grab_task_id

GLOBAL DIM cap_mode
GLOBAL ZVOBJECT image ,image1 

GLOBAL DIM  d_cam_expostime          '���岢����ع�ʱ��
            


GLOBAL DIM modbus_status 'modbusָ�����
GLOBAL DIM wheel_cmd,brush_cmd 'modbusָ�����
GLOBAL DIM Battery_V,Battery_I,Battery_Temp,Battery_W '��ز���
GLOBAL DIM Pressure_value '������ѹ������


'�ֱ�����ָ��
GLOBAL DIM PS2_SPI(5) 'SPI mode=03  100K
PS2_SPI(0,$10,$03,$42,$00,$64)
						
GLOBAL DIM PS2_lx1(6)
'lx1(0,$44,$01,$43,$00,$80,$00)
PS2_lx1(0,$44,$80,$C2,$00,$80,$00)						'��������ģʽ
GLOBAL DIM PS2_lx2(10)
'lx2(0,$44,$01,$44,$00,$01,$03,$00,$00,$00,$00) 
PS2_lx2(0,$44,$80,$22,$00,$80,$C0,$00,$00,$00,$00) 	' ����ģʽ
GLOBAL DIM PS2_lx3(10)
'lx3(0,$44,$01,$4f,$00,$ff,$ff,$03,$00,$00,$00)
PS2_lx3(0,$44,$80,$F2,$00,$ff,$ff,$C0,$00,$00,$00) 	' �����ֽڳ���
GLOBAL DIM PS2_lx4(10)
'lx4(0,$44,$01,$43,$00,$00,$5A,$5A,$5A,$5A,$5A) 
PS2_lx4(0,$44,$80,$C2,$00,$00,$5A,$5A,$5A,$5A,$5A) 	'�˳�����ģʽ
GLOBAL DIM PS2_scan(10)
'scan(0,$46,$01,$42,$00,$00,$00,$00,$00,$00,$00)
PS2_scan(0,$46,$80,$42,$00,$00,$00,$00,$00,$00,$00) '$01,$42,$00,$5A,$5A,$5A,$5A,$5A,$5A	' ���Ͷ�ȡ
GLOBAL DIM PS2_type_read(10)
'type_read(0,$46,$01,$45,$00,$5A,$5A,$5A,$5A,$5A,$5A) 
PS2_type_read(0,$46,$80,$A2,$00,$5A,$5A,$5A,$5A,$5A,$5A)  



GLOBAL DIM PS2_FunBtn'�ֱ���ť���ݻ���
GLOBAL DIM PS2_X1
GLOBAL DIM PS2_Y1
GLOBAL DIM PS2_X2
GLOBAL DIM PS2_Y2

GLOBAL DIM RS232_rx(10) '���ڽ��ջ���


