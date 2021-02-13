--[[Dependencies]]--
--LineGraph-TFM
local a,b,c,d,e,f;local g='0123456789abcdef'function num2hex(h)local i=''while h>0 do local j=math.fmod(h,16)i=string.sub(g,j+1,j+1)..i;h=math.floor(h/16)end;return string.upper(i==''and'0'or i)end;function split(i,k)result={}for l in(i..k):gmatch("(.-)"..k)do table.insert(result,l)end;return result end;function c(m)local n=m[1]for o=1,#m do o=m[o]if o<n then n=o end end;return n end;function d(m)local p=m[1]for o=1,#m do o=m[o]if o>p then p=o end end;return p end;function e(m,q)local r={}for s,o in next,m do r[s]=q(o)end;return r end;function f(t,u,v)local w=table.insert;local r={}for x=t,u,v do w(r,x)end;return r end;local function y(z)return 400-z end;a={}a.__index=a;setmetatable(a,{__call=function(A,...)return A.new(...)end})function a.new(B,C,D,E)assert(#B==#C,"Expected same number of data for both axis")local self=setmetatable({},a)self.name=D;self:setData(B,C)self.col=E or math.random(0x000000,0xFFFFFF)return self end;function a:getName()return self.name end;function a:getDX()return self.dx end;function a:getDY()return self.dy end;function a:getColor()return self.col end;function a:getMinX()return self.minX end;function a:getMinY()return self.minY end;function a:getMaxX()return self.maxX end;function a:getMaxY()return self.maxY end;function a:getDataLength()return#self.dx end;function a:getLineWidth()return self.lWidth or 3 end;function a:setName(D)self.name=D end;function a:setData(B,C)self.dx=B;self.dy=C;self.minX=c(B)self.minY=c(C)self.maxX=d(B)self.maxY=d(C)end;function a:setColor(E)self.col=E end;function a:setLineWidth(F)self.lWidth=F end;b={}b.__index=b;b._joints=10000;setmetatable(b,{__call=function(A,...)return A.new(...)end})function b.init()tfm.exec.addPhysicObject(-1,0,0,{type=14,miceCollision=false,groundCollision=false})end;function b.handleClick(G,H,I)if I:sub(0,("lchart:data:["):len())=='lchart:data:['then local J=split(I:sub(("lchart:data:["):len()+1,-2),",")local K,L,M,N=split(J[1],":")[2],split(J[2],":")[2],split(J[3],":")[2],split(J[4],":")[2]ui.addTextArea(18000,"<a href='event:chart_close'>X: "..M.."<br>Y: "..N.."</a>",H,K,L,80,30,nil,nil,0.5,false)elseif I=="chart_close"then ui.removeTextArea(G,H)end end;function b.new(G,O,z,F,P)local self=setmetatable({},b)self.id=G;self.x=O;self.y=z;self.w=F;self.h=P;self.showing=false;self.joints=b._joints;b._joints=b._joints+10000;self.series={}return self end;function b:getId()return self.id end;function b:getDimension()return{x=self.x,y=self.y,w=self.w,h=self.h}end;function b:getMinX()return self.minX end;function b:getMaxX()return self.maxX end;function b:getMinY()return self.minY end;function b:getMaxY()return self.maxY end;function b:getXRange()return self.xRange end;function b:getYRange()return self.yRange end;function b:getGraphColor()return{bgColor=self.bg or 0x324650,borderColor=self.border or 0x212F36}end;function b:getAlpha()return self.alpha or 0.5 end;function b:isShowing()return self.showing end;function b:getDataLength()local Q=0;for R,i in next,self.series do Q=Q+i:getDataLength()end;return Q end;function b:show()self:refresh()local S,T=math.floor,math.ceil;ui.addTextArea(10000+self.id,"",nil,self.x,self.y,self.w,self.h,self.bg,self.border,self:getAlpha(),false)ui.addTextArea(11000+self.id,"<b>["..S(self.minX)..", "..S(self.minY).."]</b>",nil,self.x-15,self.y+self.h+5,50,50,nil,nil,0,false)ui.addTextArea(12000+self.id,"<b>"..T(self.maxX).."</b>",nil,self.x+self.w+10,self.y+self.h+5,50,50,nil,nil,0,false)ui.addTextArea(13000+self.id,"<b>"..T(self.maxY).."</b>",nil,self.x-15,self.y-10,50,50,nil,nil,0,false)ui.addTextArea(14000+self.id,"<b>"..T((self.maxX+self.minX)/2).."</b>",nil,self.x+self.w/2,self.y+self.h+5,50,50,nil,nil,0,false)ui.addTextArea(15000+self.id,"<br><br><b>"..T((self.maxY+self.minY)/2).."</b>",nil,self.x-15,self.y+(self.h-self.y)/2,50,50,nil,nil,0,false)local U=self.joints;local V=self.w/self.xRange;local W=self.h/self.yRange;for G,X in next,self.series do for Y=1,X:getDataLength(),1 do local Z=S(X:getDX()[Y]*V+self.x-self.minX*V)local _=S(y(X:getDY()[Y]*W)+self.y-y(self.h)+self.minY*W)local a0=S((X:getDX()[Y+1]or X:getDX()[Y])*V+self.x-self.minX*V)local a1=S(y((X:getDY()[Y+1]or X:getDY()[Y])*W)+self.y-y(self.h)+self.minY*W)tfm.exec.addJoint(self.id+6+U,-1,-1,{type=0,point1=Z..",".._,point2=a0 ..","..a1,damping=0.2,line=X:getLineWidth(),color=X:getColor(),alpha=1,foreground=true})if self.showDPoints then ui.addTextArea(16000+self.id+U,"<font color='#"..num2hex(X:getColor()).."'><a href='event:lchart:data:[x:"..Z..",y:".._..",dx:"..X:getDX()[Y]..",dy:"..X:getDY()[Y].."]'>█</a></font>",nil,Z,_,10,10,nil,nil,0,false)end;U=U+1 end end;self.showing=true end;function b:setGraphColor(a2,a3)self.bg=a2;self.border=a3 end;function b:setShowDataPoints(a4)self.showDPoints=a4 end;function b:setAlpha(a5)self.alpha=a5 end;function b:addSeries(X)table.insert(self.series,X)self:refresh()end;function b:removeSeries(D)for x=1,#self.series do if self.series[x]:getName()==D then table.remove(self.series,x)break end end;self:refresh()end;function b:refresh()self.minX,self.minY,self.maxX,self.maxY=nil;for s,i in next,self.series do self.minX=math.min(i:getMinX(),self.minX or i:getMinX())self.minY=math.min(i:getMinY(),self.minY or i:getMinY())self.maxX=math.max(i:getMaxX(),self.maxX or i:getMaxX())self.maxY=math.max(i:getMaxY(),self.maxY or i:getMaxY())end;self.xRange=self.maxX-self.minX;self.yRange=self.maxY-self.minY end;function b:resize(F,P)self.w=F;self.h=P end;function b:move(O,z)self.x=O;self.y=z end;function b:hide()for G=10000,17000,1000 do ui.removeTextArea(G+self.id)end;for G=self.id+16000,self.joints,1 do ui.removeTextArea(G+self.id)end;for Y=self.joints,self.joints+self:getDataLength()+5,1 do tfm.exec.removeJoint(Y)end;self.showing=false end;function b:showLabels(a4)if a4 or a4==nil then local a6=""for R,X in next,self.series do a6=a6 .."<font color='#"..num2hex(X:getColor()).."'> ▉<b> "..X:getName().."</b></font><br>"end;ui.addTextArea(16000+self.id,a6,nil,self.x+self.w+15,self.y,100,18*#self.series,self:getGraphColor().bgColor,self:getGraphColor().borderColor,self:getAlpha(),false)else ui.removeTextArea(16000+self.id,nil)end end;function b:displayGrids(a4)if a4 or a4==nil then local a7=self.h/5;for G,z in next,f(self.y+a7,self.y+self.h-a7,a7)do tfm.exec.addJoint(self.id+G,-1,-1,{type=0,point1=self.x..","..z,point2=self.x+self.w..","..z,damping=0.2,line=1,alpha=1,foreground=true,color=0xFFFFFF})end;tfm.exec.addJoint(self.id+5,-1,-1,{type=0,point1=self.x+self.w/2 ..","..self.y,point2=self.x+self.w/2 ..","..self.y+self.h,damping=0.2,line=2,alpha=1,foreground=true,color=0xFFFFFF})tfm.exec.addJoint(self.id+6,-1,-1,{type=0,point1=self.x..","..self.y+self.h/2,point2=self.x+self.w..","..self.y+self.h/2,damping=0.2,line=2,alpha=1,foreground=true,color=0xFFFFFF})end end;Series=a;LineChart=b;getMin=c;getMax=d;map=e;range=f
--Timers4TFM
local a={}a.__index=a;a._timers={}setmetatable(a,{__call=function(b,...)return b.new(...)end})function a.process()local c=os.time()local d={}for e,f in next,a._timers do if f.isAlive and f.mature<=c then f:call()if f.loop then f:reset()else f:kill()d[#d+1]=e end end end;for e,f in next,d do a._timers[f]=nil end end;function a.new(g,h,i,j,...)local self=setmetatable({},a)self.id=g;self.callback=h;self.timeout=i;self.isAlive=true;self.mature=os.time()+i;self.loop=j;self.args={...}a._timers[g]=self;return self end;function a:setCallback(k)self.callback=k end;function a:addTime(c)self.mature=self.mature+c end;function a:setLoop(j)self.loop=j end;function a:setArgs(...)self.args={...}end;function a:call()self.callback(table.unpack(self.args))end;function a:kill()self.isAlive=false end;function a:reset()self.mature=os.time()+self.timeout end;Timer=a
--DataHandler V2
local a={}a.VERSION='1.5'a.__index=a;function a.new(b,c,d)local self=setmetatable({},a)assert(b,'Invalid module ID (nil)')assert(b~='','Invalid module ID (empty text)')assert(c,'Invalid skeleton (nil)')for e,f in next,c do f.type=f.type or type(f.default)end;self.players={}self.moduleID=b;self.moduleSkeleton=c;self.moduleIndexes={}self.otherOptions=d;self.otherData={}self.originalStuff={}for e,f in pairs(c)do self.moduleIndexes[f.index]=e end;if self.otherOptions then self.otherModuleIndexes={}for e,f in pairs(self.otherOptions)do self.otherModuleIndexes[e]={}for g,h in pairs(f)do h.type=h.type or type(h.default)self.otherModuleIndexes[e][h.index]=g end end end;return self end;function a.newPlayer(self,i,j)assert(i,'Invalid player name (nil)')assert(i~='','Invalid player name (empty text)')self.players[i]={}self.otherData[i]={}j=j or''local function k(l)local m={}for n in string.gsub(l,'%b{}',function(o)return o:gsub(',','\0')end):gmatch('[^,]+')do n=n:gsub('%z',',')if string.match(n,'^{.-}$')then table.insert(m,k(string.match(n,'^{(.-)}$')))else table.insert(m,tonumber(n)or n)end end;return m end;local function p(c,q)for e,f in pairs(c)do if f.index==q then return e end end;return 0 end;local function r(c)local s=0;for e,f in pairs(c)do if f.index>s then s=f.index end end;return s end;local function t(b,c,u,v)local w=1;local x=r(c)b="__"..b;if v then self.players[i][b]={}end;local function y(n,z,A,B)local C;if z=="number"then C=tonumber(n)or B elseif z=="string"then C=string.match(n and n:gsub('\\"','"')or'',"^\"(.-)\"$")or B elseif z=="table"then C=string.match(n or'',"^{(.-)}$")C=C and k(C)or B elseif z=="boolean"then if n then C=n=='1'else C=B end end;if v then self.players[i][b][A]=C else self.players[i][A]=C end end;if#u>0 then for n in string.gsub(u,'%b{}',function(o)return o:gsub(',','\0')end):gmatch('[^,]+')do n=n:gsub('%z',','):gsub('\9',',')local A=p(c,w)local z=c[A].type;local B=c[A].default;y(n,z,A,B)w=w+1 end end;if w<=x then for D=w,x do local A=p(c,D)local z=c[A].type;local B=c[A].default;y(nil,z,A,B)end end end;local E,F=self:getModuleData(j)self.originalStuff[i]=F;if not E[self.moduleID]then E[self.moduleID]='{}'end;t(self.moduleID,self.moduleSkeleton,E[self.moduleID]:sub(2,-2),false)if self.otherOptions then for b,c in pairs(self.otherOptions)do if not E[b]then local G={}for e,f in pairs(c)do local z=f.type or type(f.default)if z=='string'then G[f.index]='"'..tostring(f.default:gsub('"','\\"'))..'"'elseif z=='table'then G[f.index]='{}'elseif z=='number'then G[f.index]=f.default elseif z=='boolean'then G[f.index]=f.default and'1'or'0'end end;E[b]='{'..table.concat(G,',')..'}'end end end;for b,u in pairs(E)do if b~=self.moduleID then if self.otherOptions and self.otherOptions[b]then t(b,self.otherOptions[b],u:sub(2,-2),true)else self.otherData[i][b]=u end end end end;function a.dumpPlayer(self,i)local m={}local function H(I)local m={}for e,f in pairs(I)do local J=type(f)if J=='table'then m[#m+1]='{'m[#m+1]=H(f)if m[#m]:sub(-1)==','then m[#m]=m[#m]:sub(1,-2)end;m[#m+1]='}'m[#m+1]=','else if J=='string'then m[#m+1]='"'m[#m+1]=f:gsub('"','\\"')m[#m+1]='"'elseif J=='boolean'then m[#m+1]=f and'1'or'0'else m[#m+1]=f end;m[#m+1]=','end end;if m[#m]==','then m[#m]=''end;return table.concat(m)end;local function K(i,b)local m={b,'=','{'}local L=self.players[i]local M=self.moduleIndexes;local N=self.moduleSkeleton;if self.moduleID~=b then M=self.otherModuleIndexes[b]N=self.otherOptions[b]b='__'..b;L=self.players[i][b]end;if not L then return''end;for D=1,#M do local A=M[D]local z=N[A].type;if z=='string'then m[#m+1]='"'m[#m+1]=L[A]:gsub('"','\\"')m[#m+1]='"'elseif z=='number'then m[#m+1]=L[A]elseif z=='boolean'then m[#m+1]=L[A]and'1'or'0'elseif z=='table'then m[#m+1]='{'m[#m+1]=H(L[A])m[#m+1]='}'end;m[#m+1]=','end;if m[#m]==','then m[#m]='}'else m[#m+1]='}'end;return table.concat(m)end;m[#m+1]=K(i,self.moduleID)if self.otherOptions then for e,f in pairs(self.otherOptions)do local u=K(i,e)if u~=''then m[#m+1]=','m[#m+1]=u end end end;for e,f in pairs(self.otherData[i])do m[#m+1]=','m[#m+1]=e;m[#m+1]='='m[#m+1]=f end;return table.concat(m)..self.originalStuff[i]end;function a.get(self,i,A,O)if not O then return self.players[i][A]else assert(self.players[i]['__'..O],'Module data not available ('..O..')')return self.players[i]['__'..O][A]end end;function a.set(self,i,A,C,O)if O then self.players[i]['__'..O][A]=C else self.players[i][A]=C end;return self end;function a.save(self,i)system.savePlayerData(i,self:dumpPlayer(i))end;function a.removeModuleData(self,i,O)assert(O,"Invalid module name (nil)")assert(O~='',"Invalid module name (empty text)")assert(O~=self.moduleID,"Invalid module name (current module data structure)")if self.otherData[i][O]then self.otherData[i][O]=nil;return true else if self.otherOptions and self.otherOptions[O]then self.players[i]['__'..O]=nil;return true end end;return false end;function a.getModuleData(self,l)local m={}for b,u in string.gmatch(l,'([0-9A-Za-z_]+)=(%b{})')do local P=self:getTextBetweenQuotes(u:sub(2,-2))for D=1,#P do P[D]=P[D]:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]","%%%0")u=u:gsub(P[D],P[D]:gsub(',','\9'))end;m[b]=u end;for e,f in pairs(m)do l=l:gsub(e..'='..f:gsub('\9',','):gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]","%%%0")..',?','')end;return m,l end;function a.convertFromOld(self,Q,R)assert(Q,'Old data is nil')assert(R,'Old skeleton is nil')local function S(l,T)local m={}for U in string.gmatch(l,'[^'..T..']+')do m[#m+1]=U end;return m end;local E=S(Q,'?')local m={}for D=1,#E do local O=E[D]:match('([0-9a-zA-Z]+)=')local u=S(E[D]:gsub(O..'=',''):gsub(',,',',\8,'),',')local G={}for V=1,#u do if R[O][V]then if R[O][V]=='table'then G[#G+1]='{'if u[V]~='\8'then local I=S(u[V],'#')for W=1,#I do G[#G+1]=I[W]G[#G+1]=','end;if G[#G]==','then table.remove(G)end end;G[#G+1]='},'elseif R[O][V]=='string'then G[#G+1]='"'if u[V]~='\8'then G[#G+1]=u[V]end;G[#G+1]='"'G[#G+1]=','else if u[V]~='\8'then G[#G+1]=u[V]else G[#G+1]=0 end;G[#G+1]=','end end end;if G[#G]==','then table.remove(G)end;m[#m+1]=O;m[#m+1]='='m[#m+1]='{'m[#m+1]=table.concat(G)m[#m+1]='}'m[#m+1]=','end;if m[#m]==','then table.remove(m)end;return table.concat(m)end;function a.convertFromDataManager(self,Q,R)assert(Q,'Old data is nil')assert(R,'Old skeleton is nil')local function S(l,T)local m={}for U in string.gmatch(l,'[^'..T..']+')do m[#m+1]=U end;return m end;local E=S(Q,'§')local m={}for D=1,#E do local O=E[D]:match('%[(.-)%]')local u=S(E[D]:gsub('%['..O..'%]%((.-)%)','%1'),'#')local G={}for V=1,#u do if R[V]=='table'then local I=S(u[V],'&')G[#G+1]='{'for W=1,#I do if tonumber(I[W])then G[#G+1]=I[W]G[#G+1]=','else G[#G+1]='"'G[#G+1]=I[W]G[#G+1]='"'G[#G+1]=','end end;if G[#G]==','then table.remove(G)end;G[#G+1]='}'G[#G+1]=','else if R[V]=='string'then G[#G+1]='"'G[#G+1]=u[V]G[#G+1]='"'else G[#G+1]=u[V]end;G[#G+1]=','end end;if G[#G]==','then table.remove(G)end;m[#m+1]=O;m[#m+1]='='m[#m+1]='{'m[#m+1]=table.concat(G)m[#m+1]='}'end;return table.concat(m)end;function a.getTextBetweenQuotes(self,l)local m={}local X=1;local Y=0;local Z=false;for D=1,#l do local _=l:sub(D,D)if _=='"'then if l:sub(D-1,D-1)~='\\'then if Y==0 then X=D;Y=Y+1 else Y=Y-1;if Y==0 then m[#m+1]=l:sub(X,D)end end end end end;return m end;DataHandler=a
local format = function(s, tab) return (s:gsub('($%b{})', function(w) return tab[w:sub(3, -2)] or w end)) end

tfm.exec.disableAutoNewGame(true)
tfm.exec.disableAutoShaman(true)
tfm.exec.disableAutoTimeLeft(true)
tfm.exec.disableAfkDeath(true)
tfm.exec.newGame([[<C><P F="0" L="1600"/><Z><S><S X="79" o="aac4d2" L="162" Y="165" c="4" H="334" P="0,0,0.3,0.2,0,0,0,0" T="12"/><S X="169" o="6d9bb3" L="144" Y="201" c="4" H="285" P="0,0,0.3,0.2,-10,0,0,0" T="12"/><S X="296" o="285b74" L="52" Y="207" c="4" H="240" P="0,0,0.3,0.2,0,0,0,0" T="12"/><S X="367" o="b5d8ea" L="113" Y="178" c="4" H="300" P="0,0,0.3,0.2,0,0,0,0" T="12"/><S X="528" o="3d657a" L="61" Y="236" c="4" H="182" P="0,0,0.3,0.2,0,0,0,0" T="12"/><S X="653" o="a5c5d6" L="197" Y="164" c="4" H="332" P="0,0,0.3,0.2,0,0,0,0" T="12"/><S X="485" o="dfb218" L="78" Y="293" c="4" H="69" P="0,0,0.3,0.2,0,0,0,0" T="12"/><S X="435" o="5a4c06" L="75" Y="277" c="4" H="104" P="0,0,0.3,0.2,0,0,0,0" T="12"/><S X="338" o="0e67e7" L="12" Y="261" c="4" H="131" P="0,0,0.3,0.2,0,0,0,0" T="12"/><S X="337" o="0b56c2" L="28" Y="253" c="4" H="10" P="0,0,0.3,0.2,0,0,0,0" T="12"/><S X="338" o="324650" L="10" Y="155" H="22" P="0,0,0.3,0.2,0,0,0,0" T="12"/><S X="338" o="0fa5f1" L="44" Y="201" c="4" H="10" P="0,0,0.3,0.2,0,0,0,0" T="13"/><S X="338" o="0b56c2" L="17" Y="150" c="4" H="10" P="0,0,0.3,0.2,0,0,0,0" T="12"/><S X="338" o="0e67e7" L="10" Y="128" c="4" H="38" P="0,0,0.3,0.2,0,0,0,0" T="12"/><S X="721" o="7c99a7" L="111" Y="212" c="4" H="235" P="0,0,0.3,0.2,0,0,0,0" T="12"/><S X="56" o="480312" L="10" Y="310" c="4" H="36" P="0,0,0.3,0.2,0,0,0,0" T="12"/><S X="765" o="480312" L="10" Y="292" c="4" H="71" P="0,0,0.3,0.2,0,0,0,0" T="12"/><S X="800" o="480312" L="10" Y="282" c="4" H="94" P="0,0,0.3,0.2,0,0,0,0" T="12"/><S X="241" o="480312" L="10" Y="295" c="4" H="62" P="0,0,0.3,0.2,0,0,0,0" T="12"/><S X="753" o="055111" L="26" Y="248" c="4" H="10" P="0,0,0.3,0.2,0,0,0,0" T="13"/><S X="755" o="058419" L="10" Y="215" c="4" H="10" P="0,0,0.3,0.2,0,0,0,0" T="13"/><S X="730" o="05be22" L="10" Y="256" c="4" H="10" P="0,0,0.3,0.2,0,0,0,0" T="13"/><S X="769" o="83ae0b" L="20" Y="236" c="4" H="10" P="0,0,0.3,0.2,0,0,0,0" T="13"/><S X="785" o="129226" L="10" Y="195" c="4" H="10" P="0,0,0.3,0.2,0,0,0,0" T="13"/><S X="1053" Y="178" T="12" L="307" H="306" o="A3B6C0" P="0,0,0.3,0.2,0,0,0,0" c="4"/><S X="1429" o="a5c5d6" L="180" Y="174" c="4" H="332" P="0,0,0.3,0.2,7,0,0,0" T="12"/><S X="799" o="a18600" L="1602" Y="361" H="78" P="0,0,0.3,0.2,0,0,0,0" T="12"/><S X="211" o="058419" L="15" Y="253" c="4" H="10" P="0,0,0.3,0.2,0,0,0,0" T="13"/><S X="253" o="05be22" L="15" Y="288" c="4" H="10" P="0,0,0.3,0.2,0,0,0,0" T="13"/><S X="234" o="058419" L="31" Y="272" c="4" H="10" P="0,0,0.3,0.2,0,0,0,0" T="13"/><S X="54" o="05be22" L="20" Y="239" c="4" H="10" P="0,0,0.3,0.2,0,0,0,0" T="13"/><S X="56" o="83ae0b" L="26" Y="266" c="4" H="10" P="0,0,0.3,0.2,0,0,0,0" T="13"/><S X="79" o="05be22" L="10" Y="279" c="4" H="10" P="0,0,0.3,0.2,0,0,0,0" T="13"/><S X="34" o="058419" L="20" Y="264" c="4" H="10" P="0,0,0.3,0.2,0,0,0,0" T="13"/><S X="967" Y="269" T="12" L="280" H="110" o="465962" P="0,0,0.3,0.2,0,0,0,0" c="4"/><S X="773" o="096717" L="28" Y="243" c="4" H="10" P="0,0,0.3,0.2,0,0,0,0" T="13"/><S X="1056" Y="286" T="12" L="10" H="76" o="324650" P="0,0,0.3,0.2,0,0,0,0" c="4"/><S X="828" o="129226" L="29" Y="219" c="4" H="10" P="0,0,0.3,0.2,0,0,0,0" T="13"/><S X="804" o="058419" L="35" Y="232" c="4" H="10" P="0,0,0.3,0.2,0,0,0,0" T="13"/><S X="1293" Y="286" T="12" L="10" H="76" o="324650" P="0,0,0.3,0.2,0,0,0,0" c="4"/><S X="1167" Y="153" T="12" L="458" H="191" o="67818F" P="0,0,0.3,0.2,0,0,0,0" c="4"/><S X="1508" o="480312" L="10" Y="273" H="94" P="0,0,0.3,0.2,0,0,0,0" T="12" c="4"/><S X="1470" Y="199" T="13" L="31" H="41" o="1F6526" P="0,0,0.3,0.2,0,0,0,0" c="4"/><S X="1495" Y="220" T="13" L="30" H="42" o="26CD52" P="0,0,0.3,0.2,0,0,0,0" c="4"/><S X="1537" Y="226" T="13" L="28" H="27" o="13933F" P="0,0,0.3,0.2,0,0,0,0" c="4"/><S X="1511" Y="168" T="13" L="34" H="41" o="2E8030" P="0,0,0.3,0.2,0,0,0,0" c="4"/></S><D><DS X="431" Y="309"/></D><O/></Z></C>]])

--game variables

tips = {}

local OWNER = "King_seniru#5890"
local VERSION = "v1.1.2"
local VERSION_TEXT = "Minor updates"
local VERSION_DESCRIPTION = [[
    <b><PT>What's new (v1.1.2)</PT></b>

    • Increased the price of shop items as many of you have requested!
    
	<b><PT>v1.1.1</PT></b>

    • Minor grammar fixes and improve the contrast of some text areas (Thanks <b>Blank#3495</b>)

    <b><PT>v1.1.0</PT></b>

    • As I've promised, I added a leaderboard system to the game. Access it by pressing <b>L</b>
    • Updated help menu

    Hope you can beat all the other capitalists ;)

]]

local CONSTANTS = {
    BAR_WIDTH           = 720,
    BAR_X               = 75,
    STAT_BAR_Y          = 30,
    BACKGROUND_COLOR    = 0x285569,
    BORDER_COLOR        = 0x755f5f
}

local year = 3000
local month = 1
local day = 1
local specialUIS = 0

local closeButton = "<p align='right'><font color='#ff0000' size='13'><b><a href='event:close'>X</a></b></font></p>"
local specialCloseButton = "<p align='right'><font color='#ff0000' size='13'><b><a href='event:specialclose'>X</a></b></font></p>"

local months = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"}
local communityFlags = {
    xx = "1651b327097.png",
	ar = "1651b32290a.png",
	bg = "1651b300203.png",
	br = "1651b3019c0.png",
	cn = "1651b3031bf.png",
	cz = "1651b304972.png",
	de = "1651b306152.png",
	ee = "1651b307973.png",
	en = "1723dc10ec2.png",
	e2 = "1723dc10ec2.png",
	es = "1651b309222.png",
	fi = "1651b30aa94.png",
	fr = "1651b30c284.png",
	gb = "1651b30da90.png",
	hr = "1651b30f25d.png",
	hu = "1651b310a3b.png",
	id = "1651b3121ec.png",
	il = "1651b3139ed.png",
	it = "1651b3151ac.png",
	jp = "1651b31696a.png",
	lt = "1651b31811c.png",
	lv = "1651b319906.png",
	nl = "1651b31b0dc.png",
	ph = "1651b31c891.png",
	pl = "1651b31e0cf.png",
	ro = "1651b31f950.png",
	ru = "1651b321113.png",
	tr = "1651b3240e8.png",
	vk = "1651b3258b3.png"
}

local translations = {
    en = {
        welcome = "<BV><b>Welcome to #merchant!</b></BV><br><N>For more information type <J><b>!help</b></J> or press <J><b>H</b></J></V><br><br><D>Warning! The game is under development. Your data might get deleted! Please report any bug to <b><V>King_seniru#5890</V></b></D><br><br>Check out the official thread at <PT><b><i>https://atelier801.com/topic?f=6&t=886315</i></b></PT>",
        credits = [[
    <p align='center'><font size='20'><b><J>Credits</J></b></font></p>
    <b>All the credits go to these people for helping me with different things</b>
    <b><u>Coders</u>
            <BV>• Overforyou#9290                                               • Cyanny#0000</BV>
    <u>Icons and Images</u>
            <BV>• <a href='event:help:icons'>See all »</a></BV>
    <u>Editing and translations</u>
            <BV>• Haxor_333#0000                                                • Rail#9727
            • Blank#3495                                                        • Dacrooen#0000  </b> </BV>
    And special thanks for <BV><b>Haxor_333#0000</b></BV>, <BV><b>Dorjanoruci#0000</b></BV> and <BV><b>We talk a lot</b></BV> tribe members for encouring me to do this <3
        ]],
        commands = [[
    <p align='center'><font size='20'><b><J>Commands</J></b></font></p>
    <b>!help:</b>  Displays this dialogue
    <b>!company <i>[company name]:</i></b> Displays the specified compnay
    <b>!p <i>[player name]</i> or !profile <i>[player name]</i></b> Displays information about the specified player

    <p align='center'><font size='20'><b><J>Keys</J></b></font></p>
    <b>H</b> Displays this dialogue
    <b>L</b> Displays the leaderboard
        ]],
        job_qualified = "<b><font size='13'>${name} <a href='event:jobInfo:${name}'><BV>ⓘ</BV></a></font></b><br><p align='right'><b><VP><a href='event:job:${id}'> | Choose | </a></VP></b></p>Salary: ${salary} Energy: ${energy}%<br>Offered by <b> ${owner}</b> of <b> ${company}</b><br><br>",
        job_disqualified = "<N><b><font size='13'>${name} <a href='event:jobInfo:${name}'><BV>ⓘ</BV></a></font></b><br><p align='right'><b><N2>| Choose |</N2></b></p>Salary: ${salary} Energy: ${energy}%<br>Offered by <b>${owner}</b> of <b>${company}</b></N><br><br>",
        job_info = "<p align='center'><font size='15'><b><BV>${name}</BV></b></font></p><br><br><b>Salary</b>: ${salary}<br><b>Energy</b>: ${energy}%<br><br><b><u>Requirements</u></b><br><br><b>Minimum level</b>: ${minLevel}<br><b>Qualifications</b>: ${qualifications}<br><br>Offered by <b>${owner}</b> of <b>${company}</b>",
        nothing = "<br><br><br><br><p align='center'><b><R><font size='15'>Nothing to display!",
        profile = "<p align='center'><font size='15'><b><BV>${name}</BV></b></font><br>« ${title} »</p><br><b>Level:</b> ${level}<BL><font size='12'> [${xp}XP / ${xpTotal}XP]</font></BL><br><b>Money:</b> $${money}<br><br><b>Working as a</b> ${job}<br><b>Learning</b>: ${learning}",
        lotto = "<font color='#000000' size='10'><p align='center'><b><a href='event:getLottery'>Buy Lottery!</a><br><br><a href='event:checkLotto'>Check</a></b></p></font>",
        lottoinfo = "<p align='center'><font size='20'><b><J>Lotto Info</J></b></font><br><br><b>This month's winning lotto: </b>",
        nodrawings = "No drawings yet!",
        lottonowin = "You have no wins in the past month!",
        lottowin = "You have won $${win} in the past month",
        lottobuy = "<p align='center'>Please enter your choices (3 numbers between 0 and 100 and a letter) separated by spaces. <br><i>eg:15 20 30 B</i><br><br><b><i>Price: $20</i></b></p>",
        nocompanies = "<p align='center'>No owned companies<br>Do you want to own one?</p>",
        companycreate = "<p align='center'>Please choose a name<br>Price: $5000<br>Click submit to buy!</p>",
        newcompany = "<J>Succesfully created the new company <b>${company}</b></J>",
        newcompany2 = "<p align='center'>Do you want to own a new company</p>",
        newcompanybtn = "<a href='event:createCompany'>New Company</a>",
        companyinfo = [[<p align='center'><font size='20'><b><J>${name}</J></b></font></p><br>
        <b>Founder</b>: ${owner}<br>
        <b>Total Owners / Shareholders:  </b>${shareholders}<i>  <a href='event:page:owners${name}:1'>(See all)</a></i>
        <b>Total Workers:</b>                ${workers}<i>  <a href='event:page:workers${name}:1'>(See all)</a></i>]],
        ownedcompanies = "<p align='center'><font size='20'><b><J>My Companies</J></b></font></p><br><br>",
        companybrief = "<b><a href='event:${id}'>${name}</a></b> <i>(Your Ownership: ${ownedShares}%)</i><br>",
        tips = {
            "You Need $5000 To Start A New Company!", "You Gain Money From Your Workers!", "Look At The Stats of The Company Before You Apply for it!", "The Better The Job The Better The Income!", "Buy Items From The Shop To Gain Health!", "Some Jobs Needs A Specific Degree",
            "To Level Up You Need To Work!", "You Will Spend Less Energy When Working if You have Educational Qualifications", "The Stats Of A Company Can Be Seen By Anyone", "While Working Your Health Bar Goes Down", "Patience is The Key To This Game.", "The Stock Market Dashboard Displays how Companies Perform in Each Month",
            "You Can Buy Multiple Companies!", "You Can Have Only one Job at a Time", "Your Health will be Refreshed when You Level Up", "Recruit More Players to Have More Salary!", "Try your Best to Own a Company", "Make Sure You Consider About Energy and Salary When Choosing a Job", "The Red Bar Displays Your Health or Energy, While the Green Bar Displays your XP Percentage",
            "Chat With Your Friends When You Are Out of Health", "Use Your Brain and Take Correct Decisions!", "If Your Job Seems to Take More Energy, Try to Choose Another!", "Consider About Your Health When Working", "When Taking A Course, You will Need to Pay Per Lesson Only. So Try to Enroll For the One With Higher Lessons",
            "You Can Apply to Jobs According to Your Level and Degrees", "The Better Stats You Have The Better The Job You Can Have!", "Report Bugs To Developers", "The Game is More Fun with More Players", "Click Tips When You Need Help", "The Health Refreshes Every Moment <3", "There is a Chance for Luck Too! Buy a Lotto and Check Your Luck!", "Invest Other Companies to Have an Ownership Share"
        },
        help = {[[
    <p align='center'><font size='20'><b><J>Gameplay Overview</J></b></font></p>
    <font size='12'>This is a game which is largely based on businesses we see everywhere. You start as a little mouse with a basic job, but with a great story to write! Your goal is to earn money, buy companies, hire workers and be the best businessman in transformice!
    Click each title to know more about each thing in depth:
    <b><BV>
            <a href='event:page:help:2'>• Working</a>                       <a href='event:page:help:6'>• Shop</a>
            <a href='event:page:help:3'>• Learning</a>                      <a href='event:page:help:7'>• Jobs</a>
            <a href='event:page:help:4'>• Companies</a>
            <a href='event:page:help:5'>• Investing and Shares</a>
    </BV></b></font>
    ]],
    [[
    <p align='center'><font size='20'><b><J>Working</J></b></font></p>
    <font size='12'>This is the starting point for many players in this game. Working gives you money, and also it increases your XP level. To work, simply click the button in the bottom-left corner saying <b>Work!</b>
    As you work, your energy reduces. The amount of energy depends on the job you are currently doing. There are lots of jobs available (and you can create as well) and all of them have varying salaries and energy levels.
    If you do a good job, then surely you will get lot of money with minimum effort. Please read the page at <a href='event:page:help:7'><b><BV>jobs</BV></b></a> to know more about them.
    </font>
    ]],
    [[
    <p align='center'><font size='20'><b><J>Learning</J></b></font></p>
    <font size='12'>Learning makes a person better, so do here.
    <b><u>Why learning?</u></b>
    When you learn, you'll get qualifications to do many jobs with many benefits. Also according to the level of your education, the amount of energy you spend on jobs decreases. So why not learning?
    <b><u>How?</u></b>
    You can learn by entering the school. Then enroll a course of your choice and start learning. Your learning progress is displayed on top of the school, so you can plan things accordingly
    </font>
    ]],
    [[
    <p align='center'><font size='20'><b><J>Companies</J></b></font></p>
    <font size='12'>Companies are the most important things in this game; and it's the fastest way to become rich! You can view information about a company using the <i><font color='#6A7495'>!company COMPANY_NAME</font></i> command.
    There are 2 ways to own a company: By buying shares of an existing company or buying a new company for money.
    To buy a company you need to spend $5000 in your hand. Click 'Company' button and follow the instructions. If you already own companies, click the 'Create a new company' button in companies menu. To buy shares of a company of a company, simply view the desired company and do 'Buy shares' if the company has issued shares). After that you'd get the ownership of that company and you can do anything.         <i><font color='#6A7495'>(to be  continued...)</font></i>
    </font>
    ]],
    [[
    <p align='center'><font size='20'><b><J>Companies - Investing, Issuing and buying shares</J></b></font></p>
    <font size='12'>Share is based on the ownership for a ceratain company. Sometimes you may need more money to grow your business. In such cases issuing shares is a good idea. By doing so you'll improve the capital and also share the ownership of your company. Click the 'Issue Shares' button in the company's menu and follow the instructions. 1 share worths $100 in this game.
    When a certain company issue shares in the above manner, the public will be able to buy some shares to get more profit. You can buy shares buy following the instructions mentioned in the previous section.
    You can also increase the capital without issuing any sharing. That's by investing into your own company. Click the invest button and follow the instructions to invest!
    </font>
    ]],
    [[
    <p align='center'><font size='20'><b><J>Shop</J></b></font></p>
    <font size='12'>
    Shop includes healthpacks which can be used to increase your health. After buying things in shop, they will get stored in your inventory temporarily. So check your inventory and use the things you bought according to your choice!
    </font>
    ]],
    [[
    <p align='center'><font size='20'><b><J>Jobs</J></b></font></p>
    <font size='12'>You need a job to work. Each job has different salaries and energies. You can apply for a job by visiting the job menu (NOTE: You can only see jobs that you are qualified). To become qualified for a certain job, your level should be higher than the minimum level required for that job. You may also need to complete some degrees by learning, to apply for some jobs. Jobs with higher level and educational level usually have low energy consumption and higher salaries. Also if you have achieved a certain educational level, you will spend less energy when working. So keep in mind that learning is always good!
    Jobs are offered by company owners, so doing a job means you are working for a particular company. When you work you, company owners and company get profit...
    </font>
    ]],
    [[
    <p align='center'><font size='20'><b><J>Creating Jobs</J></b></font></p>
    <font size='12'>You need to become an owner to create a job. You can start creating a job by clicking the 'Create job' button in the company. You would see a dialogue asking some information about the job
        • Job Name (required): The name of the job
        • Salary (required): The salary. For a company, there's a maximum limit of salary that could be assigned to a job, which depends on the amount of invested capital. It will cost more energy if you created the job with a salary close to the minimum amount, and vice-versa.
        • Energy (required): The amount of energy spend. Energy depends on the salary, minimum level of the job and the qualifications for it.  <i><font color='#6A7495'>(to be  continued...)</font></i>
    </font>
    ]],
    [[
    <p align='center'><font size='20'><b><J>Creating Jobs</J></b></font></p>
    <font size='12'><i><font color='#6A7495'>(from the last page...)</font></i>
        • Minimum level (required): The minimum level of a player to apply for this job. Increasing the level would decrease the energy
        • Qualifications (optional): The educational qualifications required for this job. Increasing this would decrease the energy further!
    Salary and the energy consumed is the factor that many workers are looking for. So be careful when choosing this!
    <b><J>GOOD LUCK!</J></b>
    </font>
        ]],
    iconProviders = closeButton .. 
    [[
    <a href='event:credits'>« Go back</a>
    <p align='center'><font size='20'><b><J>Icons and Images</J></b></font></p>         <b><BV>Freepik</BV> from <BV>flaticons.com</BV></b>
            • Work button       • Job search icon
            • Companies icon
        <b><BV>Vector Market</BV> from <BV>flaticons.com</BV></b>
            • Idea bulb icon
        <b><BV>Payungkead</BV> from <BV>flaticons.com</BV></b>
            • Bag icon
        <b><BV>Dinosoft labs</BV> from <BV>flaticons.com</BV></b>
            • School image
        <b><BV>Nikita Golubev</BV> from <BV>flaticons.com</BV></b>
            • Lottery kiosk image
        ]]},        
    },
	["ar"] = {
        welcome = "<BV><b>مرحباً بكم في #merchant!</b></BV><br><N>للمزيد من المعلومات  <J><b>!help</b></J> او أضغط على <J><b>H</b></J></V><br><br><D>ملاحظة! اللعبة قيد التطوير حالياً. قد يتم حذف بياناتك! الرجاء الإبلاغ عن أي خطأ الى <b><V>King_seniru#5890</V></b></D><br><br>تحقق من الموضوع الرسمي في <PT><b><i>https://atelier801.com/topic?f=6&t=886315</i></b></PT>",
        credits = [[
    <p Align='center'><font size='20'><b><J>الاعتمادات</J></b></font></p>
    <b>كل الفضل يعود إلى هؤلاء الأشخاص لمساعدتي في أشياء مختلفة</b>
    <b><u>المبرمجون</u>
            <BV>• Overforyou#9290                                               • Cyanny#0000</BV>
		<u>الأيقونات والصور</u>
            <BV>• <a href='event:help:icons'>See all »</a></BV>
    <u>التحرير</u>
            <BV>• Haxor_333#0000                                                • Rail#9727
            • Blank#3495                                                        • Dacrooen#0000  </b> </BV>
   وشكر خاص الى <BV><b>Haxor_333#0000</b></BV>, <BV><b>Dorjanoruci#0000</b></BV> و <BV><b>نحن نتحدث كثيراً</b></BV> أعضاء القبيلة لتشجيعي على القيام بذالك
        ]],
         commands = [[
    <p Align='center'><font size='20'><b>أوامر</J></b></font></p>
    <b>!help:</b>  يعرض هذا الحوار
    <b>!company <i>[أسم الشركة]:</i></b> يعرض الشركة المحددة
    <b>!p <i>[اسم اللاعب]</i> او !profile <i>[اسم اللاعب]</i></b> يعرض المعلومات حول اللاعب المحدد

    <p align='center'><font size='20'><b><J>المفاتيح</J></b></font></p>
    <b>H</b> يعرض هذا الحوار
    <b>L</b> يعرض لوحة الصدارة
        ]],
        job_qualified = "<b><font size='13'>${name} <a href='event:jobInfo:${name}'><BV>ⓘ</BV></a></font></b><br><p align='right'><b><VP><a href='event:job:${id}'> | اختر | </a></VP></b></p>راتب: ${salary} طاقة: ${energy}%<br>مقدمة من <b> ${owner}</b>من <b> ${company}</b><br><br>",
        job_disqualified = "<N><b><font size='13'>${name} <a href='event:jobInfo:${name}'><BV>ⓘ</BV></a></font></b><br><p align='right'><b><N2>| اختر |</N2></b></p>الراتب: ${salary} طاقة: ${energy}%<br>مقدمة من <b>${owner}</b> of <b>${company}</b></N><br><br>",
        job_info = "<p align='center'><font size='15'><b><BV>${name}</BV></b></font></p><br><br><b>Salary</b>: ${salary}<br><b>طاقة</b>: ${energy}%<br><br><b><u>المتطلبات</u></b><br><br><b>المستوى الادنى</b>: ${minLevel}<br><b>المؤهلات</b>: ${qualifications}<br><br>مقدمة من <b>${owner}</b> من <b>${company}</b>",
        nothing = "<br><br><br><br><p align='center'><b><R><font size='15'>لاشيء لعرضه!",
        profile = "<p align='center'><font size='15'><b><BV>${name}</BV></b></font><br>« ${title} »</p><br><b>المستوى:</b> ${level}<BL><font size='12'> [${xp}XP / ${xpTotal}XP]</font></BL><br><b>المال:</b> $${money}<br><br><b>العمل كيد التقدم</b> ${job}<br><b>تعلم</b>: ${learning}",
        lotto = "<font color='#000000' size='10'><p align='center'><b><a href='event:getLottery'>شراء اليانصيب!</a><br><br><a href='event:checkLotto'>التحقق</a></b></p></font>",
        lottoinfo = "<p align='center'><font size='20'><b><J>Lotto Info</J></b></font><br><br><b>This month's winning lotto: </b>",
        nodrawings = "لا توجد رسومات بعد",
        lottonowin = "ليس لديك انتصارات في الشهر الماضي!",
        lottowin = "لقد فزت $${win} في الشهر الماضي",
        lottobuy = "<p align='center'>الرجاء ادخال اختياراتك (3 أرقام بين 0 و 100 وحرف) مفصولة بالمسافات. <br><i>مثلا:15 20 30 B</i><br><br><b><i>السعر: $20</i></b></p>",
        nocompanies = "<p align='center'>لا توجد شركات مملوكة<br>هل تريد امتلاك واحدة؟</p>",
        companycreate = "<p align='center'>الرجاء اختيار اسم<br>السعر: $5000<br>انقر فوق تقديم للشراء</p>",
        newcompany = "<J>تم انشاء الشركة الجديدة بنجاح <b>${company}</b></J>",
        newcompany2 = "<p align='center'>هل تريد أن تمتلك شركة جديدة</p>",
        newcompanybtn = "<a href='event:createCompany'>شركة جديدة</a>",
        companyinfo = [[<p align='center'><font size='20'><b><J>${name}</J></b></font></p><br>
        <b>المؤسس</b>: ${owner}<br>
        <b>مجموع الملاك / المساهمين:  </b>${shareholders}<i>  <a href='event:page:owners${name}:1'>(اظهار الكل)</a></i>
        <b>مجموع العاملين:</b>                ${workers}<i>  <a href='event:page:workers${name}:1'>(اظهار الكل)</a></i>]],
        ownedcompanies = "<p align='center'><font size='20'><b><J>شركاتي</J></b></font></p><br><br>",
        companybrief = "<b><a href='event:${id}'>${name}</a></b> <i>(ملكيتك: ${ownedShares}%)</i><br>",
        tips = {
            " أنت بحاجة الى 5000$ لبدء شركة جديدة", "تكسب المال من العاملين لديك!", "انظر الى احصائيات الشركة قبل أن تتقدم اليها!", "كلما كانت الوظيفة أفضل كلما كان الدخل أفضل", "شراء العناصر من المتحر للحصول على الصحة", "بعض الوظائف تحتاج الى درجة معينة",
            "لرفع المستوى تحتاج الى العمل!", "ستنفق طاقة أقل عند العمل اذا كانت لديك مؤهلات تعليمية", "يمكن لأي شخص أن يطلع على احصائيات الشركة", "أثناء العمل ينخفض شريط الصحة بك", "الصبر هو مفتاح هذه اللعبة.", "تعرض لوحة معلومات سوق الأسهم كيفية أداء الشركات في كل شهر",
            "يمكنك شراء عدة شركات", "يمكنك الحصول على وظيفة واحدة فقط في كل مرة", "سيتم تحديث صحتك عندما تصل الى السمتوى الأعلى", "قم بتجنيد المزيد من اللاعبين للحصول على رواتب أكثر!", "ابذل قصارى جهدك لامتلاك شركة", "تأكد من أنك تفكر في الطاقة والراتب عند اختيار الوظيفة", "يعرض الشريط الأحمر صحتك أو طاقتك , بينما يعرض الشريط الأخضر نسبة الاكس بي الخاصة بك",
			"تحدث مع أصدقائك عندما تكون بصحة جيدة"," استخدم دماغك واتخد القرارات الصحيحة!", "اذا كانت وظيفتك تبدو أنها تستهلك المزيد من الطاقة, حاول أن تختار وظيفة أخرى!","ضع في اعتبارك صحتك عند العمل", "عند أخذ دورة , سوف تحتاج الى الدفع مقابل كل درس فقط . لذا حاول الستجيل للحصول على دروس أعلى",                             
            "يمكنك التقديم على الوظائف حسب مستواك ودرجاتك", "أفضل الاحصائيات لديك أفضل وظيفة يمكنك الحصول عليها", "أبلغ عن الأخطاء للمطورين", "اللعبة أكثر متعة مع المزيد من اللاعبين", "انقر فوق تلميحات عندما تحتاج الى مساعدة", "الصحة تنعش كل لحظة <", "هناك فرصة للحصول على الحظ ! شراء لوتو وتحقق من حظك", "استثمر شركات أخرى للحصول على حصة ملكية"
        },
        help = {[[
    <p align='center'><font size='20'><b><J>نظرة عامة على اللعب</J></b></font></p>
    <font size='12'>هذه لعبة تعتمد بشكل كبير على الأعمال التجارية التي نراها في كل مكان.تبدأ كفأر صغير بوظيفة أساسية,ولكن بقصة رائعة تكتبها!هدفك هو كسب المال وشراء الشركات وتوظيف العمال وأن تكون أفضل رجل أعمال في ترانسفورمايس
    انقر فوق كل عنوان لمعرفة المزيد عن كل شيء في العمق:
    <b><BV>
            <a href='event:page:help:2'>• العمل</a>                       <a href='event:page:help:6'>• المتجر</a>
            <a href='event:page:help:3'>• تعلم</a>                      <a href='event:page:help:7'>• وظائف</a>
            <a href='event:page:help:4'>• الشركات</a>
            <a href='event:page:help:5'>• الاستثمار والاسهم</a>
    </BV></b></font>
    ]],
    [[
    <p align='center'><font size='20'><b><J>العمل</J></b></font></p>
    <font size='12'>هذه هي نقطة البداية للعديد من اللاعبين في هذه اللعبة.يمنحك العمل المال , وكما أنه يزيد من مستوى نقاط الخبرة لديك.للعمل,ما عليك سوى النقر فوق الزر الموجود في الزاوية اليسرى السفلية <b>عمل!</b>
   أثناء عملك, تقل طاقتك.يعتمد مقدار الطاقة على الوظيفة التي تقوم بها حالياً.هناك الكثير من الوظائف المتاحة(ويمكنك انشائها أيضاً) وجميعها لها رواتب ومستويات طاقة متفاوتة.
    اذا قمت بعمل جيد , فمن المؤكد أنك ستحصل على الكثير من الما بأقل جهد.يرجى قراءة الصفحة في <a href='event:page:help:7'><b><BV>وظائف</BV></b></a> لمعرفة المزيد عنها.
    </font>
    ]],
    [[
    <p align='center'><font size='20'><b><J>تعلم</J></b></font></p>
    <font size='12'>التعلم يجعل الشخص أفضل,لذا افعله هنا.
    <b><u>لماذا التعلم؟</u></b>
   عندما تتعلم , ستحصل على مؤهلات للقيام بالعديد من الوظائف مع العديد من الفوائد.أيضاً وفقاً لمستوى تعليمك ,تقل كمية الطاقة التي تنفقها على الوظائف.فلماذا لا تتعلم
    <b><u>كيف؟</u></b>
    يمكنك التعلم عن طريق دخول المدرسة.ثم قم بتسجيل دورة من اختيارك وابدأ التعلم.يتم عرض تقدم التعلم الخاص بك أعلى المدرسة ,حتى تتمكن من التخطيط للأشياء وفقاً لذلك
    </font>
    ]],
    [[
    <p align='center'><font size='20'><b><J>الشركات</J></b></font></p>
    <font size='12'>الشركات هي أهم الأشياء في هذه اللعبة;وهي أسرع طريقة لتصبح ثرياً!يمكنك عرض معلومات حول شركة تستخدم امتداد <i><font color='#6A7495'>!company أسم_الشركة</font></i> أمر.
    هناك طريقتان لامتلاك شركة: عن طريق شراء أسهم شركة قائمة أو شراء شركة جديدة مقابل المال.
    لشراء شركة تحتاج الى انفاق 5000% في يدك.انقر فوق زر "الشركة" واتبع التعليمات.اذا كنت تمتلك شركات بالفعل , فانقر فوق الزر انشاء شركة جديدة في قائمة الشركات . لشراء أسهم شركة ما , ما عليك سوى عرض الشركة المرغوبة والقيام بـ"شراء الأسهم"اذا أصدرت الشركة (أسهماً).بعد ذلك ستحصل على ملكية تلك الشركة ويمكنك فعل أي شيء         <i><font color='#6A7495'>(يتبع...)</font></i>
    </font>
    ]],
    [[
    <p align='center'><font size='20'><b><J>الشركات-استثمار واصدار وشراء الاسهم</J></b></font></p>
    <font size='12'>الحصة على أساس ملكية الشركة المؤكدة. في بعض الأحيان قد تحتاج الى المزيد من المال لتنمية عملك.في مثل هذه الحالات , يعد اصدار الأسهم فكرة جيدة. من خلال القيام بذلك , ستحسن رأس المال وتشارك أيضاً ملكية شركتك. انقر على زر "أصدار الأسهم" في قائمة الشركة واتبع التعليمات. 1 سهم بقيمة 100$ في هذه اللعبة.
   عندما تقوم شركة معينة بأصدار أسهم بالطريقة المذكورة أعلاه , سيتمكن الجمهور من شراء بعض الأسهم للحصول على المزيد من الأرباح. يمكنك شراء أسهم شراء باتباع التعليمات المذكورة في القسم السابق.
    يمكنك أيضاً زيادة رأس المال دون اصدار أي مشاركة. هذا من خلال الاستثمار في شركتك الخاصة.انقر فوق زر الاستثمار واتبع التعليمات للاستثمار!
    </font>
    ]],
    [[
    <p align='center'><font size='20'><b><J>المتجر</J></b></font></p>
    <font size='12'>
    يتضمن المتجر حزم الصحة التي يمكن استخدامها لتحسين صحتك. بعد شراء الأشياء في المتجر , سيتم تخظينها في مخزونك مؤقتاً.لذا تحقق من مخزونك واستخدم الأشياء التي اشتريتها وفقاً لاختيار
    </font>
    ]],
    [[
    <p align='center'><font size='20'><b><J>وظائف</J></b></font></p>
    <font size='12'>أنت بحاجة الى وظيفة للعمل.لكل وظيفة رواتب وطاقات مختلفة.يمكنك التقدم للحصول على وظيفة من خلال زيارة قائمة الوظائف (ملاحظة: يمكنك فقط رئية الوظائف المؤهلة).لتصبح مؤهلات لوظيفة معينة , يجب أن يكون مستواك أعلى من الحد الأدنى للمستوى المطلوب لهذه الوظيفة. قد تحتاج أيضاً الى اكمال بعض الدرجات العلمية عن طريق التعلم, للتقدم لبعض الوظائف. الوظئاف ذات المستوى الأعلى والمستوى التعليمي عادة ما يكون لها استهلاك منخفض للطاقة ورواتب أعلى. أيضاً اذا كنت قد حققت مستوى تعليمياً معيناً فسوف تنفق طاقة أقل أثناء العمل. لذا ضع في اعتبارك أن التعلم دائماً أمر جيد!
   يتم تقديم الوظائف من قبل أصحاب الشركة , لذا فإن القيام بوظيفة يعني أنك تعمل في شركة معينة. عندما تعمل أنت, يحصل أصحاب الشركة والشركة على ربح ...
    </font>
    ]],
    [[
    <p align='center'><font size='20'><b><J>صنع وظائف</J></b></font></p>
    <font size='12'>أنت بحاجة إلى أن تصبح مالكاً لإنشاء وظيفة. يمكنك البدء في إنشاء وظيفة بالنقر فوق الزر "إنشاء وظيفة"في الشركة . سترى حواراً يسأل عن بعض المعلومات حول الوظيفة
        • إسم الوظيفة (مطلوب): اسم الوظيفة
        • الراتب (مطلوب): الراتب.بالنسبة للشركة , هناك حد أقصى للراتب يمكن تخصيصه لوظيفة ما, والذي يعتمد على مقدار رأس المال المستثمر. سيكلفك المزيد من الطاقة إذا قمت بإنشاء الوظيفة براتب قريب من الحد الأدنى للمبلغ , والعكس صحيح .
        • الطاقة (المطلوبة):مقدار الطاقة المصروفة. تعتمد الطاقة على الراتب والمستوى الأدنى للوظيفة والمؤهلات اللازمة لها.  <i><font color='#6A7495'>(يتبع...)</font></i>
    </font>
    ]],
    [[
    <p align='center'><font size='20'><b><J>صنع وظائف</J></b></font></p>
    <font size='12'><i><font color='#6A7495'>(من الصفحة الأخيرة...)</font></i>
        • المستوى الأدنى (مطلوب): المستوى الأدنى للاعب للتقدم لهذه الوظيفة.زيادة المستوى يقلل من الطاقة
        • المؤهلات (اختيارية)ك المؤهلات العلمية المطلوبة لهذه الوظيفة. زيادة هذا يقلل من الطاقة أكثر!
    الراتب والطاقة المستهلكة هو العامل الذي يبحث عنه العديد من العمال. لذا كن حذراً عند اختيار هذا!
    <b><J>حظاً طيباً</J></b>
    </font>
        ]],
    iconProviders = closeButton .. 
    [[
    <a href='event:credits'>« عد للخلف</a>
    <p align='center'><font size='20'><b><J>الأيقونات والصور</J></b></font></p>         <b><BV>الفريبيك</BV> من <BV>flaticons.com</BV></b>
            • زر العمل       • رمز البحث عن وظيفة
            • أيقونة الشركات
        <b><BV>سوق المتجهات</BV> من <BV>flaticons.com</BV></b>
            • أيقونة مصباح الفكرة
        <b><BV>Payungkead</BV> من <BV>flaticons.com</BV></b>
            • رمز الحقيبة
        <b><BV>Dinosoft labs</BV> من <BV>flaticons.com</BV></b>
            • صورة المدرسة
        <b><BV>Nikita Golubev</BV> من <BV>flaticons.com</BV></b>
            • صورة كشك اليانصيب
        ]]},                
    }

}

