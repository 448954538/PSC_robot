
'相机读取
GLOBAL DIM cam_num
			cam_num=0
			
GLOBAL DIM grap_switch

GLOBAL DIM task_modbus_id
task_modbus_id = 2
GLOBAL DIM grab_task_id
grab_task_id = 3
GLOBAL DIM task_Ps2read_id
task_Ps2read_id = 4
GLOBAL DIM task_deamon_id
task_deamon_id = 5

GLOBAL DIM cap_mode
GLOBAL ZVOBJECT image ,image1 

GLOBAL DIM  d_cam_expostime          '定义并相机曝光时间
d_cam_expostime = 50000


GLOBAL DIM global_status 
global_status=0		
GLOBAL DIM global_ems
global_ems = 0
GLOBAL DIM global_run
global_run = 0

GLOBAL DIM modbus_status 'modbus指令控制
GLOBAL DIM wheel_cmd,brush_cmd '轮毂控制、钢刷控制
GLOBAL DIM	wheel_speed_l,wheel_speed_r	'轮毂速度
GLOBAL DIM Battery_V,Battery_I,Battery_Temp,Battery_P '电池参数
GLOBAL DIM Pressure_value,Pressure_value1,Pressure_value2 '传感器压力参数
GLOBAL DIM distance_f,distance_b,distance_l,distance_r'传感器参数

'手柄配置指令
GLOBAL  PS2_SPI(5) 'SPI mode=03  100K  低位在前
PS2_SPI(0,$10,$03,$42,$00,$64)
						
GLOBAL DIM PS2_lx1(6)
'lx1(0,$44,$01,$43,$00,$80,$00)
PS2_lx1(0,$44,$80,$C2,$00,$80,$00)						'进入配置模式  
GLOBAL DIM PS2_lx2(10)
'lx2(0,$44,$01,$44,$00,$01,$03,$00,$00,$00,$00) 
PS2_lx2(0,$44,$80,$22,$00,$80,$C0,$00,$00,$00,$00) 	' 设置模式
GLOBAL DIM PS2_lx3(10)
'lx3(0,$44,$01,$4f,$00,$ff,$ff,$03,$00,$00,$00)
PS2_lx3(0,$44,$80,$F2,$00,$ff,$ff,$C0,$00,$00,$00) 	' 设置字节长度
GLOBAL DIM PS2_lx4(10)
'lx4(0,$44,$01,$43,$00,$00,$5A,$5A,$5A,$5A,$5A) 
PS2_lx4(0,$44,$80,$C2,$00,$00,$5A,$5A,$5A,$5A,$5A) 	'退出配置模式
GLOBAL DIM PS2_scan(10)
'scan(0,$46,$01,$42,$00,$00,$00,$00,$00,$00,$00)
PS2_scan(0,$46,$80,$42,$00,$00,$00,$00,$00,$00,$00) '$01,$42,$00,$5A,$5A,$5A,$5A,$5A,$5A	' 类型读取
GLOBAL DIM PS2_type_read(10)
'type_read(0,$46,$01,$45,$00,$5A,$5A,$5A,$5A,$5A,$5A) 
PS2_type_read(0,$46,$80,$A2,$00,$5A,$5A,$5A,$5A,$5A,$5A)  

'手柄按钮数据缓存
GLOBAL DIM PSB_SELECT
PSB_SELECT      =$0001
GLOBAL DIM PSB_L3 
PSB_L3          =$0002
GLOBAL DIM PSB_R3 
PSB_R3          =$0004
GLOBAL DIM PSB_START 
PSB_START       =$0008
GLOBAL DIM PSB_PAD_UP
PSB_PAD_UP      =$0010
GLOBAL DIM PSB_PAD_RIGHT 
PSB_PAD_RIGHT   =$0020
GLOBAL DIM PSB_PAD_DOWN 
PSB_PAD_DOWN    =$0040
GLOBAL DIM PSB_PAD_LEFT
PSB_PAD_LEFT    =$0080
GLOBAL DIM PSB_L2
PSB_L2          =$0100
GLOBAL DIM PSB_R2
PSB_R2          =$0200
GLOBAL DIM PSB_L1 
PSB_L1          =$0400
GLOBAL DIM PSB_R1
PSB_R1          =$0800
GLOBAL DIM PSB_GREEN
PSB_GREEN       =$1000
GLOBAL DIM PSB_RED
PSB_RED         =$2000
GLOBAL DIM PSB_BLUE
PSB_BLUE        =$4000
GLOBAL DIM PSB_PINK
PSB_PINK        =$8000
GLOBAL DIM PSB_TRIANGLE
PSB_TRIANGLE    =$1000
GLOBAL DIM PSB_CIRCLE 
PSB_CIRCLE      =$2000
GLOBAL DIM PSB_CROSS
PSB_CROSS       =$4000
GLOBAL DIM PSB_SQUARE
PSB_SQUARE      =$8000

GLOBAL DIM PS2_FunBtn'手柄按钮数据缓存
GLOBAL DIM PS2_X1
GLOBAL DIM PS2_Y1
GLOBAL DIM PS2_X2
GLOBAL DIM PS2_Y2

'手柄指令解码
GLOBAL DIM PS2_front
GLOBAL DIM PS2_back
GLOBAL DIM PS2_left
GLOBAL DIM PS2_right
GLOBAL DIM PS2_ems
GLOBAL DIM PS2_run

GLOBAL DIM CHARES
GLOBAL DIM RS232_rx(10) '串口接收缓存
GLOBAL DIM battery_rx(19) '电池接收缓存


GLOBAL DIM brush_start_flag
brush_start_flag = 0
GLOBAL DIM vacuum_start_flag
vacuum_start_flag = 0
GLOBAL DIM move_start_flag
move_start_flag = 0

GLOBAL DIM task_Ps2read_flag
task_Ps2read_flag = 0

GLOBAL DIM read_battery_time
read_battery_time = 50

GLOBAL DIM read_sensor_time
read_sensor_time = 3

GLOBAL DIM safe_distance
safe_distance = 40

GLOBAL DIM Pressure_th
Pressure_th = 100


GLOBAL DIM MOVE_speed_s_r
MOVE_speed_s_r = 40 
GLOBAL DIM MOVE_speed_f_r
MOVE_speed_f_r = 5
GLOBAL DIM MOVE_speed_ratio
MOVE_speed_ratio = MOVE_speed_f_r
GLOBAL DIM MOVE_speed


GLOBAL DIM sw_speed_cnt_b
GLOBAL DIM Sw_speed_time_b
Sw_speed_time_b = 10

GLOBAL DIM sw_speed_cnt_m
GLOBAL DIM Sw_speed_time_m
Sw_speed_time_m = 10

GLOBAL DIM brush_speed_s
brush_speed_s = 500 
GLOBAL DIM brush_speed_f
brush_speed_f = 1000
GLOBAL DIM brush_speed
brush_speed = brush_speed_s
