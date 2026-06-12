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

BRAINFUCK_GRACE::2

Brainfuck_Core::struct(s:/*Brainfuck_State*/typeid,iterations_left:uint){
   v:/*Brainfuck_State*/(
      (
         Brainfuck_State(s.brainfuck,s.ip,s.backtracking,s.data,s.ptr,true,s.steps,s.result)
      )when s.ip==len(s.brainfuck) else(
         s
      )when iterations_left<=4+(1 when BRAINFUCK_DEBUG else 0) else(
         (
            (
               comp.v(Brainfuck_Core(Brainfuck_State(s.brainfuck,s.ip+1,0,s.data,s.ptr,s.finished,s.steps+1,s.result when !BRAINFUCK_DEBUG else (s.result+(comp.n(Brainfuck_State(s.brainfuck,s.ip,s.backtracking,s.data,s.ptr,s.finished,s.steps,""))+"\n"))),iterations_left-1),"v")
            )when s.backtracking==1 else(
               comp.v(Brainfuck_Core(Brainfuck_State(s.brainfuck,s.ip-1,s.backtracking-1,s.data,s.ptr,s.finished,s.steps+1,s.result when !BRAINFUCK_DEBUG else (s.result+(comp.n(Brainfuck_State(s.brainfuck,s.ip,s.backtracking,s.data,s.ptr,s.finished,s.steps,""))+"\n"))),iterations_left-1),"v")
            )
         )when s.brainfuck[s.ip]=='[' else(
            comp.v(Brainfuck_Core(Brainfuck_State(s.brainfuck,s.ip-1,s.backtracking+1,s.data,s.ptr,s.finished,s.steps+1,s.result when !BRAINFUCK_DEBUG else (s.result+(comp.n(Brainfuck_State(s.brainfuck,s.ip,s.backtracking,s.data,s.ptr,s.finished,s.steps,""))+"\n"))),iterations_left-1),"v")
         )when s.brainfuck[s.ip]==']' else(
            comp.v(Brainfuck_Core(Brainfuck_State(s.brainfuck,s.ip-1,s.backtracking,s.data,s.ptr,s.finished,s.steps+1,s.result when !BRAINFUCK_DEBUG else (s.result+(comp.n(Brainfuck_State(s.brainfuck,s.ip,s.backtracking,s.data,s.ptr,s.finished,s.steps,""))+"\n"))),iterations_left-1),"v")
         )
      )when s.backtracking>=1 else(
         comp.v(Brainfuck_Core(Brainfuck_State(s.brainfuck,s.ip+1,s.backtracking,s.data,s.ptr+1 when s.ptr!=len(s.data)-1 else 0,s.finished,s.steps+1,s.result when !BRAINFUCK_DEBUG else (s.result+(comp.n(Brainfuck_State(s.brainfuck,s.ip,s.backtracking,s.data,s.ptr,s.finished,s.steps,""))+"\n"))),iterations_left-1),"v")
      )when s.brainfuck[s.ip]=='>' else(
         comp.v(Brainfuck_Core(Brainfuck_State(s.brainfuck,s.ip+1,s.backtracking,s.data,s.ptr-1 when s.ptr!=0 else len(s.data)-1,s.finished,s.steps+1,s.result when !BRAINFUCK_DEBUG else (s.result+(comp.n(Brainfuck_State(s.brainfuck,s.ip,s.backtracking,s.data,s.ptr,s.finished,s.steps,""))+"\n"))),iterations_left-1),"v")
      )when s.brainfuck[s.ip]=='<' else(
         comp.v(Brainfuck_Core(Brainfuck_State(s.brainfuck,s.ip+1,s.backtracking,s.data[:s.ptr]+comp.RUNES[(i16(s.data[s.ptr])+1)%%256]+s.data[s.ptr+1:],s.ptr,s.finished,s.steps+1,s.result when !BRAINFUCK_DEBUG else (s.result+(comp.n(Brainfuck_State(s.brainfuck,s.ip,s.backtracking,s.data,s.ptr,s.finished,s.steps,""))+"\n"))),iterations_left-1),"v")
      )when s.brainfuck[s.ip]=='+' else(
         comp.v(Brainfuck_Core(Brainfuck_State(s.brainfuck,s.ip+1,s.backtracking,s.data[:s.ptr]+comp.RUNES[(i16(s.data[s.ptr])-1)%%256]+s.data[s.ptr+1:],s.ptr,s.finished,s.steps+1,s.result when !BRAINFUCK_DEBUG else (s.result+(comp.n(Brainfuck_State(s.brainfuck,s.ip,s.backtracking,s.data,s.ptr,s.finished,s.steps,""))+"\n"))),iterations_left-1),"v")
      )when s.brainfuck[s.ip]=='-' else(
         /*TODO , idc*/comp.v(Brainfuck_Core(Brainfuck_State(s.brainfuck,s.ip+1,s.backtracking,s.data,s.ptr,s.finished,s.steps+1,s.result when !BRAINFUCK_DEBUG else (s.result+(comp.n(Brainfuck_State(s.brainfuck,s.ip,s.backtracking,s.data,s.ptr,s.finished,s.steps,""))+"\n"))),iterations_left-1),"v")
      )when s.brainfuck[s.ip]==',' else(
         comp.v(Brainfuck_Core(Brainfuck_State(s.brainfuck,s.ip+1,s.backtracking,s.data,s.ptr,s.finished,s.steps+1,(s.result+comp.RUNES[s.data[s.ptr]]) when !BRAINFUCK_DEBUG else (s.result+(comp.n(Brainfuck_State(s.brainfuck,s.ip,s.backtracking,s.data,s.ptr,s.finished,s.steps,""))+"\n"))),iterations_left-1),"v")
      )when s.brainfuck[s.ip]=='.' else(
         /*ignore [*/comp.v(Brainfuck_Core(Brainfuck_State(s.brainfuck,s.ip+1,s.backtracking,s.data,s.ptr,s.finished,s.steps+1,s.result when !BRAINFUCK_DEBUG else (s.result+(comp.n(Brainfuck_State(s.brainfuck,s.ip,s.backtracking,s.data,s.ptr,s.finished,s.steps,""))+"\n"))),iterations_left-1),"v")
      )when s.brainfuck[s.ip]=='[' else(
         comp.v(Brainfuck_Core(Brainfuck_State(s.brainfuck,s.ip-1 when s.data[s.ptr]!=0 else s.ip+1,1 when s.data[s.ptr]!=0 else s.backtracking,s.data,s.ptr,s.finished,s.steps+1,s.result when !BRAINFUCK_DEBUG else (s.result+(comp.n(Brainfuck_State(s.brainfuck,s.ip,s.backtracking,s.data,s.ptr,s.finished,s.steps,""))+"\n"))),iterations_left-1),"v")
      )when s.brainfuck[s.ip]==']' else(
         /*ignore anything else*/comp.v(Brainfuck_Core(Brainfuck_State(s.brainfuck,s.ip+1,s.backtracking,s.data,s.ptr,s.finished,s.steps+1,s.result when !BRAINFUCK_DEBUG else (s.result+(comp.n(Brainfuck_State(s.brainfuck,s.ip,s.backtracking,s.data,s.ptr,s.finished,s.steps,""))+"\n"))),iterations_left-1),"v")
      )
   )
}