local players = {}
local healthPacks = {}
local courses = {}
local jobs = {}
local totalJobs = 0
local companies = {}
local leaderboard = {}
local tempData = {} --this table stores temporary data of players when they are creating a new job. Generally contains data in this order: tempPlayer = {jobName = 'MouseClick', jobSalary = 1000, jobEnergy = 0, minLvl = 100, qualification = "a pro"}
local closeSequence = {
    [100] = {101, 102, 103},
    [300] = {301, 302, 303},
    [400] = {401, 402, 403, 404},
    [450] = {451, 452, 453},
    [460] = {461, 462, 463},
    [800] = {801, 802, 803},
    [900] = {901},
    [952] = {950, 951, 953, 954, 955, 956},
    [5000] = {5001, 5002, 5003, 5004, 5005, 5006, 5007, 5008, 5009, 5010},
    [50000] = {50001}
}
local specialCloseSequence = {}


local titles = {
    [1] = "Newbie",
    [2] = "Worker",
    [3] = "Getting Experience",
    [4] = "Little Learner",
    [5] = "Dedicated Learner",
    [6] = "Degree Holder",
    [7] = "Investor",
    [8] = "Businessman"
}

local coursesHelper = {
    [1] = "School",
    [2] = "Junior Sports Club",
    [3] = "High School",
    [4] = "Cheese mining",
    [5] = "Cheese trading",
    [6] = "Cheese developing",
    [7] = "Law",
    [8] = "Cheese trading-II",
    [9] = "Fullstack cheese developing"
}

