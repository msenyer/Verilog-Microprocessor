@echo off
set xv_path=C:\\Xilinx\\Vivado\\2015.2\\bin
call %xv_path%/xelab  -wto 9d979456f8db498b8472b13e8362a9ed -m64 --debug typical --relax --mt 2 --include "../../../Microprosessor.srcs/sources_1/ip/ila_0/ila_v5_1/hdl/verilog" --include "../../../Microprosessor.srcs/sources_1/ip/ila_0/ltlib_v1_0/hdl/verilog" --include "../../../Microprosessor.srcs/sources_1/ip/ila_0/xsdbs_v1_0/hdl/verilog" -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot microprocessor_tb_behav xil_defaultlib.microprocessor_tb xil_defaultlib.glbl -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
