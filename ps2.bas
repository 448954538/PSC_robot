
global sub task_Ps2read()			'��ȡ�ֱ�����
	PS2_init() '��ʼ���ֱ�����
	while 1		
		PS2_Read()
		delay 100	
	wend
end sub


global sub PS2_init()

	setcom(115200,8,1,0,0,0,0,1000)	'���ô���0ΪRAW����ģʽ
	

	'����SPIģʽ 03  �ٶ�100K(200K�����)
	FOR i=0 TO 4                      '
		putchar #0,PS2_SPI(i)		 
	NEXT
	
	
	'ɨ��
	FOR i=0 TO 9  
		putchar #0, PS2_scan(i)
	NEXT
	'get #0, RS232_rx,9
	
	FOR i=0 TO 5  
		putchar #0,PS2_lx1(i)'��������ģʽ
	NEXT
	FOR i=0 TO 9
		putchar #0,PS2_lx2(i)' ����ģʽ
	NEXT
	FOR i=0 TO 9
		putchar #0,PS2_lx3(i)' �����ֽڳ���
	NEXT
	FOR i=0 TO 9
		putchar #0,PS2_lx4(i)'�˳�����ģʽ
	NEXT
	
	'ɨ�� 
	FOR i=0 TO 9  
		putchar #0, PS2_scan(i)
	NEXT
	'get #0, RS232_rx,9	
end sub

global sub PS2_Read()
	DIM funbtn
	
	'����SPIģʽ 03  �ٶ�100K(200K�����)
	FOR i=0 TO 4                      '
		putchar #0,PS2_SPI(i)		 
	NEXT
	
	delay 50
	'ɨ�� 
	FOR i=0 TO 9  
		putchar #0, PS2_scan(i)
	NEXT
	'CHARES = get #0, RS232_rx,9
	
	DIM tmp
	FOR i=0 TO 7                      '�ߵ�λ����
		if((RS232_rx(3) AND (1 << i)) = 0) THEN
			tmp = tmp AND NOT(1 << (7-i))
		ELSE 
			tmp = tmp   OR (1 << (7-i))			
		end if
		 
	NEXT
	RS232_rx(3) = tmp
	
	FOR i=0 TO 7                      '�ߵ�λ����
		if((RS232_rx(4) AND (1 << i)) = 0) THEN
			tmp = tmp AND NOT(1 << (7-i))
		ELSE 
			tmp = tmp   OR (1 << (7-i))			
		end if
		 
	NEXT
	RS232_rx(4) = tmp
	
	FOR i=0 TO 7                      '�ߵ�λ����
		if((RS232_rx(5) AND (1 << i)) = 0) THEN
			tmp = tmp AND NOT(1 << (7-i))
		ELSE 
			tmp = tmp   OR (1 << (7-i))			
		end if
		 
	NEXT
	RS232_rx(5) = tmp
	
	FOR i=0 TO 7                      '�ߵ�λ����
		if((RS232_rx(6) AND (1 << i)) = 0) THEN
			tmp = tmp AND NOT(1 << (7-i))
		ELSE 
			tmp = tmp   OR (1 << (7-i))			
		end if
		 
	NEXT
	RS232_rx(6) = tmp
	
	FOR i=0 TO 7                      '�ߵ�λ����
		if((RS232_rx(7) AND (1 << i)) = 0) THEN
			tmp = tmp AND NOT(1 << (7-i))
		ELSE 
			tmp = tmp   OR (1 << (7-i))			
		end if
		 
	NEXT
	RS232_rx(7) = tmp
	
	FOR i=0 TO 7                      '�ߵ�λ����
		if((RS232_rx(8) AND (1 << i)) = 0) THEN
			tmp = tmp AND NOT(1 << (7-i))
		ELSE 
			tmp = tmp   OR (1 << (7-i))			
		end if
		 
	NEXT
	RS232_rx(8) = tmp
	
	funbtn = (RS232_rx(4) << 8) | RS232_rx(3)

	PS2_FunBtn = funbtn
	PS2_X1 = RS232_rx(7)
	PS2_Y1 =RS232_rx(8)
	PS2_X2 = RS232_rx(5)
	PS2_Y2 = RS232_rx(6)
			
	?"ң��ָ�" PS2_FunBtn
	
	'����ң��ָ��
	
	delay 50
end sub