local items = {
    [1] = "Cheese",
    [2] = "Candy",
    [3] = "Apple",
    [4] = "Pastry",
    [5] = "Lasagne",
    [6] = "Cheese Pizza",
    [7] = "Magician`s Portion",
    [8] = "Rotten Cheese",
    [9] = "Cheef`s food",
    [10] = "Cheese Pizza - Large",
    [11] = "Vito`s Pizza",
    [12] = "Vito`s Lasagne",
    [13] = "Ambulance!"
}

local ab = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}
local latestLotto = {}
local lottoWins = {}
local lottoBuyers = {}

local dHandler = DataHandler.new("merchant", {
    money = {index = 1, type = "number", default = 100},
    title = {index = 2, type = "number", default = 1},
    xp =    {index = 3, type = "number", default = 1},
    level = {index = 4, type = "number", default = 1},
    learning = {index = 5, type = "number", default = 0},
    learnProgress = {index = 6, type = "number", default = 0},
    eduLvl = {index = 7, type = "number", default = 1},
    eduStream = {index =  8, type = "string", default = ""},
    degrees = {index = 9, type = "table", default = {}},
    inventory = {index = 10, type = "table", default = {}},
    titles = {index = 11, type = "table", default = {}}
})

local chart = LineChart(1, 944, 60, 450, 185)
local dummySeries = Series({0}, {0}, "dummy") -- *sigh*
local timer = Timer("time-sys", function()
    day = day + 1
    if day == 31 then
        day = 1
        month = month + 1
        companies["Atelier801"]:issueShares(50, "shaman")
        --updating the stock market dashboard
        chart:addSeries(dummySeries)
        for comp, data in next, companies do
            for i=1, 11, 1 do
                data.shareVal[i] = data.shareVal[i+1]
            end
            data.shareVal[12] = data.incomePerMonth / data.outstandingShares + 100
            data.chartSeries:setData(range(1, 12, 1), data.shareVal)
            data.incomePerMonth = 0
            chart:removeSeries("<a href='event:com:" .. comp .. "'>" .. comp .. "</a>")
        end
        for _, comp in next, getTopCompanies(10) do
            chart:addSeries(companies[comp[1]].chartSeries)
        end
        chart:removeSeries("dummy")
        chart:showLabels()
        chart:show()
        --checking lottery winners
        latestLotto = {math.random(1, 100), math.random(1, 100), math.random(1, 100), ab[math.random(1, 26)]}
        checkLottoWinners()
        for name, wins in next, lottoWins do
            players[name]:setMoney(wins, true)
        end
        lottoBuyers = {}
        if month == 13 then
            month = 1
            year = year + 1
        end
    end
	ui.addTextArea(12, "<p align='center'><font color='#ffffff'><b>" .. months[month] .. " " .. day .. "<br>YR " .. year .. "</p>", name, 288, 180, 100, 100, nil, nil, 0, false)
end, 1000, true)

