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

Brainfuck_State::struct(brainfuck:string,ip:uint,backtracking:uint,data:string,ptr:uint,finished:bool,steps:uint,result:string){}

BRAINFUCK_DEBUG::false

BRAINFUCK_ITERATIONS_NEEDED::4

Brainfuck_Core::struct(brainfuck:string,ip:uint,backtracking:uint,data:string,ptr:uint,finished:bool,steps:uint,result:string,iterations_left:uint){
   v:/*Brainfuck_State*/(
      (
         Brainfuck_State(brainfuck,ip,backtracking,data,ptr,true,steps,result)
      )when ip==len(brainfuck) else(
         Brainfuck_State(brainfuck,ip,backtracking,data,ptr,finished,steps,result)
      )when iterations_left<BRAINFUCK_ITERATIONS_NEEDED else(
         (
            (
               comp.v(Brainfuck_Core(brainfuck,ip+1,0,data,ptr,finished,steps+1,result when !BRAINFUCK_DEBUG else (result+(comp.n(Brainfuck_State(brainfuck,ip,backtracking,data,ptr,finished,steps,""))+"\n")),iterations_left-1),"v")
            )when backtracking==1 else(
               comp.v(Brainfuck_Core(brainfuck,ip-1,backtracking-1,data,ptr,finished,steps+1,result when !BRAINFUCK_DEBUG else (result+(comp.n(Brainfuck_State(brainfuck,ip,backtracking,data,ptr,finished,steps,""))+"\n")),iterations_left-1),"v")
            )
         )when brainfuck[ip]=='[' else(
            comp.v(Brainfuck_Core(brainfuck,ip-1,backtracking+1,data,ptr,finished,steps+1,result when !BRAINFUCK_DEBUG else (result+(comp.n(Brainfuck_State(brainfuck,ip,backtracking,data,ptr,finished,steps,""))+"\n")),iterations_left-1),"v")
         )when brainfuck[ip]==']' else(
            comp.v(Brainfuck_Core(brainfuck,ip-1,backtracking,data,ptr,finished,steps+1,result when !BRAINFUCK_DEBUG else (result+(comp.n(Brainfuck_State(brainfuck,ip,backtracking,data,ptr,finished,steps,""))+"\n")),iterations_left-1),"v")
         )
      )when backtracking>=1 else(
         comp.v(Brainfuck_Core(brainfuck,ip+1,backtracking,data,ptr+1 when ptr!=len(data)-1 else 0,finished,steps+1,result when !BRAINFUCK_DEBUG else (result+(comp.n(Brainfuck_State(brainfuck,ip,backtracking,data,ptr,finished,steps,""))+"\n")),iterations_left-1),"v")
      )when brainfuck[ip]=='>' else(
         comp.v(Brainfuck_Core(brainfuck,ip+1,backtracking,data,ptr-1 when ptr!=0 else len(data)-1,finished,steps+1,result when !BRAINFUCK_DEBUG else (result+(comp.n(Brainfuck_State(brainfuck,ip,backtracking,data,ptr,finished,steps,""))+"\n")),iterations_left-1),"v")
      )when brainfuck[ip]=='<' else(
         comp.v(Brainfuck_Core(brainfuck,ip+1,backtracking,data[:ptr]+comp.RUNES[(i16(data[ptr])+1)%%256]+data[ptr+1:],ptr,finished,steps+1,result when !BRAINFUCK_DEBUG else (result+(comp.n(Brainfuck_State(brainfuck,ip,backtracking,data,ptr,finished,steps,""))+"\n")),iterations_left-1),"v")
      )when brainfuck[ip]=='+' else(
         comp.v(Brainfuck_Core(brainfuck,ip+1,backtracking,data[:ptr]+comp.RUNES[(i16(data[ptr])-1)%%256]+data[ptr+1:],ptr,finished,steps+1,result when !BRAINFUCK_DEBUG else (result+(comp.n(Brainfuck_State(brainfuck,ip,backtracking,data,ptr,finished,steps,""))+"\n")),iterations_left-1),"v")
      )when brainfuck[ip]=='-' else(
         /*TODO , idc*/comp.v(Brainfuck_Core(brainfuck,ip+1,backtracking,data,ptr,finished,steps+1,result when !BRAINFUCK_DEBUG else (result+(comp.n(Brainfuck_State(brainfuck,ip,backtracking,data,ptr,finished,steps,""))+"\n")),iterations_left-1),"v")
      )when brainfuck[ip]==',' else(
         comp.v(Brainfuck_Core(brainfuck,ip+1,backtracking,data,ptr,finished,steps+1,(result+comp.RUNES[data[ptr]]) when !BRAINFUCK_DEBUG else (result+(comp.n(Brainfuck_State(brainfuck,ip,backtracking,data,ptr,finished,steps,""))+"\n")),iterations_left-1),"v")
      )when brainfuck[ip]=='.' else(
         /*ignore [*/comp.v(Brainfuck_Core(brainfuck,ip+1,backtracking,data,ptr,finished,steps+1,result when !BRAINFUCK_DEBUG else (result+(comp.n(Brainfuck_State(brainfuck,ip,backtracking,data,ptr,finished,steps,""))+"\n")),iterations_left-1),"v")
      )when brainfuck[ip]=='[' else(
         /*TODO backtrack multiple at once?*/comp.v(Brainfuck_Core(brainfuck,ip-1 when data[ptr]!=0 else ip+1,1 when data[ptr]!=0 else backtracking,data,ptr,finished,steps+1,result when !BRAINFUCK_DEBUG else (result+(comp.n(Brainfuck_State(brainfuck,ip,backtracking,data,ptr,finished,steps,""))+"\n")),iterations_left-1),"v")
      )when brainfuck[ip]==']' else(
         /*ignore anything else*/comp.v(Brainfuck_Core(brainfuck,ip+1,backtracking,data,ptr,finished,steps+1,result when !BRAINFUCK_DEBUG else (result+(comp.n(Brainfuck_State(brainfuck,ip,backtracking,data,ptr,finished,steps,""))+"\n")),iterations_left-1),"v")
      )
   )
}

