
global sub task_Ps2read()			'��ȡ�ֱ�����
	PS2_init() '��ʼ���ֱ�����
	while 1		
		PS2_Read()
		delay 20	
	wend
end sub


global sub PS2_init()

	setcom(115200,8,1,0,0,0,0,1000)	'���ô���0ΪRAW����ģʽ
	
	DIM tmp
	'����SPIģʽ 03  �ٶ�100K(200K�����)
	FOR i=0 TO 1                      '
		putchar #0,PS2_SPI(i)		 
	NEXT
	get #0, tmp
	'?tmp
	DELAY 10
	FOR i=2 TO 4                      '
		putchar #0,PS2_SPI(i)		 
	NEXT
	get #0, tmp
	'?tmp
	DELAY 10
	
	putchar #0,$43
	get #0, tmp
	'?tmp
	get #0, tmp
	'?tmp
	DELAY 10
		
	'ɨ��
	FOR i=0 TO 9  
		putchar #0, PS2_scan(i)
	NEXT
	FOR i=0 TO 8
		get #0, tmp		
		RS232_rx(i) = tmp
		? "rec",i,RS232_rx(i)
	NEXT
	DELAY 10
	
	'FOR i=0 TO 5  
	'	putchar #0,PS2_lx1(i)'��������ģʽ
	'NEXT
	'DELAY 10
	'FOR i=0 TO 9
	'	putchar #0,PS2_lx2(i)' ����ģʽ
	'NEXT
	'DELAY 10
	'FOR i=0 TO 9
	'	putchar #0,PS2_lx3(i)' �����ֽڳ���
	'NEXT
	'DELAY 10
	'FOR i=0 TO 9
	'	putchar #0,PS2_lx4(i)'�˳�����ģʽ
	'NEXT
	'DELAY 10
	

end sub

global sub PS2_Read()
	DIM funbtn
	
	setcom(115200,8,1,0,0,0,0,1000)	'���ô���0ΪRAW����ģʽ
	
	'����SPI �ٶ�100K(200K�����)
	FOR i=2 TO 4                      '
		putchar #0,PS2_SPI(i)		 
	NEXT
	get #0, tmp
	'?tmp
	DELAY 2
	
	'ɨ�� 
	FOR i=0 TO 9  
		putchar #0, PS2_scan(i)
	NEXT
	FOR i=0 TO 8
		get #0, tmp
		RS232_rx(i) = tmp
	NEXT
	
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
	if(RS232_rx(1) <> 206) THEN
		PS2_ems = 0
		PS2_run = 0
		M_stop()
		B_stop()
		? "�����ֱ����Ӻ�����:" RS232_rx(1),RS232_rx(2)
		RETURN
	ELSE
		? "mode head206:" RS232_rx(1),RS232_rx(2)
	endif
	
	
	PS2_FunBtn = funbtn
	PS2_X1 = RS232_rx(7)
	PS2_Y1 = RS232_rx(8)
	PS2_X2 = RS232_rx(5)
	PS2_Y2 = RS232_rx(6)
	
	? "ҡ��L:" PS2_X1,PS2_Y1,"ҡ��R:" PS2_X2,PS2_Y2
			
	'?"ң�ذ�����" PS2_FunBtn
	
	'����ң��ָ��
	if (PS2_FunBtn AND PSB_RED) = 0 THEN ' ��ͣ
		PS2_ems = 1
		? "ң��ָ�EMS!!!!"
	end if
	
	if (PS2_FunBtn AND PSB_BLUE) = 0 THEN ' ��ˢ����/ֹͣ
		PS2_run = 1	
		? "ң��ָ�RUN"
	ELSE
		PS2_run = 0
		B_stop()
	end if
			
	if (PS2_Y1 < 5 ) AND (PS2_X1 > 80) AND (PS2_X1 < 180) THEN	  'ǰ
		? "front"
	elseif (PS2_Y1 > 230) AND (PS2_X1 > 80) AND (PS2_X1 < 180) THEN  '��													  
			 ? "back" 
	elseif (PS2_X1 < 5) AND (PS2_Y1 > 80) AND (PS2_Y1 < 180)  THEN  '��ת
			 ? "left"
	elseif (PS2_X1 > 230) AND (PS2_Y1 > 80) AND (PS2_Y1 < 180) THEN '��ת
			 ? "right"
	end if
	
	if (PS2_Y1 < 127 ) OR (PS2_Y1 > 129 ) or (PS2_X1 < 127 ) or (PS2_X1 > 129 ) then
		wheel_speed_l =  ((PS2_Y1-128) - (PS2_X1-128)*50/128)/MOVE_speed_ratio
		wheel_speed_r = -((PS2_Y1-128) + (PS2_X1-128)*50/128)/MOVE_speed_ratio	'��챿����ٶ�
		? wheel_speed_l,wheel_speed_r
		M_start_B_stop()
		? "ң��ָ�Move"
	else
		wheel_speed_l=0
		wheel_speed_r=0
		M_stop()
		if PS2_run = 1 then
			B_start_M_stop()
		else 
			B_stop()
		end if	
		
	end if
	delay 2
end sub


global sub B_start_M_stop()	 '		
		delay 1
		if PS2_ems = 0 THEN
			wheel_cmd = 0	'move  stop	
			brush_cmd = 1  	'brush  start
		end if
		delay 1
		
end sub

global sub M_start_B_stop()	 '				
		delay 11
		if PS2_ems = 0 THEN
			brush_cmd = 0 	'brush stop	
			wheel_cmd = 1 	'move start
		end if
		delay 1
end sub

global sub M_stop()	 '				
		delay 1
		wheel_cmd = 0 	'move stop
		delay 1
end sub

global sub B_stop()	 '				
		delay 1
		brush_cmd = 0 	'brush stop
		delay 1
end sub