local saveDataTimer = Timer("dataTimer", function()
    print("[Stats] Attempting to save player data (Players: " .. tfm.get.room.uniquePlayers .. " / 5)")
    saveData()
end, 1000 * 60 * 3, true)

--creating the class Player
local Player = {}
Player.__index = Player
Player.__tostring = function(self)
    return "[name=" .. self.name .. ",money=" .. self.money .. ", health=" .. self.health .. "]"
end
Player._total = 0

setmetatable(Player, {
    __call = function (cls, name, config)
        return cls.new(name, config)
    end,
})

function Player.new(name, config)
    local self = setmetatable({}, Player)
    self.name = name
    self.money = config.money or 100
    self.title = config.title or "Newbie"
    self.health = 1.0
    self.healthRate = 0.002
    self.xp = config.xp or 1
    self.level = config.level or 1
    self.learning = config.learning or ""
    self.learnProgress = config.learnProgress or 0
    self.eduLvl = config.eduLvl or 1
    self.eduStream = config.eduStream or ""
    self.degrees = config.degrees or {}
    self.job = ""
    self.ownedCompanies = {}
    self.totalCompanies = 0
    self.company = "Atelier801"
    self.inventory = config.inventory or {}
    self.titles = config.titles
    ui.addTextArea(1000, "", name, CONSTANTS.BAR_X, 340, CONSTANTS.BAR_WIDTH, 20, 0xff0000, 0xee0000, 1, true)
    ui.addTextArea(2000, "", name, CONSTANTS.BAR_X, 370, CONSTANTS.BAR_WIDTH, 17, 0x00ff00, 0x00ee00, 1, true)
    Player._total = Player._total + 1
    return self
end

function Player:getName() return self.name end
function Player:getMoney() return self.money end
function Player:getHealth() return self.health end
function Player:getHealthRate() return self.healthRate end
function Player:getXP() return self.xp end
function Player:getLevel() return self.level end
function Player:getLearningCourse() return self.learning end
function Player:getLearningProgress() return self.learnProgress end
function Player:getEducationLevel() return self.eduLvl end
function Player:getEducationStream() return self.eduStream end
function Player:getDegrees() return self.degrees end
function Player:getOwnedCompanies() return self.ownedCompanies end
function Player:getInventory() return self.inventory end
function Player:getJob() return self.job end
function Player:getTitle() return self.title end
function Player:getTitles() return self.titles end

function Player:work()
    local job = jobs[self.job]
    if self.health - job.energy > 0 then
        self.setHealth(self, -job.energy, true)
        self:setMoney(job.salary + job.salary * self.eduLvl * 0.1, true)
        self:setXP(1, true)
        companies[self.company]:setIncome(job.salary * 0.5, true)
        for name, shares in next, companies[self.company]:getShareHolders() do
            players[name]:setMoney(shares.shares * job.salary * 0.1, true)
        end
        self:levelUp()
    end
