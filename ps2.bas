
global sub task_Ps2read()			'读取手柄参数
	PS2_init() '初始化手柄参数
	while 1		
		PS2_Read()
		delay 20	
	wend
end sub


global sub PS2_init()

	setcom(115200,8,1,0,0,0,0,1000)	'设置串口0为RAW数据模式
	
	'配置SPI模式 03  速度100K(200K会出错)
	putchar #0,PS2_SPI
	
	'扫描
	putchar #0, PS2_scan
	get #0, RS232_rx,9
	
	putchar #0,PS2_lx1'进入配置模式
	putchar #0,PS2_lx2' 设置模式
	putchar #0,PS2_lx3' 设置字节长度
	putchar #0,PS2_lx4'退出配置模式
	
	'扫描 
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
			
	?"遥控指令：" PS2_FunBtn
	
	'解析遥控指令
	
	
end sub
