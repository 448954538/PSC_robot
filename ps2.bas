
global sub task_Ps2read()			'��ȡ�ֱ�����
	PS2_init() '��ʼ���ֱ�����
	while 1		
		PS2_Read()
		delay 20	
	wend
end sub


global sub PS2_init()

	setcom(115200,8,1,0,0,0,0,1000)	'���ô���0ΪRAW����ģʽ
	
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
	
	'����ң��ָ��
	
	
end sub
