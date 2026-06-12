package odin_compiletime_brainfuck

PACKAGE::"odin_compiletime_brainfuck"

import comp "odin-compiletime"

import "core:fmt"

Backtrack::struct(brainfuck:string,ip:uint,depth:uint){
   v:/*comp.Uint*/(
      (
         (
            comp.Uint(ip+1)
         )when depth==1 else(
            comp.v(Backtrack(brainfuck,ip-1,depth-1),"v")
         )
      )when brainfuck[ip]=='[' else(
         comp.v(Backtrack(brainfuck,ip-1,depth+1),"v")
      )when brainfuck[ip]==']' else(
         comp.v(Backtrack(brainfuck,ip-1,depth),"v")
      )
   )
}

Brainfuck_State::struct(brainfuck:string,ip:uint,ptr:uint,data:string){}

BRAINFUCK_DEBUG::false

Brainfuck::struct(brainfuck:string,ip:uint,data:string,ptr:uint,result:string){
   v:/*comp.String*/(
      (
         comp.String(result)
      )when ip==len(brainfuck) else(
         comp.v(Brainfuck(brainfuck,ip+1,data,ptr+1 when ptr!=len(data)-1 else 0,result when !BRAINFUCK_DEBUG else (result+(comp.n(Brainfuck_State(brainfuck,ip,ptr,data))+"\n"))),"v")
      )when brainfuck[ip]=='>' else(
         comp.v(Brainfuck(brainfuck,ip+1,data,ptr-1 when ptr!=0 else len(data)-1,result when !BRAINFUCK_DEBUG else (result+(comp.n(Brainfuck_State(brainfuck,ip,ptr,data))+"\n"))),"v")
      )when brainfuck[ip]=='<' else(
         comp.v(Brainfuck(brainfuck,ip+1,data[:ptr]+comp.RUNES[(i16(data[ptr])+1)%%256]+data[ptr+1:],ptr,result when !BRAINFUCK_DEBUG else (result+(comp.n(Brainfuck_State(brainfuck,ip,ptr,data))+"\n"))),"v")
      )when brainfuck[ip]=='+' else(
         comp.v(Brainfuck(brainfuck,ip+1,data[:ptr]+comp.RUNES[(i16(data[ptr])-1)%%256]+data[ptr+1:],ptr,result when !BRAINFUCK_DEBUG else (result+(comp.n(Brainfuck_State(brainfuck,ip,ptr,data))+"\n"))),"v")
      )when brainfuck[ip]=='-' else(
         /*TODO , idc*/comp.v(Brainfuck(brainfuck,ip+1,data,ptr,result when !BRAINFUCK_DEBUG else (result+(comp.n(Brainfuck_State(brainfuck,ip,ptr,data))+"\n"))),"v")
      )when brainfuck[ip]==',' else(
         comp.v(Brainfuck(brainfuck,ip+1,data,ptr,(result+comp.RUNES[data[ptr]]) when !BRAINFUCK_DEBUG else (result+(comp.n(Brainfuck_State(brainfuck,ip,ptr,data))+"\n"))),"v")
      )when brainfuck[ip]=='.' else(
         /*ignore [*/comp.v(Brainfuck(brainfuck,ip+1,data,ptr,result when !BRAINFUCK_DEBUG else (result+(comp.n(Brainfuck_State(brainfuck,ip,ptr,data))+"\n"))),"v")
      )when brainfuck[ip]=='[' else(
         comp.v(Brainfuck(brainfuck,ip+1 when data[ptr]==0 else comp.v(Backtrack(brainfuck,ip-1,1),"v").v,data,ptr,result when !BRAINFUCK_DEBUG else (result+(comp.n(Brainfuck_State(brainfuck,ip,ptr,data))+"\n"))),"v")
      )when brainfuck[ip]==']' else(
         /*ignore anything else*/comp.v(Brainfuck(brainfuck,ip+1,data,ptr,result when !BRAINFUCK_DEBUG else (result+(comp.n(Brainfuck_State(brainfuck,ip,ptr,data))+"\n"))),"v")
      )
   )
}

brainfuck::#force_inline proc($brainfuck:string,$size:uint)->(_result:string,_escaped:string){
   init_string::comp.v(comp.Buffer_Make(size),"v").v
   result::comp.v(Brainfuck(brainfuck,0,init_string,0,""),"v").v
   escaped::comp.v(comp.Buffer_Print(result),"v").v
   return result,escaped
}

main::proc(){
   result,escaped:=brainfuck("++++++[.-].",1)
   fmt.printfln("%q",result)
   fmt.println(escaped)
   fmt.println(comp.v(Brainfuck(".>.>..>.>.>.>.>.>.>.>.",0,"Helo World!",0,""),"v").v)
}

/*
>++++++++[<+++++++++>-]<.>++++[<+++++++>-]<+.+++++++..+++.>>++++++[<+++++++>-]<++.------------.>++++++[<+++++++++>-]<+.<.+++.------.--------.>>>++++[<++++++++>-]<+.
*/
