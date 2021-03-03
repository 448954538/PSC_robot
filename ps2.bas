
global sub task_Ps2read()			'读取手柄参数
	PS2_init() '初始化手柄参数
	while 1		
		PS2_Read()
		delay 100	
	wend
end sub


global sub PS2_init()

	setcom(115200,8,1,0,0,0,0,1000)	'设置串口0为RAW数据模式
	

	'配置SPI模式 03  速度100K(200K会出错)
	FOR i=0 TO 4                      '
		putchar #0,PS2_SPI(i)		 
	NEXT
	
	
	'扫描
	FOR i=0 TO 9  
		putchar #0, PS2_scan(i)
	NEXT
	'get #0, RS232_rx,9
	
	FOR i=0 TO 5  
		putchar #0,PS2_lx1(i)'进入配置模式
	NEXT
	FOR i=0 TO 9
		putchar #0,PS2_lx2(i)' 设置模式
	NEXT
	FOR i=0 TO 9
		putchar #0,PS2_lx3(i)' 设置字节长度
	NEXT
	FOR i=0 TO 9
		putchar #0,PS2_lx4(i)'退出配置模式
	NEXT
	
	'扫描 
	FOR i=0 TO 9  
		putchar #0, PS2_scan(i)
	NEXT
	'get #0, RS232_rx,9	
end sub

global sub PS2_Read()
	DIM funbtn
	
	'配置SPI模式 03  速度100K(200K会出错)
	FOR i=0 TO 4                      '
		putchar #0,PS2_SPI(i)		 
	NEXT
	
	delay 50
	'扫描 
	FOR i=0 TO 9  
		putchar #0, PS2_scan(i)
	NEXT
	'CHARES = get #0, RS232_rx,9
	
	DIM tmp
	FOR i=0 TO 7                      '高低位互换
		if((RS232_rx(3) AND (1 << i)) = 0) THEN
			tmp = tmp AND NOT(1 << (7-i))
		ELSE 
			tmp = tmp   OR (1 << (7-i))			
		end if
		 
	NEXT
	RS232_rx(3) = tmp
	
	FOR i=0 TO 7                      '高低位互换
		if((RS232_rx(4) AND (1 << i)) = 0) THEN
			tmp = tmp AND NOT(1 << (7-i))
		ELSE 
			tmp = tmp   OR (1 << (7-i))			
		end if
		 
	NEXT
	RS232_rx(4) = tmp
	
	FOR i=0 TO 7                      '高低位互换
		if((RS232_rx(5) AND (1 << i)) = 0) THEN
			tmp = tmp AND NOT(1 << (7-i))
		ELSE 
			tmp = tmp   OR (1 << (7-i))			
		end if
		 
	NEXT
	RS232_rx(5) = tmp
	
	FOR i=0 TO 7                      '高低位互换
		if((RS232_rx(6) AND (1 << i)) = 0) THEN
			tmp = tmp AND NOT(1 << (7-i))
		ELSE 
			tmp = tmp   OR (1 << (7-i))			
		end if
		 
	NEXT
	RS232_rx(6) = tmp
	
	FOR i=0 TO 7                      '高低位互换
		if((RS232_rx(7) AND (1 << i)) = 0) THEN
			tmp = tmp AND NOT(1 << (7-i))
		ELSE 
			tmp = tmp   OR (1 << (7-i))			
		end if
		 
	NEXT
	RS232_rx(7) = tmp
	
	FOR i=0 TO 7                      '高低位互换
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
			
	?"遥控指令：" PS2_FunBtn
	
	'解析遥控指令
	
	delay 50
end sub