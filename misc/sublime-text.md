1. https://hexed.it/

2. 上传sublime_text，按下面的修改
Desciption	Offset	Original	Patched
Initial License Check 	0x003A31F2 	55 41 57 41 	48 31 C0 C3
Persistent License Check 1 	0x00399387 	E8 08 0E 12 00 	90 90 90 90 90
Persistent License Check 2 	0x0039939D 	E8 F2 0D 12 00 	90 90 90 90 90
Disable Server Validation Thread 	0x003A4E30 	55 41 56 53 41 89 F6 	48 31 C0 48 FF C0 C3
Disable License Notify Thread 	0x003A2E82 	41 	C3
Disable Crash Reporter 	0x0038C9F0 	55 	C3

 

3. 修改完成后，另存为，替换掉/opt/sublime_text/sublime_text，添加+x 权限，否则不能运行

4. 运行后，发现还是 unregistered

5. 添加注册码 试试
```
----- BEGIN LICENSE -----
 TwitterInc
 200 User License
 EA7E-890007
 1D77F72E 390CDD93 4DCBA022 FAF60790
 61AA12C0 A37081C5 D0316412 4584D136
 94D7F7D4 95BC8C1C 527DA828 560BB037
 D1EDDD8C AE7B379F 50C9D69D B35179EF
 2FE898C4 8E4277A8 555CE714 E1FB0E43
 D5D52613 C3D12E98 BC49967F 7652EED2
 9D2D2E61 67610860 6D338B72 5CF95C69
 E36B85CC 84991F19 7575D828 470A92AB
 ------ END LICENSE ------
```