Brainfuck_0::struct(s:/*Brainfuck_State*/typeid,iterations_left:uint){
   v:/*Brainfuck_State*/(
      (
         s
      )when iterations_left<=5+(1 when BRAINFUCK_DEBUG else 0)+BRAINFUCK_GRACE else(
         comp.v(Brainfuck_0(comp.v(Brainfuck_Core(s,iterations_left-1),"v"),iterations_left-1),"v")
      )
   )
}

Brainfuck_1::struct(s:/*Brainfuck_State*/typeid,iterations_left:uint){
   v:/*Brainfuck_State*/(
      (
         s
      )when iterations_left<=6+(1 when BRAINFUCK_DEBUG else 0)+BRAINFUCK_GRACE else(
         comp.v(Brainfuck_1(comp.v(Brainfuck_0(s,iterations_left-1),"v"),iterations_left-1),"v")
      )
   )
}

Brainfuck_2::struct(s:/*Brainfuck_State*/typeid,iterations_left:uint){
   v:/*Brainfuck_State*/(
      (
         s
      )when iterations_left<=7+(1 when BRAINFUCK_DEBUG else 0)+BRAINFUCK_GRACE else(
         comp.v(Brainfuck_2(comp.v(Brainfuck_1(s,iterations_left-1),"v"),iterations_left-1),"v")
      )
   )
}

Brainfuck_3::struct(s:/*Brainfuck_State*/typeid,iterations_left:uint){
   v:/*Brainfuck_State*/(
      (
         s
      )when iterations_left<=8+(1 when BRAINFUCK_DEBUG else 0)+BRAINFUCK_GRACE else(
         comp.v(Brainfuck_3(comp.v(Brainfuck_2(s,iterations_left-1),"v"),iterations_left-1),"v")
      )
   )
}

Brainfuck_4::struct(s:/*Brainfuck_State*/typeid,iterations_left:uint){
   v:/*Brainfuck_State*/(
      (
         s
      )when iterations_left<=9+(1 when BRAINFUCK_DEBUG else 0)+BRAINFUCK_GRACE else(
         comp.v(Brainfuck_4(comp.v(Brainfuck_3(s,iterations_left-1),"v"),iterations_left-1),"v")
      )
   )
}

brainfuck::#force_inline proc($brainfuck:string,$depth:int)->(_result:string,_escaped:string,_steps:uint,_finished:bool){
   init_string::comp.v(comp.Buffer_Make(128),"v").v
   when depth==0{
      result::comp.v(Brainfuck_Core(Brainfuck_State(brainfuck,0,0,init_string,0,false,0,""),27),"v")
   }else when depth==1{
      result::comp.v(Brainfuck_1(Brainfuck_State(brainfuck,0,0,init_string,0,false,0,""),27),"v")
   }else when depth==2{
      result::comp.v(Brainfuck_2(Brainfuck_State(brainfuck,0,0,init_string,0,false,0,""),27),"v")
   }else when depth==3{
      result::comp.v(Brainfuck_3(Brainfuck_State(brainfuck,0,0,init_string,0,false,0,""),27),"v")
   }else when depth==4{
      result::comp.v(Brainfuck_4(Brainfuck_State(brainfuck,0,0,init_string,0,false,0,""),27),"v")
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

   /* at grace=2
      - 0:    23 steps
      - 1:  1710 steps
      - 2:  8265 steps
      - 3: 30039 steps
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