end

function Player:setHealth(val, add)
    if add then
        self.health = self.health + val
    else
        self.health = val
    end
    self.health = self.health > 1  and 1 or self.health < 0 and 0 or self.health
    ui.addTextArea(1000, "", self.name, CONSTANTS.BAR_X, 340, CONSTANTS.BAR_WIDTH * self.health, 20, 0xff0000, 0xee0000, 1, true)
    ui.updateTextArea(2, "<p align='center'>" .. math.ceil(self.health * 100) .. "%</p>", self.name)
end

function Player:setMoney(val, add)
    if add then
        self.money = self.money + val
    else
        self.money = val
    end
    self.money = self.money < 0 and 0 or self.money
    if self.name ~= 'shaman' then
        dHandler:set(self.name, "money", self.money)
    end
    self:updateStatsBar()
end

function Player:setXP(val, add)
    if add then
        self.xp = self.xp + val
    else
        self.xp = val
    end
    dHandler:set(self.name, "xp", self.xp)
    ui.addTextArea(2000, "", self.name, CONSTANTS.BAR_X, 370, ((self.xp - calculateXP(self.level)) / (calculateXP(self.level + 1) - calculateXP(self.level)))  * CONSTANTS.BAR_WIDTH, 17, 0x00ff00, 0x00ee00, 1, true)
	ui.updateTextArea(3, "<p align='center'><font color = '#000000'>Level " .. self.level .. " - " ..self.xp .. "/" .. calculateXP(self.level + 1) .. "XP", self.name)
end

function Player:setTitle(newTitle)
    for id, title in next, titles do
        if title == newTitle and find(id, self.titles, true) then
            self.title = newTitle
            self:updateStatsBar()
            dHandler:set(self.name, "title", id)
            break
        end
    end
end

function Player:addTitle(newTitle)
    --getting the title id
    local tid = nil
    for id, title in next, titles do
        if title == newTitle then tid = id end
    end

    if not find(tid, self.titles, true) then
        table.insert(self.titles, tid)
        dHandler:set(self.name, "titles", self.titles)
        tfm.exec.chatMessage("<D>Congratulations, " ..  self.name .. " achieved a new title\n« " .. titles[tid] .. " »</D>")
    end
end

function Player:setCourse(course)
    self.learning = course.name
    self.learnProgress = 0
    self.eduLvl = course.level
    self.eduStream = course.stream
    dHandler:set(self.name, "learning", course.id)
    dHandler:set(self.name, "learnProgress", self.learnProgress)
    dHandler:set(self.name, "eduLvl", self.eduLvl)
    dHandler:set(self.name, "eduStream", self.eduStream)
    ui.updateTextArea(5, "<a href='event:courses'><font size='15'><b>Learn</b></font></a>", self.name)
    ui.addTextArea(3000, "<p align='center'><font color='#ffffff'><b>Lessons Learned: 0 / " .. courses[self.learning].lessons .. "</b></font></p>", self.name, 480, 180, 300, 20, nil, nil, 0, false)
end

function Player:setJob(job)
    local jobRef = jobs[job]
print(job)
    if jobRef and jobRef.minLvl <= self.level and (jobRef.qualifications == nil or self.degrees[jobRef.qualifications] ~= nil) then
        self.job = job
        if self.company ~= jobRef.company then
            companies[self.company]:removeMember(self.name)
        end
        self.company = jobRef.company
        companies[self.company]:addMember(self.name)
    end
end

function Player:addOwnedCompanies(comName)
    if not self.ownedCompanies[comName] then
        self:addTitle("Businessman")
        self.ownedCompanies[comName] = companies[comName]
        self.totalCompanies = self.totalCompanies + 1
    end
end

function Player:investTo(comName, amount, sharePurchase)
    if self.money < amount then
        tfm.exec.chatMessage('<R>[Error] Not Enough money!</R>', self.name)
    else
        if sharePurchase then
            if companies[comName]:getUnownedShares() < amount / 100 then
                tfm.exec.chatMessage("<R>[Error]Company doesn't issue shares of the specified amount</R>", self.name)
                return
            end
                companies[comName]:setShares(-amount / 100, true)
            tfm.exec.chatMessage("<J>Bought shares from <b>" .. comName .. "</b></J>", self.name)
        end
        companies[comName]:addShareHolder(self.name, amount)
        self:setMoney(-amount, true)
        self:addOwnedCompanies(comName)
        self:addTitle("Investor")
        displayCompany(comName, self.name)
    end
end

function Player:addDegree(id)
    self:addTitle("Degree Holder")
    if not find(id, self.degrees, true) then
        table.insert(self.degrees, id)
    end
    dHandler:set(self.name, "degrees", self.degrees)
end

function Player:learn()
    if not (self.learning == "") and self.money > courses[self.learning].feePerLesson then
        self:addTitle("Little Learner")
        self.learnProgress = self.learnProgress + 1
    	ui.updateTextArea(3000, "<font color = '#ffffff'><b><p align='center'>Lessons Learned: " .. self.learnProgress .. " / " .. courses[self.learning].lessons .. "</b></p>", self.name)
        self:setMoney(-courses[self.learning].feePerLesson, true)
        if self.learnProgress >= courses[self.learning].lessons then
            self:addDegree(courses[self.learning].id)
            self.learning = ""
            self.eduLvl = self.eduLvl + 1
            if self.eduLvl == 3 then
                self:addTitle("Dedicated Learner")
            end
        end
        dHandler:set(self.name, "learning", courses[self.learning] and courses[self.learning].id or 0)
        dHandler:set(self.name, "learnProgress", self.learnProgress)
        dHandler:set(self.name, "eduLvl", self.eduLvl)
        dHandler:set(self.name, "eduStream", self.eduStream)
    end
end

function Player:levelUp()
    if self.xp >= calculateXP(self.level + 1) then
        self.level = self.level + 1
        self:setHealth(1.0, false)
        self:setMoney(5 * self.level, true)
        dHandler:set(self.name, "level", self.level)
        displayParticles(self.name, tfm.enum.particle.star)
        self:addTitle("Worker")
        if self.level == 3 then
            self:addTitle("Getting Experience")
        end
    end
end

function Player:useMed(med)
    if not (self.health >= 1) then
        self:setHealth(med.regainVal, med.adding)
        displayParticles(self.name, tfm.enum.particle.heart)
    end
end

function Player:updateStatsBar()
    ui.updateTextArea(10, "<p align='right'>Money: $" .. formatNumber(self.money) .." </p> ", self.name)
    ui.updateTextArea(11, " Level: " .. self.level, self.name)
    ui.updateTextArea(1, "<br><p align='center'><b>" .. self.name .. "</b><br>« " .. self.title .. "»</p>", self.name)
end

function Player:grabItem(item)
    if self.inventory[item] == nil then
        self.inventory[item] = 1
    else
        self.inventory[item] = self.inventory[item] + 1
    end

    for id, value in next, items do
        if item == value then
            self:storeInventory(id, self.inventory[item])
        end
    end
    --dHandler:set(self.name, "inventory", self.inventory)
end

function Player:useItem(item)
    if self.inventory[item] ~= nil then
        self.inventory[item] = self.inventory[item] - 1
        if self.inventory[item] < 1 then
            self.inventory[item] = nil
        end
    end
    for id, value in next, items do
        if item == value then
            self:storeInventory(id, self.inventory[item])
        end
    end
end

function Player:storeInventory(item, amount)
    local inv = dHandler:get(self.name, "inventory")
    local found = false
    for k, data in next, inv do
        if data[1] == item then
            found = true
            if not amount then
                table.remove(inv, k)
            else
                inv[k] = {item, amount}
            end

            break
        end
    end
    if not found then
        table.insert(inv, {item, amount})
    end
    dHandler:set(self.name, "inventory", inv)
end

function Player:buyLottery(choices)
    local invalid = not choices:find("%s*%d+%s+%d+%s+%d+%s+[a-zA-Z]%s*")
    if invalid then
        return tfm.exec.chatMessage('<R>[Error] Invalid input!</R>', self.name)
    end
    choices = map(split(choices:gsub("%s+", " "), " "), function(x)
        if x:find("%d+") then
            local n = tonumber(x)
            if n < 0 or n > 100 then invalid = true end
            return n
        end
        if x:find("[a-zA-Z]") then return x:upper() end
        invalid = true
    end)
    if invalid then
        tfm.exec.chatMessage("<R>[Error] Invalid input!</R>", self.name)
    else
        self:setMoney(-20, true)
        if not lottoBuyers[self.name] then lottoBuyers[self.name] = {} end
        table.insert(lottoBuyers[self.name], choices)
        tfm.exec.chatMessage("<J>Bought a lottery!</J>", self.name)
    end
end

--class creation(Player) ends

--class creation(Company)
local Company = {}
Company.__index = Company
Company.__tostring = function(self)
    return "[name=" .. self.name .. ",owner=" .. self.owner .. "]"
end

setmetatable(Company, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

function Company.new(name, owner)
    local self = setmetatable({}, Company)
    self.name = name
    self.owner = owner
    self.shareholders = {[owner]={capital=5000, shares=1.0}}
    self.totalHolders = 1
    self.capital = 5000
    self.members = {}
    self.totalWorkers = 0
    self.jobs = {}
    self.unownedShares = 0
    self.outstandingShares = 50
    self.incomePerMonth = 0
    self.shareVal = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100}
    self.chartSeries = Series(range(1, 12, 1), self.shareVal, "<a href='event:com:" .. name .. "'>" .. name .. "</a>")
    chart:addSeries(self.chartSeries)
    self.uid = "com:" .. name
    return self
end

function Company:getName() return self.name end
function Company:getOwner() return self.owner end
function Company:getShareHolders() return self.shareholders end
function Company:getMembers() return self.members end
function Company:getJobs() return self.jobs end
function Company:getUID() return self.uid end
function Company:getCapital() return self.capital end
function Company:getChartSeries() return self.chartSeries end
function Company:getUnownedShares() return self.unownedShares end
function Company:getOutstandingShares() return self.outstandingShares end
function Company:getIncomePerMonth() return self.incomePerMonth end

function Company:addMember(name)
    if not self.members[name] then
        self.members[name] = true
        self.totalWorkers = self.totalWorkers + 1
    end
end

function Company:removeMember(name)
    self.members[name] = nil
    self.totalWorkers = self.totalWorkers - 1
end

function Company:addShareHolder(name, inCapital)
    self.capital = self.capital + inCapital
    local newCap = self.shareholders[name] == nil and inCapital or self.shareholders[name].capital + inCapital
    if not self.shareholders[name] then self.totalHolders = self.totalHolders + 1 end
    self.shareholders[name] = {capital=newCap, shares=newCap/self.capital}
    for n, d in next, self.shareholders do
        self.shareholders[n] = {capital=d.capital, shares=d.capital/self.capital}
    end
end

function Company:addCapital(amount)
    self.capital = self.capital + amount
    self.shareVal[month] = self.capital
end

function Company:issueShares(number, auth)
    if self.shareholders[auth] then
        self.unownedShares = self.unownedShares + number
    end
end

function Company:setShares(amount, add, category)
    if category == "outstanding" then
        self.outstandingShares = add and self.outstandingShares + amout or amount
    else
        self.unownedShares = add and self.unownedShares + amount or amount
    end
end

function Company:setIncome(amount, add)
    self.incomePerMonth = add and self.incomePerMonth + amount or amount
end

--class creation(Company) ends

--game functions

