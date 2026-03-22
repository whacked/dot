# 13 comes from
# Complete!
# {19:15}~   xinput --list      
# ⎡ Virtual core pointer                    	id=2	[master pointer  (3)]
# ⎜   ↳ Virtual core XTEST pointer              	id=4	[slave  pointer  (2)]
# ⎜   ↳ Wacom HID 5110 Pen stylus               	id=10	[slave  pointer  (2)]
# ⎜   ↳ Wacom HID 5110 Finger touch             	id=11	[slave  pointer  (2)]
# ⎜   ↳ SYNA2B31:00 06CB:7F8B Mouse             	id=12	[slave  pointer  (2)]
# ⎜   ↳ SYNA2B31:00 06CB:7F8B Touchpad          	id=13	[slave  pointer  (2)]
# ⎜   ↳ Wacom HID 5110 Pen eraser               	id=16	[slave  pointer  (2)]
xinput set-prop 13 'libinput Natural Scrolling Enabled' 1

