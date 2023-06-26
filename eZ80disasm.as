#ifndef __eZ80DISASM__
#module __eZ80DISASM__
#deffunc local initdisasm
rpa="BC","DE","HL","SP"
cc="NZ","Z","NC","CF","PO","PE","P","M"
rpb="HL","IX","IY"
rpc="B","C","D","E","H","L","(HL)","A"
rpd="B","C","D","E","IXH","IXL","(IX%s%03XH)","A"
rpe="B","C","D","E","IYH","IYL","(IY%s%03XH)","A"
rpf="BC","DE","IX","SP"
rpg="BC","DE","IY","SP"
rph="BC","DE","HL","AF"
rpi="BC","DE","IX","AF"
rpj="BC","DE","IY","AF"
rpk="HL","IX%s%03XH","IY%s%03XH"
rpl="BC","DE","HL","IX"
rpm="BC","DE","HL","IY"
inst00407="RLCA","RRCA","RLA","RRA","DAA","CPL","SCF","CCF"
instalus="ADD","ADC","SUB","SBC","AND","XOR","OR","CP"
instio="NOP","NOP","INIM","OTIM","INI2","NOP","NOP","NOP","NOP","NOP","INDM","OTDM","IND2","NOP","NOP","NOP","NOP","NOP","INIMR","OTIMR","INI2R","NOP","NOP","NOP","NOP","NOP","INDMR","OTDMR","IND2R","NOP","NOP","NOP","LDI","CPI","INI","OUTI","OUTI2","NOP","NOP","NOP","LDD","CPD","IND","OUTD","OUTD2","NOP","NOP","NOP","LDIR","CPIR","INIR","OTIR","OTI2R","NOP","NOP","NOP","LDDR","CPDR","INDR","OTDR","OTD2R","NOP","NOP","NOP","NOP","NOP","INIRX","OTIRX","NOP","NOP","NOP","NOP","NOP","NOP","INDRX","OTDRX","NOP","NOP","NOP","NOP"
instbita="RLC","RRC","RL","RR","SLA","SRA","SLL","SRL"
instbitb="NOP","BIT","RES","SET"
return
#defcfunc local eZ80disasm_rpk int prm_0
if prm_0>=1{
if relpos>127{flag4rel="-":relpos=-((relpos^128)-128)}else{flag4rel="+"}
return strf(eZ80disasm_rpk(prm_0),flag4rel,relpos)
}
return eZ80disasm_rpk(prm_0)
#defcfunc local eZ80disasm_rpcde int prm_0,int prm_1_
if relpos>127{flag4rel="-":relpos=-((relpos^128)-128)}else{flag4rel="+"}
switch prm_1_
case 0
return rpc(prm_0)
swbreak
case 1
if prm_0=6{return strf(rpd(prm_0),flag4rel,relpos)}else{return rpd(prm_0)}
swbreak
case 2
if prm_0=6{return strf(rpe(prm_0),flag4rel,relpos)}else{return rpe(prm_0)}
swbreak
swend
return rpc(prm_0)
#defcfunc local eZ80disasm_rpafg int prm_0,int prm_1_
switch prm_1_
case 0
return rpa(prm_0)
swbreak
case 1
return rpf(prm_0)
swbreak
case 2
return rpg(prm_0)
swbreak
swend
return rpa(prm_0)
#defcfunc local eZ80disasm_rphij int prm_0,int prm_1_
switch prm_1_
case 0
return rph(prm_0)
swbreak
case 1
return rpi(prm_0)
swbreak
case 2
return rpj(prm_0)
swbreak
swend
return rph(prm_0)
#defcfunc local eZ80dism_readb int prm_0
statue=0
eZ80dismmemaccess prm_0+0,0,1:statue|=((stat&0xFF)<<(8*0))
return statue
#defcfunc local eZ80dism_readw int prm_0
statue=0
eZ80dismmemaccess prm_0+0,0,1:statue|=((stat&0xFF)<<(8*0))
eZ80dismmemaccess prm_0+1,0,1:statue|=((stat&0xFF)<<(8*1))
if adl=1{
eZ80dismmemaccess prm_0+2,0,1:statue|=((stat&0xFF)<<(8*2))
}
return statue
#defcfunc eZ80disasm var prm_0_,int prm_1,int prm_2
ixyflag=0:suffix=""
adl=(prm_1!0)
if adl=0{
addr=(prm_0_&0xFFFF)|((prm_2&0xFF)<<16)
}else{
addr=prm_0_&0xFFFFFF
}
opcode=eZ80dism_readb(addr):addr++
*eZ80disasmprefixeschk
if opcode=0x40{suffix=".SIS":opcode=eZ80dism_readb(addr):addr++:adl=0:goto *eZ80disasmprefixeschk}
if opcode=0x49{suffix=".LIS":opcode=eZ80dism_readb(addr):addr++:adl=0:goto *eZ80disasmprefixeschk}
if opcode=0x52{suffix=".SIL":opcode=eZ80dism_readb(addr):addr++:adl=1:goto *eZ80disasmprefixeschk}
if opcode=0x5b{suffix=".LIL":opcode=eZ80dism_readb(addr):addr++:adl=1:goto *eZ80disasmprefixeschk}
if opcode=0xdd{opcode=eZ80dism_readb(addr):addr++:ixyflag=1:goto *eZ80disasmprefixeschk}
if opcode=0xfd{opcode=eZ80dism_readb(addr):addr++:ixyflag=2:goto *eZ80disasmprefixeschk}
if opcode<0x40{
switch (opcode&7)
case 0
if ((opcode>>3)&7)<4{
	switch ((opcode>>3)&7)
	case 0
	prm_0_=addr
		return "NOP"+suffix
		swbreak
	case 1
	prm_0_=addr
		return "EX"+suffix+" AF,AF'"
		swbreak
	case 2
	addrbase=eZ80dism_readb(addr)
	addr++
	prm_0_=addr
	addrbase=(addrbase^128)-128
	addrbase+=addr
	if adl=1{
	addrbase&=0xFFFFFF
	return "JR"+suffix+" "+strf("%07X",addrbase)+"h"
	}else{
	addrbase&=0xFFFF
	return "DJNZ"+suffix+" "+strf("%05X",addrbase)+"h"
	}
		swbreak
	case 3
	addrbase=eZ80dism_readb(addr)
	addr++
	prm_0_=addr
	addrbase=(addrbase^128)-128
	addrbase+=addr
	if adl=1{
	addrbase&=0xFFFFFF
	return "JR"+suffix+" "+strf("%07X",addrbase)+"h"
	}else{
	addrbase&=0xFFFF
	return "JR"+suffix+" "+strf("%05X",addrbase)+"h"
	}
		swbreak
	swend
}else{
	addrbase=eZ80dism_readb(addr)
	addr++
	prm_0_=addr
	addrbase=(addrbase^128)-128
	addrbase+=addr
	if adl=1{
	addrbase&=0xFFFFFF
	return "JR"+suffix+" "+cc((opcode>>3)&3)+","+strf("%07X",addrbase)+"h"
	}else{
	addrbase&=0xFFFF
	return "JR"+suffix+" "+cc((opcode>>3)&3)+","+strf("%05X",addrbase)+"h"
	}
}
swbreak
case 1
prm_0_=addr
if ((opcode>>3)&1){
	if adl=1{
	return "ADD"+suffix+" "+eZ80disasm_rpafg(2,ixyflag)+","+eZ80disasm_rpafg(((opcode>>4)&3),ixyflag)
	}else{
	return "ADD"+suffix+" "+eZ80disasm_rpafg(2,ixyflag)+","+eZ80disasm_rpafg(((opcode>>4)&3),ixyflag)
	}
}else{
	addrbase=eZ80dism_readw(addr)
	addr+=(adl+2)
	prm_0_=addr
	if adl=1{
	return "LD"+suffix+" "+eZ80disasm_rpafg(((opcode>>4)&3),ixyflag)+","+strf("%07X",addrbase)+"H"
	}else{
	return "LD"+suffix+" "+eZ80disasm_rpafg(((opcode>>4)&3),ixyflag)+","+strf("%05X",addrbase)+"H"
	}
}
swbreak
case 2
if ((opcode>>4)&3)<2{
if ((opcode>>3)&1)=0{
	prm_0_=addr
	if adl=1{
	return "LD"+suffix+" ("+eZ80disasm_rpafg(((opcode>>4)&3),ixyflag)+"),A"
	}else{
	return "LD"+suffix+" ("+eZ80disasm_rpafg(((opcode>>4)&3),ixyflag)+"),A"
	}
}else{
	prm_0_=addr
	if adl=1{
	return "LD"+suffix+" A,("+eZ80disasm_rpafg(((opcode>>4)&3),ixyflag)+")"
	}else{
	return "LD"+suffix+" A,("+eZ80disasm_rpafg(((opcode>>4)&3),ixyflag)+")"
	}
}
}else{
switch ((opcode>>4)&3)
case 2
if ((opcode>>3)&1)=0{
	addrbase=eZ80dism_readw(addr)
	addr+=(adl+2)
	prm_0_=addr
	if adl=1{
	return "LD"+suffix+" ("+strf("%07X",addrbase)+"H),"+rpb(ixyflag)
	}else{
	return "LD"+suffix+" ("+strf("%05X",addrbase)+"H),"+rpb(ixyflag)
	}
}else{
	addrbase=eZ80dism_readw(addr)
	addr+=(adl+2)
	prm_0_=addr
	if adl=1{
	return "LD"+suffix+" "+rpb(ixyflag)+",("+strf("%07X",addrbase)+"H)"
	}else{
	return "LD"+suffix+" "+rpb(ixyflag)+",("+strf("%05X",addrbase)+"H)"
	}
}
swbreak
case 3
if ((opcode>>3)&1)=0{
	addrbase=eZ80dism_readw(addr)
	addr+=(adl+2)
	prm_0_=addr
	if adl=1{
	return "LD"+suffix+" ("+strf("%07X",addrbase)+"H),A"
	}else{
	return "LD"+suffix+" ("+strf("%05X",addrbase)+"H),A"
	}
}else{
	addrbase=eZ80dism_readw(addr)
	addr+=(adl+2)
	prm_0_=addr
	if adl=1{
	return "LD"+suffix+" A,("+strf("%07X",addrbase)+"H)"
	}else{
	return "LD"+suffix+" A,("+strf("%05X",addrbase)+"H)"
	}
}
swbreak
swend
}
swbreak
case 3
prm_0_=addr
if ((opcode>>3)&1){
return "DEC"+suffix+" "+eZ80disasm_rpafg(((opcode>>4)&3),ixyflag)
}else{
return "INC"+suffix+" "+eZ80disasm_rpafg(((opcode>>4)&3),ixyflag)
}
swbreak
case 4
if ixyflag>=1 & ((opcode>>3)&7)=6{relpos=eZ80dism_readb(addr):addr++}
prm_0_=addr
return "INC"+suffix+" "+eZ80disasm_rpcde(((opcode>>3)&7),ixyflag)
swbreak
case 5
if ixyflag>=1 & ((opcode>>3)&7)=6{relpos=eZ80dism_readb(addr):addr++}
prm_0_=addr
return "DEC"+suffix+" "+eZ80disasm_rpcde(((opcode>>3)&7),ixyflag)
swbreak
case 6
if ixyflag>=1 & ((opcode>>3)&7)=6{relpos=eZ80dism_readb(addr):addr++}
addrbase=eZ80dism_readb(addr)
addr++
prm_0_=addr
return "LD"+suffix+" "+eZ80disasm_rpcde(((opcode>>3)&7),ixyflag)+","+strf("%03X",addrbase)+"H"
swbreak
case 7
prm_0_=addr
return inst00407((opcode>>3)&7)+suffix
swbreak
swend
}
if opcode<0x80{
prm_0_=addr
if opcode=0x76{return "HALT"+suffix}
if ixyflag>=1 & (((opcode>>3)&7)=6 | ((opcode>>0)&7)=6){relpos=eZ80dism_readb(addr):addr++}
if opcode=0x66|opcode=0x6e{
return "LD"+suffix+" "+rpc(((opcode>>3)&7))+","+eZ80disasm_rpcde(((opcode>>0)&7),ixyflag)
}else{
return "LD"+suffix+" "+eZ80disasm_rpcde(((opcode>>3)&7),ixyflag)+","+eZ80disasm_rpcde(((opcode>>0)&7),ixyflag)
}
}
if opcode<0xc0{
if ixyflag>=1 & ((opcode>>0)&7)=6{relpos=eZ80dism_readb(addr):addr++}
prm_0_=addr
return instalus((opcode>>3)&7)+suffix+" A,"+eZ80disasm_rpcde(((opcode>>0)&7),ixyflag)
}
if opcode<0x100{
switch (opcode&7)
case 0
prm_0_=addr
return "RET"+suffix+" "+cc((opcode>>3)&7)
swbreak
case 1
prm_0_=addr
if (opcode&8){
switch ((opcode>>4)&3)
case 0
return "RET"+suffix
swbreak
case 1
return "EXX"+suffix
swbreak
case 2
return "JP"+suffix+" ("+rpb(ixyflag)+")"
swbreak
case 3
return "LD"+suffix+" SP,"+rpb(ixyflag)
swbreak
swend
}else{
return "POP"+suffix+" "+eZ80disasm_rphij(((opcode>>4)&3),ixyflag)
}
swbreak
case 2
addrbase=eZ80dism_readw(addr)
addr+=(adl+2)
prm_0_=addr
if adl=0{
return "JP"+suffix+" "+cc((opcode>>3)&7)+","+strf("%05X",addrbase)+"H"
}else{
return "JP"+suffix+" "+cc((opcode>>3)&7)+","+strf("%07X",addrbase)+"H"
}
swbreak
case 3
	switch ((opcode>>3)&7)
	case 0
	addrbase=eZ80dism_readw(addr)
	addr+=(adl+2)
	prm_0_=addr
	if adl=0{
	return "JP"+suffix+" "+strf("%05X",addrbase)+"H"
	}else{
	return "JP"+suffix+" "+strf("%07X",addrbase)+"H"
	}
	swbreak
	case 1
	if ixyflag>=1{relpos=eZ80dism_readb(addr):addr++}
	opcode=eZ80dism_readb(addr):addr++
	prm_0_=addr
	if opcode<0x40{
		return instbita((opcode>>3)&7)+suffix+" "+eZ80disasm_rpcde(((opcode>>0)&7),ixyflag)
	}
	return instbitb((opcode>>6)&3)+suffix+" "+str((opcode>>3)&7)+","+eZ80disasm_rpcde(((opcode>>0)&7),ixyflag)
	swbreak
	case 2
	addrbase=eZ80dism_readb(addr)
	addr++
	prm_0_=addr
	return "OUT"+suffix+" ("+strf("%03X",addrbase)+"H),A"
	swbreak
	case 3
	addrbase=eZ80dism_readb(addr)
	addr++
	prm_0_=addr
	return "IN"+suffix+" A,("+strf("%03X",addrbase)+"H)"
	swbreak
	case 4
	prm_0_=addr
	return "EX"+suffix+" (SP),"+rpb(ixyflag)
	swbreak
	case 5
	prm_0_=addr
	return "EX DE,HL"
	swbreak
	case 6
	prm_0_=addr
	return "DI"
	swbreak
	case 7
	prm_0_=addr
	return "EI"
	swbreak
	swend
swbreak
case 4
addrbase=eZ80dism_readw(addr)
addr+=(adl+2)
prm_0_=addr
if adl=0{
return "CALL"+suffix+" "+cc((opcode>>3)&7)+","+strf("%05X",addrbase)+"H"
}else{
return "CALL"+suffix+" "+cc((opcode>>3)&7)+","+strf("%07X",addrbase)+"H"
}
swbreak
case 5
prm_0_=addr
if (opcode&8){
switch ((opcode>>4)&3)
case 0
	addrbase=eZ80dism_readw(addr)
	addr+=(adl+2)
	prm_0_=addr
	if adl=0{
	return "CALL"+suffix+" "+strf("%05X",addrbase)+"H"
	}else{
	return "CALL"+suffix+" "+strf("%07X",addrbase)+"H"
	}
swbreak
case 2
opcode=eZ80dism_readb(addr):addr++
prm_0_=addr
if (opcode<0x40){
switch (opcode&7)
case 0
addrbase=eZ80dism_readb(addr)
addr++
prm_0_=addr
return "IN0"+suffix+" "+rpc((opcode>>3)&7)+",("+strf("%03X",addrbase)+"H)"
swbreak
case 1
if ((opcode>>3)&7)=6{
prm_0_=addr
return "LD"+suffix+" IY,(HL)"
}else{
addrbase=eZ80dism_readb(addr)
addr++
prm_0_=addr
return "OUT0"+suffix+" ("+strf("%03X",addrbase)+"H),"+rpc((opcode>>3)&7)
}
swbreak
case 2
if (opcode&8)=0{
relpos=eZ80dism_readb(addr):addr++
prm_0_=addr
return "LEA"+suffix+" "+rpl((opcode>>4)&3)+","+eZ80disasm_rpk(1)
}
swbreak
case 3
if (opcode&8)=0{
relpos=eZ80dism_readb(addr):addr++
prm_0_=addr
return "LEA"+suffix+" "+rpm((opcode>>4)&3)+","+eZ80disasm_rpk(2)
}
swbreak
case 4
prm_0_=addr
return "TST"+suffix+" A,"+rpc((opcode>>3)&7)
swbreak
case 6
if opcode=0x3e{
prm_0_=addr
return "LD"+suffix+" (HL),"+rpm((opcode>>4)&3)
}
swbreak
case 7
prm_0_=addr
if (opcode&8){
return "LD"+suffix+" (HL),"+rpl((opcode>>4)&3)
}else{
return "LD"+suffix+" "+rpl((opcode>>4)&3)+",(HL)"
}
swbreak
swend
}
if (opcode<0x80){
prm_0_=addr
switch (opcode&7)
case 0
return "IN"+suffix+" "+rpc((opcode>>3)&7)+",(C)"
swbreak
case 1
return "OUT"+suffix+" (C),"+rpc((opcode>>3)&7)
swbreak
case 2
return "SBC"+suffix+" "+eZ80disasm_rpafg(2,0)+","+eZ80disasm_rpafg(((opcode>>4)&3),0)
swbreak
case 3
addrbase=eZ80dism_readw(addr)
addr+=(adl+2)
prm_0_=addr
if (opcode&8){
	if adl=0{
	return "LD"+suffix+" "+eZ80disasm_rpafg(((opcode>>4)&3),0)+",("+strf("%05X",addrbase)+"H)"
	}else{
	return "LD"+suffix+" "+eZ80disasm_rpafg(((opcode>>4)&3),0)+",("+strf("%07X",addrbase)+"H)"
	}
}else{
	if adl=0{
	return "LD"+suffix+" ("+strf("%05X",addrbase)+"H),"+eZ80disasm_rpafg(((opcode>>4)&3),0)
	}else{
	return "LD"+suffix+" ("+strf("%07X",addrbase)+"H),"+eZ80disasm_rpafg(((opcode>>4)&3),0)
	}
}
swbreak
case 4
prm_0_=addr
if (opcode&8){
return "MLT"+suffix+" "+eZ80disasm_rpafg(((opcode>>4)&3),0)
}else{
switch ((opcode>>4)&3)
case 0
return "NEG"+suffix
swbreak
case 1
relpos=eZ80dism_readb(addr):addr++
prm_0_=addr
return "LEA"+suffix+" IX,"+eZ80disasm_rpk(2)
swbreak
case 2
addrbase=eZ80dism_readb(addr)
addr++
return "TST"+suffix+" A,"+strf("%03X",addrbase)+"H"
swbreak
case 3
addrbase=eZ80dism_readb(addr)
addr++
return "TSTIO"+suffix+" "+strf("%03X",addrbase)+"H"
swbreak
swend
}
swbreak
case 5
prm_0_=addr
	switch ((opcode>>3)&7)
	case 0
	return "RETN"+suffix
	swbreak
	case 1
	return "RETI"+suffix
	swbreak
	case 2
	relpos=eZ80dism_readb(addr):addr++
	prm_0_=addr
	return "LEA"+suffix+" IY,"+eZ80disasm_rpk(1)
	swbreak
	case 4
	relpos=eZ80dism_readb(addr):addr++
	prm_0_=addr
	return "PEA"+suffix+" "+eZ80disasm_rpk(1)
	swbreak
	case 5
	return "LD"+suffix+" MB,A"
	swbreak
	case 7
	return "STMIX"+suffix
	swbreak
	swend
swbreak
case 6
prm_0_=addr
	switch ((opcode>>3)&7)
	case 0
	return "IM"+suffix+" 0"
	swbreak
	case 2
	return "IM"+suffix+" 1"
	swbreak
	case 3
	return "IM"+suffix+" 2"
	swbreak
	case 4
	relpos=eZ80dism_readb(addr):addr++
	prm_0_=addr
	return "PEA"+suffix+" "+eZ80disasm_rpk(2)
	swbreak
	case 5
	return "LD"+suffix+" A,MB"
	swbreak
	case 6
	return "SLP"+suffix
	swbreak
	case 7
	return "RSMIX"+suffix
	swbreak
	swend
case 7
prm_0_=addr
	switch ((opcode>>3)&7)
	case 0
	return "LD"+suffix+" I,A"
	swbreak
	case 1
	return "LD"+suffix+" R,A"
	swbreak
	case 2
	return "LD"+suffix+" A,I"
	swbreak
	case 3
	return "LD"+suffix+" A,R"
	swbreak
	case 4
	return "RRD"+suffix
	swbreak
	case 5
	return "RLD"+suffix
	swbreak
	swend
swbreak
swend
}
if (opcode<0xd0){
prm_0_=addr
if opcode=0xc7{
return "LD"+suffix+" I,HL"
}else{
return instio(opcode-0x80)+suffix
}
}
if opcode=0xd7{
return "LD"+suffix+" HL,I"
}
swbreak
swend
}else{
return "PUSH"+suffix+" "+eZ80disasm_rphij(((opcode>>4)&3),ixyflag)
}
swbreak
case 6
addrbase=eZ80dism_readb(addr)
addr++
prm_0_=addr
return instalus((opcode>>3)&7)+suffix+" A,"+strf("%03X",addrbase)+"H"
swbreak
case 7
prm_0_=addr
return "RST"+suffix+" "+strf("%03X",opcode&0x38)+"H"
swbreak
swend
}
prm_0_=addr
return "NOP"+suffix
#global
initdisasm@__eZ80DISASM__
#endif