function displayShop(target, page)
    local commu = tfm.get.room.playerList[target].community
    local medicTxt = ""
    for id, medic in next, {healthPacks[((page - 1) * 2) + 1], healthPacks[page * 2]} do
        medicTxt = medicTxt .. "<b><font size='13'>" .. medic.name  .. "</font></b><br><p align='right'><VP><a href='event:buy:" .. medic.uid .."'><b>| Buy |</b></a></VP></p>Price: " .. medic.price .. "  Energy: " .. (medic.regainVal * 100) .. "%<br>" .. medic.desc .. "<br><br>"
    end
    ui.addTextArea(100, closeButton .. "<p align='center'><font size='20'><b><J>Shop</J></b></font></p><br></br>" .. (medicTxt == "" and translate("nothing", commu) or medicTxt), target, 200, 90, 400, 200, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
    ui.addTextArea(101, "<p align='center'><a href='event:page:shop:" .. page - 1 .."'>«</a></p>", target, 500, 310, 10, 15, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
    ui.addTextArea(102, "Page " .. page, target, 523, 310, 50, 15, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
    ui.addTextArea(103, "<p align='center'><a href='event:page:shop:" .. page + 1 .."'>»</a></p>", target, 585, 310, 15, 15, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
end

function displayCourses(target)
    local courseTxt = ""
    local p = players[target]
    for id, course in next, courses do
        if p:getEducationLevel() == course.level and (p:getEducationStream() == course.stream or p:getEducationStream() == "") and learning ~= "" then
            courseTxt = courseTxt .. "<b><font size='13'>" .. course.name .. "</font></b><VP><a href='event:" .. course.uid .. "'><b> | Enroll |</b></a></VP><br><font size='10'>(Fee: " .. course.fee .. " Lessons: " .. course.lessons .. ")</font><br>"
        end
    end
    ui.addTextArea(200, closeButton .. "<p align='center'><font size='20'><b><J>Courses</J></b></font></p><br></br>" .. (courseTxt == "" and nothing or courseTxt), target, 200, 90, 400, 200, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
end

function displayJobs(target, page)
    local commu = tfm.get.room.playerList[target].community
    local qualifiedJobTxt = ""
    local disqualifedJobTxt = ""
    local p = players[target]
    local entry = 1
    for key, value in next, getSortedJobList(players[target]) do
        if (page - 1) * 2 + 1 <= entry and entry <= page * 2 then
            if value[2] then
                local job = value[1]
                qualifiedJobTxt = qualifiedJobTxt .. translate("job_qualified", commu, nil, {name = job.name, id = job.name, salary = job.salary, energy = job.energy * 100, owner = job.owner, company = job.company})
            else
                local job = value[1]
                disqualifedJobTxt = disqualifedJobTxt .. translate("job_disqualified", commu, nil, {name = job.name, salary = job.salary, energy = job.energy * 100, owner = job.owner, company = job.company})
                --disqualifedJobTxt = disqualifedJobTxt .. "<N><b><font size='13'>" .. job.name .. " <a href='event:jobInfo:" .. job.name .. "'><BV>ⓘ</BV></a></font></b><br><p align='right'><b><N2>| Choose |</N2></b></p>Salary: " .. job.salary .. " Energy: " .. (job.energy * 100) .. "%<br>Offered by <b>" .. job.owner .. "</b> of <b>" .. job.company .. "</b></N><br><br>"
            end
        elseif entry > page * 2 then
            break
        end
        entry = entry + 1
    end

    local jobTxt = qualifiedJobTxt .. disqualifedJobTxt

    ui.addTextArea(300, closeButton .. "<p align='center'><font size='20'><b><J>Jobs</J></b></font></p><br><br>" .. (jobTxt == "" and translate("nothing", commu) or jobTxt), target, 200, 90, 400, 200, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
    ui.addTextArea(301, "<p align='center'><a href='event:page:jobs:" .. page - 1 .."'>«</a></p>", target, 500, 310, 10, 15, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
    ui.addTextArea(302, "Page " .. page, target, 523, 310, 50, 15, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
    ui.addTextArea(303, "<p align='center'><a href='event:page:jobs:" .. page + 1 .."'>»</a></p>", target, 585, 310, 15, 15, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
end

function displayJobInfo(job, target)
    local job = jobs[job]
    ui.addTextArea(901, "", target, -10000, -10000, 20000, 20000, 0x333333, nil, 0.8, true)
    ui.addTextArea(900, closeButton .. translate("job_info", tfm.get.room.playerList[target].community, nil, {
        name = job.name,
        salary = job.salary,
        energy = job.energy * 100,
        minLevel = job.minLvl,
        qualifications = job.qualifications or "NA",
        owner = job.owner,
        company = job.company
    }), target, 300, 90, 200, 200, CONSTANTS.BACKGROUND_COLOR, nil, 1, true)
end

function displayCompanyDialog(target, page)
    local commu = tfm.get.room.playerList[target].community
    page = page or 1
    eventTextAreaCallback(400, target, "close")
    if not next(players[target]:getOwnedCompanies()) then
        ui.addPopup(400, 1, translate("nocompanies", commu), target, 300, 90, 200, true)
    else
        local companyTxt = ""
        local p = players[target]
        local entry = 1
        for name, company in next, p:getOwnedCompanies() do
            if (page - 1) * 8 + 1 <= entry and entry <= page * 8 then
                companyTxt = companyTxt .. translate("companybrief", commu, nil, {id = company:getUID(), name = company:getName(), ownedShares = math.ceil(company:getShareHolders()[target].shares * 100)})
            elseif entry > page * 8 then
                break
            end
            entry = entry + 1
        end
        ui.addTextArea(400, closeButton .. translate("ownedcompanies", commu) .. companyTxt, target, 200, 90, 400, 200, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
        ui.addTextArea(401, translate("newcompanybtn", commu), target, 500, 305, 100, 20, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
        ui.addTextArea(402, "<p align='center'><a href='event:page:comp:" .. (page - 1) .. "'>«</a></p>", target, 200, 305, 10, 20, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
        ui.addTextArea(403, "Page " .. page, target, 225, 305, 50, 20, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
        ui.addTextArea(404, "<p align='center'><a href='event:page:comp:" .. (page + 1) .. "'>»</a></p>", target, 290, 305, 15, 20, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
    end
end

function displayCompany(name, target)
    local commu = tfm.get.room.playerList[target].community
    if companies[name] ~= nil then
        local com = companies[name]
        local isOwner = false
        tempData[target].jobCompany = name
        local companyTxt = ""
        local members = ""
        ui.addTextArea(400, closeButton .. translate("companyinfo", commu, nil, {name = name, shareholders = com.totalHolders, workers = com.totalWorkers, owner = com:getOwner()}), target, 200, 90, 400, 200, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
        for n, _ in next, com:getShareHolders() do
            if n == target then isOwner = true end
        end
        if isOwner then
            ui.addTextArea(401, "<a href='event:createJob'>Create Job</a>", target, 500, 305, 100, 20, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
            ui.addTextArea(402, "<a href='event:invest:" .. com:getName() .. "'> Invest!</a>", target, 200, 305, 100, 20, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
            ui.addTextArea(403, "<a href='event:issueShares:" .. com:getName() .. "'>Issue Shares</a>", target, 405, 305, 80, 20, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
        end
        ui.addTextArea(404, (com:getUnownedShares() == 0 and "<BL>Buy Shares</BL>" or "<a href='event:buyShares:" .. com:getName() .. "'> Buy Shares <font size='10'>(all: " .. com:getUnownedShares() .. ")</font></a>"), target, 315, 305, isOwner and 80 or 170, 20, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
    else
        ui.addPopup(404, 0, "<p align='center'><b><font color='#CB546B'>Company doesn't exist!", target, 300, 90, 200, true)
    end
end

function displayCompanyOwners(comp, target, page)
    local entry = 1
    local res = ""
    for name, data in next, companies[comp]:getShareHolders() do
        if (page - 1) * 6 + 1 <= entry and entry <= page * 6 then
            res = res .. "<b><a href='event:profile:" .. name .. "'>" .. name .. "</a></b> <i>(Owns " .. math.ceil(data.shares * 100) .. "%)</i><br>"
        elseif entry > page * 6 then
            break
        end
        entry = entry + 1
    end
    ui.addTextArea(450, closeButton .. "<p align='center'><font size='20'><b><J>Shareholders of " .. comp .. "</J></b></font></p><br><br><b>Total: </b>" .. companies[comp].totalHolders .. "<br><br>" .. res, target, 200, 90, 400, 200, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
    ui.addTextArea(451, "<p align='center'><a href='event:page:owners" .. comp .. ":" .. page - 1 .."'>«</a></p>", target, 500, 310, 10, 15, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
    ui.addTextArea(452, "Page " .. page, target, 523, 310, 50, 15, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
    ui.addTextArea(453, "<p align='center'><a href='event:page:owners" .. comp .. ":" .. page + 1 .."'>»</a></p>", target, 585, 310, 15, 15, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
end

function displayCompanyMembers(comp, target, page)
    local entry = 1
    local res = ""
    for name, data in next, companies[comp]:getMembers() do
        if (page - 1) * 6 + 1 <= entry and entry <= page * 6 then
            res = res .. "<b><a href='event:profile:" .. name .. "'>" .. name .. "</a></b>   <i>(" .. players[name]:getJob() .. ")</i><br>"
        elseif entry > page * 6 then
            break
        end
    end
    entry = entry + 1
    ui.addTextArea(460, closeButton .. "<p align='center'><font size='20'><b><J>Workers of " .. comp .. "</J></b></font></p><br><br><b>Total: </b>" .. companies[comp].totalWorkers .. "<br><br>" .. res, target, 200, 90, 400, 200, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
    ui.addTextArea(461, "<p align='center'><a href='event:page:owners" .. comp .. ":" .. page - 1 .."'>«</a></p>", target, 500, 310, 10, 15, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
    ui.addTextArea(462, "Page " .. page, target, 523, 310, 50, 15, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
    ui.addTextArea(463, "<p align='center'><a href='event:page:owners" .. comp .. ":" .. page + 1 .."'>»</a></p>", target, 585, 310, 15, 15, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
end

function displayJobWizard(target)
    ui.addTextArea(500, closeButton .. [[<p align='center'><font size='20'><b><J>Job Wizard</J></b></font></p><br><br>
    <b>Job Name: </b><a href='event:selectJobName'>]] ..  (tempData[target].jobName == nil and "Select" or tempData[target].jobName) .. [[</a>
    <b>Salary: </b><a href='event:selectJobSalary'> ]] .. (tempData[target].jobSalary == nil and "Select" or tempData[target].jobSalary) .. [[</a>
    <b>Energy: </b><a href='event:selectJobEnergy'> ]] .. (tempData[target].jobEnergy == nil and "Select" or tempData[target].jobEnergy .. "%") .. [[</a>
    <b>Minimum Level: </b><a href='event:chooseJobMinLvl'>]] .. (tempData[target].minLvl == nil and "Select" or tempData[target].minLvl) .. [[</a>
    <b>Qualifcations: </b><a href='event:chooseJobDegree'>]] .. (tempData[target].qualification == nil and "Select" or tempData[target].qualification) .. [[</a><br>
    ]], target, 200, 90, 400, 200, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
end

function displayAllDegrees(target)
    local degreeTxt = ""
    for k, v in next, courses do
        degreeTxt = degreeTxt .. "<a href='event:degree:" .. v.name .. "'>" .. v.name .. "</a><br>"
    end
    ui.addTextArea(600, closeButton .. "<p align='center'><font size='20'><b><J>Choose a Degree</J></b></font></p>" .. degreeTxt, target, 200, 90, 400, 200, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
end

function displayInventory(target)
    local commu = tfm.get.room.playerList[target].community
    local invTxt = ""
    for k, v in next, players[target]:getInventory() do
        invTxt = invTxt .. "<b><font size='12'>".. k .. "</font><a href='event:use:" .. k .."'><VP> | Use x" .. v .. " |</VP> </a></b> : <font size='10'>(Energy: " .. (find(k, healthPacks).regainVal * 100) .. "%)</font><br>"
    end
    ui.addTextArea(700, closeButton .. "<p align='center'><font size='20'><b><J>Inventory</J></b></font></p><br>" .. (invTxt == "" and translate("nothing", commu) or invTxt), target, 200, 90, 400, 200, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
end

function displayTips(target)
    local commu = tfm.get.room.playerList[target].community
    ui.addTextArea(800, closeButton .. "<p align='center'><J><b>Tips!</b></J><br><br>" .. translate("tips", commu, 1), target, 6, 120, 120, 150, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
    ui.addTextArea(801, "«", target, 10, 285, 10, 15, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
    ui.addTextArea(802, "Page 1", target, 35, 285, 50, 15, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
    ui.addTextArea(803, "<p align='center'><a href='event:page:tip:2'>»</a></p>", target, 100, 285, 15, 15, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
end

function displayProfile(name, target)
    local commu = tfm.get.room.playerList[target].community
    local up = upper(name)
    local p = players[name] or players[up] or players[up .. "#0000"] or players[target]
print(p.job)
    if p then
        ui.addTextArea(901, "", target, -10000, -10000, 20000, 20000, 0x333333, nil, 0.8, true)
        ui.addTextArea(900, closeButton .. translate("profile", commu, nil, {name = p.name, title = p.title, level = p.level, xp = p.xp, xpTotal = calculateXP(p.level + 1), learning = p:getLearningCourse() == "" and "NA" or p:getLearningCourse(), job = p.job, money = formatNumber(p.money)}), 
        target, 300, 100, 200, 140, CONSTANTS.BACKGROUND_COLOR, 0, 1, true)
    end
end

function displayHelp(target, mode, page)
    local commu = tfm.get.room.playerList[target].community
    handleSpecialCloseButton(5000, target)
    ui.addTextArea(5001, "<B><J><a href='event:cmds'>Commands</a>", target, 30, 120, 75, 20, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
    ui.addTextArea(5002, "<a href='event:game'><B><J>Gameplay", target, 30, 85, 75, 20, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
    ui.addTextArea(5003, "<B><J><a href='event:credits'>Credits</a>", target, 30, 155, 75, 20, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
    ui.addTextArea(5000, closeButton .. (mode == "game" and translate("help", commu, page or 1) or (mode == "credits" and translate("credits", commu) or translate("commands", commu))), target, 110, 80, 650, 200, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
    if mode == "game" then
        ui.addTextArea(5004, "«",  target, 630, 300, 15, 15, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
        ui.addTextArea(5005, "Page 1", target, 660, 300, 50, 15, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
        ui.addTextArea(5006, "<a href='event:page:help:2'>»</a></p>", target, 725, 300, 15, 15, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
    end
end


function displayLeaderboard(target, mode, page)
    page = page or 1
    local temp = "<p align='center'><font size='12'><D>"
    local ranks, names, money, level, community = 
        temp .. "<b>#</b><br></D><font size='10'><b>",
        temp .. "<b>Name</b><br></D><font size='10'><b>",
        temp .. "<b>Money</b><br></D><font size='10'><b>",
        temp .. "<b>Level</b><br></D><font size='10'><b>",
        temp .. "<b>Commu</b><br></D><font size='10'><b>"
    if mode == "room" then    
        handleSpecialCloseButton(5000, target)
        local top = getTopPlayers((page - 1) * 10 + 1, page * 10)
        specialUIS = specialUIS + 1
        specialCloseSequence[5000 .. target] = {}
        local entry = 1
        for k, data in next, top do
            local p = players[data.name]
            ranks = ranks .. "# " .. data.rank .. "<br>"
            names = names .. "<a href='event:profile:" .. data.name .. "'>" .. data.name .. "</a><br>"
            money = money .. "$" .. formatNumber(p.money) .. "<br>"
            level = level .. "Level " .. p.level .. "<br>"
            specialCloseSequence[5000 .. target][entry] = tfm.exec.addImage(communityFlags[tfm.get.room.playerList[data.name].community], "&1", 710, 150 + ((entry - 1) * 12), target)
            entry = entry + 1
        end
    elseif mode == "global" then
        return tfm.exec.chatMessage("<R>Leaderboard is closed temporarily for some bug fixes...</R>", target)
        --[[if #leaderboard == 0 then
            return tfm.exec.chatMessage("<R>Leaderboard not loaded yet, please wait few minutes!</R>", target)
        end
        for i = (page - 1) * 10 + 1, page * 10 do
            ranks = ranks .. "# " .. i .. "<br>"
            names = names .. leaderboard[i].name .. "<br>" 
            money = money .. "$" .. formatNumber(leaderboard[i].money) .. "<br>"
            level = level .. "Level " .. leaderboard[i].lvl .. "<br>"
            community = community .. leaderboard[i].commu .. "<br>"
        end]]
    end
    ui.addTextArea(5001, "<B><J><a href='event:room-lboard'>Room</a>", target, 30, 120, 75, 20, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
    ui.addTextArea(5002, "<B><J><a href='event:g-lboard'>Global</a>", target, 30, 85, 75, 20, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)

    ui.addTextArea(5000, specialCloseButton .. "<p align='center'><b><font size='20'><J>Leaderboard</J></font><br>", target, 110, 80, 650, 200, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
    ui.addTextArea(5003, ranks, target, 125, 130, 40, 140, CONSTANTS.BORDER_COLOR, CONSTANTS.BORDER_COLOR, 1, true) --155
    ui.addTextArea(5004, names, target, 180, 130, 200, 140, CONSTANTS.BORDER_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
    ui.addTextArea(5005, money, target, 395, 130, 180, 140, CONSTANTS.BORDER_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
    ui.addTextArea(5006, level, target, 590, 130, 80, 140, CONSTANTS.BORDER_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
    ui.addTextArea(5007, community, target, 685, 130, 60, 140, CONSTANTS.BORDER_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
    ui.addTextArea(5008, "<a href='event:page:" .. mode .. "lboard:" .. (page - 1) .. "'>«</a>" ,  target, 630, 300, 15, 15, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
    ui.addTextArea(5009, "<p align='center'>Page " .. page, target, 660, 300, 50, 15, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
    ui.addTextArea(5010, "<a href='event:page:" .. mode .. "lboard:" .. (page + 1) .. "'>»</a></p>", target, 725, 300, 15, 15, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
end

function displayVersionDialogue(target)
    ui.addTextArea(50001, "", target, -10000, -10000, 20000, 20000, 0x333333, nil, 0.8, true)
    ui.addTextArea(50000, closeButton .. "<p align='center'><font size='18'><b><VP>" .. VERSION .. "</VP> - " .. VERSION_TEXT .. "</b></font></p><br><br><font size='12'>" .. VERSION_DESCRIPTION .. "</font>", target, 50, 50, 700, 250, CONSTANTS.BACKGROUND_COLOR, 0, 1, true)
end

function displayTitleList(target)
    local titleTxt = "Listing owned titles. Use !title NEW_TITLE to set a new title."
    for id, title in next, players[target]:getTitles() do
        titleTxt = titleTxt .. "\n« " .. titles[title] .. " »"
    end
    tfm.exec.chatMessage(titleTxt, target)
end

function displayLotto(target)
    local commu = tfm.get.room.playerList[target].community
    local txt = translate("lottoinfo", commu) .. ((#latestLotto == 0) and translate("nodrawings", commu) or latestLotto[1] .. ", " .. latestLotto[2] ..  ", " .. latestLotto[3] .. ", " .. latestLotto[4]) .. "<br><br>"
    txt = txt .. ((lottoWins[target] == nil or lottoWins[target] == 0) and translate("lottonowin", commu) or translate("lottowin", commu, nil, lottoWins[target])) .. "</p>"
    ui.addTextArea(4000, closeButton .. txt, target, 200, 90, 400, 200, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
end

function calculateXP(lvl)
    return 2.5 * (lvl + 2) * (lvl - 1)
end

function getMaxSalary(comp)
    local max = companies[comp]:getCapital() * 0.04
    return (max > 10000000 or max < 0 --[[probably integer overloads]]) and 10000000 or max
end

function displayParticles(target, particle)
    tfm.exec.displayParticle(particle, tfm.get.room.playerList[target].x, tfm.get.room.playerList[target].y, 0, -2, 0, 0, nil)
    tfm.exec.displayParticle(particle, tfm.get.room.playerList[target].x - 10, tfm.get.room.playerList[target].y, 0, -3, 0, 0, nil)
    tfm.exec.displayParticle(particle, tfm.get.room.playerList[target].x + 10, tfm.get.room.playerList[target].y, 0, -2, 0, 0, nil)
    tfm.exec.displayParticle(particle, tfm.get.room.playerList[target].x + math.random(-15, 15) , tfm.get.room.playerList[target].y, 0, -1, 0, 0, nil)
end

function isQualified(p, job)
    return p:getLevel() >= job.minLvl and (job.qualifications == nil or find(courses[job.qualifications].id, p:getDegrees(), true) ~= nil)
end

function getSortedJobList(p)
    local qJobs = {}
    for id, job in next, jobs do
        if isQualified(p, job) then
            table.insert(qJobs, 1, {job, true})
        else
            table.insert(qJobs, {job, false})
        end
    end
    return qJobs
end

function find(name, tbl, normalLists)
    if not normalLists then
        for k,v in ipairs(tbl) do
            if (v.name == name) then
                return v
            end
        end
    else
        for k, v in next, tbl do
            if v == name then
                return k
            end
        end
    end
    return nil
end

function checkLottoWinners(p)
    if p then
        return lottoWins[p]
    end
    lottoWins = {}
    for name, lottos in next, lottoBuyers do
        local wins = 0
        for _, lotto in next, lottos do
            wins = wins + getWinPrice(lotto)
        end
        lottoWins[name] = wins
    end
end

function getWinPrice(lotto)
    local wins = 0
    if latestLotto[1] == lotto[1] and latestLotto[2] == lotto[2] and latestLotto[3] == lotto[3] and latestLotto[4] == lotto[4] then
        return 100000
    elseif (latestLotto[1] == lotto[1] and latestLotto[2] == lotto[2]) or (latestLotto[2] == lotto[2] and latestLotto[3] == lotto[3]) or (latestLotto[1] == lotto[1] and latestLotto[3] == lotto[3]) then
        wins = 5000
    elseif (latestLotto[4] == lotto[4]) then
        return wins + 1000
    end
    return wins
end

function getBestParamsJobs(type, val--[[salary, energy, minLvl, eduLvl]], tempData)
    --[[TODO: Refactor this function]]
	if type == "salary" then
		local salary = val
		local minLvl = tempData.minLvl or 1
		local eduLvl = tempData.eduLvl or 0
		local energy = math.ceil(val / getMaxSalary(tempData.jobCompany) * 100)
        energy =  energy - minLvl - eduLvl * 2
		energy = energy < 5 and 5 or energy
		return salary, energy, minLvl, eduLvl
	elseif type == "energy" then
		local energy = val or 5
		local minLvl = 1
		local eduLvl = 0
		local e = energy - minLvl - eduLvl * 2
		local salary = e * getMaxSalary(tempData.jobCompany) / 100
		return salary, energy, minLvl, eduLvl
	end
end


--[[copied from stackoverflow
  Credits: https://stackoverflow.com/users/1514861/ivo-beckers
  Question: https://stackoverflow.com/questions/1426954/split-string-in-lua
]]
function split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

function table.tostring(tbl, depth)
    local res = "{"
    local prev = 0
    for k, v in next, tbl do
        if type(v) == "table" then
            if depth == nil or depth > 0 then
                res =
                    res ..
                    ((type(k) == "number" and prev and prev + 1 == k) and "" or k .. ": ") ..
                        table.tostring(v, depth and depth - 1 or nil) .. ", "
            else
                res = res .. k .. ":  {...}, "
            end
        else
            res = res .. ((type(k) == "number" and prev and prev + 1 == k) and "" or k .. ": ") .. tostring(v) .. ", "
        end
        prev = type(k) == "number" and k or nil
    end
    return res:sub(1, res:len() - 2) .. "}"
end

function float(n, digits)
	digits = digits or 1
	return math.ceil(n * 10^digits) / 10^digits
end

function formatNumber(n)
    if n >= 10e14 then
        return float(math.floor(n / 10e14),1) .. "P"
    elseif n >= 10e11 then
        return float(math.floor(n / 10e11),1) .. "T"
    elseif n >= 10e8 then
        return float(math.floor(n / 10e8),1) .. "B"
    elseif n >= 10e5 then
        return float(math.floor(n / 10e5),1) .. "M"
    elseif n >= 10e3 then
        return float(math.floor(n / 10e2),1) .. "K"
    end
    return float(n, 1)
end

function upper(str)
	return string.upper(string.sub(str,1,1)) .. string.lower(string.sub(str,2))
end


function getTopCompanies(upto)
    --eww refactor these functions
    local temp = {}
    for name, data in next, companies do
        temp[#temp + 1] = {name, data.incomePerMonth / data.outstandingShares + 100}
    end

    table.sort(temp, function(e1, e2)
        return e1[2] > e2[2]
    end)

    if not upto then return temp end
    local top = {}
    for i=1, upto, 1 do
        if temp[i] then
            top[#top + 1] = {temp[i][1], temp[i][2]}
        end
    end
    return top
end

function getTopPlayers(from, to)
    --eww refactor these functions
    local temp = {}
    for name, data in next, players do
        if name ~= "shaman" then
            temp[#temp + 1] = {name, data.money}
        end
    end

    table.sort(temp, function(e1, e2)
        return e1[2] > e2[2]
    end)

    local res = {}
    for i = from, to, 1 do
        if temp[i] then
            res[#res + 1] = {name = temp[i][1], rank = i}
        end
    end
    return res
end

function getTotalPages(type, target)
    if type == 'tip' then
        return #translations.en.tips
    elseif type == 'shop' then
        return #healthPacks / 2 + (#healthPacks % 2)
    elseif type == 'jobs' then
        return totalJobs / 2 + (totalJobs % 2)
    elseif type == 'help' then
        return #translations.en.help
    elseif type == 'comp' then
        return math.ceil(players[target].totalCompanies / 8)
    elseif type == "roomlboard" then
        return math.ceil(Player._total / 10)
    elseif type == "globallboard" then
        return 5
    elseif type:find("^owners") then
        return math.ceil(companies[type:sub(7)].totalHolders / 6)
    elseif type:find("^workers") then
        return math.ceil(companies[type:sub(8)].totalWorkers / 6)
    end
    return 0
end

function updatePages(name, type, page)
    local commu = tfm.get.room.playerList[name].community
    if not (page < 1 or page > getTotalPages(type, name)) then
        if type == 'tip' then
            ui.updateTextArea(800, closeButton .. "<p align='center'><J><b>Tips!</b></J><br><br>" .. translate("tips", commu, page), name)
            ui.updateTextArea(801, "<a href='event:page:tip:" .. (page - 1) .. "'>«</a>", name)
            ui.updateTextArea(802, "<p align='center'>Page " .. page .. "</p>", name)
            ui.updateTextArea(803, "<a href='event:page:tip:" .. (page + 1) .. "'>»</a>", name)
        elseif type == 'help' then
            ui.updateTextArea(5000, closeButton .. translate("help", commu, page), name)
            ui.updateTextArea(5004, "<a href='event:page:help:" .. (page - 1) .. "'>«</a>",  name)
            ui.updateTextArea(5005, "<p align='center'>Page " .. page .. "</p>", name)
            ui.updateTextArea(5006, "<a href='event:page:help:" .. (page + 1) .. "'>»</a>", name)
        elseif type == 'shop' then
            displayShop(name, page)
        elseif type == 'jobs' then
            displayJobs(name, page)
        elseif type == 'comp' then
            displayCompanyDialog(name, page)
        elseif type == "roomlboard" then
            displayLeaderboard(name, "room", page)
        elseif type == "globallboard" then
            displayLeaderboard(name, "global", page)
        elseif type:find("owners.+") then
            displayCompanyOwners(type:sub(7), name, page)
        elseif type:find("workers.+") then
            displayCompanyMembers(type:sub(8), name, page)
        end
    end
end

function handleCloseButton(id, name)
    if closeSequence[id] then
        for _, subId in next, closeSequence[id] do
            ui.removeTextArea(subId, name)
        end
    end
end

function handleSpecialCloseButton(id, name)
    handleCloseButton(id, name)
    for _, imgId in next, (specialCloseSequence[id .. tostring(name)] or {}) do
        tfm.exec.removeImage(imgId)
    end
end

function parseLeaderboardData(chunk)
    local entries = split(chunk, "|")
    local least = tonumber(entries[1])
    local leaderboard = {}
    local leaders = {} -- cached leaders to improve performance later
    for i = 2, #entries do
        local fieldVals = split(entries[i], ",")
        leaderboard[#leaderboard + 1] = {name = fieldVals[1], money = tonumber(fieldVals[2]), lvl = fieldVals[3], commu = fieldVals[4]}
        leaders[fieldVals[1]] = #leaderboard
    end
    return leaderboard, leaders, least
end

function dumpLeaderboardData(data, least)
    local res = least
    for rank, data in next, data do
        res = res .. "|" .. data.name .. "," .. data.money .. "," .. data.lvl .. "," .. data.commu
    end
    return res
end

function saveData(force)
    print("[Stats] Attempting to save data (Players: " .. tfm.get.room.uniquePlayers .. " / 5)")
    --system.loadFile(0) -- requesting leaderboard data
    if force or tfm.get.room.uniquePlayers >= 5 then
        -- saving player data
        for name, _ in next, tfm.get.room.playerList do
            system.savePlayerData(name, "v2" .. dHandler:dumpPlayer(name))
        end
        print('[Stats] Player Data Saved!')
    end
end

function translate(term, lang, page, kwargs)
    local translation = translations[lang] and translations[lang][term] or translations.en[term]
    return format((page and translation[page] or translation), kwargs)
end

function HealthPack(_name, _price, _regainVal, _adding, _desc)
    return {
        name = _name,
        price = _price,
        regainVal = _regainVal,
        adding = _adding,
        uid = "health:" .. _name,
        desc = _desc
    }
end

function Course(_id, _name, _fee, _lessons, _level, _stream)
    return {
        id = _id,
        name = _name,
        fee = _fee,
        lessons = _lessons,
        level = _level,
        stream = _stream,
        feePerLesson = _fee / _lessons,
        uid = "course:" .. _name
    }
end

function Job(_name, _salary, _energy, _minLvl, _qualifications, _owner, _company)
    totalJobs = totalJobs + 1
    return {
        name = _name,
        salary = _salary,
        energy = _energy,
        minLvl = _minLvl,
        qualifications = _qualifications,
        owner = _owner,
        company = _company,
        uid = "job:" .. _name
    }
end

function setUI(name)
    local p = players[name]
    local commu = tfm.get.room.playerList[name].community
    ui.setMapName("Merchant")
    --textAreas and images
    --work
    tfm.exec.addImage("16f88de3629.png", ":10", 2, 333)
    ui.addTextArea(0, "<a href='event:work'>\t<br><p align='center'><b><font size='16' color='#000000'>Work!</font></b></p><br>\t<br>\t", name, 3, 338, 60, 60, nil, nil, 0, true)
    --stats
    ui.addTextArea(10, "<p align='right'>Money: " .. formatNumber(p:getMoney()) .. " </p> ", name, 200, 25, 120, 20, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
    ui.addTextArea(11, " Level: " .. p:getLevel(), name, 480, 25, 120, 20, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true)
    ui.addTextArea(1, "<br><p align='center'><b>" .. name .. "</b><br>« " .. p:getTitle() .. " »</p>", name, 325, 20, 150, 45, CONSTANTS.BACKGROUND_COLOR, CONSTANTS.BORDER_COLOR, 1, true )
    --health bar area
    ui.addTextArea(2, "<p align='center'>100%</p>", name, CONSTANTS.BAR_X, 340, CONSTANTS.BAR_WIDTH, 20, nil, nil, 0.5, true)
    --xp bar area
    ui.addTextArea(3, "<p align='center'>Level " .. p:getLevel() .. "  -  " .. p:getXP() .. "/" .. calculateXP(p:getLevel() + 1) .. "XP</p>", name, CONSTANTS.BAR_X, 370, CONSTANTS.BAR_WIDTH, 20, nil, nil, 0.5, true)
    --shop button
    ui.addTextArea(4, "<a href='event:shop'><b><font color='#000000' size='15'>Shop</font></b></a>", name, 100, 230, 50, 40, nil, nil, 0, false)
    --school button
    ui.addTextArea(5, "<a href='event:courses'><font size='15'><b>Enter</b></font></a>", name, 600, 270, 60, 20, nil, nil, 0, false)
    if not p.learning == "" then
		ui.addTextArea(3000, "<font color = '#ffffff'><p align='center'><b>Lessons Learned: " .. p:getLearningProgress() .." / " .. courses[p.learning].lessons .. "</b></p>", name, 480, 180, 300, 20, nil, nil, 0, false)
    end
    --jobs button
    tfm.exec.addImage("16f88c66ed1.png", ":10", 620, 30) -- Job search image by Freepik in 'Flaticon.com'
    ui.addTextArea(6, "<a href='event:jobs'>\t\n\t\n\t\n</a>", name, 620, 30, 30, 30, nil, nil, 0, true)
    --Company button
    tfm.exec.addImage("16f88b93d41.png", ":10", 660, 30) -- Company buildings images by Freepik in 'Flaticon.com'
    ui.addTextArea(7, "<a href='event:company'>\t\n\t\n\t\n</a>", name, 660, 30, 30, 30, nil, nil, 0, true)
    --Tips buton
    tfm.exec.addImage("16f88aaf19f.png", ":10", 110, 25) --Idea bulb image by Vectors Market in 'flaticon.com'
    ui.addTextArea(8, "<a href='event:tips'>\t\n\t\n\t\n</a>", name, 110, 25, 30, 30, nil, nil, 0, true)
    --Inventory button
    tfm.exec.addImage("16f83fc33be.png", ":10", 150, 25) -- Bag image (icon made by Payungkead in 'flaticon.com')
    ui.addTextArea(9, "<a href='event:inv'>\t\n\t\n\t\n", name, 150, 25, 30, 30, nil, nil, 0, true)
    --Clock interface
    ui.addTextArea(12, "<p align='center'><font color='#ffffff'><b>" .. months[month] .. " " .. day .. "<br>YR " .. year .. "</p>", name, 288, 180, 100, 100, nil, nil, 0, false)
    --Lottery board
    tfm.exec.addImage("171ab7d78ec.png", "_50", 1510, 222)
    ui.addTextArea(13, translate("lotto", commu), name, 1525, 240, 70, 70, nil, nil, 0, false)
    --Version text
    ui.addTextArea(14, "<font color='#333333'><b><a href='event:version'>" .. VERSION .."</a></b></font>", name, 720, 315, 50, 20, nil, nil, 0, true)
    p:setXP(0, true)
    tfm.exec.addImage("16f2831a4b1.png", "_10", 60, 210) -- Shop image
    tfm.exec.addImage("16f285ae02c.png", "_18", 500, 100) -- School image (icon made by Dinosoft labs in 'flaticon.com')
    tfm.exec.addImage("16f3176f389.png", "_50", 1450, 260)-- Slot machine image (Icons made byNikita Golubev in flaticon.com)
    LineChart.init()
    chart:showLabels()
    chart:setShowDataPoints(true)
    chart:show()
    tfm.exec.chatMessage(translate("welcome", commu, nil), name)
end

--event handling

function eventNewPlayer(name)
    tfm.exec.respawnPlayer(name)
    if not players[name] then
        system.loadPlayerData(name)
    else
        setUI(name)
        players[name]:setJob("Cheese collector")
    end
    for _, key in next, ({72, 76}) do
        system.bindKeyboard(name, key, true, true)
    end
end

function eventPlayerLeft(name)
    if tfm.get.room.uniquePlayers < 5 then
        tfm.exec.chatMessage("You need atleast 5 players to save stats")
    else
        system.savePlayerData(name, "v2" .. dHandler:dumpPlayer(name))
    end
end

function eventPlayerDataLoaded(name, data)
    print("Loaded player data (" .. name .. ")")-- .. data)
    if data:find("^v2") then
        dHandler:newPlayer(name, data:sub(3))
    else
        system.savePlayerData(name, "")
        dHandler:newPlayer(name, "")
    end

    local inv = {}
    for _, data in next, dHandler:get(name, "inventory") do
        inv[items[data[1]]] = data[2]
    end

    players[name] = Player(name, {
        money = dHandler:get(name, "money"),
        title = titles[dHandler:get(name, "title")],
        titles = dHandler:get(name, "titles"),
        xp = dHandler:get(name, "xp"),
        level = dHandler:get(name, "level"),
        learning = coursesHelper[dHandler:get(name, "learning")],
        learnProgress = dHandler:get(name, "learnProgress"),
        eduLvl = dHandler:get(name, "eduLvl"),
        eduStream = dHandler:get(name, "eduStream"),
        degrees = dHandler:get(name, "degrees"),
        inventory = inv
    })
    tempData[name] = {}
    setUI(name)
    players[name]:setJob("Cheese collector")
end

function eventFileLoaded(id, chunk)
    -- writing crappy codes since the start of this module /shrug
    print("[Stats] File loaded")
    if id == "0" then -- merchant leaderboard data
        print("[Stats] Leaderboard data loaded")
        local lboard, leaders, least = parseLeaderboardData(chunk)
        if tfm.get.room.uniquePlayers >= 5 then
            print("Saving data")
            local updated = false
            for name, player in next, players do
                if name ~= "shaman" and player.money > least then
                    if leaders[name] then
                        lboard[leaders[name]] = {name = name, money = math.floor(player.money), lvl = player.level, commu = tfm.get.room.playerList[name].community}
                    else
                        lboard[#lboard] = {name = name, money = math.floor(player.money), lvl = player.level, commu = tfm.get.room.playerList[name].community}
                    end
                    table.sort(lboard, function(p1, p2)
                        return p1.money > p2.money
                    end)
                    updated = true              
                end
            end
            if updated then
                least = lboard[#lboard].money
                system.saveFile(dumpLeaderboardData(lboard, least), 0)
            end
        end
        leaderboard = lboard
    end
end

function eventFileSaved(id)
    if id == "0" then
        tfm.exec.chatMessage("Leaderboard updated!")
    end
end

function eventPlayerDied(name)
    tfm.exec.respawnPlayer(name)
end

function eventTextAreaCallback(id, name, evt)
    LineChart.handleClick(id, name, evt)
    local commu = tfm.get.room.playerList[name].community
    if evt == "work" then
        players[name]:work()
    elseif evt == "tips" then
        displayTips(name)
    elseif evt == "version" then
        displayVersionDialogue(name)
    elseif evt == "cmds" then
        displayHelp(name, "cmds")
    elseif evt == "game" then
        displayHelp(name, "game")
    elseif evt == "credits" then
        displayHelp(name, "credits")
    elseif string.sub(evt, 1, 4) == "page" then
        local args = split(evt, ":")
        updatePages(name, args[2], tonumber(args[3]))
    elseif evt == "shop" then
        displayShop(name, 1)
    elseif evt == "courses" then
        if players[name]:getLearningCourse() == "" then
            displayCourses(name)
        else
            players[name]:learn()
        end
    elseif evt == "jobs" then
        displayJobs(name, 1)
    elseif evt == "inv" then
        displayInventory(name)
    elseif evt == "close" then
        ui.removeTextArea(id, name)
        handleCloseButton(id, name)
    elseif evt == "specialclose" then
        ui.removeTextArea(id, name)
        handleSpecialCloseButton(id, name)
    elseif evt == "help:icons" then
        ui.updateTextArea(5000, translate("help", commu, "iconProviders"), name)
    elseif evt == "company" then
        displayCompanyDialog(name)
    elseif evt == "createJob" then
        if tempData[name].jobName == nil or tempData[name].jobSalary == nil or tempData[name].jobEnergy == nil or tempData[name].minLvl == nil then
            displayJobWizard(name)
        else
            local tempCompany = tempData[name].jobCompany
            jobs[tempData[name].jobName] = Job(tempData[name].jobName, tempData[name].jobSalary, tempData[name].jobEnergy / 100, tempData[name].minLvl, tempData[name].qualification, name, tempData[name].jobCompany)
            tfm.exec.chatMessage("<J>Successfully created the job <b>" .. tempData[name].jobName .. "</b></J>", name)
            tempData[name] = {jobCompany = tempCompany}
            ui.removeTextArea(500, name)
        end
    elseif evt == "createCompany" then
        ui.addPopup(400, 1, translate("newcompany2", commu), name, 300, 90, 200, true)
    elseif evt == "selectJobName" then
        ui.addPopup(601, 2, "<p align='center'>Please choose a name", name, 300, 90, 200, true)
    elseif evt == "selectJobSalary" then
        ui.addPopup(602, 2, "<p align='center'>Please choose the salary (<i>Should be a number lesser than " .. getMaxSalary(tempData[name].jobCompany) .."</i>)", name, 300, 90, 200, true)
    elseif evt == "selectJobEnergy" then
        ui.addPopup(603, 2, "<p align='center'>Please select the energy (<i>Should be a number in range 0 - 100</i>)", name, 300, 90, 200, true)
    elseif evt == "chooseJobMinLvl" then
        ui.addPopup(604, 2, "<p align='center'>Please select the minimum level (<i>Should be a number</i>", name, 300, 90, 200, true)
    elseif evt == "chooseJobDegree" then
        displayAllDegrees(name)
    elseif evt == "getLottery" then
        ui.addPopup(1000, 2, translate("lottobuy", commu), name, 300, 90, 200, true)
    elseif evt == "checkLotto" then
        displayLotto(name)
    elseif evt == "room-lboard" then
        displayLeaderboard(name, "room")
    elseif evt == "g-lboard" then
        displayLeaderboard(name, "global")
    elseif evt:gmatch("%w+:%w+") then
        local type = split(evt, ":")[1]
        local val = split(evt, ":")[2]
        if type == "buy" and players[name]:getMoney() - find(split(evt, ":")[3], healthPacks).price >= 0 then
            local pack = find(split(evt, ":")[3], healthPacks)
            players[name]:setMoney(-pack.price, true)
            players[name]:grabItem(pack.name)
        elseif type == "course" then
            players[name]:setCourse(courses[val])
            ui.removeTextArea(id, name)
        elseif type == "job" then
            players[name]:setJob(val)
            eventTextAreaCallback(id, name, "close")
        elseif type == "com" then
            displayCompany(val, name)
        elseif type == "degree" then
			tempData[name].qualification = val
			tempData[name].eduLvl = courses[val].level
			salary, energy = getBestParamsJobs("salary", tempData[name].jobSalary or 1, tempData[name])
            tempData[name].jobEnergy = energy
			tempData[name].jobSalary = salary
            ui.removeTextArea(id, name)
            displayJobWizard(name)
        elseif type == "use" then
            players[name]:useItem(val)
            players[name]:useMed(find(val, healthPacks))
            displayInventory(name)
        elseif type == "invest" then
            ui.addPopup(700, 2, "Please enter the amount to invest. (Should be a valid number)", name, 300, 90, 200, true)
            tempData[name].investing = val
        elseif type == "buyShares" then
            local comp = companies[val]
            ui.addPopup(800, 2, "This company issues " .. comp:getUnownedShares() .. " shares.<br>Enter the amount you want to purchase (1 share = $100)", name, 300, 90, 200, true)
            tempData[name].investing = val
        elseif type == "issueShares" then
            ui.addPopup(900, 2, "Please specify the number of shares you want to issue (Should be a valid number)", name, 300, 90, 200, true)
            tempData[name].issuesSharesIn = val
        elseif type == "profile" then
            displayProfile(val, name)
        elseif type == "jobInfo" then
            displayJobInfo(val, name)
        end
    end
end

function eventPopupAnswer(id, name, answer)
    local commu = tfm.get.room.playerList[name].commu
    if id == 400 and answer == 'yes' then --for the popup creating a compnay
        if players[name]:getMoney() < 5000 then
        ui.addPopup(450, 0, "<p align='center'><b><font color='#CB546B'>Not enough money!", name, 300, 90, 200, true)
    else
        ui.addPopup(450, 2, translate("companycreate", commu), name, 300, 90, 200, true)
    end
    elseif id == 450 and answer ~= '' then --for the popup to submit a name for the company
        if companies[answer] then
            tfm.exec.chatMessage('<R>[Error] Company already exists!</R>', name)
            return
        elseif answer:len() > 15 or answer:find("[^%w%s]") then
            tfm.exec.chatMessage('<R>[Error] Name should contain only letters, numbers and spaces, which is lesser than 15 characters</R>', name)
            return
        end
        companies[answer] = Company(answer, name)
        players[name]:setMoney(-5000, true)
        players[name]:addOwnedCompanies(answer)
        displayCompany(answer, name)
        tfm.exec.chatMessage(translate("newcompany", commu, nil, {company=answer}), name)
    elseif id == 601 and answer ~= '' then --for the popup to submit the name for a new job
        if answer:len() > 15 or answer:find("[^%w%s]") then
            tfm.exec.chatMessage('<R>[Error] Name should contain only letters, numbers and spaces, which is lesser than 15 characters</R>', name)
        elseif jobs[answer] then
            tfm.exec.chatMessage('<R>[Error] Job already exists!</R>', name)
        else
            tempData[name].jobName = answer
            displayJobWizard(name)
        end
    elseif id == 602 and tonumber(answer) and tonumber(answer) < getMaxSalary(tempData[name].jobCompany) then --for the popup to choose the salary for a new job
		tempData[name].jobSalary = tonumber(answer)
		_, energy = getBestParamsJobs("salary", tempData[name].jobSalary, tempData[name])
		tempData[name].jobEnergy = energy
        displayJobWizard(name)
    elseif id == 603 and tonumber(answer) and tonumber(answer) > 0 and tonumber(answer) <= 100 then --for the popup to choose the energy for the job
        tempData[name].jobEnergy = tonumber(answer)
		salary, energy = getBestParamsJobs("energy", tempData[name].jobEnergy, tempData[name])
        tempData[name].jobSalary = salary
        tempData[name].minLvl = 1
        tempData[name].eduLvl = 0
        tempData[name].qualification = nil
        displayJobWizard(name)
    elseif id == 604 and tonumber(answer) then --for the popup to choose the minimum level for the job
		tempData[name].minLvl = tonumber(answer)
        salary, energy, minLvl = getBestParamsJobs("salary", tempData[name].jobSalary or 5, tempData[name])
		tempData[name].jobEnergy = energy
		tempData[name].jobSalary = tempData[name].jobSalary or 1
        displayJobWizard(name)
    elseif id == 700 and tonumber(answer) then --for the investment popups
        players[name]:investTo(tempData[name].investing, tonumber(answer))
    elseif id == 800 and tonumber(answer) then
        players[name]:investTo(tempData[name].investing, tonumber(answer) * 100, true)
    elseif id == 900 and tonumber(answer) then
        companies[tempData[name].issuesSharesIn]:issueShares(tonumber(answer), name)
        displayCompany(tempData[name].issuesSharesIn, name)
    elseif id == 1000 then
        players[name]:buyLottery(answer)
    end
end

function eventChatCommand(name, msg)
    if string.sub(msg, 1, 7) == "company" then
        displayCompany(string.sub(msg, 9), name)
    elseif string.sub(msg, 1, 7) == "profile" then
        displayProfile(string.sub(msg, 9), name)
    elseif string.sub(msg, 1, 1) == "p"  then
        displayProfile(string.sub(msg, 3), name)
    elseif msg == "help" then
        displayHelp(name, "game")
    elseif string.sub(msg, 1, 5) == "title" then
        if string.sub(msg, 7) == "" then
            displayTitleList(name)
        else
            players[name]:setTitle(string.sub(msg, 7))
        end
    elseif msg == "save" and name == OWNER then
        saveData(true)
    end
end

function eventKeyboard(name, key, down, x, y)
    if key == 72 then -- H
        displayHelp(name, "game")
    elseif key == 76 then -- L
        displayLeaderboard(name, "room")
    end
end

function eventLoop(t,r)
    Timer.process()
    for name, player in next, players do
        player:setHealth(player:getHealthRate(), true)
    end
end

--event handling ends

-- game logic
do
    players["shaman"] = Player("shaman", {})
    companies["Atelier801"] = Company("Atelier801", "shaman")

    --[[--creating tips
    for id, tip in next, ({
        "You Need $5000 To Start A New Company!", "You Gain Money From Your Workers!", "Look At The Stats of The Company Before You Apply for it!", "The Better The Job The Better The Income!", "Buy Items From The Shop To Gain Health!", "Some Jobs Needs A Specific Degree",
        "To Level Up You Need To Work!", "You Will Spend Less Energy When Working if You have Educational Qualifications", "The Stats Of A Company Can Be Seen By Anyone", "While Working Your Health Bar Goes Down", "Patience is The Key To This Game.", "The Stock Market Dashboard Displays how Companies Perform in Each Month",
        "You Can Buy Multiple Companies!", "You Can Have Only one Job at a Time", "Your Health will be Refreshed when You Level Up", "Recruit More Players to Have More Salary!", "Try your Best to Own a Company", "Make Sure You Consider About Energy and Salary When Choosing a Job", "The Red Bar Displays Your Health or Energy, While the Green Bar Displays your XP Percentage",
        "Chat With Your Friends When You Are Out of Health", "Use Your Brain and Take Correct Decisions!", "If Your Job Seems to Take More Energy, Try to Choose Another!", "Consider About Your Health When Working", "When Taking A Course, You will Need to Pay Per Lesson Only. So Try to Enroll For the One With Higher Lessons",
        "You Can Apply to Jobs According to Your Level and Degrees", "The Better Stats You Have The Better The Job You Can Have!", "Report Bugs To Developers", "The Game is More Fun with More Players", "Click Tips When You Need Help", "The Health Refreshes Every Moment <3", "There is a Chance for Luck Too! Buy a Lotto and Check Your Luck!", "Invest Other Companies to Have an Ownership Share"
    }) do
        createTip(tip, id)
    end]]

    --creating and storing HealthPack tables
    healthPacks[#healthPacks + 1] = HealthPack("Cheese", 200, 0.01, true,  "Just a cheese! to refresh yourself")
    healthPacks[#healthPacks + 1] = HealthPack("Candy", 300, 0.02, true, "Halloween Treat!")
    healthPacks[#healthPacks + 1] = HealthPack("Apple", 350, 0.025, true, "A nutritious diet from shaman")
    healthPacks[#healthPacks + 1] = HealthPack("Pastry", 2000, 0.06, true, "King's favourite food")
    healthPacks[#healthPacks + 1] = HealthPack("Lasagne", 2500, 0.1, true, "Shh!!! Beware of Garfield :D")
    healthPacks[#healthPacks + 1] = HealthPack("Cheese Pizza", 3000, 0.15, true, "Treat from Italy - with lots of cheeese inside !!!")
    healthPacks[#healthPacks + 1] = HealthPack("Magician`s Portion", 4500, 0.25, true, "Restores 1/4 th of your health.")
    healthPacks[#healthPacks + 1] = HealthPack("Rotten Cheese", 5500, 0.35, true, "Gives you the power of vampire <font size='5'>(disclaimer)This won't make you a vampire</font>")
    healthPacks[#healthPacks + 1] = HealthPack("Cheef`s food", 7000, 0.5, true, "Restores half of your health (Powered by Shaman)")
    healthPacks[#healthPacks + 1] = HealthPack("Cheese Pizza - Large", 7500, 0.55, true, "More Pizza Power!")
    healthPacks[#healthPacks + 1] = HealthPack("Vito`s Pizza", 15000, 0.9, true, "World's best pizza!")
    healthPacks[#healthPacks + 1] = HealthPack("Vito`s Lasagne", 16000, 0.8, true, "World's best lasagne!")
    healthPacks[#healthPacks + 1] = HealthPack("Ambulance!", 18000, 1, false, "Restores your health back! (Powered by Shaman!)")

    --creating and storing Course tables
    courses["School"] = Course(1, "School", 20, 2, 1, "")
    courses["Junior Sports Club"] = Course(2, "Junior Sports Club", 10, 4, 2, "")
    courses["High School"] = Course(3, "High School", 1000, 20, 3, "")
    courses["Cheese mining"] = Course(4, "Cheese mining", 3000, 30, 4, "admin")
    courses["Cheese trading"] = Course(5, "Cheese trading", 5000, 30, 4, "bs")
    courses["Cheese developing"] = Course(6, "Cheese developing", 5500, 50, 4, "it")
    courses["Law"] = Course(7, "Law", 100000, 80, 5, "admin")
    courses["Cheese trading-II"] = Course(8, "Cheese trading-II", 200000, 75, 5, "bs")
    courses["Fullstack cheese developing"] = Course(9, "Fullstack cheese developing", 150000, 70, 5, "it")
    --creating and stofing Job tables
    jobs["Cheese collector"] = Job("Cheese collector", 10, 0.05, 1, nil, "shaman", "Atelier801")
    jobs["Junior miner"] = Job("Junior miner", 25, 0.1, 3, nil, "shaman", "Atelier801")
    jobs["Cheese producer"] = Job("Cheese producer", 50, 0.15, 7, nil, "shaman", "Atelier801")
    jobs["Cheese miner"] = Job("Cheese miner", 350, 0.2, 10, "Cheese mining", "shaman", "Atelier801")
    jobs["Cheese trader"] = Job("Cheese trader", 400, 0.2, 12, "Cheese trading", "shaman", "Atelier801")
    jobs["Cheese developer"] = Job("Cheese developer", 500, 0.3, 12, "Cheese developing", "shaman", "Atelier801")
    jobs["Cheese wholesaler"] = Job("Cheese wholesaler", 800, 0.2, 15, "Cheese trading-II", "shaman", "Atelier801")
    jobs["Fullstack cheese developer"] = Job("Fullstack cheese developer", 10000, 0.4, 15, "Fullstack cheese developing", "shaman", "Atelier801")

    for name, player in next, tfm.get.room.playerList do
        eventNewPlayer(name)
    end

    for id, cmd in next, {"company", "p", "profile", "help", "title"} do
        system.disableChatCommandDisplay(cmd, true)
    end

    --system.loadFile(0)

end