Brainfuck_1::struct(s:/*Brainfuck_State*/typeid,iterations_left:uint){
   v:/*Brainfuck_State*/(
      (
         s
      )when iterations_left<BRAINFUCK_ITERATIONS_NEEDED+1 else(
         s
      )when s.finished else(
         comp.v(Brainfuck_1(comp.v(Brainfuck_Core(s.brainfuck,s.ip,s.backtracking,s.data,s.ptr,s.finished,s.steps,s.result,iterations_left-1),"v"),iterations_left-1),"v")
      )
   )
}

Brainfuck_2::struct(s:/*Brainfuck_State*/typeid,iterations_left:uint){
   v:/*Brainfuck_State*/(
      (
         s
      )when iterations_left<BRAINFUCK_ITERATIONS_NEEDED+2 else(
         s
      )when s.finished else(
         comp.v(Brainfuck_2(comp.v(Brainfuck_1(s,iterations_left-1),"v"),iterations_left-1),"v")
      )
   )
}

Brainfuck_3::struct(s:/*Brainfuck_State*/typeid,iterations_left:uint){
   v:/*Brainfuck_State*/(
      (
         s
      )when iterations_left<BRAINFUCK_ITERATIONS_NEEDED+3 else(
         s
      )when s.finished else(
         comp.v(Brainfuck_3(comp.v(Brainfuck_2(s,iterations_left-1),"v"),iterations_left-1),"v")
      )
   )
}

Brainfuck_4::struct(s:/*Brainfuck_State*/typeid,iterations_left:uint){
   v:/*Brainfuck_State*/(
      (
         s
      )when iterations_left<BRAINFUCK_ITERATIONS_NEEDED+4 else(
         s
      )when s.finished else(
         comp.v(Brainfuck_4(comp.v(Brainfuck_3(s,iterations_left-1),"v"),iterations_left-1),"v")
      )
   )
}

Brainfuck_5::struct(s:/*Brainfuck_State*/typeid,iterations_left:uint){
   v:/*Brainfuck_State*/(
      (
         s
      )when iterations_left<BRAINFUCK_ITERATIONS_NEEDED+5 else(
         s
      )when s.finished else(
         comp.v(Brainfuck_5(comp.v(Brainfuck_4(s,iterations_left-1),"v"),iterations_left-1),"v")
      )
   )
}

brainfuck::#force_inline proc($brainfuck:string,$depth:int)->(_result:string,_escaped:string,_steps:uint,_finished:bool){
   ITERATION_LIMIT::27
   INIT::Brainfuck_State(brainfuck,0,0,comp.v(comp.Buffer_Make(128),"v").v,0,false,0,"")
   when depth==0{
      result::comp.v(Brainfuck_Core(INIT,ITERATION_LIMIT),"v")
   }else when depth==1{
      result::comp.v(Brainfuck_1(INIT,ITERATION_LIMIT),"v")
   }else when depth==2{
      result::comp.v(Brainfuck_2(INIT,ITERATION_LIMIT),"v")
   }else when depth==3{
      result::comp.v(Brainfuck_3(INIT,ITERATION_LIMIT),"v")
   }else when depth==4{
      result::comp.v(Brainfuck_4(INIT,ITERATION_LIMIT),"v")
   }else when depth==5{
      result::comp.v(Brainfuck_5(INIT,ITERATION_LIMIT),"v")
   }else{
      #panic("Invalid depth")
   }
   escaped::"["+comp.v(comp.Buffer_Print(result.result),"v").v+"]"
   return result.result,escaped,result.steps,result.finished
}


main::proc(){
   hello_world::">++++++++[<+++++++++>-]<.>++++[<+++++++>-]<+.+++++++..+++.>>++++++[<+++++++>-]<++.------------.>++++++[<+++++++++>-]<+.<.+++.------.--------.>>>++++[<++++++++>-]<+."

   //from https://esolangs.org/wiki/Brainfuck
   hello_world_1::"+++++++++++[>++++++>+++++++++>++++++++>++++>+++>+<<<<<<-]>++++++.>++.+++++++..+++.>>.>-.<<-.<.+++.------.--------.>>>+.>-."
   hello_world_2::"<+>+>+>+>+>+>+>+>+>+>+ <<<<<<<<<<>+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++.>++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++.>+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++.>+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++.>++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++.>+++++++++++++++++++++++++++++++++++++++++++.>-.>++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++.>++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++.>+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++.>++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++.>++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++."
   hello_world_3::"++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++."
   hello_world_4::">++++++++[-<+++++++++>]<.>>+>-[+]++>++>+++[>[->+++<<+++>]<<]>-----.>->+++..+++.>-.<<+[>[+>+]>>]<--------------.>>.+++.------.--------.>+.>+."
   hello_world_5::"+[-->-[>>+>-----<<]<--<---]>-.>>>+.>>..+++[.>]<<<<.+++.------.<<-.>>>>+."
   hello_world_6::"--<-<<+[+[<+>--->->->-<<<]>]<<--.<++++++.<<-..<<.<+.>>.>>.<<<.+++.>>.>>-.<<<+."

   quine::"-->+++>+>+>+>+++++>++>++>->+++>++>+>>>>>>>>>>>>>>>>->++++>>>>->+++>+++>+++>+++>+++>+++>+>+>>>->->>++++>+>>>>->>++++>+>+>>->->++>++>++>++++>+>++>->++>++++>+>+>++>++>->->++>++>++++>+>+>>>>>->>->>++++>++>++>++++>>>>>->>>>>+++>->++++>->->->+++>>>+>+>+++>+>++++>>+++>->>>>>->>>++++>++>++>+>+++>->++++>>->->+++>+>+++>+>++++>>>+++>->++++>>->->++>++++>++>++++>>++[-[->>+[>]++[<]<]>>+[>]<--[++>++++>]+[<]<<++]>>>[>]++++>++++[--[+>+>++++<<[-->>--<<[->-<[--->>+<<[+>+++<[+>>++<<]]]]]]>+++[>+++++++++++++++<-]>--.<<<]"

   /*
      - 0:    24 steps
      - 1:   276 steps
      - 2:  2024 steps in  1 second
      - 3: 10626 steps in  1 minute
      - 4: 42504 steps in 50 minutes (before core speedup)
   */
   DEPTH::2
   SELECTION::3

   when SELECTION==0{
      result,escaped,steps,finished:=brainfuck(hello_world,DEPTH)
      fmt.println("Name: hello_world")
   }else when SELECTION==1{
      result,escaped,steps,finished:=brainfuck(hello_world_1,DEPTH)
      fmt.println("Name: hello_world_1")
   }else when SELECTION==2{
      result,escaped,steps,finished:=brainfuck(hello_world_2,DEPTH)
      fmt.println("Name: hello_world_2")
   }else when SELECTION==3{
      result,escaped,steps,finished:=brainfuck(hello_world_3,DEPTH)
      fmt.println("Name: hello_world_3")
   }else when SELECTION==4{
      result,escaped,steps,finished:=brainfuck(hello_world_4,DEPTH)
      fmt.println("Name: hello_world_4")
   }else when SELECTION==5{
      result,escaped,steps,finished:=brainfuck(hello_world_5,DEPTH)
      fmt.println("Name: hello_world_5")
   }else when SELECTION==6{
      result,escaped,steps,finished:=brainfuck(hello_world_6,DEPTH)
      fmt.println("Name: hello_world_6")
   }else when SELECTION==7{
      result,escaped,steps,finished:=brainfuck(quine)
      fmt.println("Name: quine")
   }else{
      #panic("Invalid selection")
   }
   fmt.println("Finished:",finished)
   fmt.println("Steps:",steps)
   fmt.printfln("%q",result)
   fmt.println(escaped)
}
